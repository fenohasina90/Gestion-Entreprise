package com.gestion.groups.offreCv;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.Objects;

import com.gestion.groups.offre.MissionGroupe;

@AllArgsConstructor
@Getter
@Setter
public class MissionCvGroupe {
    private String mission;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MissionCvGroupe that = (MissionCvGroupe) o;
        return Objects.equals(mission, that.mission);
    }

    @Override
    public int hashCode() {
        return Objects.hash(mission);
    }
}
