package com.gestion.entities.cv;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "cv_competence")
public class CvCompetence {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "competence")
    private String competence;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_cv")
    private Cv idCv;

}