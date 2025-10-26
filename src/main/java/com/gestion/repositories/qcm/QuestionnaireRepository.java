package com.gestion.repositories.qcm;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.gestion.entities.qcm.Questionnaire;
import com.gestion.projection.QcmProjection;

import java.util.List;
import java.util.Map;

public interface QuestionnaireRepository extends JpaRepository<Questionnaire, Integer> {
    @Query(value = """
        SELECT * FROM v_qcm WHERE id_offre = :id
        """,
            nativeQuery = true)
    List<QcmProjection> getListQcm(@Param("id") Integer idOffre);
}