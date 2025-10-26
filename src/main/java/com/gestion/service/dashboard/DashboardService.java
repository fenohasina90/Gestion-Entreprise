package com.gestion.service.dashboard;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gestion.repositories.cv.CvRepository;
import com.gestion.repositories.cv.CvStatutRepository;
import com.gestion.repositories.offre.OffreRepository;
import com.gestion.repositories.personnel.CandidatRepository;
import com.gestion.repositories.personnel.UtilisateurEntrepriseRepository;
import com.gestion.repositories.qcm.ContratEssaieRepository;
import com.gestion.repositories.qcm.EvalutionEntretienRepository;
import com.gestion.repositories.qcm.PlaningEntretienRepository;
import com.gestion.repositories.qcm.QuestionnaireRepository;
import com.gestion.repositories.qcm.ResultatRepository;

import java.util.HashMap;
import java.util.Map;

@Service
public class DashboardService {
    private final OffreRepository offreRepository;
    private final CvRepository cvRepository;
    private final CvStatutRepository cvStatutRepository;
    private final CandidatRepository candidatRepository;
    private final QuestionnaireRepository questionnaireRepository;
    private final ResultatRepository resultatRepository;
    private final PlaningEntretienRepository planingEntretienRepository;
    private final EvalutionEntretienRepository evalutionEntretienRepository;
    private final ContratEssaieRepository contratEssaieRepository;
    private final UtilisateurEntrepriseRepository utilisateurEntrepriseRepository;

    @Autowired
    public DashboardService(OffreRepository offreRepository,
                            CvRepository cvRepository,
                            CvStatutRepository cvStatutRepository,
                            CandidatRepository candidatRepository,
                            QuestionnaireRepository questionnaireRepository,
                            ResultatRepository resultatRepository,
                            PlaningEntretienRepository planingEntretienRepository,
                            EvalutionEntretienRepository evalutionEntretienRepository,
                            ContratEssaieRepository contratEssaieRepository,
                            UtilisateurEntrepriseRepository utilisateurEntrepriseRepository) {
        this.offreRepository = offreRepository;
        this.cvRepository = cvRepository;
        this.cvStatutRepository = cvStatutRepository;
        this.candidatRepository = candidatRepository;
        this.questionnaireRepository = questionnaireRepository;
        this.resultatRepository = resultatRepository;
        this.planingEntretienRepository = planingEntretienRepository;
        this.evalutionEntretienRepository = evalutionEntretienRepository;
        this.contratEssaieRepository = contratEssaieRepository;
        this.utilisateurEntrepriseRepository = utilisateurEntrepriseRepository;
    }

    public Map<String, Long> getKpis() {
        Map<String, Long> kpis = new HashMap<>();
        long offresTotal = offreRepository.count();
        long offresValidees = offreRepository.countByEstValideRh(true);
        long offresNonValidees = offreRepository.countByEstValideRh(false);

        long cvsTotal = cvRepository.count();
        long cvsValides = safeCountDistinctCvValide();
        long cvsRefuses = safeCountDistinctCvRefuse();

        kpis.put("offresTotal", offresTotal);
        kpis.put("offresValidees", offresValidees);
        kpis.put("offresNonValidees", offresNonValidees);
        kpis.put("cvsTotal", cvsTotal);
        kpis.put("cvsValides", cvsValides);
        kpis.put("cvsRefuses", cvsRefuses);

        // Elargi: autres statistiques intéressantes
        kpis.put("candidatsTotal", candidatRepository.count());
        kpis.put("questionnairesTotal", questionnaireRepository.count());
        kpis.put("resultatsTotal", resultatRepository.count());
        kpis.put("entretiensPlanifies", planingEntretienRepository.count());
        kpis.put("evaluationsTotal", evalutionEntretienRepository.count());
        kpis.put("contratsTotal", contratEssaieRepository.count());
        kpis.put("employesTotal", utilisateurEntrepriseRepository.count());
        return kpis;
    }

    private long safeCountDistinctCvValide() {
        try { return cvStatutRepository.countDistinctCvValide(); } catch (Exception e) { return 0L; }
    }
    private long safeCountDistinctCvRefuse() {
        try { return cvStatutRepository.countDistinctCvRefuse(); } catch (Exception e) { return 0L; }
    }

    // Charts data
    public java.util.List<String> getRoleLabels() {
        java.util.List<Object[]> rows = utilisateurEntrepriseRepository.countEmployesParRole();
        java.util.List<String> labels = new java.util.ArrayList<>();
        for (Object[] r : rows) {
            labels.add(r[0] != null ? String.valueOf(r[0]) : "(Sans rôle)");
        }
        return labels;
    }

    public java.util.List<Long> getRoleCounts() {
        java.util.List<Object[]> rows = utilisateurEntrepriseRepository.countEmployesParRole();
        java.util.List<Long> data = new java.util.ArrayList<>();
        for (Object[] r : rows) {
            Number n = (Number) r[1];
            data.add(n != null ? n.longValue() : 0L);
        }
        return data;
    }

    public java.util.List<String> getMonthLabels() {
        java.util.List<Object[]> rows = utilisateurEntrepriseRepository.countEmbauchesParMois();
        java.util.List<String> labels = new java.util.ArrayList<>();
        for (Object[] r : rows) {
            Number year = (Number) r[0];
            Number month = (Number) r[1];
            String label = String.format("%04d-%02d", year.intValue(), month.intValue());
            labels.add(label);
        }
        return labels;
    }

    public java.util.List<Long> getMonthCounts() {
        java.util.List<Object[]> rows = utilisateurEntrepriseRepository.countEmbauchesParMois();
        java.util.List<Long> data = new java.util.ArrayList<>();
        for (Object[] r : rows) {
            Number n = (Number) r[2];
            data.add(n != null ? n.longValue() : 0L);
        }
        return data;
    }
}
