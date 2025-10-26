package com.gestion.service.cv;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gestion.entities.cv.*;
import com.gestion.entities.offre.CritereOffre;
import com.gestion.entities.offre.Offre;
import com.gestion.entities.other.NivDiplome;
import com.gestion.entities.personnel.Candidat;
import com.gestion.entities.personnel.UtilisateurCandidat;
import com.gestion.repositories.cv.*;
import com.gestion.repositories.offre.CritereOffreRepository;
import com.gestion.repositories.offre.OffreRepository;
import com.gestion.repositories.other.NivDiplomeRepository;
import com.gestion.repositories.personnel.CandidatRepository;
import com.gestion.repositories.personnel.UtilisateurCandidatRepository;

import java.time.LocalDate;
import java.time.Period;
import java.util.List;

@Service
public class CvService {
    private final CvRepository cvRepository;
    private final CandidatRepository candidatRepository;
    private final UtilisateurCandidatRepository ucandidatRepository;
    private final NivDiplomeRepository nivDiplomeRepository;
    private final CvCompetenceRepository cvCompetenceRepository;
    private final CvDiplomeRepository cvDiplomeRepository;
    private final CvStatutRepository cvStatutRepository;
    private final CvExperienceRepository cvExperienceRepository;
    private final OffreRepository offreRepository;
    private final CritereOffreRepository critereOffreRepository;
    @Autowired
    public CvService(CvRepository cvRepository, CandidatRepository candidatRepository, UtilisateurCandidatRepository ucandidatRepository, NivDiplomeRepository nivDiplomeRepository,
                     CvCompetenceRepository cvCompetenceRepository,
                     CvDiplomeRepository cvDiplomeRepository,
                     CvStatutRepository cvStatutRepository, CvExperienceRepository cvExperienceRepository, OffreRepository offreRepository, CritereOffreRepository critereOffreRepository) {
        this.cvRepository = cvRepository;
        this.candidatRepository = candidatRepository;
        this.ucandidatRepository = ucandidatRepository;
        this.nivDiplomeRepository = nivDiplomeRepository;
        this.cvCompetenceRepository = cvCompetenceRepository;
        this.cvDiplomeRepository = cvDiplomeRepository;
        this.cvStatutRepository = cvStatutRepository;
        this.cvExperienceRepository = cvExperienceRepository;
        this.offreRepository = offreRepository;
        this.critereOffreRepository = critereOffreRepository;
    }

    public List<NivDiplome> getAllNiveau(){
        return nivDiplomeRepository.findAll();
    }

    public void saveCv(Integer idOffre, String nom, String prenom, String email, String genre, LocalDate dateNaissance,
                        String adresse, List<LocalDate> dateDiplome, List<Integer> diplome,
                        List<String> competence, List<String> experience, List<LocalDate> debutExp,
                        List<LocalDate> finExp, Integer idUser) {

        Offre offre = offreRepository.findById(idOffre).orElse(null);
        UtilisateurCandidat utilisateurCandidat = ucandidatRepository.findById(idUser).orElse(null);
        Cv cv = new Cv();
        cv.setAdresse(adresse);
        cv.setGenre(genre);
        cv.setEmail(email);
        cv.setNom(nom);
        cv.setPrenom(prenom);
        cv.setDateNaissance(dateNaissance);
        cv.setIdOffre(offre);
        cv.setIdUtilisateur(utilisateurCandidat);
        cv.setEstEntretien(false);

        cv = cvRepository.save(cv);

        // diplome
        for (int i = 0; i < diplome.size(); i++) {
            CvDiplome cvDiplome = new CvDiplome();
            NivDiplome nivDiplome = nivDiplomeRepository.findById(diplome.get(i)).orElse(null);
            cvDiplome.setIdNiv(nivDiplome);
            cvDiplome.setDateDebut(dateDiplome.get(i));
            cvDiplome.setIdCv(cv);
            cvDiplomeRepository.save(cvDiplome);
        }

        // competence
        for (String a: competence) {
            CvCompetence com = new CvCompetence();
            com.setCompetence(a);
            com.setIdCv(cv);
            cvCompetenceRepository.save(com);
        }

        // experience
        for (int i = 0; i < experience.size(); i++) {
            CvExperience exp = new CvExperience();
            exp.setIdCv(cv);
            exp.setExperience(experience.get(i));
            exp.setDateFin(finExp.get(i));
            exp.setDateDebut(debutExp.get(i));
            cvExperienceRepository.save(exp);
        }

        Integer id = cv.getId();
        System.out.println("Ito no ID an ilay CV : "+id);
        validerCv(id);
    }

    public void validerCv(Integer idCv) {
        // Récupérer le CV
        Cv cv = cvRepository.findById(idCv).orElse(null);
        if (cv == null) {
            throw new RuntimeException("cv null");
        }
        // Récupérer critere offre associée
        Offre offre = cv.getIdOffre();
        CritereOffre critereOffre = critereOffreRepository.getCritereOffre(offre.getId());
        if (offre == null) {
            throw new RuntimeException("Offre non associée au CV");
        }

        boolean valide = true;

        // 1. Vérifier l'âge

        if (critereOffre.getAgeMax() != null && critereOffre.getAgeMin() != null) {
            int age = Period.between(cv.getDateNaissance(), LocalDate.now()).getYears();
            if (age < critereOffre.getAgeMin() || age > critereOffre.getAgeMax()) {
                System.out.println("tratra tato am age");
                valide = false;
            }
        }

        // 2. Vérifier le genre
        if (critereOffre.getGenre() != null && !critereOffre.getGenre().equalsIgnoreCase("Tout le monde")) {
            if (!cv.getGenre().equalsIgnoreCase(critereOffre.getGenre())) {
                valide = false;
                System.out.println("tratra tato am genre");
            }
        }

        // 3. Vérifier l'expérience
        if (critereOffre.getExperience() != null) {
            int totalExp = 0;
            List<CvExperience> experiences = cvExperienceRepository.findByIdCv(cv);
            for (CvExperience exp : experiences) {
                int years = Period.between(exp.getDateDebut(), exp.getDateFin()).getYears();
                totalExp += years;
            }
            if (totalExp < critereOffre.getExperience()) {
                System.out.println("tratra tato am experience");
                valide = false;
            }
        }


        // 4. Vérifier diplôme
        if (critereOffre.getIdNiv() != null) {
            List<CvDiplome> diplomes = cvDiplomeRepository.findByIdCv(cv);
            boolean diplomeOk = diplomes.stream()
                    .anyMatch(d -> d.getIdNiv().getId() >= critereOffre.getIdNiv());
            if (!diplomeOk) {
                System.out.println("tratra tato am diplome");
                valide = false;
            }
        }

        //  5. Verifier lieu
        if (critereOffre.getLieu() != null && !critereOffre.getLieu().equalsIgnoreCase("")){
            if (!cv.getAdresse().equalsIgnoreCase(critereOffre.getLieu())){
                System.out.println("tratra tato am lieu");
                System.out.println("cv lieu : "+cv.getAdresse()+"  -  offre lieu : "+critereOffre.getLieu());
                valide = false;
            }
        }

        //         Mise à jour du statut
        if (valide) {
            CvStatut statutValide = new CvStatut();
            statutValide.setIdCv(cv);
            statutValide.setStatut(true);
            cvStatutRepository.save(statutValide);

            // Ajouter le candidat
            Candidat candidat = new Candidat();
            candidat.setNom(cv.getNom());
            candidat.setPrenom(cv.getPrenom());
            candidat.setEmail(cv.getEmail());
            candidat.setDateNaissance(cv.getDateNaissance());
            candidat.setAdresse(cv.getAdresse());
            candidat.setDateDebut(LocalDate.now());
            candidat.setIdOffre(offre);
            candidatRepository.save(candidat);

        } else {
            CvStatut statutValide = new CvStatut();
            statutValide.setIdCv(cv);
            statutValide.setStatut(false);
            cvStatutRepository.save(statutValide);
        }
    }

}
