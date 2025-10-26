<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="loading" lang="fr" data-textdirection="ltr">
<head>
    <title>Liste des Résultats QCM</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Liste des Résultats QCM</h3>
            </div>
            <div class="content-header-right col-md-6 col-12">
                <div class="btn-group float-md-right" role="group" aria-label="Button group with nested dropdown">
                    <a href="/qcm/resultats" class="btn btn-outline-primary">
                        <i class="ft-refresh-cw"></i> Actualiser
                    </a>
                </div>
            </div>
        </div>
        <div class="content-body">
            <c:if test="${param.success == 'entretien_planifie'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <h4 class="alert-heading">Succès !</h4>
                    <p>L'entretien a été planifié avec succès.</p>
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </c:if>
            <section id="resultats-list">
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
                                    <form id="resultFilterForm" class="form form-horizontal" onsubmit="return false;">
                                        <div class="form-body">
                                            <div class="row">
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
                                            <div id="noResultsMsg" class="alert alert-info mt-1" style="display:none;">Aucun résultat ne correspond aux filtres.</div>
                                                </div>
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
                                        </div>
                                        <div class="form-actions d-flex align-items-center">
                                            <button type="button" class="btn btn-primary" id="applyResultsFilters">
                                                <i class="ft-search"></i> Appliquer
                                            </button>
                                            <button type="button" class="btn btn-warning ml-1" id="clearResultsFilters">
                                                <i class="ft-refresh-cw"></i> Effacer
                                            </button>
                                            <div class="ml-auto text-muted">
                                                <span id="resultsCount">0</span> résultat(s)
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Tableau des résultats -->
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Résultats des Tests QCM</h4>
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
                                        <c:when test="${empty resultats}">
                                            <div class="alert alert-info">
                                                <h4 class="alert-heading">Aucun résultat trouvé</h4>
                                                <p>Aucun résultat de QCM n'a été trouvé dans la base de données.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-striped table-bordered" id="resultats-table">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Candidat</th>
                                                            <th>Email</th>
                                                            <th>Offre</th>
                                                            <th>Score</th>
                                                            <th>Questions Total</th>
                                                            <th>Réponses Correctes</th>
                                                            <th>Pourcentage</th>
                                                            <th>Statut</th>
                                                            <th>Planifier Entretien</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${resultats}" var="resultat">
                                                            <tr class="result-row"
                                                                data-statut-id="${resultat.idResultatStatut != null ? resultat.idResultatStatut.id : ''}"
                                                                data-offre-id="${resultat.idOffre != null ? resultat.idOffre.id : ''}"
                                                                data-score="${resultat.score}">
                                                                <td>${resultat.id}</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty resultat.idCandidat.nom}">
                                                                            ${resultat.idCandidat.nom} ${resultat.idCandidat.prenom}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Candidat #${resultat.idCandidat.id}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty resultat.idCandidat.email}">
                                                                            ${resultat.idCandidat.email}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            N/A
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty resultat.idOffre}">
                                                                            <strong>${resultat.idOffre.poste}</strong><br>
                                                                            <small class="text-muted">${resultat.idOffre.entreprise}</small>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            N/A
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <span class="badge badge-primary">${resultat.score}</span>
                                                                </td>
                                                                <td>${resultat.totalQuestion}</td>
                                                                <td>${resultat.reponseCorrecte}</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${resultat.totalQuestion > 0}">
                                                                            <c:set var="pourcentage" value="${(resultat.reponseCorrecte * 100) / resultat.totalQuestion}" />
                                                                            <fmt:formatNumber value="${pourcentage}" maxFractionDigits="1" />%
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            N/A
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>

                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty resultat.idResultatStatut}">
                                                                            <c:choose>
                                                                                <c:when test="${resultat.idResultatStatut.id == 1}">
                                                                                    <span class="badge badge-success">${resultat.idResultatStatut.statut}</span>
                                                                                </c:when>
                                                                                <c:when test="${resultat.idResultatStatut.id == 2}">
                                                                                    <span class="badge badge-info">${resultat.idResultatStatut.statut}</span>
                                                                                </c:when>
                                                                                <c:when test="${resultat.idResultatStatut.id == 3}">
                                                                                    <span class="badge badge-primary">${resultat.idResultatStatut.statut}</span>
                                                                                </c:when>
                                                                                <c:when test="${resultat.idResultatStatut.id == 4}">
                                                                                    <span class="badge badge-warning">${resultat.idResultatStatut.statut}</span>
                                                                                </c:when>
                                                                                <c:when test="${resultat.idResultatStatut.id == 5}">
                                                                                    <span class="badge badge-orange">${resultat.idResultatStatut.statut}</span>
                                                                                </c:when>
                                                                                <c:when test="${resultat.idResultatStatut.id == 6}">
                                                                                    <span class="badge badge-danger">${resultat.idResultatStatut.statut}</span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="badge badge-secondary">${resultat.idResultatStatut.statut}</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge badge-secondary">Non évalué</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${resultat.totalQuestion > 0}">
                                                                            <c:set var="pourcentage" value="${(resultat.reponseCorrecte * 100) / resultat.totalQuestion}" />
                                                                            <c:choose>
                                                                                <c:when test="${pourcentage >= 50}">
                                                                                    <c:choose>
                                                                                        <c:when test="${qcmService.aDejaEntretien(resultat.id)}">
                                                                                            <span class="badge badge-success">
                                                                                                <i class="ft-calendar"></i> Entretien planifié
                                                                                            </span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <a href="/qcm/entretien/planifier/${resultat.id}" class="btn btn-sm btn-primary">
                                                                                                <i class="ft-calendar"></i> Planifier
                                                                                            </a>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="badge badge-secondary">
                                                                                        <i class="ft-x"></i> Score insuffisant
                                                                                    </span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge badge-secondary">
                                                                                <i class="ft-x"></i> Non évalué
                                                                            </span>
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

<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>

<!-- Scripts pour DataTables (dépend de jQuery/DataTables chargés dans footer.jsp) -->
<script>
    $(document).ready(function() {
        var table = $('#resultats-table').DataTable({
            language: { url: "//cdn.datatables.net/plug-ins/1.10.25/i18n/French.json" },
            pageLength: 25,
            order: [[ 0, "desc" ]],
            columnDefs: [
                { orderable: false, targets: [8, 9] }
            ]
        });

        function parseIntSafe(v){
            var n = parseInt(v, 10);
            return isNaN(n) ? null : n;
        }

        function applyClientFilters(){
            var fStatut = ($('#idStatut').val() || '').toString();
            var fOffre = ($('#idOffre').val() || '').toString();
            var fNom = ($('#nomCandidat').val() || '').toLowerCase().trim();
            var fMin = parseIntSafe($('input[name="scoreMin"]').val());
            var fMax = parseIntSafe($('input[name="scoreMax"]').val());

            // Unified filter for this table
            $.fn.dataTable.ext.search = $.fn.dataTable.ext.search || [];
            // Remove previous filter for this table id to avoid duplicates
            $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn){ return !fn.__resultsFilter; });

            var unified = function(settings, data, dataIndex){
                if (settings.nTable.id !== 'resultats-table') return true;
                var $row = $(table.row(dataIndex).node());
                var rStatut = ($row.attr('data-statut-id') || '').toString();
                var rOffre = ($row.attr('data-offre-id') || '').toString();
                var rScore = parseIntSafe($row.attr('data-score'));
                var rNom = ($row.find('td').eq(1).text() || '').toLowerCase();

                if (fStatut && rStatut !== fStatut) return false;
                if (fOffre && rOffre !== fOffre) return false;
                if (fNom && rNom.indexOf(fNom) === -1) return false;
                if (fMin !== null && (rScore === null || rScore < fMin)) return false;
                if (fMax !== null && (rScore === null || rScore > fMax)) return false;
                return true;
            };
            unified.__resultsFilter = true;
            $.fn.dataTable.ext.search.push(unified);

            table.draw();

            // Update count and no-results message
            var count = table.rows({ filter: 'applied' }).nodes().length;
            $('#resultsCount').text(count);
            if (count === 0) {
                $('#noResultsMsg').slideDown(120);
            } else {
                $('#noResultsMsg').slideUp(120);
            }
        }

        // Bind events
        $('#idStatut, #idOffre').on('change', applyClientFilters);
        $('#nomCandidat').on('keyup change', function(){
            clearTimeout($(this).data('timer'));
            var $i = $(this), t = setTimeout(applyClientFilters, 150);
            $i.data('timer', t);
        });
        $('input[name="scoreMin"], input[name="scoreMax"]').on('change keyup', function(){
            clearTimeout($(this).data('timer'));
            var $i = $(this), t = setTimeout(applyClientFilters, 150);
            $i.data('timer', t);
        });
        $('#applyResultsFilters').on('click', applyClientFilters);
        $('#clearResultsFilters').on('click', function(){
            $('#resultFilterForm')[0].reset();
            applyClientFilters();
        });

        // Initial
        applyClientFilters();
    });
</script>
</body>
</html>
