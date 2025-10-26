package com.gestion.service.pdf;

import com.gestion.entities.qcm.ContratEssaie;
import com.itextpdf.html2pdf.HtmlConverter;

import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.format.DateTimeFormatter;

@Service
public class ContratPdfService {

    public byte[] genererPdfContrat(ContratEssaie contrat) throws IOException {
        String html = genererHtmlContrat(contrat);
        
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        HtmlConverter.convertToPdf(html, outputStream);
        
        return outputStream.toByteArray();
    }

    private String genererHtmlContrat(ContratEssaie contrat) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; margin: 40px; line-height: 1.6; }" +
                ".header { text-align: center; border-bottom: 2px solid #333; padding-bottom: 20px; margin-bottom: 30px; }" +
                ".title { font-size: 24px; font-weight: bold; color: #333; }" +
                ".subtitle { font-size: 18px; color: #666; margin-top: 10px; }" +
                ".section { margin: 20px 0; }" +
                ".section-title { font-size: 16px; font-weight: bold; color: #333; margin-bottom: 10px; }" +
                ".info-table { width: 100%; border-collapse: collapse; margin: 10px 0; }" +
                ".info-table td { padding: 8px; border: 1px solid #ddd; }" +
                ".info-table .label { background-color: #f5f5f5; font-weight: bold; width: 30%; }" +
                ".credentials { background-color: #e8f4fd; padding: 15px; border-radius: 5px; margin: 20px 0; }" +
                ".credentials h3 { color: #1976d2; margin-top: 0; }" +
                ".footer { margin-top: 40px; text-align: center; font-size: 12px; color: #666; }" +
                ".signature-section { margin-top: 50px; }" +
                ".signature-line { border-top: 1px solid #333; width: 200px; margin: 20px 0; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='header'>" +
                "<div class='title'>CONTRAT D'ESSAI</div>" +
                "<div class='subtitle'>Gestion d'Entreprise - Système de Recrutement</div>" +
                "</div>" +
                
                "<div class='section'>" +
                "<div class='section-title'>1. INFORMATIONS DU CANDIDAT</div>" +
                "<table class='info-table'>" +
                "<tr><td class='label'>Nom complet :</td><td>" + contrat.getIdEvaluation().getIdEntretien().getIdResultat().getIdCandidat().getNom() + " " + contrat.getIdEvaluation().getIdEntretien().getIdResultat().getIdCandidat().getPrenom() + "</td></tr>" +
                "<tr><td class='label'>Email :</td><td>" + contrat.getEmailUtilisateur() + "</td></tr>" +
                "<tr><td class='label'>Date de naissance :</td><td>" + (contrat.getIdEvaluation().getIdEntretien().getIdResultat().getIdCandidat().getDateNaissance() != null ? contrat.getIdEvaluation().getIdEntretien().getIdResultat().getIdCandidat().getDateNaissance().format(formatter) : "N/A") + "</td></tr>" +
                "<tr><td class='label'>Adresse :</td><td>" + (contrat.getIdEvaluation().getIdEntretien().getIdResultat().getIdCandidat().getAdresse() != null ? contrat.getIdEvaluation().getIdEntretien().getIdResultat().getIdCandidat().getAdresse() : "N/A") + "</td></tr>" +
                "</table>" +
                "</div>" +
                
                "<div class='section'>" +
                "<div class='section-title'>2. INFORMATIONS DU POSTE</div>" +
                "<table class='info-table'>" +
                "<tr><td class='label'>Poste :</td><td>" + contrat.getIdEvaluation().getIdEntretien().getIdResultat().getIdOffre().getPoste() + "</td></tr>" +
                "<tr><td class='label'>Entreprise :</td><td>" + contrat.getIdEvaluation().getIdEntretien().getIdResultat().getIdOffre().getEntreprise() + "</td></tr>" +
                "<tr><td class='label'>Type de contrat :</td><td>" + contrat.getIdEvaluation().getIdEntretien().getIdResultat().getIdOffre().getContrat() + "</td></tr>" +
                "<tr><td class='label'>Salaire :</td><td>" + contrat.getIdEvaluation().getIdEntretien().getIdResultat().getIdOffre().getSalaire() + "</td></tr>" +
                "</table>" +
                "</div>" +
                
                "<div class='section'>" +
                "<div class='section-title'>3. CONDITIONS DU CONTRAT D'ESSAI</div>" +
                "<table class='info-table'>" +
                "<tr><td class='label'>Durée :</td><td>" + contrat.getDuree() + " mois</td></tr>" +
                "<tr><td class='label'>Date de début :</td><td>" + contrat.getDateDebut().format(formatter) + "</td></tr>" +
                "<tr><td class='label'>Date de fin :</td><td>" + contrat.getDateDebut().plusMonths(contrat.getDuree()).format(formatter) + "</td></tr>" +
                "<tr><td class='label'>Type :</td><td>" + (contrat.getEstProlongation() ? "Prolongation" : "Contrat original") + "</td></tr>" +
                "</table>" +
                "</div>" +
                
                "<div class='section'>" +
                "<div class='section-title'>4. RÉSULTATS DE L'ÉVALUATION</div>" +
                "<table class='info-table'>" +
                "<tr><td class='label'>Note QCM :</td><td>" + contrat.getIdEvaluation().getIdEntretien().getIdResultat().getScore() + "/" + contrat.getIdEvaluation().getIdEntretien().getIdResultat().getTotalQuestion() + "</td></tr>" +
                "<tr><td class='label'>Note entretien :</td><td>" + contrat.getIdEvaluation().getNote() + "/20</td></tr>" +
                "<tr><td class='label'>Date d'évaluation :</td><td>" + contrat.getIdEvaluation().getDateEvaluation().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) + "</td></tr>" +
                "</table>" +
                "</div>" +
                
                "<div class='credentials'>" +
                "<h3>🔐 INFORMATIONS DE CONNEXION</h3>" +
                "<p><strong>Email de connexion :</strong> " + contrat.getEmailUtilisateur() + "</p>" +
                "<p><strong>Mot de passe temporaire :</strong> " + contrat.getMotDePasse() + "</p>" +
                "<p><em>⚠️ Important : Changez votre mot de passe lors de votre première connexion.</em></p>" +
                "</div>" +
                
                "<div class='section'>" +
                "<div class='section-title'>5. CONDITIONS GÉNÉRALES</div>" +
                "<ul>" +
                "<li>Ce contrat d'essai a une durée de " + contrat.getDuree() + " mois maximum.</li>" +
                "<li>La durée totale des contrats d'essai ne peut excéder 12 mois.</li>" +
                "<li>Le candidat peut être embauché définitivement à l'issue de la période d'essai.</li>" +
                "<li>Chaque partie peut mettre fin au contrat d'essai avec un préavis de 24 heures.</li>" +
                "<li>Les informations de connexion sont confidentielles et personnelles.</li>" +
                "</ul>" +
                "</div>" +
                
                "<div class='signature-section'>" +
                "<p><strong>Fait le :</strong> " + contrat.getCreateAt().format(formatter) + "</p>" +
                "<br>" +
                "<div style='display: flex; justify-content: space-between;'>" +
                "<div>" +
                "<div class='signature-line'></div>" +
                "<p>Signature du candidat</p>" +
                "</div>" +
                "<div>" +
                "<div class='signature-line'></div>" +
                "<p>Signature de l'entreprise</p>" +
                "</div>" +
                "</div>" +
                "</div>" +
                
                "<div class='footer'>" +
                "<p>Document généré automatiquement par le système de gestion d'entreprise</p>" +
                "<p>Contrat d'essai #" + contrat.getId() + " - " + contrat.getCreateAt().format(formatter) + "</p>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
}
