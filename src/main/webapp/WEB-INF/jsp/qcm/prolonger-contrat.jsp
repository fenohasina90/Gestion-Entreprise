<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="loading" lang="fr" data-textdirection="ltr">
<head>
    <title>Prolonger un Contrat d'Essai</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Prolonger un Contrat d'Essai</h3>
            </div>
            <div class="content-header-right col-md-6 col-12">
                <div class="btn-group float-md-right" role="group" aria-label="Button group with nested dropdown">
                    <a href="/qcm/contrats" class="btn btn-outline-primary">
                        <i class="ft-arrow-left"></i> Retour aux contrats
                    </a>
                </div>
            </div>
        </div>
        <div class="content-body">
            <section id="prolonger-contrat">
                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Prolongation du Contrat</h4>
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

                                    <form class="form form-horizontal form-bordered" action="/qcm/contrat/prolonger/${idContratOriginal}" method="post">
                                        <div class="form-body">
                                            <h4 class="form-section"><i class="ft-plus"></i> Informations de la Prolongation</h4>
                                            
                                            <div class="form-group row">
                                                <label class="col-md-3 label-control" for="dureeProlongation">Durée de prolongation (mois)</label>
                                                <div class="col-md-9">
                                                    <input type="number" class="form-control" id="dureeProlongation" name="dureeProlongation" 
                                                           min="1" max="12" required>
                                                    <small class="text-muted">Durée de la prolongation (maximum 12 mois au total)</small>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-md-3 label-control" for="dateDebut">Date de début de la prolongation</label>
                                                <div class="col-md-9">
                                                    <input type="date" class="form-control" id="dateDebut" name="dateDebut" required>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-md-3 label-control">Informations</label>
                                                <div class="col-md-9">
                                                    <div class="alert alert-warning">
                                                        <h6><i class="ft-info"></i> Règles de prolongation</h6>
                                                        <p>La durée totale du contrat (original + prolongations) ne peut pas dépasser 12 mois.</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-actions">
                                            <a href="/qcm/contrats" class="btn btn-warning mr-1">
                                                <i class="ft-x"></i> Annuler
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="ft-plus"></i> Prolonger le Contrat
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
                                <h4 class="card-title">Historique du Contrat</h4>
                            </div>
                            <div class="card-content collpase show">
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${empty contrats}">
                                            <p>Aucun contrat trouvé.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${contrats}" var="contrat" varStatus="status">
                                                <div class="card mb-2">
                                                    <div class="card-body p-2">
                                                        <h6 class="card-title">
                                                            <c:choose>
                                                                <c:when test="${contrat.estProlongation}">
                                                                    <span class="badge badge-warning">Prolongation</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-success">Contrat Original</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </h6>
                                                        <p class="card-text">
                                                            <strong>Durée :</strong> ${contrat.duree} mois<br>
                                                            <strong>Début :</strong> ${contrat.dateDebut}
                                                            <strong>Fin :</strong> ${contrat.dateDebut.plusMonths(contrat.duree)}
                                                        </p>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
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
        $('#dureeProlongation').on('input', function() {
            var duree = parseInt($(this).val());
            if (duree < 1) $(this).val(1);
            if (duree > 12) $(this).val(12);
        });
    });
</script>

<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
</body>
</html>
