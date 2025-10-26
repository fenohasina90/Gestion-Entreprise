package com.gestion.entities.qcm;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

import com.gestion.entities.offre.Offre;
import com.gestion.entities.personnel.Candidat;

@Getter
@Setter
@Entity
@Table(name = "resultat")
public class Resultat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "score")
    private Integer score;

    @Column(name = "total_question")
    private Integer totalQuestion;

    @Column(name = "reponse_correcte")
    private Integer reponseCorrecte;

    @Column(name = "date_passage")
    private LocalDateTime datePassage;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_candidat")
    private Candidat idCandidat;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_resultat_statut")
    private ResultatStatut idResultatStatut;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_offre")
    private Offre idOffre;
} 