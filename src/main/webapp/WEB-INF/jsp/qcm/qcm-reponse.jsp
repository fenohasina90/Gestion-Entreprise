<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="loading" lang="fr" data-textdirection="ltr">
<head>
    <title>Créer un QCM</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Formulaire - Test QCM</h3>
            </div>
        </div>
        <div class="content-body">
            <section id="qcm-form">
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
                                <div class="heading-elements">
                                    <ul class="list-inline mb-0">
                                        <li><a data-action="collapse"><i class="ft-minus"></i></a></li>
                                        <li><a data-action="reload"><i class="ft-rotate-cw"></i></a></li>
                                        <li><a data-action="expand"><i class="ft-maximize"></i></a></li>
                                        <li><a data-action="close"><i class="ft-x"></i></a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="card-content collpase show">
                                <div class="card-body">
                                    <!-- Formulaire du QCM -->
                                    <form class="form form-horizontal form-bordered" action="/qcm/save/${id}" method="post">
                                        <div class="form-body">
                                            <input type="hidden" value="${idCandidat}" name="idCandidat">
                                            <c:set var="questionCounter" value="0" />
                                            <c:forEach items="${liste}" var="qst">
                                                <h4 class="form-section"><i class="ft-layers"></i> Informations du Questionnaire : <span class="font-weight-bold">${qst.questionnaire}</span> </h4>
                                                <h4 class="form-section"><i class="ft-help-circle"></i> Questions et Réponses</h4>
                                                <c:forEach items="${qst.questions}" var="st">
                                                    <c:set var="questionCounter" value="${questionCounter + 1}" />
                                                    <div class="form-group">
                                                        <label><strong>Question ${questionCounter} : ${st.question}</strong></label>
                                                        <div class="col-md-12">
                                                            <c:forEach items="${st.reponses}" var="res" varStatus="respStatus">
                                                                <div class="custom-control custom-radio">
                                                                    <input type="checkbox" class="skin skin-flat custom-control-input" name="reponse[${res.idReponse}]" id="q${st.idQuestion}r${res.idReponse}" value="${res.idReponse}">
                                                                    <label class="custom-control-label" for="q${st.idQuestion}r${res.idReponse}">
                                                                        <c:choose>
                                                                            <c:when test="${respStatus.count == 1}">A. </c:when>
                                                                            <c:when test="${respStatus.count == 2}">B. </c:when>
                                                                            <c:when test="${respStatus.count == 3}">C. </c:when>
                                                                            <c:when test="${respStatus.count == 4}">D. </c:when>
                                                                            <c:when test="${respStatus.count == 5}">E. </c:when>
                                                                            <c:otherwise>${respStatus.count}. </c:otherwise>
                                                                        </c:choose>
                                                                            ${res.reponseText}
                                                                    </label>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:forEach>
                                        </div>

                                        <!-- Boutons -->
                                        <div class="form-actions">
                                            <a href="/qcm"><button type="button" class="btn btn-warning mr-1">
                                                <i class="ft-x"></i> Annuler
                                            </button></a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="la la-check-square-o"></i> Enregistrer
                                            </button>
                                        </div>
                                    </form>
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
</body>
</html>