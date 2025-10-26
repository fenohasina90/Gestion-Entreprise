<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html class="loading" lang="fr" data-textdirection="ltr">
<head>
    <title>Employés de l'entreprise</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Liste des Employés</h3>
            </div>
        </div>
        <div class="content-body">
            <section id="employes-filters">
                <div class="card border-primary">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="ft-filter"></i> Filtres
                            <button class="btn btn-sm btn-outline-light float-right" type="button" id="toggleEmpFilters">
                                <i class="ft-chevron-up"></i>
                            </button>
                        </h5>
                    </div>
                    <div class="card-body" id="empFiltersSection">
                        <form method="get" action="/entreprise/employes" class="form form-horizontal">
                            <div class="row">
                                <div class="col-md-4 col-sm-6 mb-1">
                                    <label for="roleId" class="form-label">Rôle</label>
                                    <select id="roleId" name="roleId" class="form-control">
                                        <option value="">Tous</option>
                                        <c:forEach items="${roles}" var="r">
                                            <option value="${r.id}" <c:if test="${f_roleId == r.id}">selected</c:if>>${r.type}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4 col-sm-6 mb-1">
                                    <label for="dateDebut" class="form-label">Date début</label>
                                    <input id="dateDebut" name="dateDebut" type="date" class="form-control" value="${f_dateDebut}">
                                </div>
                                <div class="col-md-4 col-sm-6 mb-1">
                                    <label for="dateFin" class="form-label">Date fin</label>
                                    <input id="dateFin" name="dateFin" type="date" class="form-control" value="${f_dateFin}">
                                </div>
                            </div>
                            <div class="d-flex align-items-center mt-1">
                                <button type="submit" class="btn btn-primary mr-1"><i class="ft-search"></i> Appliquer</button>
                                <a href="/entreprise/employes" class="btn btn-secondary"><i class="ft-x"></i> Effacer</a>
                                <div class="ml-auto text-muted">
                                    <span id="empResultCount">${fn:length(employes)}</span> employé(s)
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </section>

            <section id="employes-list" class="mt-1">
                <div class="card">
                    <div class="card-header">
                        <h4 class="card-title">Employés</h4>
                    </div>
                    <div class="card-content">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered" id="employes-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Nom</th>
                                            <th>Prénom</th>
                                            <th>Email</th>
                                            <th>Rôle</th>
                                            <th>Date début</th>
                                            <th>Adresse</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${employes}" var="e">
                                            <tr>
                                                <td>${e.id}</td>
                                                <td>${e.nom}</td>
                                                <td>${e.prenom}</td>
                                                <td>${e.email}</td>
                                                <td>${e.idRole.type}</td>
                                                <td>${e.dateDebut}</td>
                                                <td>${e.adresse}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
<script>
    $(function(){
        $('#toggleEmpFilters').on('click', function(){
            var $s = $('#empFiltersSection');
            var $ic = $(this).find('i');
            if ($s.is(':visible')){ $s.slideUp(120); $ic.removeClass('ft-chevron-up').addClass('ft-chevron-down'); }
            else { $s.slideDown(120); $ic.removeClass('ft-chevron-down').addClass('ft-chevron-up'); }
        });
        $('#employes-table').DataTable({
            language: { url: "//cdn.datatables.net/plug-ins/1.10.25/i18n/French.json" },
            pageLength: 25,
            order: [[ 0, 'desc' ]]
        });
    });
</script>
</body>
</html>
