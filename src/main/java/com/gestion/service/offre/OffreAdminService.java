package com.gestion.service.offre;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gestion.groups.offre.MissionGroupe;
import com.gestion.groups.offre.OffreAdminGroupe;
import com.gestion.projection.OffreAdminProjection;
import com.gestion.repositories.offre.OffreRepository;

import java.util.*;

@Service
public class OffreAdminService {
    private final OffreRepository offreRepository;
    @Autowired
    public OffreAdminService(OffreRepository offreRepository) {
        this.offreRepository = offreRepository;
    }

    public List<OffreAdminGroupe> getAllOffreAdminRh() {
        List<OffreAdminProjection> offreProjections = offreRepository.getListeOffreAdmin();
        Map<Integer, OffreAdminGroupe> grouped = new LinkedHashMap<>();
        for (OffreAdminProjection proj : offreProjections) {
            grouped.computeIfAbsent(proj.getId(), k -> new OffreAdminGroupe(
                    proj.getId(),
                    proj.getPoste(),
                    proj.getEntreprise(),
                    proj.getContrat(),
                    proj.getSalaire(),
                    proj.getIdRole(),
                    proj.getRoleRequis(),
                    proj.getDateCreation(),
                    proj.getEstValideRh(),
                    new HashSet<>()
            ));
            OffreAdminGroupe groupe = grouped.get(proj.getId());
            groupe.getMissions().add(new MissionGroupe(
                    proj.getMissions()
            ));
        }
        return new ArrayList<>(grouped.values());
    }

    public List<OffreAdminGroupe> getAllOffreAdminRhFiltered(String entreprise, String unite, String contrat, String poste) {
        List<OffreAdminGroupe> base = getAllOffreAdminRh();
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

        List<OffreAdminGroupe> out = new ArrayList<>();
        for (OffreAdminGroupe o : base) {
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

    public List<OffreAdminGroupe> getAllOffreAdminRole(Integer idRole) {
        List<OffreAdminProjection> offreProjections = offreRepository.getListeOffreAdminUnite(idRole);
        Map<Integer, OffreAdminGroupe> grouped = new LinkedHashMap<>();
        for (OffreAdminProjection proj : offreProjections) {
            grouped.computeIfAbsent(proj.getId(), k -> new OffreAdminGroupe(
                    proj.getId(),
                    proj.getPoste(),
                    proj.getEntreprise(),
                    proj.getContrat(),
                    proj.getSalaire(),
                    proj.getIdRole(),
                    proj.getRoleRequis(),
                    proj.getDateCreation(),
                    proj.getEstValideRh(),
                    new HashSet<>()
            ));
            OffreAdminGroupe groupe = grouped.get(proj.getId());
            groupe.getMissions().add(new MissionGroupe(
                    proj.getMissions()
            ));
        }
        return new ArrayList<>(grouped.values());
    }


}
