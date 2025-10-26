package com.gestion.entities.cv;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

import com.gestion.entities.offre.Offre;
import com.gestion.entities.personnel.UtilisateurCandidat;

@Getter
@Setter
@Entity
@Table(name = "cv")
public class Cv {
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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_offre")
    private Offre idOffre;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_utilisateur")
    private UtilisateurCandidat idUtilisateur;

    @Column(name = "genre")
    private String genre;

    @Column(name = "est_entretien")
    private boolean estEntretien;

}