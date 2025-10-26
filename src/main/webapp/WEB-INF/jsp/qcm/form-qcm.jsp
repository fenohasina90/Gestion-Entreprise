<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>Créer un QCM</title>
    <script>
        function ajouterQuestion() {
            let questionContainer = document.getElementById("questions");
            let indexQ = document.querySelectorAll(".question-block").length;

            let block = document.createElement("div");
            block.classList.add("question-block");
            block.innerHTML = `
                <hr>
                <label>Question :</label>
                <input type="text" name="questions[${indexQ}].question" required />
                <label>Points :</label>
                <input type="number" name="questions[${indexQ}].points" required />
                <button type="button" onclick="ajouterReponse(this, ${indexQ})">+ Réponse</button>
                <div class="reponses"></div>
            `;
            questionContainer.appendChild(block);
        }

        function ajouterReponse(button, indexQ) {
            let repContainer = button.parentNode.querySelector(".reponses");
            let indexR = repContainer.querySelectorAll(".reponse-block").length;

            let rep = document.createElement("div");
            rep.classList.add("reponse-block");
            rep.innerHTML = `
                <label>Réponse :</label>
                <input type="text" name="questions[${indexQ}].reponses[${indexR}].reponseText" required />
                <label>Vraie ?</label>
                <input type="checkbox" name="questions[${indexQ}].reponses[${indexR}].estVraie" value="true" />
            `;
            repContainer.appendChild(rep);
        }
    </script>
</head>
<body>
<h2>Créer un QCM</h2>
<form action="/admin/offre/saveQcm" method="post">
    <label>Questionnaire :</label>
    <input type="text" name="questionnaire" required /><br>

<%--    <label>ID Offre :</label>--%>
    <input type="hidden" value="${id}" name="idOffre" required /><br>

    <button type="button" onclick="ajouterQuestion()">+ Question</button>

    <div id="questions"></div>

    <br><button type="submit">Enregistrer</button>
</form>
</body>
</html>
