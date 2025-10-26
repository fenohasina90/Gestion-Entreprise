package com.gestion.projection;

public interface QcmProjection {
    Integer getId();
    String getQuestionnaire();
    Integer getIdQuestion();
    String getQuestion();
    Integer getPoints();
    Integer getIdReponse();
    String getReponseText();
    boolean getEstVraie();
    Integer getIdOffre();
}
