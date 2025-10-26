<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html class="loading" lang="fr" data-textdirection="ltr">
<head>
    <title>Dashboard</title>
    <%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body class="vertical-layout vertical-menu 2-columns fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
<%@ include file="/WEB-INF/jsp/include/sidebar.jsp"%>
<div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">Tableau de bord</h3>
            </div>
        </div>
        <div class="content-body">
            <section id="stats-cards">
                <div class="row">
                    <div class="col-xl-3 col-lg-6 col-12">
                        <div class="card">
                            <div class="card-content">
                                <div class="card-body">
                                    <h5 class="text-muted">Offres totales</h5>
                                    <h2 class="text-bold-700">${kpis.offresTotal}</h2>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-6 col-12">
                        <div class="card">
                            <div class="card-content">
                                <div class="card-body">
                                    <h5 class="text-muted">Offres validées RH</h5>
                                    <h2 class="text-bold-700 text-success">${kpis.offresValidees}</h2>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-6 col-12">
                        <div class="card">
                            <div class="card-content">
                                <div class="card-body">
                                    <h5 class="text-muted">Offres non validées RH</h5>
                                    <h2 class="text-bold-700 text-warning">${kpis.offresNonValidees}</h2>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-6 col-12">
                        <div class="card">
                            <div class="card-content">
                                <div class="card-body">
                                    <h5 class="text-muted">CV Totaux</h5>
                                    <h2 class="text-bold-700">${kpis.cvsTotal}</h2>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-6 col-12">
                        <div class="card">
                            <div class="card-content">
                                <div class="card-body">
                                    <h5 class="text-muted">CV Validés</h5>
                                    <h2 class="text-bold-700 text-success">${kpis.cvsValides}</h2>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-6 col-12">
                        <div class="card">
                            <div class="card-content">
                                <div class="card-body">
                                    <h5 class="text-muted">CV Refusés</h5>
                                    <h2 class="text-bold-700 text-danger">${kpis.cvsRefuses}</h2>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-6 col-12">
                        <div class="card">
                            <div class="card-content">
                                <div class="card-body">
                                    <h5 class="text-muted">Employés</h5>
                                    <h2 class="text-bold-700">${kpis.employesTotal}</h2>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section id="charts" class="mt-2">
                <div class="row">
                    <div class="col-xl-6 col-lg-12">
                        <div class="card">
                            <div class="card-header"><h4 class="card-title">Employés par rôle</h4></div>
                            <div class="card-content"><div class="card-body"><canvas id="rolesChart" height="160"></canvas></div></div>
                        </div>
                    </div>
                    <div class="col-xl-6 col-lg-12">
                        <div class="card">
                            <div class="card-header"><h4 class="card-title">Embauches par mois</h4></div>
                            <div class="card-content"><div class="card-body"><canvas id="hiresChart" height="160"></canvas></div></div>
                        </div>
                    </div>
                </div>
                <!-- Data holder to avoid embedding JSTL in JS -->
                <div id="chartData" style="display:none"
                     data-role-labels="<c:forEach var='l' items='${roleLabels}' varStatus='s'>${fn:escapeXml(l)}<c:if test='${!s.last}'>|</c:if></c:forEach>"
                     data-role-counts="<c:forEach var='n' items='${roleCounts}' varStatus='s'>${n}<c:if test='${!s.last}'>,</c:if></c:forEach>"
                     data-month-labels="<c:forEach var='m' items='${monthLabels}' varStatus='s'>${fn:escapeXml(m)}<c:if test='${!s.last}'>|</c:if></c:forEach>"
                     data-month-counts="<c:forEach var='n' items='${monthCounts}' varStatus='s'>${n}<c:if test='${!s.last}'>,</c:if></c:forEach>">
                </div>
            </section>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<script>
    (function(){
        // Read datasets from hidden data holder (avoids JSTL inside JS)
        var holder = document.getElementById('chartData');
        var roleLabels = (holder?.dataset.roleLabels || '').split('|').filter(function(x){return x.length>0});
        var roleCounts = (holder?.dataset.roleCounts || '').split(',').map(function(x){var n=parseInt(x,10);return isNaN(n)?0:n});
        var monthLabels = (holder?.dataset.monthLabels || '').split('|').filter(function(x){return x.length>0});
        var monthCounts = (holder?.dataset.monthCounts || '').split(',').map(function(x){var n=parseInt(x,10);return isNaN(n)?0:n});

        // Roles doughnut
        var rc = document.getElementById('rolesChart');
        if (rc){
            new Chart(rc.getContext('2d'), {
                type: 'doughnut',
                data: {
                    labels: roleLabels,
                    datasets: [{
                        data: roleCounts,
                        backgroundColor: ['#36A2EB','#4BC0C0','#FF6384','#FF9F40','#9966FF','#FFCD56','#2ecc71','#e74c3c']
                    }]
                },
                options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
            });
        }

        // Monthly hires line
        var hc = document.getElementById('hiresChart');
        if (hc){
            new Chart(hc.getContext('2d'), {
                type: 'line',
                data: {
                    labels: monthLabels,
                    datasets: [{
                        label: 'Embauches',
                        data: monthCounts,
                        borderColor: '#36A2EB',
                        backgroundColor: 'rgba(54,162,235,0.2)',
                        tension: 0.25,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: { beginAtZero: true, ticks: { precision: 0 } }
                    }
                }
            });
        }
    })();
</script>
</body>
</html>
