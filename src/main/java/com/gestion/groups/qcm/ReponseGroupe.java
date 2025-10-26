package com.gestion.groups.qcm;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
@AllArgsConstructor
@Getter
@Setter
public class ReponseGroupe {
    private Integer idReponse;
    private String reponseText;
    private boolean estVraie;
}
