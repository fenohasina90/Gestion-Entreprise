package com.gestion.controller.pdf;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.gestion.entities.qcm.ContratEssaie;
import com.gestion.service.pdf.ContratPdfService;
import com.gestion.service.qcm.QcmService;

import java.io.IOException;

@Controller
@RequestMapping("/pdf")
public class PdfController {

    @Autowired
    private QcmService qcmService;

    @Autowired
    private ContratPdfService contratPdfService;

    @GetMapping("/contrat/{idContrat}")
    public ResponseEntity<byte[]> genererPdfContrat(@PathVariable Integer idContrat) {
        try {
            ContratEssaie contrat = qcmService.getContratById(idContrat);
            if (contrat == null) {
                return ResponseEntity.notFound().build();
            }

            byte[] pdfBytes = contratPdfService.genererPdfContrat(contrat);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDispositionFormData("attachment", 
                "contrat_essaie_" + contrat.getId() + "_" + 
                contrat.getIdEvaluation().getIdEntretien().getIdResultat().getIdCandidat().getNom() + ".pdf");

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(pdfBytes);

        } catch (IOException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
