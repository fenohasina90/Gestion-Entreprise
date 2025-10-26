package com.gestion.projection;

import java.time.Instant;

public interface OffreAdminProjection {
    Integer getId();
    String getPoste();
    String getEntreprise();
    String getContrat();
    String getSalaire();
    Integer getIdRole();
    String getRoleRequis();
    Instant getDateCreation();
    boolean getEstValideRh();
    String getMissions();
}
