package com.gestion.entities.other;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "niv_diplome")
public class NivDiplome {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "type_diplome", length = 250)
    private String typeDiplome;

    @Column(name = "niveau")
    private Integer niveau;

}