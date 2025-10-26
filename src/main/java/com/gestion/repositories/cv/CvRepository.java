package com.gestion.repositories.cv;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.gestion.entities.cv.Cv;

public interface CvRepository extends JpaRepository<Cv, Integer> {
    @Transactional
    @Modifying
    @Query("update Cv c set c.estEntretien = true where c.id = ?1")
    int updateEstEntretienById(Integer id);
    @Query(value = """
        SELECT email FROM cv  WHERE id_utilisateur = :id AND id_offre = :idOffre
    """,nativeQuery = true)
    String getEmailCandidat(@Param("id") Integer id, @Param("idOffre") Integer idOffre);

    @Query(value = """
        SELECT id FROM cv  WHERE id_utilisateur = :id AND id_offre = :idOffre
    """, nativeQuery = true)
    Integer getIdCvCandidat(@Param("id") Integer id, @Param("idOffre") Integer idOffre);
}