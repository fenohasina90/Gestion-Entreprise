package com.gestion.repositories.qcm;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.gestion.entities.qcm.EvalutionEntretien;

import java.util.List;
import java.util.Optional;

public interface EvalutionEntretienRepository extends JpaRepository<EvalutionEntretien, Integer> {
    
    @Query("SELECT e FROM EvalutionEntretien e JOIN FETCH e.idEntretien p JOIN FETCH p.idResultat r JOIN FETCH r.idCandidat c ORDER BY e.dateEvaluation DESC")
    List<EvalutionEntretien> findAllWithDetails();
    
    @Query("SELECT e FROM EvalutionEntretien e WHERE e.idEntretien.id = :idEntretien")
    Optional<EvalutionEntretien> findByIdEntretien(@Param("idEntretien") Integer idEntretien);
    
    @Query("SELECT e FROM EvalutionEntretien e WHERE e.note >= 12 ORDER BY e.dateEvaluation DESC")
    List<EvalutionEntretien> findEvaluationsValidees();
}
