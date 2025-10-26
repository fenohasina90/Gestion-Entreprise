package com.gestion.controller.offre;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gestion.service.cv.CvService;
import com.gestion.service.offre.OffreAdminService;
import com.gestion.service.offre.OffreService;
import com.gestion.service.qcm.QcmService;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/offre")
public class OffreAdminController {
    private final OffreService offreService;
    private final OffreAdminService offreAdminService;
    private final CvService cvService;
    private final QcmService qcmService;
    @Autowired
    public OffreAdminController(OffreService offreService, OffreAdminService offreAdminService, CvService cvService, QcmService qcmService) {
        this.offreService = offreService;
        this.offreAdminService = offreAdminService;
        this.cvService = cvService;
        this.qcmService = qcmService;
    }
    @GetMapping("/{id}")
    public ModelAndView listeOffreAdmin(@PathVariable Integer id){
        ModelAndView mv = new ModelAndView("personnel/offre");
        mv.addObject("liste", offreAdminService.getAllOffreAdminRole(id));
        return mv;
    }

    @GetMapping("/add")
    public ModelAndView formulaireAjoutOffre() {
        return new ModelAndView("offre/formulaire-ajout-offre");
    }

    @PostMapping("/add")
    public ModelAndView traitementFormulaireAjoutOffre(@RequestParam("poste") String poste,
                                                       @RequestParam("entreprise") String entreprise,
                                                       @RequestParam("contrat") String contrat,
                                                       @RequestParam("salaire") String salaire,
                                                       @RequestParam("mission")List<String> mission,
                                                       @RequestParam("idRole") Integer idRole) {

        offreService.saveOffre(poste, entreprise, contrat, salaire, idRole, mission);
        return new ModelAndView("redirect:/admin/home");
    }

    @GetMapping("/rh")
    public ModelAndView listeOffreRh(
            @RequestParam(value = "entreprise", required = false) String entreprise,
            @RequestParam(value = "unite", required = false) String unite,
            @RequestParam(value = "contrat", required = false) String contrat,
            @RequestParam(value = "poste", required = false) String poste
    ){
        ModelAndView mv = new ModelAndView("offre/offre-rh");
        mv.addObject("liste", offreAdminService.getAllOffreAdminRhFiltered(entreprise, unite, contrat, poste));
        mv.addObject("f_entreprise", entreprise);
        mv.addObject("f_unite", unite);
        mv.addObject("f_contrat", contrat);
        mv.addObject("f_poste", poste);
        return mv;
    }

    @GetMapping("/rh/validation/{id}")
    public ModelAndView validationOffreRh(@PathVariable Integer id) {
        offreService.valideOffreRh(id);
        return new ModelAndView("redirect:/admin/offre/rh");
    }

    @GetMapping("/critere/add/{id}")
    public ModelAndView formulaireAjoutCritereOffre(@PathVariable Integer id){
        ModelAndView mv = new ModelAndView("offre/formulaire-ajout-critere");
        mv.addObject("niveau", cvService.getAllNiveau());
        mv.addObject("id", id);
        return mv;
    }

    @PostMapping("/critere/add/{id}")
    public ModelAndView traitementFormulaireAjoutCritere(@PathVariable Integer id,
                                                         @RequestParam(value = "experience", required = false) Integer experience,
                                                         @RequestParam(value = "genre", required = false) String genre,
                                                         @RequestParam(value = "agemin", required = false) Integer ageMin,
                                                         @RequestParam(value = "agemax", required = false) Integer ageMax,
                                                         @RequestParam(value = "idniv", required = false) Integer idNiv,
                                                         @RequestParam(value = "lieu", required = false) String lieu) {
        offreService.updateCritere(id, experience, genre,ageMin, ageMax, idNiv, lieu);
        return new ModelAndView("redirect:/admin/offre/rh");
    }

    @GetMapping("/qcm/add/{id}")
    public ModelAndView formulaireCreationQcm(@PathVariable Integer id) {
        ModelAndView mv = new ModelAndView("qcm/formulaire-ajout-qcm");
//        ModelAndView mv = new ModelAndView("qcm/form-qcm");
        mv.addObject("id", id);
        return mv;
    }

    @PostMapping("/saveQcm")
    public ModelAndView saveQcm(@RequestParam String questionnaire,
                                @RequestParam Integer idOffre,
                                @RequestParam("questionsJson") String questionsJson) {
        try{
            ObjectMapper objectMapper = new ObjectMapper();
            List<Map<String, Object>> questions = objectMapper.readValue(
                    questionsJson,
                    new TypeReference<List<Map<String, Object>>>() {}
            );
            qcmService.saveQcm(questionnaire, idOffre, questions);
            return new ModelAndView("redirect:/admin/home");
        } catch (Exception e) {
            ModelAndView mv = new ModelAndView("qcm/formulaire-ajout-qcm");
            mv.addObject("id", idOffre);
            return mv;
        }
    }

//    @PostMapping("/qcm/add/{id}")
//    public ModelAndView traitementCreationQcm(@ModelAttribute Questionnaire questionnaire,
//                                              @PathVariable Integer id) {
//        qcmService.enregistrerQcm(questionnaire, id);
//        return new ModelAndView("redirect:/admin/home");
//    }
}
