package com.gestion.repositories.offre;

import org.springframework.data.jpa.repository.JpaRepository;

import com.gestion.entities.offre.OffreMission;

public interface OffreMissionRepository extends JpaRepository<OffreMission, Integer> {
}