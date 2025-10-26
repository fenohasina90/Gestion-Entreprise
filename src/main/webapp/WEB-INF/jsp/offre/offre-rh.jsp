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

            <!-- Section: Filtres RH -->
            <section id="offre-rh-filtres" class="mb-2">
                <div class="card border-primary">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="ft-filter"></i> Filtres
                            <button class="btn btn-sm btn-outline-light float-right" type="button" id="toggleRhFilters">
                                <i class="ft-chevron-up"></i>
                            </button>
                        </h5>
                    </div>
                    <div class="card-body" id="rhFiltersSection" data-pre-entreprise="${f_entreprise}" data-pre-unite="${f_unite}" data-pre-contrat="${f_contrat}" data-pre-poste="${f_poste}">
                        <form id="rhFilterForm">
                            <div class="row">
                                <div class="col-md-3 col-sm-6 mb-1">
                                    <label for="rhFilterEntreprise" class="form-label">Type entreprise</label>
                                    <select id="rhFilterEntreprise" class="form-control">
                                        <option value="">Toutes</option>
                                    </select>
                                </div>
                                <div class="col-md-3 col-sm-6 mb-1">
                                    <label for="rhFilterUnite" class="form-label">Unité</label>
                                    <select id="rhFilterUnite" class="form-control">
                                        <option value="">Toutes</option>
                                    </select>
                                </div>
                                <div class="col-md-3 col-sm-6 mb-1">
                                    <label for="rhFilterContrat" class="form-label">Type de contrat</label>
                                    <select id="rhFilterContrat" class="form-control">
                                        <option value="">Tous</option>
                                    </select>
                                </div>
                                <div class="col-md-3 col-sm-6 mb-1">
                                    <label for="rhFilterPoste" class="form-label">Poste</label>
                                    <input id="rhFilterPoste" class="form-control" type="text" placeholder="Rechercher un poste..." />
                                </div>
                            </div>
                            <div class="d-flex align-items-center mt-1">
                                <button type="button" class="btn btn-primary mr-1" id="applyRhFilters"><i class="ft-search"></i> Appliquer</button>
                                <button type="button" class="btn btn-secondary" id="clearRhFilters"><i class="ft-x"></i> Effacer</button>
                                <div class="ml-auto text-muted">
                                    <span id="rhResultCount">0</span> offre(s)
                                </div>
                            </div>
                        </form>
                        <div id="noRhResults" class="alert alert-info mt-1" style="display:none;">Aucune offre ne correspond aux filtres.</div>
                    </div>
                </div>
            </section>

            <!-- card actions section start -->
            <section id="card-actions">
                <div class="row">
                    <c:forEach items="${liste}" var="offre" varStatus="status">
                        <div class="col-md-4 col-sm-12">
                            <div class="card rh-offer-card" data-entreprise="${offre.entreprise}" data-unite="${offre.roleRequis}" data-contrat="${offre.contrat}" data-poste="${offre.poste}">
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
                                            <a href="/admin/offre/rh/validation/${offre.id}">
                                                <button class="btn btn-success">Valider</button>
                                            </a>
                                            <a href="/admin/offre/critere/add/${offre.id}">
                                                <button class="btn btn-primary">Ajouter Critere</button>
                                            </a>
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

<script>
    $(function(){
        var $cards = $('.rh-offer-card');

        function uniq(values){
            return Array.from(new Set(values.filter(function(v){return v && v.trim()!=='';}))).sort(function(a,b){return a.localeCompare(b);});
        }

        function populate($select, attr){
            var vals = [];
            $cards.each(function(){
                var v = ($(this).attr(attr) || '').trim();
                if (v) vals.push(v);
            });
            $select.find('option:not(:first)').remove();
            uniq(vals).forEach(function(v){ $select.append($('<option>',{value:v,text:v})); });
        }

        populate($('#rhFilterEntreprise'), 'data-entreprise');
        populate($('#rhFilterUnite'), 'data-unite');
        populate($('#rhFilterContrat'), 'data-contrat');

        // Pré-remplissage depuis serveur via data-attributes
        var $rhFS = $('#rhFiltersSection');
        var preEnt = ($rhFS.data('pre-entreprise') || '').toString();
        var preUni = ($rhFS.data('pre-unite') || '').toString();
        var preCon = ($rhFS.data('pre-contrat') || '').toString();
        var prePos = ($rhFS.data('pre-poste') || '').toString();
        if (preEnt) { $('#rhFilterEntreprise').val(preEnt); }
        if (preUni) { $('#rhFilterUnite').val(preUni); }
        if (preCon) { $('#rhFilterContrat').val(preCon); }
        if (prePos) { $('#rhFilterPoste').val(prePos); }

        function applyRhFilters(){
            var ent = ($('#rhFilterEntreprise').val()||'').toLowerCase();
            var uni = ($('#rhFilterUnite').val()||'').toLowerCase();
            var con = ($('#rhFilterContrat').val()||'').toLowerCase();
            var pos = ($('#rhFilterPoste').val()||'').toLowerCase().trim();

            var count = 0;
            $cards.each(function(){
                var $c = $(this);
                var vEnt = ($c.attr('data-entreprise')||'').toLowerCase();
                var vUni = ($c.attr('data-unite')||'').toLowerCase();
                var vCon = ($c.attr('data-contrat')||'').toLowerCase();
                var vPos = ($c.attr('data-poste')||'').toLowerCase();

                var ok = true;
                if (ent && vEnt !== ent) ok = false;
                if (uni && vUni !== uni) ok = false;
                if (con && vCon !== con) ok = false;
                if (pos && vPos.indexOf(pos) === -1) ok = false;

                if (ok){
                    count++;
                    if(!$c.is(':visible')) $c.stop(true,true).fadeIn(120);
                } else {
                    if($c.is(':visible')) $c.stop(true,true).fadeOut(120);
                }
            });

            $('#rhResultCount').text(count);
            if (count===0) $('#noRhResults').slideDown(120); else $('#noRhResults').slideUp(120);
        }

        $('#rhFilterEntreprise, #rhFilterUnite, #rhFilterContrat').on('change', applyRhFilters);
        $('#rhFilterPoste').on('keyup change', function(){
            clearTimeout($(this).data('timer'));
            var $i=$(this);
            var t=setTimeout(applyRhFilters, 180);
            $i.data('timer', t);
        });
        // Bouton Appliquer: rediriger vers serveur
        $('#applyRhFilters').on('click', function(){
            var params = [];
            var ent = $('#rhFilterEntreprise').val();
            var uni = $('#rhFilterUnite').val();
            var con = $('#rhFilterContrat').val();
            var pos = $('#rhFilterPoste').val();
            if (ent) params.push('entreprise=' + encodeURIComponent(ent));
            if (uni) params.push('unite=' + encodeURIComponent(uni));
            if (con) params.push('contrat=' + encodeURIComponent(con));
            if (pos) params.push('poste=' + encodeURIComponent(pos));
            var qs = params.length ? ('?' + params.join('&')) : '';
            window.location = '/admin/offre/rh' + qs;
        });
        // Bouton Effacer: reset côté serveur
        $('#clearRhFilters').on('click', function(){
            window.location = '/admin/offre/rh';
        });

        $('#toggleRhFilters').on('click', function(){
            var $s = $('#rhFiltersSection');
            var $ic = $(this).find('i');
            if ($s.is(':visible')){ $s.slideUp(120); $ic.removeClass('ft-chevron-up').addClass('ft-chevron-down'); }
            else { $s.slideDown(120); $ic.removeClass('ft-chevron-down').addClass('ft-chevron-up'); }
        });

        // Initial draw
        applyRhFilters();
    });
</script>

</body>
</html>