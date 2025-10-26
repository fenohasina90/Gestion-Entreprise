package com.gestion.controller.qcm;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.gestion.service.qcm.QcmService;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.Map;

@Controller
@RequestMapping("/qcm")
public class QcmController {
    private final QcmService qcmService;
    @Autowired
    public QcmController(QcmService qcmService) {
        this.qcmService = qcmService;
    }

    @GetMapping("/reponse/{id}")
    public ModelAndView formulaireReponseQcm(@PathVariable Integer id,
                                             HttpSession session) {
        Integer idUser = (Integer) session.getAttribute("idUser");
        ModelAndView mv = new ModelAndView("qcm/qcm-reponse");
        mv.addObject("liste", qcmService.getFullQuestionnaire(id));
        mv.addObject("id", id);
        mv.addObject("idCandidat", qcmService.getIdCandidat(idUser, id));
        System.out.println("Ito ilay ID Candidat : " + qcmService.getIdCandidat(idUser, id));
        System.out.println("Ito ilay ID User : " + idUser);
        return mv;
    }

    @PostMapping("/save/{id}")
    public ModelAndView enregistrerReponses(@PathVariable Integer id,
                                            @RequestParam Map<String, String> formData,
                                            HttpSession session) {
        Integer idUser = (Integer) session.getAttribute("idUser");
        qcmService.enregistrerReponses(formData);
        qcmService.updateCv(idUser, id);
        return new ModelAndView("redirect:/offre");
    }

    @GetMapping("/resultats")
    public ModelAndView listeResultats(HttpSession session) {
        ModelAndView mv = new ModelAndView("qcm/liste-resultats");
        mv.addObject("resultats", qcmService.getAllResultats());
        mv.addObject("statuts", qcmService.getAllStatuts());
        mv.addObject("offres", qcmService.getAllOffres());
        mv.addObject("qcmService", qcmService); // Pour accéder aux méthodes dans JSP
        return mv;
    }

    @GetMapping("/resultats/candidat/{idCandidat}")
    public ModelAndView resultatsCandidat(@PathVariable Integer idCandidat, HttpSession session) {
        ModelAndView mv = new ModelAndView("qcm/liste-resultats");
        mv.addObject("resultats", qcmService.getResultatsByCandidat(idCandidat));
        mv.addObject("statuts", qcmService.getAllStatuts());
        mv.addObject("offres", qcmService.getAllOffres());
        mv.addObject("qcmService", qcmService);
        return mv;
    }

    @PostMapping("/resultats/filter")
    public ModelAndView filtrerResultats(@RequestParam(required = false) Integer idStatut,
                                        @RequestParam(required = false) Integer idOffre,
                                        @RequestParam(required = false) String nomCandidat,
                                        @RequestParam(required = false) Integer scoreMin,
                                        @RequestParam(required = false) Integer scoreMax,
                                        HttpSession session) {
        ModelAndView mv = new ModelAndView("qcm/");
        mv.addObject("resultats", qcmService.getResultatsFiltres(idStatut, idOffre, nomCandidat, scoreMin, scoreMax));
        mv.addObject("statuts", qcmService.getAllStatuts());
        mv.addObject("offres", qcmService.getAllOffres());
        mv.addObject("qcmService", qcmService);
        
        // Conserver les valeurs des filtres pour la réaffichage
        mv.addObject("selectedStatut", idStatut);
        mv.addObject("selectedOffre", idOffre);
        mv.addObject("selectedNomCandidat", nomCandidat);
        mv.addObject("selectedScoreMin", scoreMin);
        mv.addObject("selectedScoreMax", scoreMax);
        
        return mv;
    }

    @GetMapping("/entretien/planifier/{idResultat}")
    public ModelAndView formulairePlanificationEntretien(@PathVariable Integer idResultat, HttpSession session) {
        ModelAndView mv = new ModelAndView("qcm/planifier-entretien");
        mv.addObject("idResultat", idResultat);
        return mv;
    }

    @PostMapping("/entretien/planifier/{idResultat}")
    public ModelAndView planifierEntretien(@PathVariable Integer idResultat,
                                          @RequestParam String dateEntretien,
                                          @RequestParam String heureEntretien,
                                          HttpSession session) {
        try {
            // Combiner la date et l'heure
            String dateTimeString = dateEntretien + " " + heureEntretien;
            java.time.LocalDateTime dateTime = java.time.LocalDateTime.parse(dateTimeString, 
                java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
            
            qcmService.planifierEntretien(idResultat, dateTime);
            return new ModelAndView("redirect:/qcm/resultats?success=entretien_planifie");
        } catch (Exception e) {
            ModelAndView mv = new ModelAndView("qcm/planifier-entretien");
            mv.addObject("idResultat", idResultat);
            mv.addObject("error", e.getMessage());
            return mv;
        }
    }

    @GetMapping("/entretiens")
    public ModelAndView listeEntretiens(HttpSession session) {
        ModelAndView mv = new ModelAndView("qcm/liste-entretiens");
        mv.addObject("entretiens", qcmService.getAllEntretiens());
        mv.addObject("qcmService", qcmService);
        mv.addObject("statuts", qcmService.getAllStatuts());
        mv.addObject("offres", qcmService.getAllOffres());
        mv.addObject("annees", qcmService.getAnneesDisponibles());
        return mv;
    }

    @PostMapping("/entretiens/filter")
    public ModelAndView filtrerEntretiens(@RequestParam(required = false) Integer idOffre,
                                         @RequestParam(required = false) Integer scoreMin,
                                         @RequestParam(required = false) Integer scoreMax,
                                         @RequestParam(required = false) String dateDebut,
                                         @RequestParam(required = false) String dateFin,
                                         @RequestParam(required = false) Integer mois,
                                         @RequestParam(required = false) Integer annee,
                                         @RequestParam(required = false) Integer idStatut,
                                         @RequestParam(required = false) String nomCandidat,
                                         HttpSession session) {
        ModelAndView mv = new ModelAndView("qcm/liste-entretiens");
        
        // Conversion des dates
        LocalDateTime dateDebutTime = null;
        LocalDateTime dateFinTime = null;
        
        if (dateDebut != null && !dateDebut.isEmpty()) {
            try {
                dateDebutTime = LocalDateTime.parse(dateDebut + " 00:00", 
                    java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
            } catch (Exception e) {
                // Ignorer l'erreur de parsing
            }
        }
        
        if (dateFin != null && !dateFin.isEmpty()) {
            try {
                dateFinTime = LocalDateTime.parse(dateFin + " 23:59", 
                    java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
            } catch (Exception e) {
                // Ignorer l'erreur de parsing
            }
        }
        
        mv.addObject("entretiens", qcmService.getEntretiensFiltres(idOffre, scoreMin, scoreMax, 
                                                                  dateDebutTime, dateFinTime, 
                                                                  mois, annee, idStatut, nomCandidat));
        mv.addObject("qcmService", qcmService);
        mv.addObject("statuts", qcmService.getAllStatuts());
        mv.addObject("offres", qcmService.getAllOffres());
        mv.addObject("annees", qcmService.getAnneesDisponibles());
        
        // Conserver les valeurs des filtres pour la réaffichage
        mv.addObject("selectedOffre", idOffre);
        mv.addObject("selectedScoreMin", scoreMin);
        mv.addObject("selectedScoreMax", scoreMax);
        mv.addObject("selectedDateDebut", dateDebut);
        mv.addObject("selectedDateFin", dateFin);
        mv.addObject("selectedMois", mois);
        mv.addObject("selectedAnnee", annee);
        mv.addObject("selectedStatut", idStatut);
        mv.addObject("selectedNomCandidat", nomCandidat);
        
        return mv;
    }

    // Endpoints pour l'évaluation des entretiens
    @GetMapping("/entretien/evaluer/{idEntretien}")
    public ModelAndView formulaireEvaluationEntretien(@PathVariable Integer idEntretien, HttpSession session) {
        ModelAndView mv = new ModelAndView("qcm/evaluer-entretien");
        mv.addObject("idEntretien", idEntretien);
        return mv;
    }

    @PostMapping("/entretien/evaluer/{idEntretien}")
    public ModelAndView evaluerEntretien(@PathVariable Integer idEntretien,
                                        @RequestParam Integer note,
                                        @RequestParam(required = false) String commentaire,
                                        HttpSession session) {
        try {
            qcmService.evaluerEntretien(idEntretien, note, commentaire);
            return new ModelAndView("redirect:/qcm/entretiens?success=evaluation_ajoutee");
        } catch (Exception e) {
            ModelAndView mv = new ModelAndView("qcm/evaluer-entretien");
            mv.addObject("idEntretien", idEntretien);
            mv.addObject("error", e.getMessage());
            return mv;
        }
    }

    // Endpoints pour les contrats d'essai
    @GetMapping("/contrat/creer/{idEvaluation}")
    public ModelAndView formulaireContratEssaie(@PathVariable Integer idEvaluation, HttpSession session) {
        ModelAndView mv = new ModelAndView("qcm/creer-contrat-essaie");
        mv.addObject("idEvaluation", idEvaluation);
        return mv;
    }

    @PostMapping("/contrat/creer/{idEvaluation}")
    public ModelAndView creerContratEssaie(@PathVariable Integer idEvaluation,
                                          @RequestParam Integer duree,
                                          @RequestParam String dateDebut,
                                          HttpSession session) {
        try {
            LocalDate dateDebutLocal = LocalDate.parse(dateDebut);
            qcmService.creerContratEssaie(idEvaluation, duree, dateDebutLocal);
            return new ModelAndView("redirect:/qcm/contrats?success=contrat_creer");
        } catch (Exception e) {
            ModelAndView mv = new ModelAndView("qcm/creer-contrat-essaie");
            mv.addObject("idEvaluation", idEvaluation);
            mv.addObject("error", e.getMessage());
            return mv;
        }
    }

    @GetMapping("/contrats")
    public ModelAndView listeContrats(HttpSession session) {
        ModelAndView mv = new ModelAndView("qcm/liste-contrats");
        mv.addObject("contrats", qcmService.getAllContrats());
        mv.addObject("qcmService", qcmService);
        return mv;
    }

    @GetMapping("/contrat/prolonger/{idContratOriginal}")
    public ModelAndView formulaireProlongationContrat(@PathVariable Integer idContratOriginal, HttpSession session) {
        ModelAndView mv = new ModelAndView("qcm/prolonger-contrat");
        mv.addObject("idContratOriginal", idContratOriginal);
        mv.addObject("contrats", qcmService.getContratsByOriginalId(idContratOriginal));
        return mv;
    }

    @PostMapping("/contrat/prolonger/{idContratOriginal}")
    public ModelAndView prolongerContrat(@PathVariable Integer idContratOriginal,
                                        @RequestParam Integer dureeProlongation,
                                        @RequestParam String dateDebut,
                                        HttpSession session) {
        try {
            LocalDate dateDebutLocal = LocalDate.parse(dateDebut);
            qcmService.prolongerContrat(idContratOriginal, dureeProlongation, dateDebutLocal);
            return new ModelAndView("redirect:/qcm/contrats?success=contrat_prolonge");
        } catch (Exception e) {
            ModelAndView mv = new ModelAndView("qcm/prolonger-contrat");
            mv.addObject("idContratOriginal", idContratOriginal);
            mv.addObject("contrats", qcmService.getContratsByOriginalId(idContratOriginal));
            mv.addObject("error", e.getMessage());
            return mv;
        }
    }

    @GetMapping("/contrat/pdf/{idContrat}")
    public String genererPdfContrat(@PathVariable Integer idContrat, HttpSession session) {
        return "redirect:/pdf/contrat/" + idContrat;
    }

}
