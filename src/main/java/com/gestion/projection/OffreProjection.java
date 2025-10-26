package com.gestion.projection;

import java.time.Instant;

public interface OffreProjection {
    Integer getId();
    String getPoste();
    String getEntreprise();
    String getContrat();
    String getSalaire();
    String getRoleRequis();
    Instant getDateCreation();
    String getMissions();
    Integer getExperience();
    String getGenre();
    Integer getAgeMin();
    Integer getAgeMax();
    String getTypeDiplome();
    String getLieu();
}
