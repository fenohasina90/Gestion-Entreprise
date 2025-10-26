package com.gestion.repositories.offre;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.gestion.entities.offre.CritereOffre;
import com.gestion.entities.offre.Offre;

import java.util.List;

public interface CritereOffreRepository extends JpaRepository<CritereOffre, Integer> {
    @Transactional
    @Modifying
    @Query("""
            update CritereOffre c set c.experience = ?1, c.genre = ?2, c.ageMin = ?3, c.ageMax = ?4, c.idNiv = ?5, c.lieu = ?6
            where c.idOffre = ?7""")
    void updateCritereOffre(Integer experience, String genre, Integer ageMin, Integer ageMax, Integer idNiv, String lieu, Offre idOffre);
    @Query(value = """
    SELECT * FROM critere_offre WHERE id_offre = :id
""", nativeQuery = true)
    CritereOffre getCritereOffre(@Param("id") Integer idOffre);
}