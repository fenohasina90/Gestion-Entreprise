package com.gestion.controller.cv;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.gestion.service.cv.CvService;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/cv")
public class CvController {
    private final CvService cvService;
    @Autowired
    public CvController(CvService cvService) {
        this.cvService = cvService;
    }

    @GetMapping("/add/{id}")
    public ModelAndView formulaireAjoutCv(@PathVariable Integer id){
        ModelAndView mv = new ModelAndView("all_utilisateur/form-cv");
        mv.addObject("liste", cvService.getAllNiveau());
        mv.addObject("id", id);
        return mv;
    }
    @PostMapping("/add/{id}")
    public ModelAndView traitementAjoutCv(@PathVariable Integer id,
                                          @RequestParam("nom") String nom,
                                          @RequestParam("prenom") String prenom,
                                          @RequestParam("dateNaissance") LocalDate dateNaissance,
                                          @RequestParam("email") String email,
                                          @RequestParam("adresse") String adresse,
                                          @RequestParam("genre") String genre,
                                          @RequestParam("diplome")List<Integer> diplome,
                                          @RequestParam("dateDiplome") List<LocalDate> dateDiplome,
                                          @RequestParam("experience")List<String> experience,
                                          @RequestParam("dateDebut") List<LocalDate> dateDebut,
                                          @RequestParam("dateFin") List<LocalDate> dateFin,
                                          @RequestParam("competence") List<String> competence,
                                          @RequestParam("iduser") Integer idUser){
        cvService.saveCv(id, nom, prenom,email, genre, dateNaissance, adresse, dateDiplome, diplome, competence, experience, dateDebut, dateFin, idUser);

        return new ModelAndView("redirect:/offre");

    }
}
