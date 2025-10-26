<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="loading" lang="en" data-textdirection="ltr">
<!-- BEGIN: Head-->

<head>
    <title>Listes des Clients</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>

<body class="vertical-layout vertical-menu 2-columns   fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-10 col-12 mb-2">
                <h3 class="content-header-title">Liste des Offres</h3>
            </div>
        </div>
        <div class="content-body">
            <section class="control-sizing">
                <div class="row match-height">
                    <div class="col-lg-12 col-md-12">
                        <div class="card">
                            <div class="card-body">
                                <form method="get" action="/offre">
                                    <div class="form-row">
                                        <div class="form-group col-md-3">
                                            <input type="text" name="entreprise" class="form-control" placeholder="Entreprise" value="${entreprise}" />
                                        </div>
                                        <div class="form-group col-md-3">
                                            <input type="text" name="poste" class="form-control" placeholder="Poste" value="${poste}" />
                                        </div>
                                        <div class="form-group col-md-3">
                                            <input type="text" name="role" class="form-control" placeholder="Type de rôle" value="${role}" />
                                        </div>
                                        <div class="form-group col-md-3">
                                            <button type="submit" class="btn btn-primary">Filtrer</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Base style table -->
            <section id="base-style">
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Liste des Offres</h4>
                            </div>
                            <div class="card-content collapse show">
                                <div class="card-body card-dashboard">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>Entreprise</th>
                                                <th>Poste</th>
                                                <th>Contrat</th>
                                                <th>Salaire</th>
                                                <th>Type profil</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="offre" items="${liste}">
                                                <tr>
                                                    <td>${offre.entreprise}</td>
                                                    <td>${offre.poste}</td>
                                                    <td>${offre.contrat}</td>
                                                    <td>${offre.salaire}</td>
                                                    <td>${offre.role}</td>
                                                    <td>
                                                        <a href="/offre/detail/${offre.id}" class="btn btn-info btn-sm">Détail</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!--/ Base style table -->


        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
<script src="/app-assets/jsp/js/client.js"></script>

</body>
</html>