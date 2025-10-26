package com.gestion.repositories.qcm;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.gestion.entities.qcm.PlaningEntretien;

import java.util.List;
import java.util.Optional;

public interface PlaningEntretienRepository extends JpaRepository<PlaningEntretien, Integer> {
    
    @Query("SELECT p FROM PlaningEntretien p JOIN FETCH p.idResultat r JOIN FETCH r.idCandidat c ORDER BY p.dateEntretien ASC")
    List<PlaningEntretien> findAllWithDetails();
    
    @Query("SELECT p FROM PlaningEntretien p WHERE p.idResultat.id = :idResultat")
    Optional<PlaningEntretien> findByIdResultat(@Param("idResultat") Integer idResultat);
    
    @Query("SELECT p FROM PlaningEntretien p WHERE p.idResultat.id = :idResultat")
    Optional<PlaningEntretien> findByResultatId(@Param("idResultat") Integer idResultat);
    
    @Query("SELECT p FROM PlaningEntretien p " +
           "JOIN FETCH p.idResultat r " +
           "JOIN FETCH r.idCandidat c " +
           "JOIN FETCH r.idResultatStatut s " +
           "JOIN FETCH r.idOffre o " +
           "WHERE (:idOffre = -1 OR o.id = :idOffre) " +
           "AND (:scoreMin = -1 OR r.score >= :scoreMin) " +
           "AND (:scoreMax = -1 OR r.score <= :scoreMax) " +
           "AND (p.dateEntretien >= :dateDebut) " +
           "AND (p.dateEntretien <= :dateFin) " +
           "AND (:mois = -1 OR FUNCTION('DATE_PART','month', p.dateEntretien) = :mois) " +
           "AND (:annee = -1 OR FUNCTION('DATE_PART','year', p.dateEntretien) = :annee) " +
           "AND (:idStatut = -1 OR s.id = :idStatut) " +
           "AND (:nomCandidat = '' OR LOWER(CONCAT(c.nom, ' ', c.prenom)) LIKE LOWER(CONCAT('%', :nomCandidat, '%'))) " +
           "ORDER BY p.dateEntretien ASC")
    List<PlaningEntretien> findEntretiensFiltres(@Param("idOffre") Integer idOffre,
                                                @Param("scoreMin") Integer scoreMin,
                                                @Param("scoreMax") Integer scoreMax,
                                                @Param("dateDebut") java.time.LocalDateTime dateDebut,
                                                @Param("dateFin") java.time.LocalDateTime dateFin,
                                                @Param("mois") Integer mois,
                                                @Param("annee") Integer annee,
                                                @Param("idStatut") Integer idStatut,
                                                @Param("nomCandidat") String nomCandidat);
}
