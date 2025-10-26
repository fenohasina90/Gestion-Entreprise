-- Script pour mettre à jour la table resultat avec les statuts
-- Exécuter ce script après avoir créé la table resultat_statut

-- Insérer les statuts
INSERT INTO resultat_statut (id, statut) VALUES
(1, 'Excellent'),         -- Note ≥ 90%
(2, 'Très bien'),         -- Note entre 80% et 89%
(3, 'Bien'),              -- Note entre 70% et 79%
(4, 'Passable'),          -- Note entre 60% et 69%
(5, 'Insuffisant'),       -- Note entre 40% et 59%
(6, 'Échec'),             -- Note < 40%
(7, 'Non évalué');

-- Ajouter les colonnes manquantes à la table resultat si elles n'existent pas
ALTER TABLE resultat 
ADD COLUMN IF NOT EXISTS id_resultat_statut INT REFERENCES resultat_statut(id),
ADD COLUMN IF NOT EXISTS id_offre INT REFERENCES offre(id);

-- Mettre à jour les résultats existants avec le statut approprié
UPDATE resultat 
SET id_resultat_statut = CASE 
    WHEN total_question > 0 THEN
        CASE 
            WHEN (reponse_correcte * 100.0 / total_question) >= 90 THEN 1
            WHEN (reponse_correcte * 100.0 / total_question) >= 80 THEN 2
            WHEN (reponse_correcte * 100.0 / total_question) >= 70 THEN 3
            WHEN (reponse_correcte * 100.0 / total_question) >= 60 THEN 4
            WHEN (reponse_correcte * 100.0 / total_question) >= 40 THEN 5
            ELSE 6
        END
    ELSE 7
END
WHERE id_resultat_statut IS NULL;

-- Créer des index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_resultat_id_resultat_statut ON resultat(id_resultat_statut);
CREATE INDEX IF NOT EXISTS idx_resultat_id_offre ON resultat(id_offre);
CREATE INDEX IF NOT EXISTS idx_resultat_score ON resultat(score);
