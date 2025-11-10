-- ====================================================================
-- SCRIPT DE MIGRATION: CANDIDAT → EMPLOYÉ
-- ====================================================================
-- Ce script permet de transformer un candidat recruté en employé RH
-- avec création de toutes les données nécessaires (contrat, soldes, etc.)
-- ====================================================================

\c gestion_entreprise;

-- ====================================================================
-- SECTION 1: FONCTION DE MIGRATION COMPLÈTE
-- ====================================================================

CREATE OR REPLACE FUNCTION migrate_candidat_to_employe(
    p_id_evaluation INT,              -- ID de l'évaluation d'entretien validée
    p_id_service INT,                 -- Service d'affectation
    p_id_poste INT,                   -- Poste
    p_id_categorie INT,               -- Catégorie de personnel
    p_id_type_contrat INT,            -- Type de contrat (CDI, CDD, etc.)
    p_salaire_brut DECIMAL(12,2),     -- Salaire brut mensuel
    p_date_embauche DATE DEFAULT CURRENT_DATE,
    p_duree_periode_essai INT DEFAULT 90  -- En jours
)
RETURNS TABLE(
    id_employe_cree INT,
    matricule VARCHAR(50),
    message TEXT
) AS $$
DECLARE
    v_id_utilisateur INT;
    v_email VARCHAR(255);
    v_nom VARCHAR(255);
    v_prenom VARCHAR(255);
    v_date_naissance DATE;
    v_adresse VARCHAR(255);
    v_id_employe INT;
    v_matricule VARCHAR(50);
    v_id_contrat INT;
BEGIN
    -- 1. Récupérer les informations du candidat depuis le contrat d'essai
    SELECT 
        ue.id,
        ce.email_utilisateur,
        ue.nom,
        ue.prenom,
        ue.date_naissance,
        ue.adresse
    INTO 
        v_id_utilisateur,
        v_email,
        v_nom,
        v_prenom,
        v_date_naissance,
        v_adresse
    FROM contrat_essaie ce
    JOIN utilisateur_entreprise ue ON ce.email_utilisateur = ue.email
    WHERE ce.id_evaluation = p_id_evaluation
    LIMIT 1;

    -- Vérifier que le candidat existe
    IF v_id_utilisateur IS NULL THEN
        RETURN QUERY SELECT NULL::INT, NULL::VARCHAR, 'Candidat non trouvé pour cette évaluation'::TEXT;
        RETURN;
    END IF;

    -- Vérifier que l'employé n'existe pas déjà
    IF EXISTS (SELECT 1 FROM employe WHERE id_utilisateur = v_id_utilisateur) THEN
        RETURN QUERY SELECT NULL::INT, NULL::VARCHAR, 'Cet utilisateur est déjà enregistré comme employé'::TEXT;
        RETURN;
    END IF;

    -- 2. Générer un matricule unique
    v_matricule := 'EMP' || LPAD(NEXTVAL('employe_id_seq')::TEXT, 6, '0');

    -- 3. Créer l'employé
    INSERT INTO employe (
        id_utilisateur,
        matricule,
        date_embauche,
        id_service,
        id_poste,
        id_categorie,
        statut,
        created_at
    ) VALUES (
        v_id_utilisateur,
        v_matricule,
        p_date_embauche,
        p_id_service,
        p_id_poste,
        p_id_categorie,
        'Actif',
        CURRENT_TIMESTAMP
    )
    RETURNING id INTO v_id_employe;

    -- 4. Créer le contrat de travail
    INSERT INTO contrat_employe (
        id_employe,
        id_type_contrat,
        date_debut,
        duree_periode_essai,
        date_fin_periode_essai,
        salaire_brut,
        est_actif,
        created_at
    ) VALUES (
        v_id_employe,
        p_id_type_contrat,
        p_date_embauche,
        p_duree_periode_essai,
        p_date_embauche + (p_duree_periode_essai || ' days')::INTERVAL,
        p_salaire_brut,
        TRUE,
        CURRENT_TIMESTAMP
    )
    RETURNING id INTO v_id_contrat;

    -- 5. Initialiser les soldes de congés (fait automatiquement par trigger)
    -- Le trigger trg_create_solde_conges se déclenche après INSERT employe

    -- 6. Créer une notification pour le RH
    INSERT INTO notification_rh (id_destinataire, type_notification, titre, message)
    SELECT 
        id,
        'Recrutement',
        'Nouveau collaborateur',
        'Le candidat ' || v_nom || ' ' || v_prenom || ' a été intégré avec le matricule ' || v_matricule
    FROM utilisateur_entreprise
    WHERE est_rh = TRUE;

    -- 7. Log d'audit
    INSERT INTO audit_log (id_utilisateur, action, table_concernee, id_enregistrement, details)
    VALUES (
        v_id_utilisateur,
        'MIGRATION',
        'employe',
        v_id_employe,
        jsonb_build_object(
            'source', 'recrutement',
            'id_evaluation', p_id_evaluation,
            'matricule', v_matricule
        )
    );

    -- Retourner le résultat
    RETURN QUERY SELECT 
        v_id_employe, 
        v_matricule, 
        ('Employé créé avec succès: ' || v_nom || ' ' || v_prenom || ' (Matricule: ' || v_matricule || ')')::TEXT;
END;
$$ LANGUAGE plpgsql;

-- ====================================================================
-- SECTION 2: EXEMPLES D'UTILISATION
-- ====================================================================

-- Exemple 1: Migrer un candidat validé
/*
SELECT * FROM migrate_candidat_to_employe(
    p_id_evaluation := 1,              -- ID de l'évaluation validée
    p_id_service := 1,                 -- Service IT
    p_id_poste := 1,                   -- Développeur
    p_id_categorie := 4,               -- Cadre
    p_id_type_contrat := 1,            -- CDI
    p_salaire_brut := 2500000.00,      -- 2,5M Ar/mois
    p_date_embauche := '2024-12-01',
    p_duree_periode_essai := 90
);
*/

-- ====================================================================
-- SECTION 3: MIGRATION EN MASSE
-- ====================================================================

-- Fonction pour migrer plusieurs candidats validés en une fois
CREATE OR REPLACE FUNCTION migrate_candidats_valides_batch(
    p_id_service_defaut INT DEFAULT 1,
    p_id_poste_defaut INT DEFAULT 1,
    p_id_categorie_defaut INT DEFAULT 2,  -- Employé par défaut
    p_id_type_contrat_defaut INT DEFAULT 1  -- CDI par défaut
)
RETURNS TABLE(
    candidat_nom VARCHAR,
    matricule VARCHAR,
    statut TEXT
) AS $$
DECLARE
    r RECORD;
    v_result RECORD;
BEGIN
    -- Parcourir les candidats avec évaluation positive (note >= 70)
    FOR r IN 
        SELECT DISTINCT
            ee.id AS id_evaluation,
            ue.id AS id_utilisateur,
            ue.nom,
            ue.prenom,
            o.salaire
        FROM evalution_entretien ee
        JOIN planing_entretien pe ON ee.id_entretien = pe.id
        JOIN resultat res ON pe.id_resultat = res.id
        JOIN candidat c ON res.id_candidat = c.id
        JOIN utilisateur_entreprise ue ON ue.email = c.email
        JOIN offre o ON c.id_offre = o.id
        WHERE ee.note >= 70
          AND NOT EXISTS (SELECT 1 FROM employe e WHERE e.id_utilisateur = ue.id)
          AND NOT EXISTS (SELECT 1 FROM contrat_essaie ce WHERE ce.id_evaluation = ee.id)
    LOOP
        -- Extraire le salaire (convertir "1000000 - 1500000 Ar" en nombre)
        DECLARE
            v_salaire DECIMAL(12,2);
        BEGIN
            v_salaire := REGEXP_REPLACE(SPLIT_PART(r.salaire, '-', 1), '[^0-9]', '', 'g')::DECIMAL(12,2);
            
            -- Appeler la fonction de migration
            SELECT * INTO v_result
            FROM migrate_candidat_to_employe(
                p_id_evaluation := r.id_evaluation,
                p_id_service := p_id_service_defaut,
                p_id_poste := p_id_poste_defaut,
                p_id_categorie := p_id_categorie_defaut,
                p_id_type_contrat := p_id_type_contrat_defaut,
                p_salaire_brut := v_salaire,
                p_date_embauche := CURRENT_DATE
            );
            
            RETURN QUERY SELECT 
                (r.nom || ' ' || r.prenom)::VARCHAR,
                v_result.matricule,
                v_result.message;
        EXCEPTION WHEN OTHERS THEN
            RETURN QUERY SELECT 
                (r.nom || ' ' || r.prenom)::VARCHAR,
                NULL::VARCHAR,
                ('Erreur: ' || SQLERRM)::TEXT;
        END;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- ====================================================================
-- SECTION 4: REQUÊTES DE VÉRIFICATION POST-MIGRATION
-- ====================================================================

-- Vérifier les employés créés aujourd'hui
CREATE OR REPLACE VIEW v_employes_nouveaux AS
SELECT 
    e.matricule,
    ue.nom,
    ue.prenom,
    ue.email,
    s.nom AS service,
    p.titre AS poste,
    cp.nom AS categorie,
    ce.salaire_brut,
    tc.libelle AS type_contrat,
    e.date_embauche,
    e.created_at
FROM employe e
JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
LEFT JOIN service s ON e.id_service = s.id
LEFT JOIN poste p ON e.id_poste = p.id
LEFT JOIN categorie_personnel cp ON e.id_categorie = cp.id
LEFT JOIN contrat_employe ce ON ce.id_employe = e.id AND ce.est_actif = TRUE
LEFT JOIN type_contrat tc ON ce.id_type_contrat = tc.id
WHERE e.created_at::DATE = CURRENT_DATE
ORDER BY e.created_at DESC;

-- Vérifier les soldes de congés initialisés
SELECT 
    e.matricule,
    ue.nom,
    ue.prenom,
    tc.libelle AS type_conge,
    sc.annee,
    sc.solde_initial,
    sc.solde_restant
FROM employe e
JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
JOIN solde_conge sc ON sc.id_employe = e.id
JOIN type_conge tc ON sc.id_type_conge = tc.id
WHERE e.created_at::DATE = CURRENT_DATE
ORDER BY e.matricule, tc.libelle;

-- ====================================================================
-- SECTION 5: FONCTION DE ROLLBACK (en cas d'erreur)
-- ====================================================================

-- Fonction pour supprimer un employé et toutes ses données RH
CREATE OR REPLACE FUNCTION rollback_employe(p_matricule VARCHAR)
RETURNS TEXT AS $$
DECLARE
    v_id_employe INT;
    v_nom_complet TEXT;
BEGIN
    -- Récupérer l'ID de l'employé
    SELECT e.id, ue.nom || ' ' || ue.prenom
    INTO v_id_employe, v_nom_complet
    FROM employe e
    JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
    WHERE e.matricule = p_matricule;

    IF v_id_employe IS NULL THEN
        RETURN 'Employé non trouvé avec le matricule: ' || p_matricule;
    END IF;

    -- Supprimer dans l'ordre (contraintes FK)
    DELETE FROM ligne_bulletin WHERE id_bulletin IN (SELECT id FROM bulletin_paie WHERE id_employe = v_id_employe);
    DELETE FROM bulletin_paie WHERE id_employe = v_id_employe;
    DELETE FROM prime_employe WHERE id_employe = v_id_employe;
    DELETE FROM avance_salaire WHERE id_employe = v_id_employe;
    DELETE FROM heure_supplementaire WHERE id_employe = v_id_employe;
    DELETE FROM feuille_presence WHERE id_employe = v_id_employe;
    DELETE FROM pointage WHERE id_employe = v_id_employe;
    DELETE FROM absence WHERE id_employe = v_id_employe;
    DELETE FROM demande_conge WHERE id_employe = v_id_employe;
    DELETE FROM solde_conge WHERE id_employe = v_id_employe;
    DELETE FROM demande_rh WHERE id_employe = v_id_employe;
    DELETE FROM document_employe WHERE id_employe = v_id_employe;
    DELETE FROM historique_poste WHERE id_employe = v_id_employe;
    DELETE FROM contrat_employe WHERE id_employe = v_id_employe;
    DELETE FROM employe WHERE id = v_id_employe;

    RETURN 'Employé supprimé avec succès: ' || v_nom_complet || ' (Matricule: ' || p_matricule || ')';
END;
$$ LANGUAGE plpgsql;

-- ====================================================================
-- SECTION 6: SCRIPT DE DONNÉES DE TEST (OPTIONNEL)
-- ====================================================================

-- Créer un service de test si non existant
INSERT INTO service (nom, description) 
VALUES ('Service IT', 'Département informatique')
ON CONFLICT DO NOTHING;

-- Créer un poste de test si non existant
INSERT INTO poste (titre, description, id_service, id_categorie, salaire_min, salaire_max)
SELECT 
    'Développeur Full Stack',
    'Développement d''applications web et mobile',
    s.id,
    cp.id,
    1500000,
    3000000
FROM service s
CROSS JOIN categorie_personnel cp
WHERE s.nom = 'Service IT'
  AND cp.nom = 'Cadre'
ON CONFLICT DO NOTHING;

-- ====================================================================
-- FIN DU SCRIPT
-- ====================================================================

-- Instructions d'utilisation:
-- 1. Pour migrer un candidat spécifique:
--    SELECT * FROM migrate_candidat_to_employe(1, 1, 1, 4, 1, 2500000.00);
--
-- 2. Pour migrer tous les candidats validés:
--    SELECT * FROM migrate_candidats_valides_batch();
--
-- 3. Pour vérifier les nouveaux employés:
--    SELECT * FROM v_employes_nouveaux;
--
-- 4. Pour annuler une migration (ATTENTION: suppression définitive):
--    SELECT rollback_employe('EMP000001');
