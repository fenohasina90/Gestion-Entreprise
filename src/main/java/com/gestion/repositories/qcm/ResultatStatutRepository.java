package com.gestion.repositories.qcm;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.gestion.entities.qcm.ResultatStatut;

import java.util.List;

@Repository
public interface ResultatStatutRepository extends JpaRepository<ResultatStatut, Integer> {
    List<ResultatStatut> findAllByOrderByIdAsc();
}
