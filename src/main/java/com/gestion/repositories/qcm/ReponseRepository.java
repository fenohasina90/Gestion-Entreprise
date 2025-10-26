package com.gestion.repositories.qcm;

import org.springframework.data.jpa.repository.JpaRepository;

import com.gestion.entities.qcm.Reponse;

public interface ReponseRepository extends JpaRepository<Reponse, Integer> {
}