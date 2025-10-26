<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="loading" lang="en" data-textdirection="ltr">
<head>
    <title>Créer un QCM</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
    <style>
        .question-block, .reponse-block {
            margin-top: 15px;
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            background: #fafafa;
        }
        .reponse-block {
            margin-left: 20px;
            background: #fff;
        }
        .question-actions, .reponse-actions {
            margin-top: 10px;
        }
    </style>
    <script>
        function ajouterQuestion() {
            let questionContainer = document.getElementById("questions");
            let block = document.createElement("div");
            block.classList.add("question-block");
            block.innerHTML = `
                <h5>Nouvelle Question</h5>
                <div class="form-group row">
                    <label class="col-md-2 col-form-label">Intitulé :</label>
                    <div class="col-md-10">
                        <input type="text" class="form-control" name="" required />
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-md-2 col-form-label">Points :</label>
                    <div class="col-md-4">
                        <input type="number" class="form-control" name="" required />
                    </div>
                </div>
                <div class="question-actions">
                    <button type="button" class="btn btn-sm btn-success" onclick="ajouterReponse(this)">+ Réponse</button>
                    <button type="button" class="btn btn-sm btn-danger" onclick="supprimerElement(this)">Supprimer la Question</button>
                </div>
                <div class="reponses"></div>
            `;
            questionContainer.appendChild(block);
            recalibrerIndexes();
        }

        function ajouterReponse(button) {
            let repContainer = button.closest(".question-block").querySelector(".reponses");

            let rep = document.createElement("div");
            rep.classList.add("reponse-block");
            rep.innerHTML = `
                <div class="form-group row">
                    <label class="col-md-2 col-form-label">Réponse :</label>
                    <div class="col-md-6">
                        <input type="text" class="form-control" name="" required />
                    </div>
                    <div class="col-md-2">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" name="" value="true" />
                            <label class="form-check-label">Vraie ?</label>
                        </div>
                    </div>
                    <div class="col-md-2 reponse-actions">
                        <button type="button" class="btn btn-sm btn-danger" onclick="supprimerElement(this)">Supprimer</button>
                    </div>
                </div>
            `;
            repContainer.appendChild(rep);
            recalibrerIndexes();
        }

        // Supprimer une question ou une réponse
        function supprimerElement(button) {
            let parent = button.closest(".question-block, .reponse-block");
            if (parent) {
                parent.remove();
                recalibrerIndexes();
            }
        }

        // Réinitialiser le formulaire
        function resetForm() {
            document.getElementById("qcmForm").reset();
            document.getElementById("questions").innerHTML = "";
        }

        // Recalibrer les indexes pour Spring Boot (questions[i], reponses[j])
        function recalibrerIndexes() {
            let questions = document.querySelectorAll(".question-block");
            questions.forEach((qBlock, i) => {
                qBlock.querySelector("h5").textContent = "Question " + (i + 1);

                let inputsQ = qBlock.querySelectorAll("input[type='text'], input[type='number']");
                if (inputsQ.length >= 2) {
                    inputsQ[0].setAttribute("name", `questions[${i}].question`);
                    inputsQ[1].setAttribute("name", `questions[${i}].points`);
                }

                let reponses = qBlock.querySelectorAll(".reponse-block");
                reponses.forEach((rBlock, j) => {
                    let txt = rBlock.querySelector("input[type='text']");
                    let chk = rBlock.querySelector("input[type='checkbox']");
                    txt.setAttribute("name", `questions[${i}].reponses[${j}].reponseText`);
                    chk.setAttribute("name", `questions[${i}].reponses[${j}].estVraie`);
                });
            });
        }

        function serializeQuestionsToJson() {
            const result = [];
            const qBlocks = document.querySelectorAll(".question-block");
            qBlocks.forEach(qBlock => {
                const inputsQ = qBlock.querySelectorAll("input[type='text'], input[type='number']");
                const questionText = inputsQ[0] ? inputsQ[0].value : "";
                const pointsVal = inputsQ[1] ? inputsQ[1].value : "0";
                const reponses = [];
                const rBlocks = qBlock.querySelectorAll(".reponse-block");
                rBlocks.forEach(rBlock => {
                    const txt = rBlock.querySelector("input[type='text']");
                    const chk = rBlock.querySelector("input[type='checkbox']");
                    reponses.push({
                        reponseText: txt ? txt.value : "",
                        estVraie: chk ? chk.checked : false
                    });
                });
                result.push({
                    question: questionText,
                    points: pointsVal,
                    reponses: reponses
                });
            });
            return JSON.stringify(result);
        }

        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("qcmForm");
            form.addEventListener("submit", function(e) {
                const hidden = document.getElementById("questionsJson");
                hidden.value = serializeQuestionsToJson();
            });
        });
    </script>
</head>
<body class="vertical-layout vertical-menu 2-columns fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Créer un QCM</h3>
            </div>
        </div>
        <div class="content-body">
            <section id="basic-form-layouts">
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Formulaire de QCM</h4>
                            </div>
                            <div class="card-content collpase show">
                                <div class="card-body">
                                    <form id="qcmForm" class="form form-horizontal form-bordered" action="/admin/offre/saveQcm" method="post">
                                        <div class="form-body">
                                            <div class="form-group row mx-auto">
                                                <label class="col-md-3 label-control">Nom du questionnaire :</label>
                                                <div class="col-md-9">
                                                    <input type="text" class="form-control" name="questionnaire" required />
                                                    <input type="hidden" name="idOffre" value="${id}" />
                                                    <input type="hidden" id="questionsJson" name="questionsJson" />
                                                </div>
                                            </div>

                                            <button class="btn btn-primary" type="button" onclick="ajouterQuestion()">+ Ajouter une Question</button>

                                            <div id="questions" class="mt-3"></div>
                                        </div>

                                        <div class="form-actions mt-3">
                                            <button type="submit" class="btn btn-success">
                                                <i class="ft-check"></i> Enregistrer
                                            </button>
                                            <button type="button" class="btn btn-secondary" onclick="resetForm()">
                                                <i class="ft-refresh-ccw"></i> Réinitialiser
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
