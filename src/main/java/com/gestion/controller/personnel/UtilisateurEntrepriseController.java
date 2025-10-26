package com.gestion.controller.personnel;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.gestion.service.personnel.UtilisateurEntrepriseService;

@Controller
@RequestMapping("/admin")
public class UtilisateurEntrepriseController {
    private final UtilisateurEntrepriseService utilisateurEntrepriseService;
    @Autowired
    public UtilisateurEntrepriseController(UtilisateurEntrepriseService utilisateurEntrepriseService) {
        this.utilisateurEntrepriseService = utilisateurEntrepriseService;
    }

    @GetMapping("/home")
    public ModelAndView AccueilHome(){
        return new ModelAndView("personnel/home");
    }
    @GetMapping("")
    public ModelAndView formulaireLogin(){
        return new ModelAndView("personnel/login");
    }

    @PostMapping("")
    public ModelAndView traitementFormulaireLogin(@RequestParam("email") String email,
                                                  @RequestParam("password") String mdp,
                                                  HttpSession session){

        try {
            ModelAndView mv = new ModelAndView("redirect:/admin/home");
            utilisateurEntrepriseService.authentification(email, mdp);
            session.setAttribute("connecte", utilisateurEntrepriseService.getRoleUser(email, mdp));
            session.setAttribute("idConnecte", utilisateurEntrepriseService.getRoleIdUser(email, mdp));

            if (utilisateurEntrepriseService.getRoleUser(email, mdp).equals("RH")) {
                return new ModelAndView("redirect:/dashboard");
            }
            return mv;

        } catch (Exception e) {
            ModelAndView mv = new ModelAndView("personnel/login");
            mv.addObject("erreur", e.getMessage());
            return mv;
        }

    }
}
