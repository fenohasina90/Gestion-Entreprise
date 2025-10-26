package com.gestion.entities.qcm;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "question")
public class Question {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "question", length = Integer.MAX_VALUE)
    private String question;

    @Column(name = "points")
    private Integer points;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_questionnaire")
    private Questionnaire idQuestionnaire;

    @OneToMany(mappedBy = "idQuestion", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Reponse> reponses;
}