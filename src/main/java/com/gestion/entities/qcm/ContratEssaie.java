package com.gestion.entities.qcm;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "contrat_essaie")
public class ContratEssaie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "contrat", length = 255)
    private String contrat;

    @Column(name = "duree")
    private Integer duree;

    @Column(name = "date_debut")
    private LocalDate dateDebut;

    @Column(name = "create_at")
    private LocalDate createAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_evaluation")
    private EvalutionEntretien idEvaluation;

    @Column(name = "mot_de_passe")
    private String motDePasse;

    @Column(name = "email_utilisateur")
    private String emailUtilisateur;

    @Column(name = "est_prolongation")
    private Boolean estProlongation = false;

    @Column(name = "id_contrat_original")
    private Integer idContratOriginal;
}
