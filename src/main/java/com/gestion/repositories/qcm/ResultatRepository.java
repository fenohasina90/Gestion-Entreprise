package com.gestion.repositories.qcm;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.gestion.entities.qcm.Resultat;

import java.util.List;

public interface ResultatRepository extends JpaRepository<Resultat, Integer> {
    
    @Query("SELECT r FROM Resultat r JOIN FETCH r.idCandidat c ORDER BY r.datePassage DESC")
    List<Resultat> findAllWithCandidat();
    
    @Query("SELECT r FROM Resultat r JOIN FETCH r.idCandidat c WHERE c.id = :idCandidat ORDER BY r.datePassage DESC")
    List<Resultat> findByCandidatId(@Param("idCandidat") Integer idCandidat);
    
    @Query("SELECT r FROM Resultat r " +
           "JOIN FETCH r.idCandidat c " +
           "JOIN FETCH r.idResultatStatut s " +
           "JOIN FETCH r.idOffre o " +
           "WHERE (:idStatut = -1 OR s.id = :idStatut) " +
           "AND (:idOffre = -1 OR o.id = :idOffre) " +
           "AND (:nomCandidat = '' OR LOWER(CONCAT(c.nom, ' ', c.prenom)) LIKE LOWER(CONCAT('%', :nomCandidat, '%'))) " +
           "AND (:scoreMin = -1 OR r.score >= :scoreMin) " +
           "AND (:scoreMax = -1 OR r.score <= :scoreMax) " +
           "ORDER BY r.datePassage DESC")
    List<Resultat> findResultatsFiltres(@Param("idStatut") Integer idStatut,
                                       @Param("idOffre") Integer idOffre,
                                       @Param("nomCandidat") String nomCandidat,
                                       @Param("scoreMin") Integer scoreMin,
                                       @Param("scoreMax") Integer scoreMax);
} 