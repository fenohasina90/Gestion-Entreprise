package com.gestion.repositories.qcm;

import org.springframework.data.jpa.repository.JpaRepository;

import com.gestion.entities.qcm.Question;

public interface QuestionRepository extends JpaRepository<Question, Integer> {
}