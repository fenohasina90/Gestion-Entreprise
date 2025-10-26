<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="loading" lang="en" data-textdirection="ltr">
<head>
    <title>Liste des Entretiens Planifiés</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns   fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Entretiens Planifiés</h3>
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
            <section id="entretiens-list">
                <div class="row">
                    <div class="col-12">
                        <!-- Formulaire de filtres -->
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Filtres de recherche</h4>
                                <div class="heading-elements">
                                    <ul class="list-inline mb-0">
                                        <li><a data-action="collapse"><i class="ft-minus"></i></a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="card-content collpase show">
                                <div class="card-body">
                                    <form method="post" action="/qcm/entretiens/filter" class="form form-horizontal">
                                        <div class="form-body">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label for="idOffre">Type d'offre</label>
                                                        <select class="form-control" id="idOffre" name="idOffre">
                                                            <option value="">Toutes les offres</option>
                                                            <c:forEach items="${offres}" var="offre">
                                                                <option value="${offre.id}" 
                                                                        <c:if test="${selectedOffre == offre.id}">selected</c:if>>
                                                                    ${offre.poste} - ${offre.entreprise}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label for="idStatut">Statut</label>
                                                        <select class="form-control" id="idStatut" name="idStatut">
                                                            <option value="">Tous les statuts</option>
                                                            <c:forEach items="${statuts}" var="statut">
                                                                <option value="${statut.id}" 
                                                                        <c:if test="${selectedStatut == statut.id}">selected</c:if>>
                                                                    ${statut.statut}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label for="nomCandidat">Nom du candidat</label>
                                                        <input type="text" class="form-control" id="nomCandidat" name="nomCandidat" 
                                                               placeholder="Rechercher par nom..." value="${selectedNomCandidat}">
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label>Score</label>
                                                        <div class="row">
                                                            <div class="col-6">
                                                                <input type="number" class="form-control" name="scoreMin" 
                                                                       placeholder="Min" value="${selectedScoreMin}">
                                                            </div>
                                                            <div class="col-6">
                                                                <input type="number" class="form-control" name="scoreMax" 
                                                                       placeholder="Max" value="${selectedScoreMax}">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label for="dateDebut">Date début</label>
                                                        <input type="date" class="form-control" id="dateDebut" name="dateDebut" 
                                                               value="${selectedDateDebut}">
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label for="dateFin">Date fin</label>
                                                        <input type="date" class="form-control" id="dateFin" name="dateFin" 
                                                               value="${selectedDateFin}">
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label for="mois">Mois</label>
                                                        <select class="form-control" id="mois" name="mois">
                                                            <option value="">Tous les mois</option>
                                                            <option value="1" <c:if test="${selectedMois == 1}">selected</c:if>>Janvier</option>
                                                            <option value="2" <c:if test="${selectedMois == 2}">selected</c:if>>Février</option>
                                                            <option value="3" <c:if test="${selectedMois == 3}">selected</c:if>>Mars</option>
                                                            <option value="4" <c:if test="${selectedMois == 4}">selected</c:if>>Avril</option>
                                                            <option value="5" <c:if test="${selectedMois == 5}">selected</c:if>>Mai</option>
                                                            <option value="6" <c:if test="${selectedMois == 6}">selected</c:if>>Juin</option>
                                                            <option value="7" <c:if test="${selectedMois == 7}">selected</c:if>>Juillet</option>
                                                            <option value="8" <c:if test="${selectedMois == 8}">selected</c:if>>Août</option>
                                                            <option value="9" <c:if test="${selectedMois == 9}">selected</c:if>>Septembre</option>
                                                            <option value="10" <c:if test="${selectedMois == 10}">selected</c:if>>Octobre</option>
                                                            <option value="11" <c:if test="${selectedMois == 11}">selected</c:if>>Novembre</option>
                                                            <option value="12" <c:if test="${selectedMois == 12}">selected</c:if>>Décembre</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label for="annee">Année</label>
                                                        <select class="form-control" id="annee" name="annee">
                                                            <option value="">Toutes les années</option>
                                                            <c:forEach items="${annees}" var="annee">
                                                                <option value="${annee}" 
                                                                        <c:if test="${selectedAnnee == annee}">selected</c:if>>
                                                                    ${annee}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-actions">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="ft-search"></i> Filtrer
                                            </button>
                                            <a href="/qcm/entretiens" class="btn btn-warning">
                                                <i class="ft-refresh-cw"></i> Réinitialiser
                                            </a>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Tableau des entretiens -->
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Entretiens Planifiés</h4>
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
                                    <c:choose>
                                        <c:when test="${empty entretiens}">
                                            <div class="alert alert-info">
                                                <h4 class="alert-heading">Aucun entretien planifié</h4>
                                                <p>Aucun entretien n'a été planifié pour le moment.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-striped table-bordered" id="entretiens-table">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Candidat</th>
                                                            <th>Email</th>
                                                            <th>Offre</th>
                                                            <th>Score QCM</th>
                                                            <th>Date Entretien</th>
                                                            <th>Statut</th>
                                                            <th>Évaluer</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${entretiens}" var="entretien">
                                                            <tr>
                                                                <td>${entretien.id}</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty entretien.idResultat.idCandidat.nom}">
                                                                            ${entretien.idResultat.idCandidat.nom} ${entretien.idResultat.idCandidat.prenom}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Candidat #${entretien.idResultat.idCandidat.id}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty entretien.idResultat.idCandidat.email}">
                                                                            ${entretien.idResultat.idCandidat.email}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            N/A
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty entretien.idResultat.idOffre}">
                                                                            <strong>${entretien.idResultat.idOffre.poste}</strong><br>
                                                                            <small class="text-muted">${entretien.idResultat.idOffre.entreprise}</small>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            N/A
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <span class="badge badge-primary">${entretien.idResultat.score}</span>
                                                                    <c:if test="${entretien.idResultat.totalQuestion > 0}">
                                                                        <br><small class="text-muted">
                                                                            <c:set var="pourcentage" value="${(entretien.idResultat.reponseCorrecte * 100) / entretien.idResultat.totalQuestion}" />
                                                                            <fmt:formatNumber value="${pourcentage}" maxFractionDigits="1" />%
                                                                        </small>
                                                                    </c:if>
                                                                </td>
                                                                <td>
                                                                    ${qcmService.formatLocalDateTime(entretien.dateEntretien)}
                                                                    <c:choose>
                                                                        <c:when test="${qcmService.isDatePassed(entretien.dateEntretien)}">
                                                                            <br><span class="badge badge-warning">Passé</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <br><span class="badge badge-success">À venir</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${entretien.idResultat.idResultatStatut != null}">
                                                                            <span class="badge badge-info">${entretien.idResultat.idResultatStatut.statut}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge badge-secondary">Non évalué</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${qcmService.aDejaEvaluation(entretien.id)}">
                                                                            <c:set var="evaluation" value="${qcmService.getEvaluationByEntretienId(entretien.id)}" />
                                                                            <c:choose>
                                                                                <c:when test="${evaluation.note >= 12}">
                                                                                    <span class="badge badge-success">
                                                                                        <i class="ft-check"></i> ${evaluation.note}/20
                                                                                    </span>
                                                                                    <br>
                                                                                    <c:choose>
                                                                                        <c:when test="${qcmService.aDejaContrat(evaluation.id)}">
                                                                                            <a href="/qcm/contrats" class="btn btn-sm btn-info">
                                                                                                <i class="ft-file-text"></i> Voir Contrat
                                                                                            </a>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <a href="/qcm/contrat/creer/${evaluation.id}" class="btn btn-sm btn-primary">
                                                                                                <i class="ft-plus"></i> Créer Contrat
                                                                                            </a>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="badge badge-danger">
                                                                                        <i class="ft-x"></i> ${evaluation.note}/20
                                                                                    </span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <a href="/qcm/entretien/evaluer/${entretien.id}" class="btn btn-sm btn-warning">
                                                                                <i class="ft-star"></i> Évaluer
                                                                            </a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
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

<!-- Scripts pour DataTables -->
<script>
    $(document).ready(function() {
        $('#entretiens-table').DataTable({
            "language": {
                "url": "//cdn.datatables.net/plug-ins/1.10.25/i18n/French.json"
            },
            "pageLength": 25,
            "order": [[ 5, "asc" ]], // Trier par date d'entretien
            "columnDefs": [
                { "orderable": false, "targets": [6, 7] } // Désactiver le tri sur les colonnes statut et évaluer
            ]
        });
    });
</script>

<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
</body>
</html>
