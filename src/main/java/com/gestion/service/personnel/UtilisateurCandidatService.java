package com.gestion.service.personnel;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gestion.entities.personnel.UtilisateurCandidat;
import com.gestion.entities.personnel.UtilisateurEntreprise;
import com.gestion.repositories.personnel.UtilisateurCandidatRepository;

@Service
public class UtilisateurCandidatService {
    private final UtilisateurCandidatRepository utilisateurCandidatRepository;
    @Autowired
    public UtilisateurCandidatService(UtilisateurCandidatRepository utilisateurCandidatRepository) {
        this.utilisateurCandidatRepository = utilisateurCandidatRepository;
    }

    public void authentification(String email, String mdp) {
        UtilisateurCandidat user = utilisateurCandidatRepository.getUtilisateurCandidat(email, mdp);
        if (user == null) {
            throw new RuntimeException("Information de connexion incorrecte");
        }
    }

    public Integer getIdUser(String email, String mdp) {
        return utilisateurCandidatRepository.getIDUtilisateur(email, mdp);
    }
}
