-- ====================================================================
-- VUES ET TRIGGERS POUR AUTOMATISATION RH
-- ====================================================================
-- Ce script complète BD_RH_COMPLETE.sql avec:
-- 1. Vues métier pour faciliter les requêtes
-- 2. Triggers pour calculs automatiques
-- 3. Fonctions utilitaires
-- ====================================================================

\c gestion_entreprise;

-- ====================================================================
-- SECTION 1: VUES MÉTIER
-- ====================================================================

-- Vue: Fiche employé complète (jointure employe + utilisateur)
CREATE OR REPLACE VIEW v_employe_complet AS
SELECT 
    e.id,
    e.matricule,
    ue.nom,
    ue.prenom,
    ue.email,
    ue.date_naissance,
    EXTRACT(YEAR FROM AGE(ue.date_naissance)) AS age,
    e.telephone,
    e.adresse AS adresse_complete,
    e.situation_familiale,
    e.nombre_enfants,
    s.nom AS service,
    p.titre AS poste,
    cp.nom AS categorie,
    e.date_embauche,
    EXTRACT(YEAR FROM AGE(e.date_embauche)) AS anciennete_annees,
    e.statut,
    manager.nom || ' ' || manager.prenom AS nom_manager,
    ce.salaire_brut,
    tc.libelle AS type_contrat,
    ce.date_fin AS fin_contrat
FROM employe e
JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
LEFT JOIN service s ON e.id_service = s.id
LEFT JOIN poste p ON e.id_poste = p.id
LEFT JOIN categorie_personnel cp ON e.id_categorie = cp.id
LEFT JOIN employe manager_emp ON e.id_manager = manager_emp.id
LEFT JOIN utilisateur_entreprise manager ON manager_emp.id_utilisateur = manager.id
LEFT JOIN contrat_employe ce ON ce.id_employe = e.id AND ce.est_actif = TRUE
LEFT JOIN type_contrat tc ON ce.id_type_contrat = tc.id
WHERE e.statut = 'Actif';

-- Vue: Soldes de congés actuels
CREATE OR REPLACE VIEW v_soldes_conges_actuels AS
SELECT 
    e.matricule,
    ue.nom,
    ue.prenom,
    tc.libelle AS type_conge,
    sc.annee,
    sc.solde_initial,
    sc.solde_acquis,
    sc.solde_pris,
    sc.solde_restant,
    tc.cumul_par_mois AS acquisition_mensuelle
FROM solde_conge sc
JOIN employe e ON sc.id_employe = e.id
JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
JOIN type_conge tc ON sc.id_type_conge = tc.id
WHERE sc.annee = EXTRACT(YEAR FROM CURRENT_DATE)
  AND e.statut = 'Actif'
ORDER BY ue.nom, tc.libelle;

-- Vue: Demandes de congés en attente de validation
CREATE OR REPLACE VIEW v_demandes_conges_attente AS
SELECT 
    dc.id,
    e.matricule,
    ue.nom || ' ' || ue.prenom AS employe,
    tc.libelle AS type_conge,
    dc.date_debut,
    dc.date_fin,
    dc.nombre_jours,
    dc.motif,
    dc.date_demande,
    manager.nom || ' ' || manager.prenom AS validateur,
    s.nom AS service
FROM demande_conge dc
JOIN employe e ON dc.id_employe = e.id
JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
JOIN type_conge tc ON dc.id_type_conge = tc.id
LEFT JOIN employe val_emp ON dc.id_validateur = val_emp.id
LEFT JOIN utilisateur_entreprise manager ON val_emp.id_utilisateur = manager.id
LEFT JOIN service s ON e.id_service = s.id
WHERE dc.statut = 'En attente'
ORDER BY dc.date_demande DESC;

-- Vue: Présences du jour
CREATE OR REPLACE VIEW v_presences_aujourdhui AS
SELECT 
    e.matricule,
    ue.nom || ' ' || ue.prenom AS employe,
    s.nom AS service,
    fp.heure_arrivee,
    fp.heure_depart,
    fp.heures_travaillees,
    fp.retard_minutes,
    fp.statut,
    CASE 
        WHEN fp.retard_minutes > 0 THEN 'En retard'
        WHEN fp.heure_arrivee IS NULL THEN 'Absent'
        ELSE 'À l''heure'
    END AS etat_pointage
FROM employe e
JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
LEFT JOIN service s ON e.id_service = s.id
LEFT JOIN feuille_presence fp ON fp.id_employe = e.id 
    AND fp.date_travail = CURRENT_DATE
WHERE e.statut = 'Actif'
ORDER BY s.nom, ue.nom;

-- Vue: Bulletins de paie du mois en cours
CREATE OR REPLACE VIEW v_bulletins_mois_courant AS
SELECT 
    bp.id,
    e.matricule,
    ue.nom || ' ' || ue.prenom AS employe,
    s.nom AS service,
    bp.mois,
    bp.annee,
    bp.salaire_brut,
    bp.total_primes,
    bp.total_heures_sup,
    bp.total_retenues,
    bp.cotisation_cnaps,
    bp.cotisation_ostie,
    bp.impot_irsa,
    bp.salaire_net,
    bp.jours_travailles,
    bp.jours_conges,
    bp.jours_absences,
    bp.statut,
    bp.date_paiement
FROM bulletin_paie bp
JOIN employe e ON bp.id_employe = e.id
JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
LEFT JOIN service s ON e.id_service = s.id
WHERE bp.mois = EXTRACT(MONTH FROM CURRENT_DATE)
  AND bp.annee = EXTRACT(YEAR FROM CURRENT_DATE)
ORDER BY s.nom, ue.nom;

-- Vue: Statistiques RH globales
CREATE OR REPLACE VIEW v_stats_rh_globales AS
SELECT 
    (SELECT COUNT(*) FROM employe WHERE statut = 'Actif') AS effectif_total,
    (SELECT COUNT(*) FROM employe WHERE statut = 'Actif' AND id_utilisateur IN 
        (SELECT id FROM utilisateur_entreprise WHERE date_naissance > CURRENT_DATE - INTERVAL '30 years')) AS effectif_moins_30ans,
    (SELECT COUNT(DISTINCT id_employe) FROM demande_conge 
        WHERE statut = 'En attente') AS demandes_conges_attente,
    (SELECT COUNT(*) FROM demande_rh WHERE statut = 'En cours') AS demandes_rh_en_cours,
    (SELECT COUNT(*) FROM bulletin_paie 
        WHERE mois = EXTRACT(MONTH FROM CURRENT_DATE) 
        AND annee = EXTRACT(YEAR FROM CURRENT_DATE)
        AND statut = 'Validé') AS bulletins_valides_mois,
    (SELECT AVG(salaire_net) FROM bulletin_paie 
        WHERE mois = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 month')
        AND annee = EXTRACT(YEAR FROM CURRENT_DATE)) AS salaire_moyen_mois_dernier,
    (SELECT COUNT(*) FROM contrat_employe 
        WHERE est_actif = TRUE 
        AND date_fin < CURRENT_DATE + INTERVAL '30 days'
        AND date_fin > CURRENT_DATE) AS contrats_fin_30jours;

-- Vue: Alertes RH
CREATE OR REPLACE VIEW v_alertes_rh AS
SELECT 
    'Fin de contrat' AS type_alerte,
    e.matricule,
    ue.nom || ' ' || ue.prenom AS employe,
    'Contrat expire le ' || TO_CHAR(ce.date_fin, 'DD/MM/YYYY') AS message,
    ce.date_fin AS date_echeance,
    'Urgent' AS priorite
FROM employe e
JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
JOIN contrat_employe ce ON ce.id_employe = e.id AND ce.est_actif = TRUE
WHERE ce.date_fin < CURRENT_DATE + INTERVAL '30 days'
  AND ce.date_fin > CURRENT_DATE
  AND e.statut = 'Actif'

UNION ALL

SELECT 
    'Congés non pris',
    e.matricule,
    ue.nom || ' ' || ue.prenom,
    'Solde de ' || sc.solde_restant || ' jours non utilisé',
    NULL,
    'Moyen'
FROM employe e
JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
JOIN solde_conge sc ON sc.id_employe = e.id
JOIN type_conge tc ON sc.id_type_conge = tc.id
WHERE sc.solde_restant > 20
  AND tc.libelle = 'Congé payé'
  AND sc.annee = EXTRACT(YEAR FROM CURRENT_DATE)
  AND e.statut = 'Actif'

UNION ALL

SELECT 
    'Document expiré',
    e.matricule,
    ue.nom || ' ' || ue.prenom,
    'Document ' || td.libelle || ' expire le ' || TO_CHAR(de.date_expiration, 'DD/MM/YYYY'),
    de.date_expiration,
    'Élevé'
FROM employe e
JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
JOIN document_employe de ON de.id_employe = e.id
JOIN type_document_rh td ON de.id_type_document = td.id
WHERE de.date_expiration < CURRENT_DATE + INTERVAL '60 days'
  AND de.date_expiration > CURRENT_DATE
  AND e.statut = 'Actif'

ORDER BY priorite DESC, date_echeance;

-- ====================================================================
-- SECTION 2: TRIGGERS POUR AUTOMATISATION
-- ====================================================================

-- Trigger: Mise à jour automatique du solde de congés après validation
CREATE OR REPLACE FUNCTION update_solde_conge_after_validation()
RETURNS TRIGGER AS $$
BEGIN
    -- Si la demande est validée, déduire du solde
    IF NEW.statut = 'Validée' AND OLD.statut != 'Validée' THEN
        UPDATE solde_conge
        SET solde_pris = solde_pris + NEW.nombre_jours,
            solde_restant = solde_restant - NEW.nombre_jours
        WHERE id_employe = NEW.id_employe
          AND id_type_conge = NEW.id_type_conge
          AND annee = EXTRACT(YEAR FROM NEW.date_debut);
    END IF;
    
    -- Si la demande est annulée après validation, recréditer le solde
    IF NEW.statut = 'Annulée' AND OLD.statut = 'Validée' THEN
        UPDATE solde_conge
        SET solde_pris = solde_pris - NEW.nombre_jours,
            solde_restant = solde_restant + NEW.nombre_jours
        WHERE id_employe = NEW.id_employe
          AND id_type_conge = NEW.id_type_conge
          AND annee = EXTRACT(YEAR FROM NEW.date_debut);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_solde_conge
AFTER UPDATE OF statut ON demande_conge
FOR EACH ROW
EXECUTE FUNCTION update_solde_conge_after_validation();

-- Trigger: Calcul automatique nombre de jours de congé
CREATE OR REPLACE FUNCTION calculate_nombre_jours_conge()
RETURNS TRIGGER AS $$
BEGIN
    -- Calculer le nombre de jours ouvrables entre date_debut et date_fin
    -- Version simplifiée: compte tous les jours (amélioration possible: exclure week-ends)
    NEW.nombre_jours := NEW.date_fin - NEW.date_debut + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_jours_conge
BEFORE INSERT OR UPDATE OF date_debut, date_fin ON demande_conge
FOR EACH ROW
EXECUTE FUNCTION calculate_nombre_jours_conge();

-- Trigger: Création automatique des soldes de congés pour nouvel employé
CREATE OR REPLACE FUNCTION create_initial_solde_conges()
RETURNS TRIGGER AS $$
BEGIN
    -- Créer un solde pour chaque type de congé
    INSERT INTO solde_conge (id_employe, id_type_conge, annee, solde_initial, solde_acquis, solde_restant)
    SELECT 
        NEW.id,
        tc.id,
        EXTRACT(YEAR FROM CURRENT_DATE),
        0,
        0,
        0
    FROM type_conge tc
    WHERE tc.cumul_par_mois IS NOT NULL;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_create_solde_conges
AFTER INSERT ON employe
FOR EACH ROW
EXECUTE FUNCTION create_initial_solde_conges();

-- Trigger: Calcul automatique des heures travaillées
CREATE OR REPLACE FUNCTION calculate_heures_travaillees()
RETURNS TRIGGER AS $$
DECLARE
    pause_minutes INT := 60; -- 1h de pause par défaut
BEGIN
    IF NEW.heure_arrivee IS NOT NULL AND NEW.heure_depart IS NOT NULL THEN
        -- Calculer heures travaillées (en heures décimales)
        NEW.heures_travaillees := EXTRACT(EPOCH FROM (NEW.heure_depart - NEW.heure_arrivee)) / 3600 - (pause_minutes / 60.0);
        
        -- Calculer retard (si arrivée après 8h00)
        IF NEW.heure_arrivee > '08:00:00'::TIME THEN
            NEW.retard_minutes := EXTRACT(EPOCH FROM (NEW.heure_arrivee - '08:00:00'::TIME)) / 60;
        END IF;
        
        -- Calculer heures supplémentaires (si > 8h de travail)
        IF NEW.heures_travaillees > 8 THEN
            NEW.heures_supplementaires := NEW.heures_travaillees - 8;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_heures
BEFORE INSERT OR UPDATE OF heure_arrivee, heure_depart ON feuille_presence
FOR EACH ROW
EXECUTE FUNCTION calculate_heures_travaillees();

-- Trigger: Log d'audit automatique sur modifications employé
CREATE OR REPLACE FUNCTION log_audit_employe()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (id_utilisateur, action, table_concernee, id_enregistrement, details)
        VALUES (
            COALESCE(NULLIF(current_setting('app.current_user_id', true), ''), '0')::INT,
            'UPDATE',
            'employe',
            NEW.id,
            jsonb_build_object(
                'old', row_to_json(OLD),
                'new', row_to_json(NEW)
            )
        );
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (id_utilisateur, action, table_concernee, id_enregistrement, details)
        VALUES (
            COALESCE(NULLIF(current_setting('app.current_user_id', true), ''), '0')::INT,
            'CREATE',
            'employe',
            NEW.id,
            jsonb_build_object('new', row_to_json(NEW))
        );
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (id_utilisateur, action, table_concernee, id_enregistrement, details)
        VALUES (
            COALESCE(NULLIF(current_setting('app.current_user_id', true), ''), '0')::INT,
            'DELETE',
            'employe',
            OLD.id,
            jsonb_build_object('old', row_to_json(OLD))
        );
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_employe
AFTER INSERT OR UPDATE OR DELETE ON employe
FOR EACH ROW
EXECUTE FUNCTION log_audit_employe();

-- Trigger: Notification automatique lors de validation de congé
CREATE OR REPLACE FUNCTION notify_conge_validation()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.statut != OLD.statut AND NEW.statut IN ('Validée', 'Refusée') THEN
        INSERT INTO notification_rh (id_destinataire, type_notification, titre, message)
        SELECT 
            e.id_utilisateur,
            'Congé',
            'Demande de congé ' || NEW.statut,
            'Votre demande de congé du ' || TO_CHAR(NEW.date_debut, 'DD/MM/YYYY') || 
            ' au ' || TO_CHAR(NEW.date_fin, 'DD/MM/YYYY') || 
            ' a été ' || LOWER(NEW.statut) || 
            CASE WHEN NEW.commentaire_validation IS NOT NULL 
                THEN '. Commentaire: ' || NEW.commentaire_validation 
                ELSE '' 
            END
        FROM employe e
        WHERE e.id = NEW.id_employe;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_notify_conge
AFTER UPDATE OF statut ON demande_conge
FOR EACH ROW
EXECUTE FUNCTION notify_conge_validation();

-- ====================================================================
-- SECTION 3: FONCTIONS UTILITAIRES
-- ====================================================================

-- Fonction: Calculer l'acquisition mensuelle de congés pour tous les employés
CREATE OR REPLACE FUNCTION calculate_monthly_conge_acquisition()
RETURNS void AS $$
BEGIN
    UPDATE solde_conge sc
    SET 
        solde_acquis = solde_acquis + tc.cumul_par_mois,
        solde_restant = solde_initial + solde_acquis + tc.cumul_par_mois - solde_pris,
        updated_at = CURRENT_TIMESTAMP
    FROM type_conge tc
    JOIN employe e ON e.id = sc.id_employe
    WHERE sc.id_type_conge = tc.id
      AND tc.cumul_par_mois > 0
      AND sc.annee = EXTRACT(YEAR FROM CURRENT_DATE)
      AND e.statut = 'Actif';
END;
$$ LANGUAGE plpgsql;

-- Fonction: Générer feuille de présence depuis pointages
CREATE OR REPLACE FUNCTION generate_feuille_presence(p_date DATE)
RETURNS void AS $$
BEGIN
    INSERT INTO feuille_presence (id_employe, date_travail, heure_arrivee, heure_depart, est_present)
    SELECT DISTINCT
        p.id_employe,
        p_date,
        MIN(CASE WHEN tp.libelle = 'Entrée' THEN p.heure_pointage END),
        MAX(CASE WHEN tp.libelle = 'Sortie' THEN p.heure_pointage END),
        TRUE
    FROM pointage p
    JOIN type_pointage tp ON p.id_type_pointage = tp.id
    WHERE p.date_pointage = p_date
    GROUP BY p.id_employe
    ON CONFLICT (id_employe, date_travail) DO UPDATE
    SET heure_arrivee = EXCLUDED.heure_arrivee,
        heure_depart = EXCLUDED.heure_depart;
END;
$$ LANGUAGE plpgsql;

-- Fonction: Créer notifications pour contrats expirant bientôt
CREATE OR REPLACE FUNCTION notify_expiring_contracts()
RETURNS void AS $$
BEGIN
    INSERT INTO notification_rh (id_destinataire, type_notification, titre, message)
    SELECT DISTINCT
        (SELECT id FROM utilisateur_entreprise WHERE est_rh = TRUE LIMIT 1),
        'Contrat',
        'Contrat expire bientôt',
        'Le contrat de ' || ue.nom || ' ' || ue.prenom || 
        ' (matricule: ' || e.matricule || ') expire le ' || 
        TO_CHAR(ce.date_fin, 'DD/MM/YYYY')
    FROM employe e
    JOIN utilisateur_entreprise ue ON e.id_utilisateur = ue.id
    JOIN contrat_employe ce ON ce.id_employe = e.id AND ce.est_actif = TRUE
    WHERE ce.date_fin BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days'
      AND e.statut = 'Actif'
      AND NOT EXISTS (
          SELECT 1 FROM notification_rh nr
          WHERE nr.type_notification = 'Contrat'
            AND nr.message LIKE '%' || e.matricule || '%'
            AND nr.date_creation > CURRENT_DATE - INTERVAL '7 days'
      );
END;
$$ LANGUAGE plpgsql;

-- ====================================================================
-- SECTION 4: TÂCHES PLANIFIÉES (à exécuter via CRON ou pg_cron)
-- ====================================================================

-- À exécuter le 1er de chaque mois
-- SELECT calculate_monthly_conge_acquisition();

-- À exécuter quotidiennement en fin de journée
-- SELECT generate_feuille_presence(CURRENT_DATE);

-- À exécuter quotidiennement
-- SELECT notify_expiring_contracts();

-- ====================================================================
-- FIN DU SCRIPT
-- ====================================================================

-- Vérification des vues créées
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public' 
  AND table_name LIKE 'v_%'
ORDER BY table_name;

-- Vérification des triggers créés
SELECT trigger_name, event_object_table, action_timing, event_manipulation
FROM information_schema.triggers
WHERE trigger_schema = 'public'
  AND trigger_name LIKE 'trg_%'
ORDER BY event_object_table, trigger_name;
