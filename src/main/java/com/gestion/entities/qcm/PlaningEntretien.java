package com.gestion.entities.qcm;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "planing_entretien")
public class PlaningEntretien {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "date_entretien")
    private LocalDateTime dateEntretien;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_resultat")
    private Resultat idResultat;
}
