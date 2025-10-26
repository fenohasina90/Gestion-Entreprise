package com.gestion.service.offre;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gestion.groups.offre.MissionGroupe;
import com.gestion.groups.offre.OffreAdminGroupe;
import com.gestion.groups.offreCv.MissionCvGroupe;
import com.gestion.groups.offreCv.OffreCvGroupe;
import com.gestion.projection.OffreAdminProjection;
import com.gestion.projection.OffreCvProjection;
import com.gestion.repositories.offre.OffreRepository;

import java.util.*;

@Service
public class OffreCvService {
    private final OffreRepository offreRepository;
    @Autowired
    public OffreCvService(OffreRepository offreRepository) {
        this.offreRepository = offreRepository;
    }

    public List<OffreCvGroupe> getAllOffreCv(Integer idUser) {
        List<OffreCvProjection> offreCvProjections = offreRepository.getListeOffreCv(idUser);
        Map<Integer, OffreCvGroupe> grouped = new LinkedHashMap<>();
        for (OffreCvProjection proj : offreCvProjections) {
            grouped.computeIfAbsent(proj.getId(), k -> new OffreCvGroupe(
                    proj.getId(),
                    proj.getPoste(),
                    proj.getEntreprise(),
                    proj.getContrat(),
                    proj.getSalaire(),
                    proj.getRoleRequis(),
                    proj.getDateCreation(),
                    proj.getIdUtilisateur(),
                    proj.getStatut(),
                    proj.getEstEntretien(),
                    new HashSet<>()
            ));
            OffreCvGroupe groupe = grouped.get(proj.getId());
            groupe.getMissions().add(new MissionCvGroupe(
                    proj.getMissions()
            ));
        }
        return new ArrayList<>(grouped.values());
    }
}
