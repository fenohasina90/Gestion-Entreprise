-- ====================================================================
-- STRUCTURE COMPLETE BASE DE DONNÉES RH
-- ====================================================================
-- Ce script étend la base existante avec les fonctionnalités RH complètes
-- sans modifier les tables existantes (recrutement, offres, CV, etc.)
-- 
-- NOUVELLES FONCTIONNALITÉS AJOUTÉES:
-- 1. Gestion du personnel (fiches employés, contrats, documents)
-- 2. Gestion des congés et absences
-- 3. Gestion du temps et présences (pointage)
-- 4. Gestion de la paie
-- 5. Self-service employé et audit
-- ====================================================================

\c gestion_entreprise;

-- ====================================================================
-- SECTION 1: GESTION DU PERSONNEL
-- ====================================================================

-- Table: Catégories de personnel (Ouvriers, Employés, TAM, Cadres, Dirigeants)
CREATE TABLE IF NOT EXISTS categorie_personnel(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,  -- Ouvrier, Employé, TAM, Cadre, Dirigeant
    description TEXT,
    niveau_hierarchique INT,  -- 1 = Ouvrier, 5 = Dirigeant
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Types de contrat
CREATE TABLE IF NOT EXISTS type_contrat(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE,  -- CDI, CDD, Stage, Contrat temporaire
    description TEXT
);

-- Table: Services/Départements
CREATE TABLE IF NOT EXISTS service(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    id_responsable INT,  -- FK vers employe (peut être NULL initialement)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Postes
CREATE TABLE IF NOT EXISTS poste(
    id SERIAL PRIMARY KEY,
    titre VARCHAR(150) NOT NULL,
    description TEXT,
    id_service INT REFERENCES service(id),
    id_categorie INT REFERENCES categorie_personnel(id),
    salaire_min DECIMAL(12,2),
    salaire_max DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Employés (extension de utilisateur_entreprise pour données RH complètes)
CREATE TABLE IF NOT EXISTS employe(
    id SERIAL PRIMARY KEY,
    id_utilisateur INT REFERENCES utilisateur_entreprise(id) ON DELETE CASCADE,
    matricule VARCHAR(50) UNIQUE NOT NULL,
    photo_url VARCHAR(255),
    telephone VARCHAR(20),
    telephone_urgence VARCHAR(20),
    contact_urgence VARCHAR(255),
    situation_familiale VARCHAR(50),  -- Célibataire, Marié(e), Divorcé(e), Veuf/Veuve
    nombre_enfants INT DEFAULT 0,
    numero_securite_sociale VARCHAR(100),
    numero_cin VARCHAR(50),
    date_delivrance_cin DATE,
    lieu_delivrance_cin VARCHAR(100),
    id_service INT REFERENCES service(id),
    id_poste INT REFERENCES poste(id),
    id_categorie INT REFERENCES categorie_personnel(id),
    id_manager INT REFERENCES employe(id),  -- Hiérarchie
    date_embauche DATE NOT NULL,
    date_fin_contrat DATE,
    statut VARCHAR(50) DEFAULT 'Actif',  -- Actif, En congé, Suspendu, Démissionnaire, Licencié
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Historique des contrats
CREATE TABLE IF NOT EXISTS contrat_employe(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    id_type_contrat INT REFERENCES type_contrat(id),
    date_debut DATE NOT NULL,
    date_fin DATE,
    duree_periode_essai INT,  -- en jours
    date_fin_periode_essai DATE,
    salaire_brut DECIMAL(12,2) NOT NULL,
    est_actif BOOLEAN DEFAULT TRUE,
    motif_fin TEXT,
    document_url VARCHAR(255),  -- Lien vers le PDF du contrat
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Historique des postes (promotions, mobilités)
CREATE TABLE IF NOT EXISTS historique_poste(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    id_poste_ancien INT REFERENCES poste(id),
    id_poste_nouveau INT REFERENCES poste(id),
    date_changement DATE NOT NULL,
    motif VARCHAR(50),  -- Promotion, Mutation, Rétrogradation
    commentaire TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Types de documents RH
CREATE TABLE IF NOT EXISTS type_document_rh(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE,  -- CIN, Diplôme, Certificat médical, Attestation
    est_obligatoire BOOLEAN DEFAULT FALSE
);

-- Table: Documents employés
CREATE TABLE IF NOT EXISTS document_employe(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    id_type_document INT REFERENCES type_document_rh(id),
    nom_fichier VARCHAR(255) NOT NULL,
    url_fichier VARCHAR(500) NOT NULL,
    date_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expiration DATE,
    commentaire TEXT
);

-- ====================================================================
-- SECTION 2: GESTION DES CONGÉS ET ABSENCES
-- ====================================================================

-- Table: Types de congés
CREATE TABLE IF NOT EXISTS type_conge(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE,  -- Congé payé, Maladie, Maternité, Sans solde, etc.
    est_remunere BOOLEAN DEFAULT TRUE,
    duree_max_jours INT,  -- Durée maximale autorisée
    cumul_par_mois DECIMAL(5,2),  -- Ex: 2.5 jours/mois pour congé payé
    justificatif_requis BOOLEAN DEFAULT FALSE,
    description TEXT
);

-- Table: Soldes de congés par employé
CREATE TABLE IF NOT EXISTS solde_conge(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    id_type_conge INT REFERENCES type_conge(id),
    annee INT NOT NULL,
    solde_initial DECIMAL(5,2) DEFAULT 0,  -- Solde en début d'année
    solde_acquis DECIMAL(5,2) DEFAULT 0,   -- Jours acquis durant l'année
    solde_pris DECIMAL(5,2) DEFAULT 0,     -- Jours pris
    solde_restant DECIMAL(5,2) DEFAULT 0,  -- Solde disponible
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_employe, id_type_conge, annee)
);

-- Table: Demandes de congés
CREATE TABLE IF NOT EXISTS demande_conge(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    id_type_conge INT REFERENCES type_conge(id),
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    nombre_jours DECIMAL(5,2) NOT NULL,
    motif TEXT,
    document_justificatif VARCHAR(255),
    statut VARCHAR(50) DEFAULT 'En attente',  -- En attente, Validée, Refusée, Annulée
    id_validateur INT REFERENCES employe(id),
    date_demande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_validation TIMESTAMP,
    commentaire_validation TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Absences (autres que congés: retards, absences injustifiées, etc.)
CREATE TABLE IF NOT EXISTS absence(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    date_absence DATE NOT NULL,
    heure_debut TIME,
    heure_fin TIME,
    type_absence VARCHAR(50),  -- Retard, Absence injustifiée, Autorisation spéciale
    motif TEXT,
    est_justifiee BOOLEAN DEFAULT FALSE,
    document_justificatif VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ====================================================================
-- SECTION 3: GESTION DU TEMPS ET DES PRÉSENCES
-- ====================================================================

-- Table: Types de pointage
CREATE TABLE IF NOT EXISTS type_pointage(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,  -- Entrée, Sortie, Pause début, Pause fin
    description TEXT
);

-- Table: Pointages quotidiens
CREATE TABLE IF NOT EXISTS pointage(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    date_pointage DATE NOT NULL,
    heure_pointage TIME NOT NULL,
    id_type_pointage INT REFERENCES type_pointage(id),
    methode VARCHAR(50),  -- Manuel, Badgeuse, Application mobile, Biométrique
    latitude DECIMAL(10,8),  -- Pour géolocalisation si pointage mobile
    longitude DECIMAL(11,8),
    commentaire TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Feuilles de présence (récapitulatif journalier)
CREATE TABLE IF NOT EXISTS feuille_presence(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    date_travail DATE NOT NULL,
    heure_arrivee TIME,
    heure_depart TIME,
    heures_travaillees DECIMAL(5,2),
    heures_supplementaires DECIMAL(5,2) DEFAULT 0,
    retard_minutes INT DEFAULT 0,
    est_present BOOLEAN DEFAULT TRUE,
    statut VARCHAR(50),  -- Présent, Absent, Congé, Télétravail
    commentaire TEXT,
    validee BOOLEAN DEFAULT FALSE,
    date_validation TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_employe, date_travail)
);

-- Table: Heures supplémentaires
CREATE TABLE IF NOT EXISTS heure_supplementaire(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    date_hs DATE NOT NULL,
    nombre_heures DECIMAL(5,2) NOT NULL,
    type_hs VARCHAR(50),  -- Normal, Nuit, Week-end, Jour férié
    taux_majoration DECIMAL(5,2) DEFAULT 1.25,  -- Coefficient multiplicateur
    motif TEXT,
    validee BOOLEAN DEFAULT FALSE,
    id_validateur INT REFERENCES employe(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ====================================================================
-- SECTION 4: GESTION DE LA PAIE
-- ====================================================================

-- Table: Éléments de paie (primes, avances, retenues, etc.)
CREATE TABLE IF NOT EXISTS element_paie(
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    libelle VARCHAR(150) NOT NULL,
    type_element VARCHAR(50) NOT NULL,  -- Prime, Avance, Retenue, Indemnité
    mode_calcul VARCHAR(50),  -- Fixe, Pourcentage, Quantité
    est_imposable BOOLEAN DEFAULT TRUE,
    est_cotisable BOOLEAN DEFAULT TRUE,  -- Soumis aux cotisations sociales
    description TEXT
);

-- Table: Paramètres de paie (taux CNAPS, OSTIE, IRSA, etc.)
CREATE TABLE IF NOT EXISTS parametre_paie(
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    libelle VARCHAR(150) NOT NULL,
    valeur DECIMAL(10,4) NOT NULL,  -- Taux en pourcentage ou valeur fixe
    type_parametre VARCHAR(50),  -- Cotisation sociale, Taux impôt, Plafond
    date_debut DATE NOT NULL,
    date_fin DATE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Bulletins de paie
CREATE TABLE IF NOT EXISTS bulletin_paie(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    mois INT NOT NULL CHECK(mois BETWEEN 1 AND 12),
    annee INT NOT NULL,
    salaire_brut DECIMAL(12,2) NOT NULL,
    total_primes DECIMAL(12,2) DEFAULT 0,
    total_avances DECIMAL(12,2) DEFAULT 0,
    total_heures_sup DECIMAL(12,2) DEFAULT 0,
    total_retenues DECIMAL(12,2) DEFAULT 0,
    cotisation_cnaps DECIMAL(12,2) DEFAULT 0,
    cotisation_ostie DECIMAL(12,2) DEFAULT 0,
    impot_irsa DECIMAL(12,2) DEFAULT 0,
    salaire_net DECIMAL(12,2) NOT NULL,
    jours_travailles INT,
    jours_conges INT,
    jours_absences INT,
    statut VARCHAR(50) DEFAULT 'Brouillon',  -- Brouillon, Validé, Payé
    date_paiement DATE,
    fichier_pdf VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT REFERENCES utilisateur_entreprise(id),
    UNIQUE(id_employe, mois, annee)
);

-- Table: Détails du bulletin (lignes de paie)
CREATE TABLE IF NOT EXISTS ligne_bulletin(
    id SERIAL PRIMARY KEY,
    id_bulletin INT REFERENCES bulletin_paie(id) ON DELETE CASCADE,
    id_element_paie INT REFERENCES element_paie(id),
    libelle VARCHAR(150),
    base_calcul DECIMAL(12,2),
    taux DECIMAL(10,4),
    montant DECIMAL(12,2) NOT NULL,
    type_ligne VARCHAR(50),  -- Gain, Retenue, Cotisation
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Avances sur salaire
CREATE TABLE IF NOT EXISTS avance_salaire(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    montant DECIMAL(12,2) NOT NULL,
    date_demande DATE NOT NULL,
    date_octroi DATE,
    nombre_mois_remboursement INT DEFAULT 1,
    montant_rembourse DECIMAL(12,2) DEFAULT 0,
    statut VARCHAR(50) DEFAULT 'En attente',  -- En attente, Accordée, Refusée, Remboursée
    motif TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Primes
CREATE TABLE IF NOT EXISTS prime_employe(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    id_element_paie INT REFERENCES element_paie(id),
    montant DECIMAL(12,2) NOT NULL,
    mois INT CHECK(mois BETWEEN 1 AND 12),
    annee INT,
    motif TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ====================================================================
-- SECTION 5: SELF-SERVICE EMPLOYÉ & AUDIT
-- ====================================================================

-- Table: Types de demandes RH
CREATE TABLE IF NOT EXISTS type_demande_rh(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE,  -- Attestation travail, Bulletin paie, Certificat salaire
    delai_traitement_jours INT DEFAULT 7,
    necessite_validation BOOLEAN DEFAULT TRUE,
    description TEXT
);

-- Table: Demandes RH (attestations, documents, etc.)
CREATE TABLE IF NOT EXISTS demande_rh(
    id SERIAL PRIMARY KEY,
    id_employe INT REFERENCES employe(id) ON DELETE CASCADE,
    id_type_demande INT REFERENCES type_demande_rh(id),
    date_demande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motif TEXT,
    statut VARCHAR(50) DEFAULT 'En cours',  -- En cours, Traitée, Refusée
    date_traitement TIMESTAMP,
    id_traiteur INT REFERENCES utilisateur_entreprise(id),
    commentaire_traitement TEXT,
    document_genere VARCHAR(255)
);

-- Table: Notifications
CREATE TABLE IF NOT EXISTS notification_rh(
    id SERIAL PRIMARY KEY,
    id_destinataire INT REFERENCES utilisateur_entreprise(id),
    type_notification VARCHAR(100),
    titre VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    est_lue BOOLEAN DEFAULT FALSE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_lecture TIMESTAMP,
    lien_action VARCHAR(255)  -- URL pour action directe
);

-- Table: Journal d'audit (traçabilité)
CREATE TABLE IF NOT EXISTS audit_log(
    id SERIAL PRIMARY KEY,
    id_utilisateur INT REFERENCES utilisateur_entreprise(id),
    action VARCHAR(100) NOT NULL,  -- CREATE, UPDATE, DELETE, LOGIN, EXPORT
    table_concernee VARCHAR(100),
    id_enregistrement INT,
    details JSONB,  -- Stockage des anciennes/nouvelles valeurs
    adresse_ip VARCHAR(50),
    date_action TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ====================================================================
-- SECTION 6: INDEXES POUR OPTIMISATION
-- ====================================================================

-- Indexes sur employe
CREATE INDEX IF NOT EXISTS idx_employe_utilisateur ON employe(id_utilisateur);
CREATE INDEX IF NOT EXISTS idx_employe_matricule ON employe(matricule);
CREATE INDEX IF NOT EXISTS idx_employe_service ON employe(id_service);
CREATE INDEX IF NOT EXISTS idx_employe_poste ON employe(id_poste);
CREATE INDEX IF NOT EXISTS idx_employe_manager ON employe(id_manager);
CREATE INDEX IF NOT EXISTS idx_employe_statut ON employe(statut);

-- Indexes sur service
CREATE INDEX IF NOT EXISTS idx_service_responsable ON service(id_responsable);

-- Indexes sur contrat_employe
CREATE INDEX IF NOT EXISTS idx_contrat_employe ON contrat_employe(id_employe);
CREATE INDEX IF NOT EXISTS idx_contrat_actif ON contrat_employe(est_actif);

-- Indexes sur congés
CREATE INDEX IF NOT EXISTS idx_solde_conge_employe ON solde_conge(id_employe);
CREATE INDEX IF NOT EXISTS idx_solde_conge_annee ON solde_conge(annee);
CREATE INDEX IF NOT EXISTS idx_demande_conge_employe ON demande_conge(id_employe);
CREATE INDEX IF NOT EXISTS idx_demande_conge_statut ON demande_conge(statut);
CREATE INDEX IF NOT EXISTS idx_demande_conge_dates ON demande_conge(date_debut, date_fin);

-- Indexes sur pointage
CREATE INDEX IF NOT EXISTS idx_pointage_employe ON pointage(id_employe);
CREATE INDEX IF NOT EXISTS idx_pointage_date ON pointage(date_pointage);
CREATE INDEX IF NOT EXISTS idx_feuille_presence_employe ON feuille_presence(id_employe);
CREATE INDEX IF NOT EXISTS idx_feuille_presence_date ON feuille_presence(date_travail);

-- Indexes sur paie
CREATE INDEX IF NOT EXISTS idx_bulletin_employe ON bulletin_paie(id_employe);
CREATE INDEX IF NOT EXISTS idx_bulletin_periode ON bulletin_paie(annee, mois);
CREATE INDEX IF NOT EXISTS idx_bulletin_statut ON bulletin_paie(statut);
CREATE INDEX IF NOT EXISTS idx_ligne_bulletin ON ligne_bulletin(id_bulletin);

-- Indexes sur audit
CREATE INDEX IF NOT EXISTS idx_audit_utilisateur ON audit_log(id_utilisateur);
CREATE INDEX IF NOT EXISTS idx_audit_action ON audit_log(action);
CREATE INDEX IF NOT EXISTS idx_audit_date ON audit_log(date_action);

-- ====================================================================
-- SECTION 7: CONTRAINTES ET RELATIONS SUPPLÉMENTAIRES
-- ====================================================================

-- Contrainte: manager référence employe
ALTER TABLE "service" 
ADD CONSTRAINT fk_service_responsable 
FOREIGN KEY (id_responsable) REFERENCES employe(id) ON DELETE SET NULL;

-- ====================================================================
-- SECTION 8: DONNÉES DE RÉFÉRENCE INITIALES
-- ====================================================================

-- Catégories de personnel
INSERT INTO categorie_personnel (nom, description, niveau_hierarchique) VALUES
('Ouvrier', 'Exécutent des tâches manuelles ou techniques précises', 1),
('Employé', 'Réalisent des tâches administratives ou commerciales', 2),
('Technicien et Agent de Maîtrise', 'Supervisent des équipes ou projets techniques', 3),
('Cadre', 'Responsables de gestion et stratégie départementale', 4),
('Dirigeant', 'Niveau le plus élevé de décision stratégique', 5)
ON CONFLICT (nom) DO NOTHING;

-- Types de contrat
INSERT INTO type_contrat (libelle, description) VALUES
('CDI', 'Contrat à Durée Indéterminée'),
('CDD', 'Contrat à Durée Déterminée'),
('Stage', 'Contrat de stage professionnel'),
('Apprentissage', 'Contrat d''apprentissage'),
('Interim', 'Contrat de travail temporaire'),
('Freelance', 'Contrat de prestation de service')
ON CONFLICT (libelle) DO NOTHING;

-- Types de congés
INSERT INTO type_conge (libelle, est_remunere, duree_max_jours, cumul_par_mois, justificatif_requis, description) VALUES
('Congé payé', TRUE, 30, 2.5, FALSE, 'Congé annuel rémunéré (2,5 jours/mois)'),
('Congé maladie', TRUE, 90, 0, TRUE, 'Congé pour raison de santé avec certificat médical'),
('Congé maternité', TRUE, 98, 0, TRUE, 'Congé de maternité (14 semaines)'),
('Congé paternité', TRUE, 10, 0, TRUE, 'Congé de paternité'),
('Congé sans solde', FALSE, NULL, 0, FALSE, 'Congé non rémunéré pour motif personnel'),
('Congé exceptionnel', TRUE, 10, 0, TRUE, 'Mariage, décès, naissance'),
('Congé sabbatique', FALSE, 365, 0, TRUE, 'Longue absence pour projet personnel'),
('Congé formation', TRUE, 30, 0, TRUE, 'Formation professionnelle')
ON CONFLICT (libelle) DO NOTHING;

-- Types de documents RH
INSERT INTO type_document_rh (libelle, est_obligatoire) VALUES
('CIN', TRUE),
('Diplôme', TRUE),
('Certificat de naissance', TRUE),
('Certificat de résidence', FALSE),
('Certificat médical', TRUE),
('Attestation de travail', FALSE),
('Photo d''identité', TRUE),
('RIB/RIP', TRUE),
('Casier judiciaire', FALSE),
('Certificat de mariage', FALSE)
ON CONFLICT (libelle) DO NOTHING;

-- Types de pointage
INSERT INTO type_pointage (libelle, description) VALUES
('Entrée', 'Pointage d''arrivée'),
('Sortie', 'Pointage de départ'),
('Pause début', 'Début de pause déjeuner'),
('Pause fin', 'Fin de pause déjeuner')
ON CONFLICT (libelle) DO NOTHING;

-- Éléments de paie
INSERT INTO element_paie (code, libelle, type_element, mode_calcul, est_imposable, est_cotisable) VALUES
('PRIME_TRANSPORT', 'Prime de transport', 'Prime', 'Fixe', FALSE, FALSE),
('PRIME_ANCIENNETE', 'Prime d''ancienneté', 'Prime', 'Pourcentage', TRUE, TRUE),
('PRIME_RENDEMENT', 'Prime de rendement', 'Prime', 'Fixe', TRUE, TRUE),
('AVANCE_SALAIRE', 'Avance sur salaire', 'Retenue', 'Fixe', FALSE, FALSE),
('RETENUE_ABSENCE', 'Retenue pour absence', 'Retenue', 'Quantité', FALSE, FALSE),
('HS_NORMALE', 'Heures supplémentaires normales', 'Prime', 'Quantité', TRUE, TRUE),
('HS_NUIT', 'Heures supplémentaires de nuit', 'Prime', 'Quantité', TRUE, TRUE),
('INDEMNITE_LICENCIEMENT', 'Indemnité de licenciement', 'Indemnité', 'Fixe', FALSE, FALSE)
ON CONFLICT (code) DO NOTHING;

-- Paramètres de paie (taux Madagascar 2024)
INSERT INTO parametre_paie (code, libelle, valeur, type_parametre, date_debut, description) VALUES
('TAUX_CNAPS', 'Taux CNAPS employeur', 13.00, 'Cotisation sociale', '2024-01-01', 'Cotisation CNAPS part patronale'),
('TAUX_CNAPS_EMP', 'Taux CNAPS salarié', 1.00, 'Cotisation sociale', '2024-01-01', 'Cotisation CNAPS part salariale'),
('TAUX_OSTIE', 'Taux OSTIE', 5.00, 'Cotisation sociale', '2024-01-01', 'Cotisation santé OSTIE'),
('PLAFOND_CNAPS', 'Plafond CNAPS', 1800000, 'Plafond', '2024-01-01', 'Plafond cotisation CNAPS mensuel'),
('TAUX_IRSA', 'Taux IRSA progressif', 20.00, 'Taux impôt', '2024-01-01', 'Impôt sur revenu salarial')
ON CONFLICT (code) DO NOTHING;

-- Types de demandes RH
INSERT INTO type_demande_rh (libelle, delai_traitement_jours, necessite_validation, description) VALUES
('Attestation de travail', 3, TRUE, 'Document certifiant l''emploi'),
('Certificat de salaire', 5, TRUE, 'Justificatif de rémunération'),
('Bulletin de paie', 1, FALSE, 'Copie d''un bulletin de paie antérieur'),
('Autorisation de sortie', 1, TRUE, 'Permission de quitter le poste'),
('Demande de formation', 15, TRUE, 'Demande de participation à une formation')
ON CONFLICT (libelle) DO NOTHING;

-- ====================================================================
-- FIN DU SCRIPT
-- ====================================================================
