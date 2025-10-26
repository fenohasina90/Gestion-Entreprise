package com.gestion.groups.offre;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.Objects;

@AllArgsConstructor
@Getter
@Setter
public class ProfilGroupe {
    private String profil;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProfilGroupe that = (ProfilGroupe) o;
        return Objects.equals(profil, that.profil);
    }

    @Override
    public int hashCode() {
        return Objects.hash(profil);
    }
}
