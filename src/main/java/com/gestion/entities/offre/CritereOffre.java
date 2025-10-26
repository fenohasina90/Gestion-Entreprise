package com.gestion.entities.offre;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "critere_offre")
public class CritereOffre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "experience")
    private Integer experience;

    @Column(name = "genre")
    private String genre;

    @Column(name = "age_min")
    private Integer ageMin;

    @Column(name = "age_max")
    private Integer ageMax;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_offre")
    private Offre idOffre;

    @JoinColumn(name = "id_niv")
    private Integer idNiv;

    @Column(name = "lieu")
    private String lieu;

}