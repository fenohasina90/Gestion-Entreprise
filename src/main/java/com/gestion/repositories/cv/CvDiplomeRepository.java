package com.gestion.repositories.cv;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import com.gestion.entities.cv.Cv;
import com.gestion.entities.cv.CvDiplome;

import java.util.List;

public interface CvDiplomeRepository extends JpaRepository<CvDiplome, Integer> {
    List<CvDiplome> findByIdCv(Cv idCv);

}