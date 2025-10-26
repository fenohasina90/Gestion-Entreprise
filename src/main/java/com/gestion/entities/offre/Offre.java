package com.gestion.entities.offre;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

import com.gestion.entities.other.NivDiplome;
import com.gestion.entities.other.RoleProfil;

@Getter
@Setter
@Entity
@Table(name = "offre")
public class Offre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "poste")
    private String poste;

    @Column(name = "entreprise")
    private String entreprise;

    @Column(name = "contrat")
    private String contrat;

    @Column(name = "salaire")
    private String salaire;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_role")
    private RoleProfil idRole;

    @Column(name = "est_valide_rh")
    private Boolean estValideRh;

    @Column(name = "create_at")
    private Instant createAt;

}