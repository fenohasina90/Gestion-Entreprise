package com.gestion.entities.personnel;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

import com.gestion.entities.offre.Offre;

@Getter
@Setter
@Entity
@Table(name = "candidat")
public class Candidat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "nom")
    private String nom;

    @Column(name = "prenom")
    private String prenom;

    @Column(name = "email")
    private String email;

    @Column(name = "date_naissance")
    private LocalDate dateNaissance;

    @Column(name = "adresse")
    private String adresse;

    @Column(name = "date_debut")
    private LocalDate dateDebut;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_offre")
    private Offre idOffre;

}