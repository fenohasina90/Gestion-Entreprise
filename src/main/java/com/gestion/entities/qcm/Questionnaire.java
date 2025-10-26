package com.gestion.entities.qcm;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

import com.gestion.entities.offre.Offre;

@Getter
@Setter
@Entity
@Table(name = "questionnaire")
public class Questionnaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "questionnaire", length = Integer.MAX_VALUE)
    private String questionnaire;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_offre")
    private Offre idOffre;

    @OneToMany(mappedBy = "idQuestionnaire", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Question> questions;
}