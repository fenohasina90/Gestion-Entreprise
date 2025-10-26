package com.gestion.entities.cv;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

import com.gestion.entities.other.NivDiplome;

@Getter
@Setter
@Entity
@Table(name = "cv_diplome")
public class CvDiplome {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "date_debut")
    private LocalDate dateDebut;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_niv")
    private NivDiplome idNiv;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_cv")
    private Cv idCv;

}