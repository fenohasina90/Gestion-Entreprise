package com.gestion.service.qcm;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestion.entities.offre.Offre;
import com.gestion.entities.personnel.Candidat;
import com.gestion.entities.personnel.UtilisateurEntreprise;
import com.gestion.entities.qcm.ContratEssaie;
import com.gestion.entities.qcm.EvalutionEntretien;
import com.gestion.entities.qcm.PlaningEntretien;
import com.gestion.entities.qcm.Question;
import com.gestion.entities.qcm.Questionnaire;
import com.gestion.entities.qcm.Reponse;
import com.gestion.entities.qcm.Resultat;
import com.gestion.entities.qcm.ResultatStatut;
import com.gestion.groups.qcm.QuestionGroupe;
import com.gestion.groups.qcm.QuestionnaireGroupe;
import com.gestion.groups.qcm.ReponseGroupe;
import com.gestion.projection.QcmProjection;
import com.gestion.repositories.cv.CvRepository;
import com.gestion.repositories.offre.OffreRepository;
import com.gestion.repositories.personnel.CandidatRepository;
import com.gestion.repositories.personnel.UtilisateurEntrepriseRepository;
import com.gestion.repositories.qcm.ContratEssaieRepository;
import com.gestion.repositories.qcm.EvalutionEntretienRepository;
import com.gestion.repositories.qcm.PlaningEntretienRepository;
import com.gestion.repositories.qcm.QuestionRepository;
import com.gestion.repositories.qcm.QuestionnaireRepository;
import com.gestion.repositories.qcm.ReponseRepository;
import com.gestion.repositories.qcm.ResultatRepository;
import com.gestion.repositories.qcm.ResultatStatutRepository;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.*;

@Service
//@RequiredArgsConstructor
public class QcmService {
    private final QuestionnaireRepository questionnaireRepository;
    private final QuestionRepository questionRepository;
    private final CandidatRepository candidatRepository;
    private final CvRepository cvRepository;
    private final ReponseRepository reponseRepository;
    private final OffreRepository offreRepository;
    private final ResultatRepository resultatRepository;
    private final ResultatStatutRepository resultatStatutRepository;
    private final PlaningEntretienRepository planingEntretienRepository;
    private final EvalutionEntretienRepository evalutionEntretienRepository;
    private final ContratEssaieRepository contratEssaieRepository;
    private final UtilisateurEntrepriseRepository utilisateurEntrepriseRepository;
    @Autowired
    public QcmService(QuestionnaireRepository questionnaireRepository,
                      QuestionRepository questionRepository, CandidatRepository candidatRepository, CvRepository cvRepository, ReponseRepository reponseRepository,
                      OffreRepository offreRepository, ResultatRepository resultatRepository, ResultatStatutRepository resultatStatutRepository, 
                      PlaningEntretienRepository planingEntretienRepository, EvalutionEntretienRepository evalutionEntretienRepository,
                      ContratEssaieRepository contratEssaieRepository, UtilisateurEntrepriseRepository utilisateurEntrepriseRepository) {
        this.questionnaireRepository = questionnaireRepository;
        this.questionRepository = questionRepository;
        this.candidatRepository = candidatRepository;
        this.cvRepository = cvRepository;
        this.reponseRepository = reponseRepository;
        this.offreRepository = offreRepository;
        this.resultatRepository = resultatRepository;
        this.resultatStatutRepository = resultatStatutRepository;
        this.planingEntretienRepository = planingEntretienRepository;
        this.evalutionEntretienRepository = evalutionEntretienRepository;
        this.contratEssaieRepository = contratEssaieRepository;
        this.utilisateurEntrepriseRepository = utilisateurEntrepriseRepository;
    }

    @Transactional
    public void saveQcm(String questionnaireName, Integer idOffre, List<Map<String, Object>> questionsData){
        // Verifie offre
        Offre offre = offreRepository.findById(idOffre).orElse(null);

        Questionnaire questionnaire = new Questionnaire();
        questionnaire.setQuestionnaire(questionnaireName);
        questionnaire.setIdOffre(offre);
        questionnaire = questionnaireRepository.save(questionnaire);

        for (int i = 0; i < questionsData.size(); i++) {
            Map<String, Object> questionData = questionsData.get(i);

            // Creer et sauvegarder question
            Question question = new Question();
            question.setQuestion((String) questionData.get("question"));
            question.setPoints(Integer.parseInt(String.valueOf(questionData.get("points"))));
            question.setIdQuestionnaire(questionnaire);
            question = questionRepository.save(question);

            // traitement reponse pour chaque question
            List<Map<String, Object>> reponsesData = (List<Map<String, Object>>) questionData.get("reponses");

            for (int j = 0; j < reponsesData.size(); j++) {
                Map<String, Object> reponseData = reponsesData.get(j);

                // Creer et sauvegarder reponse
                Reponse reponse = new Reponse();
                reponse.setReponseText((String) reponseData.get("reponseText"));
                Object estVraieRaw = reponseData.get("estVraie");
                boolean estVraieBool = false;
                if (estVraieRaw instanceof Boolean) {
                    estVraieBool = (Boolean) estVraieRaw;
                } else if (estVraieRaw instanceof String) {
                    String v = ((String) estVraieRaw).trim().toLowerCase();
                    estVraieBool = "true".equals(v) || "on".equals(v) || "1".equals(v) || "yes".equals(v);
                } else if (estVraieRaw instanceof Number) {
                    estVraieBool = ((Number) estVraieRaw).intValue() != 0;
                }
                reponse.setEstVraie(estVraieBool);
                reponse.setIdQuestion(question);
                reponseRepository.save(reponse);
            }
        }
    }

    public Integer getIdCandidat(Integer idUtilisateur, Integer idOffre) {
        String email = cvRepository.getEmailCandidat(idUtilisateur, idOffre);
        return candidatRepository.getIdCandidat(email, idOffre);
    }

    public void updateCv(Integer idUtilisateur, Integer idOffre) {
        Integer idCv = cvRepository.getIdCvCandidat(idUtilisateur, idOffre);
        cvRepository.updateEstEntretienById(idCv);
    }

    public List<QuestionnaireGroupe> getFullQuestionnaire(Integer idOffre) {
        List<QcmProjection> qcmProjections = questionnaireRepository.getListQcm(idOffre);
        Map<Integer, QuestionnaireGroupe> questionnaireMap = new LinkedHashMap<>();
        Map<Integer, QuestionGroupe> questionMap = new HashMap<>();

        for (QcmProjection proj : qcmProjections) {
            // Gérer. le questionnaire
            QuestionnaireGroupe questionnaire = questionnaireMap.computeIfAbsent(
                    proj.getId(),
                    k -> new QuestionnaireGroupe(
                            proj.getId(),
                            proj.getQuestionnaire(),
                            proj.getIdOffre(),
                            new HashSet<>()
                    )
            );

            // Gérer la question
            QuestionGroupe question = questionMap.computeIfAbsent(
                    proj.getIdQuestion(),
                    k -> {
                        QuestionGroupe newQuestion = new QuestionGroupe(
                                proj.getIdQuestion(),
                                proj.getQuestion(),
                                proj.getPoints(),
                                new HashSet<>()
                        );
                        questionnaire.getQuestions().add(newQuestion);
                        return newQuestion;
                    }
            );

            // Ajouter la réponse à la question
            ReponseGroupe reponse = new ReponseGroupe(
                    proj.getIdReponse(),
                    proj.getReponseText(),
                    proj.getEstVraie()
            );
            question.getReponses().add(reponse);
        }

        return new ArrayList<>(questionnaireMap.values());
    }

    @Transactional
    public void enregistrerReponses(Map<String, String> formData) {
        Integer idCandidat = null;
        int score = 0;
        int totalQuestions = 0;
        int totalCorrect = 0;

        // Extraire idCandidat
        String idCandidatStr = formData.get("idCandidat");
        if (idCandidatStr != null && !idCandidatStr.isEmpty()) {
            idCandidat = Integer.parseInt(idCandidatStr);
        }

        if (idCandidat == null) {
            throw new IllegalArgumentException("idCandidat manquant");
        }

        // Calculer score: les inputs sont de la forme reponse[<idReponse>] = <idReponse>
        Set<Integer> questionVues = new HashSet<>();
        for (Map.Entry<String, String> entry : formData.entrySet()) {
            String key = entry.getKey();
            if (key.startsWith("reponse[")) {
                String value = entry.getValue();
                if (value == null || value.isEmpty()) continue;
                Integer idReponse = Integer.parseInt(value);
                Optional<Reponse> repOpt = reponseRepository.findById(idReponse);
                if (repOpt.isEmpty()) continue;
                Reponse rep = repOpt.get();
                Question q = rep.getIdQuestion();
                if (q != null && questionVues.add(q.getId())) {
                    totalQuestions++;
                }
                if (Boolean.TRUE.equals(rep.getEstVraie())) {
                    totalCorrect++;
                    score += q != null && q.getPoints() != null ? q.getPoints() : 1;
                }
            }
        }

        // Sauvegarder le resultat
        Candidat candidat = candidatRepository.findById(idCandidat).orElse(null);
        if (candidat == null) {
            throw new IllegalArgumentException("Candidat introuvable");
        }
        
        // Calculer le pourcentage et déterminer le statut
        double pourcentage = totalQuestions > 0 ? (totalCorrect * 100.0 / totalQuestions) : 0;
        Integer statutId = calculerStatut(pourcentage);
        ResultatStatut statut = resultatStatutRepository.findById(statutId).orElse(null);
        
        // Récupérer l'offre associée au candidat
        Offre offre = candidat.getIdOffre();
        
        Resultat resultat = new Resultat();
        resultat.setIdCandidat(candidat);
        resultat.setScore(score);
        resultat.setTotalQuestion(totalQuestions);
        resultat.setReponseCorrecte(totalCorrect);
        resultat.setDatePassage(LocalDateTime.now());
        resultat.setIdResultatStatut(statut);
        resultat.setIdOffre(offre);
        resultatRepository.save(resultat);
    }

    public List<Resultat> getAllResultats() {
        return resultatRepository.findAllWithCandidat();
    }

    public List<Resultat> getResultatsByCandidat(Integer idCandidat) {
        return resultatRepository.findByCandidatId(idCandidat);
    }

    private Integer calculerStatut(double pourcentage) {
        if (pourcentage >= 90) return 1; // Excellent
        if (pourcentage >= 80) return 2; // Très bien
        if (pourcentage >= 70) return 3; // Bien
        if (pourcentage >= 60) return 4; // Passable
        if (pourcentage >= 40) return 5; // Insuffisant
        return 6; // Échec
    }

    public List<Resultat> getResultatsFiltres(Integer idStatut, Integer idOffre, String nomCandidat, Integer scoreMin, Integer scoreMax) {
        Integer idStatutN = (idStatut == null) ? -1 : idStatut;
        Integer idOffreN = (idOffre == null) ? -1 : idOffre;
        Integer scoreMinN = (scoreMin == null) ? -1 : scoreMin;
        Integer scoreMaxN = (scoreMax == null) ? -1 : scoreMax;
        String nomCandidatN = (nomCandidat == null) ? "" : nomCandidat.trim();
        return resultatRepository.findResultatsFiltres(idStatutN, idOffreN, nomCandidatN, scoreMinN, scoreMaxN);
    }

    public List<ResultatStatut> getAllStatuts() {
        return resultatStatutRepository.findAllByOrderByIdAsc();
    }

    public List<Offre> getAllOffres() {
        return offreRepository.findAll();
    }

    public boolean peutPlanifierEntretien(Resultat resultat) {
        if (resultat.getTotalQuestion() == null || resultat.getTotalQuestion() == 0) {
            return false;
        }
        // Calculer le pourcentage basé sur le score par rapport au total des points possibles
        // Pour l'instant, on utilise le score directement car il représente déjà les points obtenus
        // Le score maximum serait la somme de tous les points des questions
        return resultat.getScore() != null && resultat.getScore() > 0;
    }

    public boolean aDejaEntretien(Integer idResultat) {
        return planingEntretienRepository.findByResultatId(idResultat).isPresent();
    }

    @Transactional
    public void planifierEntretien(Integer idResultat, LocalDateTime dateEntretien) {
        Resultat resultat = resultatRepository.findById(idResultat).orElse(null);
        if (resultat == null) {
            throw new IllegalArgumentException("Résultat introuvable");
        }

        // Vérifier si un entretien existe déjà
        if (aDejaEntretien(idResultat)) {
            throw new IllegalArgumentException("Un entretien est déjà planifié pour ce résultat");
        }

        PlaningEntretien entretien = new PlaningEntretien();
        entretien.setIdResultat(resultat);
        entretien.setDateEntretien(dateEntretien);
        planingEntretienRepository.save(entretien);
    }

    public List<PlaningEntretien> getAllEntretiens() {
        return planingEntretienRepository.findAllWithDetails();
    }

    public PlaningEntretien getEntretienByResultatId(Integer idResultat) {
        return planingEntretienRepository.findByResultatId(idResultat).orElse(null);
    }

    public String formatLocalDateTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "N/A";
        }
        return String.format("%02d/%02d/%04d %02d:%02d", 
            dateTime.getDayOfMonth(), 
            dateTime.getMonthValue(), 
            dateTime.getYear(),
            dateTime.getHour(), 
            dateTime.getMinute());
    }

    public boolean isDatePassed(LocalDateTime dateTime) {
        if (dateTime == null) {
            return false;
        }
        return dateTime.isBefore(LocalDateTime.now());
    }

    public List<PlaningEntretien> getEntretiensFiltres(Integer idOffre, Integer scoreMin, Integer scoreMax, 
                                                      LocalDateTime dateDebut, LocalDateTime dateFin, 
                                                      Integer mois, Integer annee, Integer idStatut, String nomCandidat) {
        Integer idOffreN = (idOffre == null) ? -1 : idOffre;
        Integer scoreMinN = (scoreMin == null) ? -1 : scoreMin;
        Integer scoreMaxN = (scoreMax == null) ? -1 : scoreMax;
        Integer moisN = (mois == null) ? -1 : mois;
        Integer anneeN = (annee == null) ? -1 : annee;
        Integer idStatutN = (idStatut == null) ? -1 : idStatut;
        String nomCandidatN = (nomCandidat == null) ? "" : nomCandidat.trim();
        // Défauts pour bornes de date si null (évite paramètres JDBC non typés)
        LocalDateTime dateDebutN = (dateDebut == null) ? LocalDateTime.of(1970, 1, 1, 0, 0) : dateDebut;
        LocalDateTime dateFinN = (dateFin == null) ? LocalDateTime.of(3000, 12, 31, 23, 59) : dateFin;
        return planingEntretienRepository.findEntretiensFiltres(idOffreN, scoreMinN, scoreMaxN, dateDebutN, dateFinN, 
                                                               moisN, anneeN, idStatutN, nomCandidatN);
    }

    public List<Integer> getAnneesDisponibles() {
        return planingEntretienRepository.findAll().stream()
                .map(entretien -> entretien.getDateEntretien().getYear())
                .distinct()
                .sorted()
                .collect(java.util.stream.Collectors.toList());
    }

    // Méthodes pour l'évaluation des entretiens
    public boolean aDejaEvaluation(Integer idEntretien) {
        return evalutionEntretienRepository.findByIdEntretien(idEntretien).isPresent();
    }

    @Transactional
    public void evaluerEntretien(Integer idEntretien, Integer note, String commentaire) {
        PlaningEntretien entretien = planingEntretienRepository.findById(idEntretien).orElse(null);
        if (entretien == null) {
            throw new IllegalArgumentException("Entretien introuvable");
        }

        if (aDejaEvaluation(idEntretien)) {
            throw new IllegalArgumentException("Cet entretien a déjà été évalué");
        }

        EvalutionEntretien evaluation = new EvalutionEntretien();
        evaluation.setIdEntretien(entretien);
        evaluation.setNote(note);
        evaluation.setCommentaire(commentaire);
        evaluation.setDateEvaluation(LocalDateTime.now());
        evalutionEntretienRepository.save(evaluation);
    }

    public EvalutionEntretien getEvaluationByEntretienId(Integer idEntretien) {
        return evalutionEntretienRepository.findByIdEntretien(idEntretien).orElse(null);
    }

    public List<EvalutionEntretien> getAllEvaluations() {
        return evalutionEntretienRepository.findAllWithDetails();
    }

    // Méthodes pour les contrats d'essai
    public boolean peutCreerContrat(Integer idEvaluation) {
        EvalutionEntretien evaluation = evalutionEntretienRepository.findById(idEvaluation).orElse(null);
        return evaluation != null && evaluation.getNote() >= 12;
    }

    public boolean aDejaContrat(Integer idEvaluation) {
        List<ContratEssaie> contratEssaies = contratEssaieRepository.findByIdEvaluation(idEvaluation);
        return !contratEssaies.isEmpty();
    }

    @Transactional
    public ContratEssaie creerContratEssaie(Integer idEvaluation, Integer duree, LocalDate dateDebut) {
        EvalutionEntretien evaluation = evalutionEntretienRepository.findById(idEvaluation).orElse(null);
        if (evaluation == null) {
            throw new IllegalArgumentException("Évaluation introuvable");
        }

        if (!peutCreerContrat(idEvaluation)) {
            throw new IllegalArgumentException("Note insuffisante pour créer un contrat");
        }

        if (aDejaContrat(idEvaluation)) {
            throw new IllegalArgumentException("Un contrat existe déjà pour cette évaluation");
        }

        if (duree > 12) {
            throw new IllegalArgumentException("La durée ne peut pas dépasser 12 mois");
        }

        // Générer mot de passe automatique
        String motDePasse = genererMotDePasse();
        
        // Récupérer les informations du candidat
        Candidat candidat = evaluation.getIdEntretien().getIdResultat().getIdCandidat();
        
        // Créer l'utilisateur entreprise
        UtilisateurEntreprise utilisateur = new UtilisateurEntreprise();
        utilisateur.setEmail(candidat.getEmail());
        utilisateur.setMdp(motDePasse);
        utilisateur.setNom(candidat.getNom());
        utilisateur.setPrenom(candidat.getPrenom());
        utilisateur.setDateNaissance(candidat.getDateNaissance());
        utilisateur.setAdresse(candidat.getAdresse());
        utilisateur.setDateDebut(dateDebut);
        
        utilisateur.setIdRole(evaluation.getIdEntretien().getIdResultat().getIdOffre().getIdRole());
        utilisateur.setEstRh(false);
        utilisateur = utilisateurEntrepriseRepository.save(utilisateur);

        // Créer le contrat
        ContratEssaie contrat = new ContratEssaie();
        contrat.setIdEvaluation(evaluation);
        contrat.setDuree(duree);
        contrat.setContrat("Essaie");
        contrat.setDateDebut(dateDebut);
        contrat.setCreateAt(LocalDate.now());
        contrat.setMotDePasse(motDePasse);
        contrat.setEmailUtilisateur(candidat.getEmail());
        contrat.setEstProlongation(false);
        contrat.setIdContratOriginal(null);
        contrat = contratEssaieRepository.save(contrat);

        return contrat;
    }

    @Transactional
    public ContratEssaie prolongerContrat(Integer idContratOriginal, Integer dureeProlongation, LocalDate dateDebut) {
        ContratEssaie contratOriginal = contratEssaieRepository.findById(idContratOriginal).orElse(null);
        if (contratOriginal == null) {
            throw new IllegalArgumentException("Contrat original introuvable");
        }

        // Calculer la durée totale
        Integer dureeTotale = contratEssaieRepository.getTotalDureeContrat(idContratOriginal);
        if (dureeTotale == null) {
            dureeTotale = contratOriginal.getDuree();
        }

        if (dureeTotale + dureeProlongation > 12) {
            throw new IllegalArgumentException("La durée totale ne peut pas dépasser 12 mois");
        }

        // Créer la prolongation
        ContratEssaie prolongation = new ContratEssaie();
        prolongation.setIdEvaluation(contratOriginal.getIdEvaluation());
        prolongation.setDuree(dureeProlongation);
        prolongation.setDateDebut(dateDebut);
        prolongation.setContrat("Essaie");
        prolongation.setCreateAt(LocalDate.now());
        prolongation.setMotDePasse(contratOriginal.getMotDePasse());
        prolongation.setEmailUtilisateur(contratOriginal.getEmailUtilisateur());
        prolongation.setEstProlongation(true);
        prolongation.setIdContratOriginal(idContratOriginal);
        prolongation = contratEssaieRepository.save(prolongation);

        return prolongation;
    }

    public List<ContratEssaie> getAllContrats() {
        return contratEssaieRepository.findAllWithDetails();
    }

    public ContratEssaie getContratById(Integer id) {
        return contratEssaieRepository.findById(id).orElse(null);
    }

    public List<ContratEssaie> getContratsByOriginalId(Integer idContratOriginal) {
        return contratEssaieRepository.findContratsByOriginalId(idContratOriginal);
    }

    private String genererMotDePasse() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!?-#";
        StringBuilder motDePasse = new StringBuilder();
        for (int i = 0; i < 8; i++) {
            motDePasse.append(chars.charAt((int) (Math.random() * chars.length())));
        }
        return motDePasse.toString();
    }
}
