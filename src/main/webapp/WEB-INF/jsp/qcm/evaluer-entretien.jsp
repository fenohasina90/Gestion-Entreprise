<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="loading" lang="fr" data-textdirection="ltr">
<head>
    <title>Évaluer un Entretien</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Évaluer un Entretien</h3>
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
            <section id="evaluer-entretien">
                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Évaluation de l'Entretien</h4>
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
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger">
                                            <h4 class="alert-heading">Erreur</h4>
                                            <p>${error}</p>
                                        </div>
                                    </c:if>

                                    <form class="form form-horizontal form-bordered" action="/qcm/entretien/evaluer/${idEntretien}" method="post">
                                        <div class="form-body">
                                            <h4 class="form-section"><i class="ft-star"></i> Note de l'Entretien</h4>
                                            
                                            <div class="form-group row">
                                                <label class="col-md-3 label-control" for="note">Note sur 20</label>
                                                <div class="col-md-9">
                                                    <input type="number" class="form-control" id="note" name="note" 
                                                           min="0" max="20" required>
                                                    <small class="text-muted">Notez l'entretien sur une échelle de 0 à 20</small>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-md-3 label-control" for="commentaire">Commentaire</label>
                                                <div class="col-md-9">
                                                    <textarea class="form-control" id="commentaire" name="commentaire" 
                                                              rows="4" placeholder="Ajoutez vos commentaires sur l'entretien..."></textarea>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-md-3 label-control">Informations</label>
                                                <div class="col-md-9">
                                                    <div class="alert alert-info">
                                                        <h6><i class="ft-info"></i> Note importante</h6>
                                                        <p>Les candidats ayant obtenu une note supérieure ou égale à 12/20 pourront bénéficier d'un contrat d'essai.</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-actions">
                                            <a href="/qcm/entretiens" class="btn btn-warning mr-1">
                                                <i class="ft-x"></i> Annuler
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="ft-star"></i> Évaluer l'Entretien
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">Critères d'Évaluation</h4>
                            </div>
                            <div class="card-content collpase show">
                                <div class="card-body">
                                    <h6>Échelle de notation</h6>
                                    <ul>
                                        <li><strong>16-20 :</strong> Excellent</li>
                                        <li><strong>12-15 :</strong> Bien</li>
                                        <li><strong>8-11 :</strong> Moyen</li>
                                        <li><strong>4-7 :</strong> Insuffisant</li>
                                        <li><strong>0-3 :</strong> Très insuffisant</li>
                                    </ul>
                                    
                                    <h6 class="mt-2">Critères à évaluer</h6>
                                    <ul>
                                        <li>Compétences techniques</li>
                                        <li>Expérience professionnelle</li>
                                        <li>Motivation</li>
                                        <li>Communication</li>
                                        <li>Adaptabilité</li>
                                    </ul>
                                    
                                    <h6 class="mt-2">Prochaines étapes</h6>
                                    <p>Après l'évaluation, si la note est ≥ 12, vous pourrez créer un contrat d'essai pour le candidat.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // Validation côté client
        $('#note').on('input', function() {
            var note = parseInt($(this).val());
            if (note < 0) $(this).val(0);
            if (note > 20) $(this).val(20);
        });
    });
</script>

<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
</body>
</html>
