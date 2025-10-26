package com.gestion.repositories.cv;

import org.springframework.data.jpa.repository.JpaRepository;

import com.gestion.entities.cv.CvCompetence;

public interface CvCompetenceRepository extends JpaRepository<CvCompetence, Integer> {
}