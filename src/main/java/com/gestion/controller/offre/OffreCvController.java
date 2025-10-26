package com.gestion.controller.offre;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.gestion.service.offre.OffreCvService;

@Controller
@RequestMapping("/cv")
public class OffreCvController {
    private final OffreCvService offreCvService;
    @Autowired
    public OffreCvController(OffreCvService offreCvService) {
        this.offreCvService = offreCvService;
    }
    @GetMapping("/{id}")
    public ModelAndView listeCvPostule(@PathVariable Integer id) {
        ModelAndView mv = new ModelAndView("all_utilisateur/cv-postule");
        mv.addObject("liste", offreCvService.getAllOffreCv(id));
        return mv;
    }
}
