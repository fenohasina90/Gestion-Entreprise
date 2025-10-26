<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="loading" lang="fr" data-textdirection="ltr">
<head>
    <title>Créer un Contrat d'Essai</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Créer un Contrat d'Essai</h3>
            </div>
            <div class="content-header-right col-md-6 col-12">
                <div class="btn-group float-md-right" role="group" aria-label="Button group with nested dropdown">
                    <a href="/qcm/entretiens" class="btn btn-outline-primary">
                        <i class="ft-arrow-left"></i> Retour aux entretiens
                    </a>
                </div>
            </div>
        </div>
        <div class="content-body">
            <section id="creer-contrat-essaie">
                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Nouveau Contrat d'Essai</h4>
                                <div class="heading-elements">
                                    <ul class="list-inline mb-0">
                                        <li><a data-action="collapse"><i class="ft-minus"></i></a></li>
                                        <li><a data-action="reload"><i class="ft-rotate-cw"></i></a></li>
                                        <li><a data-action="expand"><i class="ft-maximize"></i></a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="card-content collpase show">
                                <div class="card-body">
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger">
                                            <h4 class="alert-heading">Erreur</h4>
                                            <p>${error}</p>
                                        </div>
                                    </c:if>

                                    <form class="form form-horizontal form-bordered" action="/qcm/contrat/creer/${idEvaluation}" method="post">
                                        <div class="form-body">
                                            <h4 class="form-section"><i class="ft-file-text"></i> Informations du Contrat</h4>
                                            
                                            <div class="form-group row">
                                                <label class="col-md-3 label-control" for="duree">Durée (mois)</label>
                                                <div class="col-md-9">
                                                    <input type="number" class="form-control" id="duree" name="duree" 
                                                           min="1" max="12" required>
                                                    <small class="text-muted">Durée du contrat d'essai (maximum 12 mois)</small>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-md-3 label-control" for="dateDebut">Date de début</label>
                                                <div class="col-md-9">
                                                    <input type="date" class="form-control" id="dateDebut" name="dateDebut" required>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-md-3 label-control">Informations</label>
                                                <div class="col-md-9">
                                                    <div class="alert alert-success">
                                                        <h6><i class="ft-check-circle"></i> Candidat éligible</h6>
                                                        <p>Ce candidat a obtenu une note suffisante pour bénéficier d'un contrat d'essai. 
                                                        Un mot de passe sera généré automatiquement et l'utilisateur sera créé dans le système.</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-actions">
                                            <a href="/qcm/entretiens" class="btn btn-warning mr-1">
                                                <i class="ft-x"></i> Annuler
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="ft-file-text"></i> Créer le Contrat
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Règles du Contrat d'Essai</h4>
                            </div>
                            <div class="card-content collpase show">
                                <div class="card-body">
                                    <h6>Durée maximale</h6>
                                    <p>La durée totale d'un contrat d'essai ne peut pas dépasser 12 mois.</p>
                                    
                                    <h6 class="mt-2">Prolongation possible</h6>
                                    <p>Le contrat peut être prolongé, mais la durée totale (original + prolongations) ne doit pas dépasser 12 mois.</p>
                                    
                                    <h6 class="mt-2">Création d'utilisateur</h6>
                                    <p>Un compte utilisateur sera automatiquement créé avec :</p>
                                    <ul>
                                        <li>Email du candidat</li>
                                        <li>Mot de passe généré</li>
                                        <li>Informations personnelles</li>
                                    </ul>
                                    
                                    <h6 class="mt-2">Export PDF</h6>
                                    <p>Le contrat peut être exporté en PDF avec toutes les informations de connexion.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // Définir la date minimum à aujourd'hui
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0');
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;
        document.getElementById('dateDebut').setAttribute('min', today);
        
        // Validation de la durée
        $('#duree').on('input', function() {
            var duree = parseInt($(this).val());
            if (duree < 1) $(this).val(1);
            if (duree > 12) $(this).val(12);
        });
    });
</script>

<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
</body>
</html>
