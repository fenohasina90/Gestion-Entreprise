<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="loading" lang="en" data-textdirection="ltr">
<head>
    <title>Ajouter Critere</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns   fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Formulaire - Ajouter Critere offre</h3>
            </div>
        </div>
        <div class="content-body">
            <section id="basic-form-layouts">
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
                                    <form class="form form-horizontal form-bordered" action="/admin/offre/critere/add/${id}" method="post">
                                        <div class="form-body">
                                            <div class="form-group row mx-auto">
                                                <label class="col-md-3 label-control" for="projectinput7">Diplome : </label>
                                                <div class="col-md-9">
                                                    <select id="projectinput7" name="idniv" class="form-control">
                                                        <option value="" selected="">-- Selectionner le diplome --</option>
                                                        <c:choose>
                                                            <c:when test="${not empty niveau}">
                                                                <c:forEach items="${niveau}" var="st">
                                                                    <option value="${st.id}">${st.typeDiplome}</option>
                                                                </c:forEach>
                                                            </c:when>
                                                        </c:choose>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group row mx-auto">
                                                <label class="col-md-3 label-control" for="projectinput75">Sexe : </label>
                                                <div class="col-md-9">
                                                    <select name="genre" class="form-control" id="projectinput75">
                                                        <option value="Tout le monde">Tout le monde</option>
                                                        <option value="Homme">Masculin</option>
                                                        <option value="Femme">Feminin</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group row mx-auto">
                                                <label class="col-md-3 label-control" for="projectinput7">Ville : </label>
                                                <div class="col-md-9">
                                                    <select name="lieu" class="form-control" id="date3569">
                                                        <option value="" selected="">-- Selectionner une ville --</option>
                                                        <option value="Antananarivo">Antananarivo</option>
                                                        <option value="Toamasina">Toamasina</option>
                                                        <option value="Mahajanga">Mahajanga</option>
                                                        <option value="Fianarantsoa">Fianarantsoa</option>
                                                        <option value="Toliara">Toliara</option>
                                                        <option value="Antsiranana">Antsiranana</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-group row mx-auto last">
                                                <label class="col-md-3 label-control" for="date-debut">Experience (en annee) : </label>
                                                <div class="col-md-9">
                                                    <input type="number" id="date-debut" class="form-control" placeholder="Experience en annee..." name="experience">
                                                </div>
                                            </div>
                                            <div class="form-group row mx-auto last">
                                                <label class="col-md-3 label-control" for="date-debut">Age minimum : </label>
                                                <div class="col-md-9">
                                                    <input type="number" id="date-debuts"  class="form-control" placeholder="Age minimum..." name="agemin">
                                                </div>
                                            </div>
                                            <div class="form-group row mx-auto last">
                                                <label class="col-md-3 label-control" for="date-debsuts">Age maximum : </label>
                                                <div class="col-md-9">
                                                    <input type="number" id="date-debsuts" class="form-control" placeholder="Age maximum..." name="agemax">
                                                </div>
                                            </div>


                                        </div>
                                        <div class="form-actions">
                                            <a href="/admin/offre/rh"><button type="button" class="btn btn-warning mr-1"><i class="ft-x"></i> Annuler</button></a>
                                            <button type="submit" class="btn btn-primary"><i class="la la-check-square-o"></i> Enregistrer</button>
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