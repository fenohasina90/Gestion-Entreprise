<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Détail de l'offre</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body>
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="container mt-4">
    <h2>Détail de l'offre</h2>
    <table class="table table-bordered">
        <tr><th>Entreprise</th><td>${offre.entreprise}</td></tr>
        <tr><th>Poste</th><td>${offre.poste}</td></tr>
        <tr><th>Contrat</th><td>${offre.contrat}</td></tr>
        <tr><th>Salaire</th><td>${offre.salaire}</td></tr>
        <tr><th>Type de rôle</th><td>${offre.role}</td></tr>
        <tr><th>Date de création</th><td>${offre.dateCreation}</td></tr>
        <tr><th>Expérience</th><td>${offre.experience}</td></tr>
        <tr><th>Genre</th><td>${offre.genre}</td></tr>
        <tr><th>Âge min</th><td>${offre.ageMin}</td></tr>
        <tr><th>Âge max</th><td>${offre.ageMax}</td></tr>
        <tr><th>Type diplôme</th><td>${offre.typeDiplome}</td></tr>
        <tr><th>Lieu</th><td>${offre.lieu}</td></tr>
        <tr>
            <th>Missions</th>
            <td>
                <ul>
                    <c:forEach var="mission" items="${offre.missions}">
                        <li>${mission.mission}</li>
                    </c:forEach>
                </ul>
            </td>
        </tr>
    </table>
    <a href="/offre" class="btn btn-secondary">Retour à la liste</a>
</div>
<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
</body>
</html>
