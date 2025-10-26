-- Script de test pour les entretiens
-- Exécuter après avoir créé la table planing_entretien

-- Insérer quelques entretiens de test (remplacer les IDs par des valeurs réelles)
-- INSERT INTO planing_entretien (date_entretien, id_resultat) VALUES
-- ('2025-09-25 09:30:00', 1),
-- ('2025-09-26 14:00:00', 2),
-- ('2025-10-01 10:30:00', 3),
-- ('2025-10-15 16:00:00', 4);

-- Vérifier les entretiens existants
SELECT 
    p.id,
    p.date_entretien,
    r.score,
    r.total_question,
    r.reponse_correcte,
    c.nom,
    c.prenom,
    c.email,
    o.poste,
    o.entreprise,
    s.statut
FROM planing_entretien p
JOIN resultat r ON p.id_resultat = r.id
JOIN candidat c ON r.id_candidat = c.id
JOIN offre o ON r.id_offre = o.id
LEFT JOIN resultat_statut s ON r.id_resultat_statut = s.id
ORDER BY p.date_entretien ASC;
