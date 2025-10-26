package com.gestion.groups.qcm;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.Set;
@AllArgsConstructor
@Getter
@Setter
public class QuestionnaireGroupe {
    private Integer id;
    private String questionnaire;
    private Integer idOffre;
    private Set<QuestionGroupe> questions;
}
