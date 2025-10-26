-- Script de mise à jour pour les évaluations et contrats d'essai
-- Exécuter après avoir créé les entités

-- Créer la table evalution_entretien si elle n'existe pas
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'evalution_entretien') THEN
        CREATE TABLE evalution_entretien (
            id SERIAL PRIMARY KEY,
            note INT,
            commentaire TEXT,
            date_evaluation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            id_entretien INT REFERENCES planing_entretien(id)
        );
    END IF;
END $$;

-- Créer la table contrat_essaie si elle n'existe pas
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'contrat_essaie') THEN
        CREATE TABLE contrat_essaie (
            id SERIAL PRIMARY KEY,
            contrat VARCHAR(255),
            duree INT,
            date_debut DATE,
            create_at DATE DEFAULT CURRENT_DATE,
            id_evaluation INT REFERENCES evalution_entretien(id),
            mot_de_passe VARCHAR(255),
            email_utilisateur VARCHAR(255),
            est_prolongation BOOLEAN DEFAULT FALSE,
            id_contrat_original INT
        );
    END IF;
END $$;

-- Ajouter des contraintes de clé étrangère pour id_contrat_original
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_name = 'fk_contrat_original' 
                   AND table_name = 'contrat_essaie') THEN
        ALTER TABLE contrat_essaie 
        ADD CONSTRAINT fk_contrat_original 
        FOREIGN KEY (id_contrat_original) REFERENCES contrat_essaie(id);
    END IF;
END $$;

-- Créer des index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_evalution_entretien_id_entretien ON evalution_entretien(id_entretien);
CREATE INDEX IF NOT EXISTS idx_evalution_entretien_note ON evalution_entretien(note);
CREATE INDEX IF NOT EXISTS idx_evalution_entretien_date ON evalution_entretien(date_evaluation);

CREATE INDEX IF NOT EXISTS idx_contrat_essaie_id_evaluation ON contrat_essaie(id_evaluation);
CREATE INDEX IF NOT EXISTS idx_contrat_essaie_date_debut ON contrat_essaie(date_debut);
CREATE INDEX IF NOT EXISTS idx_contrat_essaie_est_prolongation ON contrat_essaie(est_prolongation);
CREATE INDEX IF NOT EXISTS idx_contrat_essaie_id_contrat_original ON contrat_essaie(id_contrat_original);

-- Insérer quelques données de test (optionnel)
-- INSERT INTO evalution_entretien (note, commentaire, id_entretien) VALUES
-- (15, 'Excellent candidat, très motivé', 1),
-- (18, 'Profil parfait pour le poste', 2),
-- (10, 'Compétences moyennes', 3);

-- Vérifier les tables créées
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name IN ('evalution_entretien', 'contrat_essaie')
ORDER BY table_name, ordinal_position;
