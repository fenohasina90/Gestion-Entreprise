package com.gestion.groups.offre;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.Set;

@AllArgsConstructor
@Getter
@Setter
public class OffreAdminGroupe {
    private Integer id;
    private String poste;
    private String entreprise;
    private String contrat;
    private String salaire;
    private Integer idRole;
    private String roleRequis;
    private Instant creatAt;
    private boolean estValideRh;
    private Set<MissionGroupe> missions;
}
