package com.gestion.service.personnel;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gestion.entities.personnel.UtilisateurEntreprise;
import com.gestion.repositories.personnel.UtilisateurEntrepriseRepository;

import java.time.LocalDate;
import java.util.List;

@Service
public class UtilisateurEntrepriseService {
    private final UtilisateurEntrepriseRepository utilisateurEntrepriseRepo;
    @Autowired
    public UtilisateurEntrepriseService(UtilisateurEntrepriseRepository utilisateurEntrepriseRepo) {
        this.utilisateurEntrepriseRepo = utilisateurEntrepriseRepo;
    }

    public void authentification(String email, String mdp) {
        UtilisateurEntreprise user = utilisateurEntrepriseRepo.getUtilisateurEntreprise(email, mdp);
        if (user == null) {
            throw new RuntimeException("Information de connexion incorrecte");
        }
    }

    public String getRoleUser(String email, String mdp) {
        return utilisateurEntrepriseRepo.getRoleUtilisateur(email, mdp);
    }
    public Integer getRoleIdUser(String email, String mdp) {
        return utilisateurEntrepriseRepo.getRoleIDUtilisateur(email, mdp);
    }

    public List<UtilisateurEntreprise> listEmployesFiltered(Integer roleId, LocalDate dateDebut, LocalDate dateFin) {
        Integer roleIdN = (roleId == null) ? -1 : roleId;
        LocalDate dd = (dateDebut == null) ? LocalDate.of(1970,1,1) : dateDebut;
        LocalDate df = (dateFin == null) ? LocalDate.of(3000,12,31) : dateFin;
        return utilisateurEntrepriseRepo.findAllFiltered(roleIdN, dd, df);
    }
}
