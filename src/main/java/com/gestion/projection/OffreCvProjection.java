package com.gestion.projection;

import java.time.Instant;

public interface OffreCvProjection {
    Integer getId();
    String getPoste();
    String getEntreprise();
    String getContrat();
    String getSalaire();
    String getRoleRequis();
    Instant getDateCreation();
    String getMissions();
    Integer getIdUtilisateur();
    boolean getStatut();
    boolean getEstEntretien();
}
