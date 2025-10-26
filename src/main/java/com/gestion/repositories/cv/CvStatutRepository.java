package com.gestion.repositories.cv;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.gestion.entities.cv.CvStatut;

public interface CvStatutRepository extends JpaRepository<CvStatut, Integer> {
    long countByStatut(Boolean statut);

    @Query("select count(distinct cs.idCv.id) from CvStatut cs where cs.statut = true")
    long countDistinctCvValide();

    @Query("select count(distinct cs.idCv.id) from CvStatut cs where cs.statut = false")
    long countDistinctCvRefuse();
}