package com.gestion.controller.offre;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.gestion.service.offre.OffreService;

@Controller
@RequestMapping("/offre")
public class OffreController {
    private final OffreService offreService;
    @Autowired
    public OffreController(OffreService offreService) {
        this.offreService = offreService;
    }
    @GetMapping("")
    public ModelAndView listeOffre(
            @RequestParam(value = "entreprise", required = false) String entreprise,
            @RequestParam(value = "unite", required = false) String unite,
            @RequestParam(value = "contrat", required = false) String contrat,
            @RequestParam(value = "poste", required = false) String poste
    ) {
        ModelAndView mv = new ModelAndView("all_utilisateur/home");
        mv.addObject("liste", offreService.getAllOffreFiltered(entreprise, unite, contrat, poste));
        // renvoyer aussi les filtres choisis pour pré-remplir si besoin
        mv.addObject("f_entreprise", entreprise);
        mv.addObject("f_unite", unite);
        mv.addObject("f_contrat", contrat);
        mv.addObject("f_poste", poste);
        return mv;
    }

//    @GetMapping("/detail/{id}")
//    public ModelAndView detailOffre(@PathVariable Integer id) {
//        ModelAndView mv = new ModelAndView("personnel/detail-offre");
//        mv.addObject("offre", offreService.getOffreById(id));
//        return mv;
//    }
}
