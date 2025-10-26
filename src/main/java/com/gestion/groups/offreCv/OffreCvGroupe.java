package com.gestion.groups.offreCv;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.Set;

@AllArgsConstructor
@Getter
@Setter
public class OffreCvGroupe {
    private Integer id;
    private String poste;
    private String entreprise;
    private String contact;
    private String salaire;
    private String roleRequis;
    private Instant dateCreation;
    private Integer idUtilisateur;
    private boolean statut;
    private boolean estEntretien;
    private Set<MissionCvGroupe> missions;
}
