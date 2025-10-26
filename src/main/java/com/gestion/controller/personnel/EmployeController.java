package com.gestion.controller.personnel;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.gestion.entities.other.RoleProfil;
import com.gestion.entities.personnel.UtilisateurEntreprise;
import com.gestion.repositories.other.RoleProfilRepository;
import com.gestion.service.personnel.UtilisateurEntrepriseService;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/entreprise/employes")
public class EmployeController {

    private final UtilisateurEntrepriseService utilisateurEntrepriseService;
    private final RoleProfilRepository roleProfilRepository;

    @Autowired
    public EmployeController(UtilisateurEntrepriseService utilisateurEntrepriseService,
                             RoleProfilRepository roleProfilRepository) {
        this.utilisateurEntrepriseService = utilisateurEntrepriseService;
        this.roleProfilRepository = roleProfilRepository;
    }

    @GetMapping("")
    public ModelAndView listeEmployes(
            @RequestParam(value = "roleId", required = false) Integer roleId,
            @RequestParam(value = "dateDebut", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(value = "dateFin", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin
    ) {
        ModelAndView mv = new ModelAndView("personnel/employes");
        List<UtilisateurEntreprise> employes = utilisateurEntrepriseService.listEmployesFiltered(roleId, dateDebut, dateFin);
        List<RoleProfil> roles = roleProfilRepository.findAll();
        mv.addObject("employes", employes);
        mv.addObject("roles", roles);
        // Preserve selected filters for the view
        mv.addObject("f_roleId", roleId);
        mv.addObject("f_dateDebut", dateDebut);
        mv.addObject("f_dateFin", dateFin);
        return mv;
    }
}
