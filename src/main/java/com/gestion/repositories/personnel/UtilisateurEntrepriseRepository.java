package com.gestion.repositories.personnel;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.gestion.entities.personnel.UtilisateurEntreprise;

import java.time.LocalDate;
import java.util.List;

public interface UtilisateurEntrepriseRepository extends JpaRepository<UtilisateurEntreprise, Integer> {

    @Query(value = """
    SELECT * FROM utilisateur_entreprise WHERE email = :email AND mdp = :mdp
    """, nativeQuery = true)
    UtilisateurEntreprise getUtilisateurEntreprise(@Param("email") String email,
                                                   @Param("mdp") String motDePasse);

    @Query("""
    SELECT u.idRole.type FROM UtilisateurEntreprise u WHERE u.email = :email AND u.mdp = :mdp
    """)
    String getRoleUtilisateur(@Param("email") String email,
                              @Param("mdp") String motDePasse);

    @Query("""
    SELECT u.idRole.id FROM UtilisateurEntreprise u WHERE u.email = :email AND u.mdp = :mdp
    """)
    Integer getRoleIDUtilisateur(@Param("email") String email,
                                 @Param("mdp") String motDePasse);

    @Query("SELECT u FROM UtilisateurEntreprise u JOIN FETCH u.idRole r " +
           "WHERE (:roleId = -1 OR r.id = :roleId) " +
           "AND (u.dateDebut >= :dateDebut) " +
           "AND (u.dateDebut <= :dateFin) " +
           "ORDER BY u.dateDebut DESC")
    List<UtilisateurEntreprise> findAllFiltered(@Param("roleId") Integer roleId,
                                                @Param("dateDebut") LocalDate dateDebut,
                                                @Param("dateFin") LocalDate dateFin);

    // Aggregations for dashboard
    @Query("select r.type, count(u.id) from UtilisateurEntreprise u join u.idRole r group by r.type order by count(u.id) desc")
    List<Object[]> countEmployesParRole();

    @Query("select FUNCTION('DATE_PART','year', u.dateDebut) as annee, FUNCTION('DATE_PART','month', u.dateDebut) as mois, count(u.id) as nb " +
           "from UtilisateurEntreprise u group by annee, mois order by annee, mois")
    List<Object[]> countEmbauchesParMois();
}