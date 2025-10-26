    
package com.gestion.service.offre;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gestion.entities.offre.CritereOffre;
import com.gestion.entities.offre.Offre;
import com.gestion.entities.offre.OffreMission;
import com.gestion.entities.other.RoleProfil;
import com.gestion.entities.qcm.Question;
import com.gestion.groups.offre.MissionGroupe;
import com.gestion.groups.offre.OffreAdminGroupe;
import com.gestion.groups.offre.OffreGroupe;
import com.gestion.groups.offre.ProfilGroupe;
import com.gestion.projection.OffreAdminProjection;
import com.gestion.projection.OffreProjection;
import com.gestion.repositories.offre.CritereOffreRepository;
import com.gestion.repositories.offre.OffreMissionRepository;
import com.gestion.repositories.offre.OffreRepository;
import com.gestion.repositories.other.RoleProfilRepository;
import com.gestion.repositories.qcm.QuestionRepository;
import com.gestion.repositories.qcm.QuestionnaireRepository;
import com.gestion.repositories.qcm.ReponseRepository;

import java.time.Instant;
import java.util.*;

@Service
public class OffreService {
    private final OffreRepository offreRepository;
    private final OffreMissionRepository offreMissionRepository;
    private final RoleProfilRepository profilRepository;
    private final CritereOffreRepository critereOffreRepository;
    private final QuestionnaireRepository questionnaireRepository;
    private final QuestionRepository questionRepository;
    private final ReponseRepository reponseRepository;
    @Autowired
    public OffreService(OffreRepository offreRepository, OffreMissionRepository offreMissionRepository,
                        RoleProfilRepository profilRepository, CritereOffreRepository critereOffreRepository, QuestionnaireRepository questionnaireRepository, QuestionRepository questionRepository, ReponseRepository reponseRepository) {
        this.offreRepository = offreRepository;
        this.offreMissionRepository = offreMissionRepository;
        this.profilRepository = profilRepository;
        this.critereOffreRepository = critereOffreRepository;
        this.questionnaireRepository = questionnaireRepository;
        this.questionRepository = questionRepository;
        this.reponseRepository = reponseRepository;
    }

    public void valideOffreRh(Integer idOffre) {
        offreRepository.updateOffre(idOffre);
    }

//    public void saveQCM(String questionnaire, List<String> question, List<Integer> point, )

    public void saveCritere(Integer idOffre){
        Offre offre = offreRepository.findById(idOffre).orElse(null);
        CritereOffre critereOffre = new CritereOffre();
        critereOffre.setGenre("Tout le monde");
        critereOffre.setIdOffre(offre);
        critereOffreRepository.save(critereOffre);
    }
    public void updateCritere(Integer idOffre, Integer experience, String genre, Integer ageMin,
                            Integer ageMax, Integer idNiv, String lieu){
        Offre offre = offreRepository.findById(idOffre).orElse(null);
        CritereOffre critereOffre = new CritereOffre();
        critereOffre.setGenre("Tout le monde");
        critereOffre.setIdOffre(offre);
        critereOffreRepository.updateCritereOffre(experience, genre, ageMin, ageMax, idNiv, lieu, offre);
    }

//    public List<OffreGroupe> getOffresFiltres(String entreprise, String poste, String role) {
//        List<OffreProjection> offreProjections = offreRepository.getListeOffreFiltres(entreprise, poste, role);
//        Map<Integer, OffreGroupe> grouped = new LinkedHashMap<>();
//        for (OffreProjection proj : offreProjections) {
//            grouped.computeIfAbsent(proj.getId(), k -> new OffreGroupe(
//                    proj.getId(),
//                    proj.getPoste(),
//                    proj.getEntreprise(),
//                    proj.getContrat(),
//                    proj.getSalaire(),
//                    proj.getRoleRequis(),
//                    proj.getDateCreation(),
//                    proj.getExperience(),
//                    proj.getGenre(),
//                    proj.getAgeMin(),
//                    proj.getAgeMax(),
//                    proj.getTypeDiplome(),
//                    proj.getLieu(),
//                    new HashSet<>()
//            ));
//            OffreGroupe groupe = grouped.get(proj.getId());
//            groupe.getMissions().add(new MissionGroupe(proj.getMissions()));
//        }
//        return new ArrayList<>(grouped.values());
//    }

//    public OffreGroupe getOffreById(Integer id) {
//        OffreProjection proj = offreRepository.getOffreById(id);
//        if (proj == null) return null;
//        OffreGroupe groupe = new OffreGroupe(
//                proj.getId(),
//                proj.getPoste(),
//                proj.getEntreprise(),
//                proj.getContrat(),
//                proj.getSalaire(),
//                proj.getRoleRequis(),
//                proj.getDateCreation(),
//                proj.getExperience(),
//                proj.getGenre(),
//                proj.getAgeMin(),
//                proj.getAgeMax(),
//                proj.getTypeDiplome(),
//                proj.getLieu(),
//                new HashSet<>()
//        );
//        if (proj.getMissions() != null) {
//            groupe.getMissions().add(new MissionGroupe(proj.getMissions()));
//        }
//        return groupe;
//    }

    public void saveOffre(String poste, String entreprise, String contrat, String salaire, Integer idRole,
                          List<String> mission){
        RoleProfil roleProfil = profilRepository.findById(idRole).orElse(null);
        Offre offre = new Offre();
        offre.setContrat(contrat);
        offre.setPoste(poste);
        offre.setEntreprise(entreprise);
        offre.setSalaire(salaire);
        offre.setIdRole(roleProfil);
        offre.setEstValideRh(false);
        offre.setCreateAt(Instant.now());
        offre = offreRepository.save(offre);

        for (String mi : mission) {
            OffreMission offreMission = new OffreMission();
            offreMission.setMission(mi);
            offreMission.setIdOffre(offre);
            offreMissionRepository.save(offreMission);
        }

        saveCritere(offre.getId());

    }

    public List<OffreGroupe> getAllOffre() {
        List<OffreProjection> offreProjections = offreRepository.getListeOffre();

        Map<Integer, OffreGroupe> grouped = new LinkedHashMap<>();

        for (OffreProjection proj : offreProjections) {
            grouped.computeIfAbsent(proj.getId(), k -> new OffreGroupe(
                    proj.getId(),
                    proj.getPoste(),
                    proj.getEntreprise(),
                    proj.getContrat(),
                    proj.getSalaire(),
                    proj.getRoleRequis(),
                    proj.getDateCreation(),
                    proj.getExperience(),
                    proj.getGenre(),
                    proj.getAgeMin(),
                    proj.getAgeMax(),
                    proj.getTypeDiplome(),
                    proj.getLieu(),
                    new HashSet<>()
            ));

            OffreGroupe groupe = grouped.get(proj.getId());

            groupe.getMissions().add(new MissionGroupe(
                    proj.getMissions()
            ));

        }
        return new ArrayList<>(grouped.values());
    }

    public List<OffreGroupe> getAllOffreFiltered(String entreprise, String unite, String contrat, String poste) {
        List<OffreGroupe> base = getAllOffre();
        String ent = entreprise == null ? null : entreprise.trim();
        String uni = unite == null ? null : unite.trim();
        String con = contrat == null ? null : contrat.trim();
        String pos = poste == null ? null : poste.trim();

        if ((ent == null || ent.isEmpty()) &&
            (uni == null || uni.isEmpty()) &&
            (con == null || con.isEmpty()) &&
            (pos == null || pos.isEmpty())) {
            return base;
        }

        List<OffreGroupe> out = new ArrayList<>();
        for (OffreGroupe o : base) {
            boolean ok = true;
            if (ent != null && !ent.isEmpty()) {
                ok = ok && ent.equalsIgnoreCase(o.getEntreprise());
            }
            if (uni != null && !uni.isEmpty()) {
                ok = ok && uni.equalsIgnoreCase(o.getRoleRequis());
            }
            if (con != null && !con.isEmpty()) {
                ok = ok && con.equalsIgnoreCase(o.getContrat());
            }
            if (pos != null && !pos.isEmpty()) {
                ok = ok && o.getPoste() != null && o.getPoste().toLowerCase().contains(pos.toLowerCase());
            }
            if (ok) out.add(o);
        }
        return out;
    }

}
