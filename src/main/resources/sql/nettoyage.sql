delete from cv_experience;
delete from cv_competence;
delete from cv_diplome;
delete from cv_statut;
delete from cv;

delete from critere_offre;
delete from candidat;
update offre set est_valide_rh = FALSE where id = 5;

delete from offre_profil;
delete from offre_mission;
delete from offre;




delete from reponse;
delete from question;
delete from questionnaire;
