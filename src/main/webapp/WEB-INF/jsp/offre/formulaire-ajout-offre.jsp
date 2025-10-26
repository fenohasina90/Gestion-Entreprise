<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="loading" lang="en" data-textdirection="ltr">
<head>
    <title>Ajouter Dépense</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns   fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Formulaire - Ajouter offre</h3>
            </div>
        </div>
        <div class="content-body">
            <!-- Basic form layout section start -->
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
                                    <form action="/admin/offre/add" class="form steps-validation wizard-circle" method="post">

                                        <!-- Step 1 -->
                                        <h6>Etape 1</h6>
                                        <fieldset>
                                            <div class="row">
                                                <div class="col-md-6 offset-3">
                                                    <div class="form-group">
                                                        <label for="date3">
                                                            Poste :
                                                            <span class="danger">*</span>
                                                        </label>
                                                        <input type="text" class="form-control" name="poste" id="date3" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-6 offset-3">
                                                    <div class="form-group">
                                                        <label for="date35">
                                                            Entreprise :
                                                            <span class="danger">*</span>
                                                        </label>
                                                        <input type="text" class="form-control" name="entreprise" id="date35" required>
                                                    </div>
                                                </div>

                                                <div class="col-md-6 offset-3">
                                                    <div class="form-group">
                                                        <label for="forme-recipient">
                                                            Contrat :
                                                            <span class="danger">*</span>
                                                        </label>
                                                        <select name="contrat" class="form-control" id="forme-recipient">
                                                            <option value="CDD">CDD</option>
                                                            <option value="CDI">CDI</option>
                                                        </select>
                                                    </div>
                                                </div>

                                            </div>

                                            <div class="row">
                                                <div class="col-md-6 offset-3">
                                                    <div class="form-group">
                                                        <label for="date34">
                                                            Salaire :
                                                            <span class="danger">*</span>
                                                        </label>
                                                        <input type="text" class="form-control" name="salaire" id="date34" required>
                                                    </div>
                                                </div>

                                                <input type="hidden" value="${sessionScope.idConnecte}" class="form-control" name="idRole" id="date378">

                                            </div>
                                        </fieldset>

                                        <!-- Step 4 -->
                                        <h6>Etape 2</h6>
                                        <fieldset>
                                            <div id="lignes-competence">
                                                <div class="row">
                                                    <div class="col-md-1">
                                                        <div class="form-group">
                                                            <button class="btn btn-primary" type="button"
                                                                    onclick="addLigneCompetence()">Add</button><br><br>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row ligne-competence">
                                                    <div class="col-md-10">
                                                        <div class="form-group">
                                                            <label for="date361">
                                                                Mission :
                                                                <span class="danger">*</span>
                                                            </label>
                                                            <input type="text" class="form-control" name="mission" id="date361" required>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        </fieldset>

                                        <div class="form-actions text-right">
                                            <button type="submit" class="btn btn-primary">
                                                Enregistrer
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- // Basic form layout section end -->
        </div>
    </div>
</div>
<script>
    function addLigneCompetence() {
        let container = document.getElementById("lignes-competence");
        let ligne = document.createElement("div");
        ligne.classList.add("row");
        ligne.classList.add("ligne-competence")

        ligne.innerHTML = `
                <div class="col-md-10">
                    <div class="form-group">
                        <label for="date361">
                            Mission :
                            <span class="danger">*</span>
                        </label>
                        <input type="text" class="form-control" name="mission" id="date361" required>
                    </div>
                </div>

                <button style="height: 40px; text-align: center; padding: 10px; margin-top: 27px;" class="btn btn-danger" type="button" onclick="removeLigneCompetence(this)">Annuler</button>

            `;
        container.appendChild(ligne);
        reindexLignesCompetence();
    }

    function removeLigneCompetence(btn) {
        btn.parentElement.remove();
        reindexLignesCompetence();
    }

    function reindexLignesCompetence() {
        let lignes = document.querySelectorAll("#lignes-competence .ligne-competence");
        lignes.forEach((ligne, idx) => {
            ligne.querySelectorAll("select, input").forEach(field => {
                if (field.name.includes("mission")) {
                    field.name = `mission[${idx}]`;
                }
                if (field.name.includes("mission")) {
                    field.name = `mission[${idx}]`;
                }
            });
        });
    }

    window.onload = function () {
        reindexLignesCompetence();
    };
</script>
<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
</body>
</html>