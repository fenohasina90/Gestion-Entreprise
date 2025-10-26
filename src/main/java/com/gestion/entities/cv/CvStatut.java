package com.gestion.entities.cv;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "cv_statut")
public class CvStatut {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "statut")
    private Boolean statut;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_cv")
    private Cv idCv;

}