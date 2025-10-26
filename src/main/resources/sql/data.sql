INSERT INTO role_profil (id, "type") VALUES
(1, 'RH'),
(2, 'Informatique'),
(3, 'Communication'),
(4, 'Finance'),
(5, 'Consultant IT');


INSERT INTO resultat_statut (id, statut) VALUES
(1, 'Excellent'),         -- Note ≥ 90%
(2, 'Tres bien'),         -- Note entre 80% et 89%
(3, 'Bien'),              -- Note entre 70% et 79%
(4, 'Passable'),          -- Note entre 60% et 69%
(5, 'Insuffisant'),       -- Note entre 40% et 59%
(6, 'Echec');             -- Note < 40%



INSERT INTO niv_diplome (type_diplome, niveau) VALUES
('BAC', 1),
('BTS', 2),
('Licence', 3),
('Master', 4),
('Ingénieur', 5),
('Doctorat', 6);

INSERT INTO utilisateur_candidat (email, mdp) VALUES
('candidat1@email.com', 'mdp123'),
('candidat2@email.com', 'mdp123'),
('candidat3@email.com', 'mdp123'),
('candidat4@email.com', 'mdp123'),
('candidat5@email.com', 'mdp123'),
('candidat6@email.com', 'mdp123'),
('candidat7@email.com', 'mdp123'),
('candidat8@email.com', 'mdp123'),
('candidat9@email.com', 'mdp123'),
('candidat10@email.com', 'mdp123');

INSERT INTO utilisateur_entreprise (email, mdp, nom, prenom, date_naissance, adresse, date_debut, id_role, est_rh) VALUES
('admin@gmail.com', 'admin123', 'Dupont', 'Pierre', '1980-05-15', '123 Rue Admin, Paris', '2020-01-15', 1, true),
('info@gmail.com', 'mdp123', 'Martin', 'Sophie', '1985-08-22', '456 Ave Recrutement, Lyon', '2021-03-10', 2, false),
('comm@gmail.com', 'mdp123', 'Bernard', 'Luc', '1978-12-03', '789 Blvd Management, Marseille', '2019-06-20', 3, false),
('finance@gmail.com', 'mdp123', 'Petit', 'Julie', '1990-02-28', '321 Rue Consultant, Toulouse', '2022-01-08', 4, false),
('consultant@gmail.com', 'mdp123', 'Bertrand', 'Luca', '1978-12-03', '789 Blvd Management, Monaco', '2019-06-20', 5, false);



-- OFFRES
INSERT INTO offre (poste, entreprise, contrat, salaire, id_role, est_valide_rh)
VALUES
('Developpeur Java', 'TechCorp', 'CDI', '2500 EUR', 2, false),
('Analyste Donnees', 'DataSolutions', 'CDD', '2200 EUR', 2, false),
('Chef de Projet', 'BuildIT', 'CDI', '3200 EUR', 3, false),
('Comptable', 'Financia', 'CDI', '2000 EUR', 4, false),
('Technicien Reseau', 'NetLink', 'CDI', '2100 EUR', 5, false),
('Developpeur Frontend', 'WebWorks', 'CDD', '2400 EUR', 1, false),
('Consultant ERP', 'ERPGlobal', 'CDI', '3300 EUR', 2, false),
('Responsable Marketing', 'MarketPlus', 'CDI', '2800 EUR', 3, false),
('Assistant RH', 'HumanPro', 'CDD', '1900 EUR', 4, false),
('Graphiste', 'Designo', 'CDI', '2100 EUR', 5, false),
('Ingenieur DevOps', 'CloudOps', 'CDI', '3500 EUR', 1, false),
('Administrateur Système', 'SysManage', 'CDI', '2600 EUR', 2, false),
('Ingenieur Securite', 'SecureIT', 'CDI', '3700 EUR', 3, false),
('Charge de Clientèle', 'ServicePlus', 'CDD', '1800 EUR', 4, false),
('Formateur IT', 'EduTech', 'CDI', '2300 EUR', 5, false),
('Ingenieur IA', 'SmartAI', 'CDI', '4000 EUR', 1, false),
('Developpeur Mobile', 'AppMakers', 'CDI', '2700 EUR', 2, false),
('Secretaire Administratif', 'OfficePro', 'CDD', '1600 EUR', 3, false),
('Architecte Logiciel', 'SoftBuild', 'CDI', '4200 EUR', 4, false),
('Technicien Support', 'HelpDesk', 'CDI', '1700 EUR', 5, false);

-- CRITERES OFFRE (1 critère par offre)
INSERT INTO critere_offre (genre, id_offre)
VALUES
('Tout le monde', 1),
('Tout le monde', 2),
('Tout le monde', 3),
('Tout le monde', 4),
('Tout le monde', 5),
('Tout le monde', 6),
('Tout le monde', 7),
('Tout le monde', 8),
('Tout le monde', 9),
('Tout le monde', 10),
('Tout le monde', 11),
('Tout le monde', 12),
('Tout le monde', 13),
('Tout le monde', 14),
('Tout le monde', 15),
('Tout le monde', 16),
('Tout le monde', 17),
('Tout le monde', 18),
('Tout le monde', 19),
('Tout le monde', 20);

-- OFFRE_MISSION (2 missions par offre)
INSERT INTO offre_mission (mission, id_offre) VALUES
('Pilotage des projets IT', 3),
('Coordination des equipes', 3),
('Developper des applications Java', 1),
('Corriger les bugs', 1),
('Analyse de donnees clients', 2),
('Preparation de rapports', 2),
('Gestion comptable', 4),
('etablir bilans financiers', 4),
('Maintenance reseaux', 5),
('Assurer la connectivite', 5),
('Developpement UI/UX', 6),
('Optimiser performances frontend', 6),
('Implementation ERP', 7),
('Support utilisateurs ERP', 7),
('Creation campagnes marketing', 8),
('Analyse marche', 8),
('Recrutement', 9),
('Suivi administratif RH', 9),
('Creation visuels', 10),
('Conception maquettes', 10);

-- OFFRE_PROFIL (1 à 2 profils par offre)
INSERT INTO offre_profil (profil, id_offre) VALUES
('Chef de projet senior', 3),
('Developpeur junior', 1),
('Developpeur confirme', 1),
('Data analyst', 2),
('Comptable experimente', 4),
('Technicien reseaux', 5),
('Frontend junior', 6),
('Consultant ERP', 7),
('Responsable marketing', 8),
('Assistant RH', 9),
('Graphiste creatif', 10),
('DevOps engineer', 11),
('Administrateur système', 12),
('Ingenieur securite', 13),
('Charge clientèle', 14),
('Formateur IT', 15),
('Ingenieur IA', 16),
('Developpeur mobile', 17),
('Secretaire administratif', 18),
('Architecte logiciel', 19),
('Technicien support', 20);


-- =======================
-- Questionnaires
-- =======================
-- Questionnaire 1 pour l'offre 1 (Développeur Java)
INSERT INTO questionnaire (questionnaire, id_offre) VALUES 
('Questionnaire technique Java', 1),
('Questionnaire compétences générales', 1),
('Questionnaire culture entreprise', 1);

-- Questions pour le questionnaire 1 (offre 1)
INSERT INTO question (question, points, id_questionnaire) VALUES 
('Quelle est la différence entre ArrayList et LinkedList?', 1, 1),
('Qu''est-ce que le polymorphisme en Java?', 1, 1),
('Comment gérer les exceptions en Java?', 1, 1),
('Qu''est-ce que Spring Framework?', 1, 1);

-- Réponses pour les questions du questionnaire 1
INSERT INTO reponse (reponse_text, est_vraie, id_question) VALUES 
('ArrayList utilise un tableau dynamique', true, 1),
('ArrayList utilise une liste chaînée', false, 1),
('Le polymorphisme permet à une méthode d''avoir plusieurs formes', true, 2),
('Le polymorphisme est un type de variable', false, 2),
('Avec try-catch', true, 3),
('Avec if-else', false, 3),
('Un framework pour développer des applications Java', true, 4),
('Un langage de programmation', false, 4);

-- Questionnaire 2 pour l'offre 1
INSERT INTO question (question, points, id_questionnaire) VALUES 
('Quelle est votre expérience avec les tests unitaires?', 1, 2),
('Comment gérez-vous les délais serrés?', 1, 2),
('Quels sont vos points forts?', 1, 2),
('Pourquoi voulez-vous travailler chez nous?', 1, 2);

INSERT INTO reponse (reponse_text, est_vraie, id_question) VALUES 
('Expérience avec JUnit', true, 5),
('Je ne connais pas les tests', false, 5),
('En priorisant les tâches', true, 6),
('Je travaille plus vite', false, 6),
('La résolution de problèmes', true, 7),
('Je n''en ai pas', false, 7),
('Pour la culture d''entreprise', true, 8),
('Pour le salaire uniquement', false, 8);

-- Questionnaire 3 pour l'offre 1
INSERT INTO question (question, points, id_questionnaire) VALUES 
('Quelles sont nos valeurs principales?', 1, 3),
('Connaissez-vous nos produits?', 1, 3),
('Qu''attendez-vous de notre entreprise?', 1, 3),
('Quelle est notre mission?', 1, 3);

INSERT INTO reponse (reponse_text, est_vraie, id_question) VALUES 
('Innovation et qualité', true, 9),
('Je ne sais pas', false, 9),
('Oui, j''ai étudié votre portfolio', true, 10),
('Non, pas vraiment', false, 10),
('Un environnement de travail stimulant', true, 11),
('Rien de spécial', false, 11),
('Fournir des solutions technologiques innovantes', true, 12),
('Je ne connais pas votre mission', false, 12);

-- Continuer pour les autres offres (2 à 20)...

-- Questionnaire pour l'offre 2 (Analyste Données)
INSERT INTO questionnaire (questionnaire, id_offre) VALUES 
('Questionnaire SQL', 2),
('Questionnaire analyse données', 2),
('Questionnaire outils BI', 2);

INSERT INTO question (question, points, id_questionnaire) VALUES 
('Qu''est-ce qu''une jointure SQL?', 1, 4),
('Comment optimiser une requête?', 1, 4),
('Qu''est-ce qu''un index?', 1, 4),
('Différence entre WHERE et HAVING?', 1, 4);

INSERT INTO reponse (reponse_text, est_vraie, id_question) VALUES 
('Combinaison de tables', true, 13),
('Un type de données', false, 13),
('Avec des indexes', true, 14),
('En utilisant plus de mémoire', false, 14),
('Structure pour accélérer les recherches', true, 15),
('Un type de table', false, 15),
('WHERE filtre avant regroupement', true, 16),
('Aucune différence', false, 16);

-- ... Continuer de la même manière pour toutes les offres...

-- Questionnaire pour l'offre 20 (Technicien Support)
INSERT INTO questionnaire (questionnaire, id_offre) VALUES 
('Questionnaire support technique', 3,
('Questionnaire relation client', 3),
('Questionnaire résolution problèmes', 3);

INSERT INTO question (question, points, id_questionnaire) VALUES 
('Comment gérez-vous un client mécontent?', 1, 58),
('Quelle est la première étape de dépannage?', 1, 58),
('Comment documentez-vous les incidents?', 1, 58),
('Quels outils de support utilisez-vous?', 1, 58);

INSERT INTO reponse (reponse_text, est_vraie, id_question) VALUES 
('En écoutant et proposant des solutions', true, 229),
('En ignorant le problème', false, 229),
('Identifier le problème', true, 230),
('Redémarrer immédiatement', false, 230),
('Via un système de ticketing', true, 231),
('Oralement uniquement', false, 231),
('Zendesk, Jira, etc.', true, 232),
('Aucun outil spécifique', false, 232);
