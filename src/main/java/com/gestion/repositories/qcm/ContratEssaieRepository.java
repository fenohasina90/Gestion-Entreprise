package com.gestion.repositories.qcm;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.gestion.entities.qcm.ContratEssaie;

import java.util.List;
import java.util.Optional;

public interface ContratEssaieRepository extends JpaRepository<ContratEssaie, Integer> {
    
    @Query("SELECT c FROM ContratEssaie c JOIN FETCH c.idEvaluation e JOIN FETCH e.idEntretien p JOIN FETCH p.idResultat r JOIN FETCH r.idCandidat cand ORDER BY c.createAt DESC")
    List<ContratEssaie> findAllWithDetails();
    
    @Query(value = """
         SELECT c.*
         FROM contrat_essaie c
         JOIN evalution_entretien e ON c.id_evaluation = e.id
         WHERE e.id = :idEvaluation
    """, nativeQuery = true)
    List<ContratEssaie> findByIdEvaluation(@Param("idEvaluation") Integer idEvaluation);
    
    @Query("SELECT c FROM ContratEssaie c WHERE c.idContratOriginal = :idContratOriginal OR c.id = :idContratOriginal")
    List<ContratEssaie> findContratsByOriginalId(@Param("idContratOriginal") Integer idContratOriginal);
    
    @Query("SELECT SUM(c.duree) FROM ContratEssaie c WHERE c.idContratOriginal = :idContratOriginal OR c.id = :idContratOriginal")
    Integer getTotalDureeContrat(@Param("idContratOriginal") Integer idContratOriginal);
}
