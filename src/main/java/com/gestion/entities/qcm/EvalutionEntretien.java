package com.gestion.entities.qcm;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "evalution_entretien")
public class EvalutionEntretien {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "note")
    private Integer note;

    @Column(name = "commentaire")
    private String commentaire;

    @Column(name = "date_evaluation")
    private LocalDateTime dateEvaluation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_entretien")
    private PlaningEntretien idEntretien;
}
