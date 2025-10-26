package com.gestion.repositories.personnel;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.gestion.entities.personnel.Candidat;

public interface CandidatRepository extends JpaRepository<Candidat, Integer> {
    @Query(value = """
        SELECT id FROM candidat WHERE email = :email AND id_offre = :id
     """,nativeQuery = true)
    Integer getIdCandidat(@Param("email") String email,
                          @Param("id") Integer idOffre);
}