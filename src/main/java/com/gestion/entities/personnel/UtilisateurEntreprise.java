package com.gestion.entities.personnel;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

import com.gestion.entities.other.RoleProfil;

@Getter
@Setter
@Entity
@Table(name = "utilisateur_entreprise")
public class UtilisateurEntreprise {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "mdp")
    private String mdp;

    @Column(name = "nom")
    private String nom;

    @Column(name = "prenom")
    private String prenom;

    @Column(name = "date_naissance")
    private LocalDate dateNaissance;

    @Column(name = "adresse")
    private String adresse;

    @Column(name = "date_debut")
    private LocalDate dateDebut;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_role")
    private RoleProfil idRole;

    @Column(name = "est_rh")
    private Boolean estRh;

}