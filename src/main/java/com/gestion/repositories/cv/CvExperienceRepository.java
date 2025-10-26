package com.gestion.repositories.cv;

import org.springframework.data.jpa.repository.JpaRepository;

import com.gestion.entities.cv.Cv;
import com.gestion.entities.cv.CvExperience;

import java.util.List;

public interface CvExperienceRepository extends JpaRepository<CvExperience, Integer> {
    List<CvExperience> findByIdCv(Cv idCv);
}