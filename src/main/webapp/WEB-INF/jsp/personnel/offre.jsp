<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="loading" lang="en" data-textdirection="ltr">
<head>
    <title>Ajouter tarif</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns   fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>

<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Liste Offre</h3>
            </div>
        </div>
        <div class="content-header row">
            <div class="content-header-left col-md-12 col-12 mb-2">
                <c:if test="${not empty erreur}">
                    <div class="alert alert-danger text-center">${erreur}</div>
                </c:if>
            </div>
        </div>
        <div class="content-body">

            <!-- card actions section start -->
            <section id="card-actions">
                <div class="row">
                    <c:forEach items="${liste}" var="offre" varStatus="status">
                        <div class="col-md-4 col-sm-12">
                            <div class="card">
                                <div class="card-header">
                                    <h4 class="card-title">${offre.poste}</h4>
                                    <br>
                                    <p>Entreprise : ${offre.entreprise}</p>
                                    <p>Unite : ${offre.roleRequis}</p>
                                    <p>Contrat : ${offre.contrat}</p>
                                    <p>Salaire : ${offre.salaire}</p>
                                    <a class="heading-elements-toggle"><i class="la la-ellipsis-v font-medium-3"></i></a>
                                    <div class="heading-elements">
                                        <ul class="list-inline mb-0">
                                            <li><a data-action="collapse"><i class="ft-minus"></i></a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="card-content collapse show">
                                    <div class="card-body">

                                        <p>Mission :
                                        <ul>
                                            <c:forEach items="${offre.missions}" var="mission">
                                                <li>${mission.mission}</li>
                                            </c:forEach>
                                        </ul>

                                        </p>
                                        <c:if test="${offre.estValideRh == false}">
                                            <a href="/admin/offre/qcm/add/${offre.id}">
                                                <button class="btn btn-secondary">Ajouter Qcm</button>
                                            </a>

                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                </div>
            </section>
            <!-- // card-actions section end -->
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
</body>
</html>