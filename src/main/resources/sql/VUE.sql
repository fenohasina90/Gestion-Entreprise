-- nettoyage


-- offre miseho any utilisateur
CREATE OR REPLACE VIEW v_offre_utilisateur AS
SELECT 
    o.id,
    o.poste,
    o.entreprise,
    o.contrat,
    o.salaire,
    rp.type AS role_requis,
    o.create_at AS date_creation,
    om.mission AS missions,
    op.experience, 
    op.genre,
    op.age_min,
    op.age_max,
    (SELECT type_diplome FROM niv_diplome WHERE id = op.id_niv) AS type_diplome,
    op.lieu
FROM offre o
JOIN offre_mission om ON om.id_offre = o.id
LEFT JOIN critere_offre op ON op.id_offre = o.id
LEFT JOIN role_profil rp ON o.id_role = rp.id
WHERE o.est_valide_rh = true
ORDER BY o.create_at DESC;

-- offre miseho any @ RH sy ny unite
-- misy condition ID unite ftsn refa unite
CREATE OR REPLACE VIEW v_offre_admin AS
SELECT 
    o.id,
    o.poste,
    o.entreprise,
    o.contrat,
    o.salaire,
    o.id_role,
    rp.type AS role_requis,
    o.create_at AS date_creation,
    om.mission AS missions,
    o.est_valide_rh
FROM offre o
JOIN offre_mission om ON om.id_offre = o.id
LEFT JOIN critere_offre op ON op.id_offre = o.id
LEFT JOIN role_profil rp ON o.id_role = rp.id
ORDER BY o.create_at DESC;


-- liste offre misy cv an utilisateur
CREATE OR REPLACE VIEW v_offre_user_cv AS
SELECT 
    o.id,
    o.poste,
    o.entreprise,
    o.contrat,
    o.salaire,
    rp.type AS role_requis,
    o.create_at AS date_creation,
    om.mission AS missions,
    c.id_utilisateur,
    cs.statut,
    c.est_entretien
FROM offre o
JOIN offre_mission om ON om.id_offre = o.id
LEFT JOIN role_profil rp ON o.id_role = rp.id
JOIN cv c ON c.id_offre = o.id
JOIN cv_statut cs ON c.id = cs.id_cv
ORDER BY o.create_at DESC;

CREATE OR REPLACE VIEW v_qcm AS
SELECT 
    q.id AS id,
    q.questionnaire,
    qt.id AS id_question,
    qt.question,
    qt.points,
    r.id AS id_reponse,
    r.reponse_text,
    r.est_vraie,
    q.id_offre
FROM questionnaire q
JOIN question qt ON qt.id_questionnaire = q.id
JOIN reponse r ON r.id_question = qt.id
ORDER BY q.id ASC, qt.id ASC;



-- valiny marina
-- SELECT c FROM ContratEssaie c WHERE c.idEvaluation.id = :idEvaluation
SELECT c.* 
FROM contrat_essaie c 
JOIN evalution_entretien e ON c.id_evaluation = e.id
WHERE e.id = :idEvaluation;