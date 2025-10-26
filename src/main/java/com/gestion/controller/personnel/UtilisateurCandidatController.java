package com.gestion.controller.personnel;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.gestion.service.personnel.UtilisateurCandidatService;

@Controller
@RequestMapping("/")
public class UtilisateurCandidatController {
    private final UtilisateurCandidatService candidatService;

    @Autowired
    public UtilisateurCandidatController(UtilisateurCandidatService candidatService) {
        this.candidatService = candidatService;
    }

    @GetMapping("")
    public ModelAndView formulaireLoginUser(){
        return new ModelAndView("all_utilisateur/login");
    }

    @PostMapping("")
    public ModelAndView traitementFormulaireLoginUser(@RequestParam("email") String email,
                                                  @RequestParam("password") String mdp,
                                                  HttpSession session){

        try {
            ModelAndView mv = new ModelAndView("redirect:/offre");
            candidatService.authentification(email, mdp);
            session.setAttribute("idUser", candidatService.getIdUser(email, mdp));

            return mv;

        } catch (Exception e) {
            ModelAndView mv = new ModelAndView("all_utilisateur/login");
            mv.addObject("erreur", e.getMessage());
            return mv;
        }

    }
}
