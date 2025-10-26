package com.gestion.repositories.personnel;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.gestion.entities.personnel.UtilisateurCandidat;
import com.gestion.entities.personnel.UtilisateurEntreprise;

public interface UtilisateurCandidatRepository extends JpaRepository<UtilisateurCandidat, Integer> {
    @Query(value = """
    SELECT * FROM utilisateur_candidat WHERE email = :email AND mdp = :mdp
    """, nativeQuery = true)
    UtilisateurCandidat getUtilisateurCandidat(@Param("email") String email,
                                                   @Param("mdp") String motDePasse);

    @Query("""
    SELECT u.id FROM UtilisateurCandidat u WHERE u.email = :email AND u.mdp = :mdp
    """)
    Integer getIDUtilisateur(@Param("email") String email,
                              @Param("mdp") String motDePasse);


}