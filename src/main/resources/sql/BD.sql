CREATE DATABASE gestion_entreprise;

\c gestion_entreprise;

-- utilisateur entreprise

CREATE TABLE role_profil(
    id SERIAL PRIMARY KEY,
    "type" VARCHAR(50)
);

CREATE TABLE utilisateur_candidat(
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    mdp VARCHAR(255)
);


CREATE TABLE utilisateur_entreprise(
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    mdp VARCHAR(255),
    nom VARCHAR(255),
    prenom VARCHAR(255),
    date_naissance DATE,
    adresse VARCHAR(255),
    date_debut DATE,
    id_role INT REFERENCES role_profil(id),
    est_rh BOOLEAN
);

-- offre
CREATE TABLE niv_diplome(
    id SERIAL PRIMARY KEY ,
    type_diplome VARCHAR (250),
    niveau INT 
);

CREATE TABLE offre(
    id SERIAL PRIMARY KEY,
    poste VARCHAR(255),
    entreprise VARCHAR(255),
    contrat VARCHAR(255),
    salaire VARCHAR(255),
    id_role INT REFERENCES role_profil(id),
    est_valide_rh BOOLEAN,
    create_at TIMESTAMP DEFAULT CURRENT_DATE
);

CREATE TABLE critere_offre(
    id SERIAL PRIMARY KEY,
    experience INT,
    genre VARCHAR (255),
    age_min INT,
    age_max INT,
    id_niv INT,
    lieu VARCHAR(255),
    id_offre INT REFERENCES offre(id)
);

CREATE TABLE offre_mission(
    id SERIAL PRIMARY KEY,
    mission VARCHAR(255),
    id_offre INT REFERENCES offre(id)
);

CREATE TABLE offre_profil(
    id SERIAL PRIMARY KEY,
    profil VARCHAR(255),
    id_offre INT REFERENCES offre(id)
);



-- CV
CREATE TABLE cv(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255),
    prenom VARCHAR(255),
    email VARCHAR(255),
    genre VARCHAR(255),
    date_naissance DATE,
    adresse VARCHAR(255),
    id_offre INT REFERENCES offre(id),
    id_utilisateur INT REFERENCES utilisateur_candidat(id),
    est_entretien BOOLEAN
);

CREATE TABLE cv_statut(
    id SERIAL PRIMARY KEY,
    statut BOOLEAN,
    id_cv INT REFERENCES cv(id)
);

CREATE TABLE cv_diplome(
    id SERIAL PRIMARY KEY,
    date_debut DATE,
    id_niv INT REFERENCES niv_diplome(id),
    id_cv INT REFERENCES cv(id)
);

CREATE TABLE cv_competence(
    id SERIAL PRIMARY KEY,
    competence VARCHAR(255),
    id_cv INT REFERENCES cv(id)
);

CREATE TABLE cv_experience(
    id SERIAL PRIMARY KEY,
    experience VARCHAR(255),
    date_debut DATE,
    date_fin DATE,
    id_cv INT REFERENCES cv(id)
);

-- Candidat 
CREATE TABLE candidat(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255),
    prenom VARCHAR(255),
    email VARCHAR(255),
    date_naissance DATE,
    adresse VARCHAR(255),
    date_debut DATE,
    id_offre INT REFERENCES offre(id) 
);

-- test QCM
CREATE TABLE questionnaire(
    id SERIAL PRIMARY KEY,
    questionnaire TEXT,
    id_offre INT REFERENCES offre(id)
);

CREATE TABLE question(
    id SERIAL PRIMARY KEY,
    question TEXT,
    points INT,
    id_questionnaire INT REFERENCES questionnaire(id)
);

CREATE TABLE reponse(
    id SERIAL PRIMARY KEY,
    reponse_text TEXT,
    est_vraie BOOLEAN,
    id_question INT REFERENCES question(id)
);

CREATE TABLE resultat_statut(
    id INT PRIMARY KEY,
    statut VARCHAR(200)
);

CREATE TABLE resultat(
    id SERIAL PRIMARY KEY,
    score INT,
    total_question INT,
    reponse_correcte INT,
    date_passage TIMESTAMP DEFAULT CURRENT_DATE,
    id_candidat INT REFERENCES candidat(id),
    id_resultat_statut INT REFERENCES resultat_statut(id),
    id_offre INT REFERENCES offre(id)
);

CREATE TABLE planing_entretien(
    id SERIAL PRIMARY KEY,
    date_entretien TIMESTAMP,
    id_resultat INT REFERENCES resultat(id)
);

CREATE TABLE evalution_entretien (
    id SERIAL PRIMARY KEY,
    note INT,
    commentaire TEXT,
    date_evaluation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_entretien INT REFERENCES planing_entretien(id)
);

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



-- =========================
-- Index sur les tables utilisateur
-- =========================
CREATE INDEX idx_utilisateur_entreprise_id_role ON utilisateur_entreprise(id_role);

-- =========================
-- Index sur Offre et ses relations
-- =========================
CREATE INDEX idx_offre_id_role ON offre(id_role);
CREATE INDEX idx_critere_offre_id_niv ON critere_offre(id_niv);
CREATE INDEX idx_critere_offre_id_offre ON critere_offre(id_offre);
CREATE INDEX idx_offre_mission_id_offre ON offre_mission(id_offre);
CREATE INDEX idx_offre_profil_id_offre ON offre_profil(id_offre);

-- =========================
-- Index sur CV
-- =========================
CREATE INDEX idx_cv_id_offre ON cv(id_offre);
CREATE INDEX idx_cv_id_utilisateur ON cv(id_utilisateur);
CREATE INDEX idx_cv_statut_id_cv ON cv_statut(id_cv);
CREATE INDEX idx_cv_diplome_id_niv ON cv_diplome(id_niv);
CREATE INDEX idx_cv_diplome_id_cv ON cv_diplome(id_cv);
CREATE INDEX idx_cv_competence_id_cv ON cv_competence(id_cv);
CREATE INDEX idx_cv_experience_id_cv ON cv_experience(id_cv);

-- =========================
-- Index sur Candidat
-- =========================
CREATE INDEX idx_candidat_id_offre ON candidat(id_offre);

-- =========================
-- Index sur QCM
-- =========================
CREATE INDEX idx_questionnaire_id_offre ON questionnaire(id_offre);
CREATE INDEX idx_question_id_questionnaire ON question(id_questionnaire);
CREATE INDEX idx_reponse_id_question ON reponse(id_question);

-- =========================
-- Index sur Résultats
-- =========================
CREATE INDEX idx_resultat_id_candidat ON resultat(id_candidat);
CREATE INDEX idx_resultat_id_resultat_statut ON resultat(id_resultat_statut);
CREATE INDEX idx_resultat_id_offre ON resultat(id_offre);

CREATE INDEX idx_planing_entretien_id_resultat ON planing_entretien(id_resultat);
CREATE INDEX idx_evalution_entretien_id_entretien ON evalution_entretien(id_entretien);
CREATE INDEX idx_contrat_essaie_id_evaluation ON contrat_essaie(id_evaluation);


