package com.gestion.groups.offre;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.Objects;

@AllArgsConstructor
@Getter
@Setter
public class MissionGroupe {
    private String mission;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MissionGroupe that = (MissionGroupe) o;
        return Objects.equals(mission, that.mission);
    }

    @Override
    public int hashCode() {
        return Objects.hash(mission);
    }
}
