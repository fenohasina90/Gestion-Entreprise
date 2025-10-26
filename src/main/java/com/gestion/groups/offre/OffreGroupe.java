package com.gestion.groups.offre;

import jakarta.persistence.criteria.CriteriaBuilder;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.Set;

@AllArgsConstructor
@Getter
@Setter
public class OffreGroupe {
    private Integer id;
    private String poste;
    private String entreprise;
    private String contrat;
    private String salaire;
    private String roleRequis;
    private Instant creatAt;
    private Integer experience;
    private String genre;
    private Integer ageMin;
    private Integer ageMax;
    private String typeDiplome;
    private String lieu;
    private Set<MissionGroupe> missions;
}
