<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="loading" lang="fr" data-textdirection="ltr">
<head>
    <title>Planifier un Entretien</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Planifier un Entretien</h3>
            </div>
            <div class="content-header-right col-md-6 col-12">
                <div class="btn-group float-md-right" role="group" aria-label="Button group with nested dropdown">
                    <a href="/qcm/resultats" class="btn btn-outline-primary">
                        <i class="ft-arrow-left"></i> Retour aux résultats
                    </a>
                </div>
            </div>
        </div>
        <div class="content-body">
            <section id="planifier-entretien">
                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Nouvel Entretien</h4>
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

                                    <form class="form form-horizontal form-bordered" action="/qcm/entretien/planifier/${idResultat}" method="post">
                                        <div class="form-body">
                                            <h4 class="form-section"><i class="ft-calendar"></i> Informations de l'Entretien</h4>
                                            
                                            <div class="form-group row">
                                                <label class="col-md-3 label-control" for="dateEntretien">Date de l'entretien</label>
                                                <div class="col-md-9">
                                                    <input type="date" class="form-control" id="dateEntretien" name="dateEntretien" required>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-md-3 label-control" for="heureEntretien">Heure de l'entretien</label>
                                                <div class="col-md-9">
                                                    <input type="time" class="form-control" id="heureEntretien" name="heureEntretien" required>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-md-3 label-control">Informations</label>
                                                <div class="col-md-9">
                                                    <div class="alert alert-info">
                                                        <h6><i class="ft-info"></i> Note importante</h6>
                                                        <p>L'entretien sera planifié pour le candidat ayant obtenu un score suffisant au test QCM. 
                                                        Veuillez vous assurer que la date et l'heure choisies sont disponibles.</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-actions">
                                            <a href="/qcm/resultats" class="btn btn-warning mr-1">
                                                <i class="ft-x"></i> Annuler
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="ft-calendar"></i> Planifier l'Entretien
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
                                <h4 class="card-title">Aide</h4>
                            </div>
                            <div class="card-content collpase show">
                                <div class="card-body">
                                    <h6>Comment planifier un entretien ?</h6>
                                    <ol>
                                        <li>Sélectionnez une date disponible</li>
                                        <li>Choisissez une heure appropriée</li>
                                        <li>Cliquez sur "Planifier l'Entretien"</li>
                                    </ol>
                                    
                                    <h6 class="mt-2">Critères d'éligibilité</h6>
                                    <p>Seuls les candidats ayant obtenu un score suffisant au test QCM peuvent être convoqués en entretien.</p>
                                    
                                    <h6 class="mt-2">Prochaines étapes</h6>
                                    <p>Après la planification, le candidat recevra une notification et l'entretien apparaîtra dans la liste des entretiens planifiés.</p>
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
        document.getElementById('dateEntretien').setAttribute('min', today);
        
        // Définir l'heure par défaut à 9h00
        document.getElementById('heureEntretien').value = '09:00';
    });
</script>

<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
</body>
</html>
