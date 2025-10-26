package com.gestion.entities.qcm;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "resultat_statut")
public class ResultatStatut {
    @Id
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "statut", length = 200)
    private String statut;

    @OneToMany(mappedBy = "idResultatStatut", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Resultat> resultats;
}
