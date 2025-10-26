package com.gestion.groups.qcm;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.Set;
@AllArgsConstructor
@Getter
@Setter
public class QuestionGroupe {
    private Integer idQuestion;
    private String question;
    private Integer points;
    private Set<ReponseGroupe> reponses;
}
