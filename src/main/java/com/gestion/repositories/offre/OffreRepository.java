package com.gestion.repositories.offre;

import jakarta.persistence.criteria.CriteriaBuilder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.gestion.entities.offre.Offre;
import com.gestion.projection.OffreAdminProjection;
import com.gestion.projection.OffreCvProjection;
import com.gestion.projection.OffreProjection;

import java.util.List;

public interface OffreRepository extends JpaRepository<Offre, Integer> {
    @Query(value = """
        SELECT * FROM v_offre_utilisateur
    """,nativeQuery = true)
    List<OffreProjection> getListeOffre();

    @Query(value = """
        SELECT * FROM v_offre_user_cv WHERE id_utilisateur = :id
    """,nativeQuery = true)
    List<OffreCvProjection> getListeOffreCv(@Param("id") Integer idutilisateur);
    @Query(value = """
        SELECT * FROM v_offre_admin
    """,nativeQuery = true)
    List<OffreAdminProjection> getListeOffreAdmin();

    @Query(value = """
        SELECT * FROM v_offre_admin WHERE id_role = :id
    """,nativeQuery = true)
    List<OffreAdminProjection> getListeOffreAdminRol(@Param("id")Integer idRole);

    @Query(value = """
        SELECT * FROM v_offre_admin WHERE id_role = :idRole
    """,nativeQuery = true)
    List<OffreAdminProjection> getListeOffreAdminUnite(@Param("idRole")Integer idRoleProfil);

    @Transactional
    @Modifying
    @Query(value = """
        UPDATE offre SET est_valide_rh = true WHERE id = :id
    """, nativeQuery = true)
    void updateOffre(@Param("id") Integer idOffre);

    long countByEstValideRh(Boolean estValideRh);

    // Retourne toutes les offres filtrées
//    @Query("SELECT o FROM OffreProjection o WHERE "
//            + "(:entreprise IS NULL OR o.entreprise = :entreprise) AND "
//            + "(:poste IS NULL OR o.poste = :poste) AND "
//            + "(:role IS NULL OR o.roleRequis = :role)")
//    List<OffreProjection> getListeOffreFiltres(
//            @Param("entreprise") String entreprise,
//            @Param("poste") String poste,
//            @Param("role") String role
//    );
//
//    // Retourne une offre par son id
//    @Query("SELECT o FROM OffreProjection o WHERE o.id = :id")
//    OffreProjection getOffreById(@Param("id") Integer id);
}