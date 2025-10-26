<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="loading" lang="fr" data-textdirection="ltr">
<head>
    <title>Liste des Contrats d'Essai</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Contrats d'Essai</h3>
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
            <c:if test="${param.success == 'contrat_creer'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <h4 class="alert-heading">Succès !</h4>
                    <p>Le contrat d'essai a été créé avec succès.</p>
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </c:if>
            <c:if test="${param.success == 'contrat_prolonge'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <h4 class="alert-heading">Succès !</h4>
                    <p>Le contrat d'essai a été prolongé avec succès.</p>
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </c:if>
            <section id="contrats-list">
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Contrats d'Essai</h4>
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
                                    <!-- Section des filtres -->
                                    <div class="row mb-3">
                                        <div class="col-12">
                                            <div class="card border-primary">
                                                <div class="card-header bg-primary text-white">
                                                    <h5 class="mb-0">
                                                        <i class="ft-filter"></i> Filtres de recherche
                                                        <button class="btn btn-sm btn-outline-light float-right" type="button" id="toggleFilters">
                                                            <i class="ft-chevron-up"></i>
                                                        </button>
                                                    </h5>
                                                </div>
                                                <div class="card-body" id="filtersSection">
                                                    <form id="filterForm">
                                                        <div class="row">
                                                            <!-- Filtre par type -->
                                                            <div class="col-md-3 col-sm-6 mb-2">
                                                                <label for="typeFilter" class="form-label">Type de contrat</label>
                                                                <select class="form-control" id="typeFilter" name="type">
                                                                    <option value="">Tous les types</option>
                                                                    <option value="original">Original</option>
                                                                    <option value="prolongation">Prolongation</option>
                                                                </select>
                                                            </div>
                                                            
                                                            <!-- Filtre par durée -->
                                                            <div class="col-md-3 col-sm-6 mb-2">
                                                                <label for="dureeFilter" class="form-label">Durée (mois)</label>
                                                                <select class="form-control" id="dureeFilter" name="duree">
                                                                    <option value="">Toutes les durées</option>
                                                                    <option value="1">1 mois</option>
                                                                    <option value="2">2 mois</option>
                                                                    <option value="3">3 mois</option>
                                                                    <option value="4">4 mois</option>
                                                                    <option value="6">6 mois</option>
                                                                    <option value="12">12 mois</option>
                                                                </select>
                                                            </div>
                                                            
                                                            <!-- Filtre par candidat -->
                                                            <div class="col-md-6 col-sm-12 mb-2">
                                                                <label for="candidatFilter" class="form-label">Candidat</label>
                                                                <input type="text" class="form-control" id="candidatFilter" name="candidat" 
                                                                       placeholder="Rechercher par nom ou prénom du candidat...">
                                                            </div>
                                                        </div>
                                                        
                                                        <div class="row">
                                                            <!-- Filtre par date de début -->
                                                            <div class="col-md-3 col-sm-6 mb-2">
                                                                <label for="dateDebutFilter" class="form-label">Date début (à partir de)</label>
                                                                <input type="date" class="form-control" id="dateDebutFilter" name="dateDebut">
                                                            </div>
                                                            
                                                            <!-- Filtre par date de fin -->
                                                            <div class="col-md-3 col-sm-6 mb-2">
                                                                <label for="dateFinFilter" class="form-label">Date début (jusqu'à)</label>
                                                                <input type="date" class="form-control" id="dateFinFilter" name="dateFin">
                                                            </div>
                                                            
                                                            <!-- Boutons d'action -->
                                                            <div class="col-md-6 col-sm-12 mb-2 d-flex align-items-end">
                                                                <button type="button" class="btn btn-primary mr-2" id="applyFilters">
                                                                    <i class="ft-search"></i> Appliquer les filtres
                                                                </button>
                                                                <button type="button" class="btn btn-secondary" id="clearFilters">
                                                                    <i class="ft-x"></i> Effacer
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Fin de la section des filtres -->
                                    
                                    <c:choose>
                                        <c:when test="${empty contrats}">
                                            <div class="alert alert-info">
                                                <h4 class="alert-heading">Aucun contrat trouvé</h4>
                                                <p>Aucun contrat d'essai n'a été créé pour le moment.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-striped table-bordered" id="contrats-table">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Candidat</th>
                                                            <th>Email</th>
                                                            <th>Durée</th>
                                                            <th>Date Début</th>
                                                            <th>Date Fin</th>
                                                            <th>Type</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${contrats}" var="contrat">
                                                            <tr>
                                                                <td>${contrat.id}</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty contrat.idEvaluation.idEntretien.idResultat.idCandidat.nom}">
                                                                            ${contrat.idEvaluation.idEntretien.idResultat.idCandidat.nom} ${contrat.idEvaluation.idEntretien.idResultat.idCandidat.prenom}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Candidat #${contrat.idEvaluation.idEntretien.idResultat.idCandidat.id}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>${contrat.emailUtilisateur}</td>
                                                                <td>
                                                                    <span class="badge badge-primary">${contrat.duree} mois</span>
                                                                </td>
                                                                <td>
                                                                    ${contrat.dateDebut}
                                                                </td>
                                                                <td>
                                                                    ${contrat.dateDebut.plusMonths(contrat.duree)}
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${contrat.estProlongation}">
                                                                            <span class="badge badge-warning">Prolongation</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge badge-success">Original</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <div class="btn-group" role="group">
                                                                        <a href="/qcm/contrat/pdf/${contrat.id}" class="btn btn-sm btn-info" target="_blank">
                                                                            <i class="ft-download"></i> PDF
                                                                        </a>
                                                                        <c:if test="${!contrat.estProlongation}">
                                                                            <a href="/qcm/contrat/prolonger/${contrat.id}" class="btn btn-sm btn-warning">
                                                                                <i class="ft-plus"></i> Prolonger
                                                                            </a>
                                                                        </c:if>
                                                                    </div>
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

<!-- Scripts pour DataTables et filtres -->
<script>
    $(document).ready(function() {
        // Initialiser DataTables
        var table = $('#contrats-table').DataTable({
            "language": {
                "url": "//cdn.datatables.net/plug-ins/1.10.25/i18n/French.json"
            },
            "pageLength": 25,
            "order": [[ 4, "desc" ]], // Trier par date de début
            "columnDefs": [
                { "orderable": false, "targets": [7] } // Désactiver le tri sur la colonne actions
            ]
        });

        // Conversion d'une date affichée vers ISO (YYYY-MM-DD)
        function toISO(dateStr) {
            if (!dateStr) return null;
            if (/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) return dateStr;
            var parts = dateStr.split(/[\/\-]/);
            if (parts.length === 3) {
                return parts[2] + '-' + parts[1].padStart(2, '0') + '-' + parts[0].padStart(2, '0');
            }
            return null;
        }

        // Définir UN SEUL filtre personnalisé DataTables qui lit tous les champs
        var unifiedFilter = function(settings, data, dataIndex) {
            if (settings.nTable.id !== 'contrats-table') return true;

            // Lire les valeurs des filtres
            var typeFilter = ($('#typeFilter').val() || '').toLowerCase();
            var dureeFilter = ($('#dureeFilter').val() || '').trim();
            var candidatFilter = ($('#candidatFilter').val() || '').toLowerCase().trim();
            var dateDebutMin = ($('#dateDebutFilter').val() || '').trim();
            var dateDebutMax = ($('#dateFinFilter').val() || '').trim();

            // Récupérer le texte depuis le DOM pour éviter les soucis d'HTML/badges
            var $row = $(table.row(dataIndex).node());
            var candidatCell = ($row.find('td').eq(1).text() || '').toLowerCase().trim();
            var dureeCell = ($row.find('td').eq(3).text() || '').trim();
            var dateDebutCell = ($row.find('td').eq(4).text() || '').trim();
            var typeCell = ($row.find('td').eq(6).text() || '').toLowerCase().trim();

            // Filtre par candidat (contient)
            if (candidatFilter && candidatCell.indexOf(candidatFilter) === -1) {
                return false;
            }

            // Filtre par type (original / prolongation) - cherche le mot dans la cellule
            if (typeFilter) {
                if (typeFilter === 'original' && typeCell.indexOf('original') === -1) return false;
                if (typeFilter === 'prolongation' && typeCell.indexOf('prolongation') === -1) return false;
            }

            // Filtre par durée exacte en mois (extrait le nombre de la cellule "X mois")
            if (dureeFilter) {
                var match = dureeCell.match(/\d+/);
                var dureeVal = match ? match[0] : '';
                if (String(dureeVal) !== String(dureeFilter)) return false;
            }

            // Filtre par plage de dates sur la Date Début (data[4])
            var debutISO = toISO(dateDebutCell);
            if (dateDebutMin && debutISO && debutISO < dateDebutMin) return false;
            if (dateDebutMax && debutISO && debutISO > dateDebutMax) return false;

            return true;
        };

        // Enregistrer le filtre une seule fois
        $.fn.dataTable.ext.search.push(unifiedFilter);

        // Redessiner au changement de n'importe quel filtre
        $('#typeFilter, #dureeFilter, #dateDebutFilter, #dateFinFilter').on('change', function() {
            table.draw();
        });
        $('#candidatFilter').on('keyup change', function() {
            table.draw();
        });

        // Boutons
        $('#applyFilters').on('click', function() {
            table.draw();
        });
        $('#clearFilters').on('click', function() {
            $('#filterForm')[0].reset();
            table.search('').columns().search('');
            table.draw();
        });

        // Toggle d'affichage de la section filtres
        $('#toggleFilters').on('click', function() {
            var filtersSection = $('#filtersSection');
            var icon = $(this).find('i');
            if (filtersSection.is(':visible')) {
                filtersSection.slideUp();
                icon.removeClass('ft-chevron-up').addClass('ft-chevron-down');
            } else {
                filtersSection.slideDown();
                icon.removeClass('ft-chevron-down').addClass('ft-chevron-up');
            }
        });

        // Afficher la section filtres par défaut
        $('#filtersSection').show();
    });
</script>
</body>
</html>
