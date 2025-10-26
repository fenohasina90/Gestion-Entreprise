<%--<%@ page contentType="text/html; charset=UTF-8" %>--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- BEGIN: Header-->
<nav class="header-navbar navbar-expand-md navbar navbar-with-menu navbar-without-dd-arrow fixed-top navbar-semi-light bg-info navbar-shadow">
    <div class="navbar-wrapper">
        <div class="navbar-header">
            <ul class="nav navbar-nav flex-row">
                <li class="nav-item mobile-menu d-md-none mr-auto"><a class="nav-link nav-menu-main menu-toggle hidden-xs" href="#"><i class="ft-menu font-large-1"></i></a></li>
                <li class="nav-item"><a class="navbar-brand" href="index.html"><img class="brand-logo" alt="modern admin logo" src="/app-assets/images/logo/logo.png">
                    <h3 class="brand-text">Modern</h3>
                </a></li>
                <li class="nav-item d-md-none"><a class="nav-link open-navbar-container" data-toggle="collapse" data-target="#navbar-mobile"><i class="la la-ellipsis-v"></i></a></li>
            </ul>
        </div>
        <div class="navbar-container content">
            <div class="collapse navbar-collapse" id="navbar-mobile">
                <ul class="nav navbar-nav mr-auto float-left">
                    <li class="nav-item d-none d-md-block"><a class="nav-link nav-menu-main menu-toggle hidden-xs" href="#"><i class="ft-menu"></i></a></li>
                    <li class="nav-item d-none d-lg-block"><a class="nav-link nav-link-expand" href="#"><i class="ficon ft-maximize"></i></a></li>
                </ul>
                <ul class="nav navbar-nav float-right">

                    <li class="dropdown dropdown-notification nav-item"><a class="nav-link nav-link-label" href="#" data-toggle="dropdown"><i class="ficon ft-bell"></i><span class="badge badge-pill badge-danger badge-up badge-glow">5</span></a>
                        <ul class="dropdown-menu dropdown-menu-media dropdown-menu-right">
                            <li class="dropdown-menu-header">
                                <h6 class="dropdown-header m-0"><span class="grey darken-2">Notifications</span></h6><span class="notification-tag badge badge-danger float-right m-0">5 New</span>
                            </li>
                            <li class="scrollable-container media-list w-100"><a href="javascript:void(0)">
                                <div class="media">
                                    <div class="media-left align-self-center"><i class="ft-plus-square icon-bg-circle bg-cyan mr-0"></i></div>
                                    <div class="media-body">
                                        <h6 class="media-heading">You have new order!</h6>
                                        <p class="notification-text font-small-3 text-muted">Lorem ipsum dolor sit amet, consectetuer elit.</p><small>
                                        <time class="media-meta text-muted" datetime="2015-06-11T18:29:20+08:00">30 minutes ago</time></small>
                                    </div>
                                </div>
                            </a><a href="javascript:void(0)">
                                <div class="media">
                                    <div class="media-left align-self-center"><i class="ft-download-cloud icon-bg-circle bg-red bg-darken-1 mr-0"></i></div>
                                    <div class="media-body">
                                        <h6 class="media-heading red darken-1">99% Server load</h6>
                                        <p class="notification-text font-small-3 text-muted">Aliquam tincidunt mauris eu risus.</p><small>
                                        <time class="media-meta text-muted" datetime="2015-06-11T18:29:20+08:00">Five hour ago</time></small>
                                    </div>
                                </div>
                            </a><a href="javascript:void(0)">
                                <div class="media">
                                    <div class="media-left align-self-center"><i class="ft-alert-triangle icon-bg-circle bg-yellow bg-darken-3 mr-0"></i></div>
                                    <div class="media-body">
                                        <h6 class="media-heading yellow darken-3">Warning notifixation</h6>
                                        <p class="notification-text font-small-3 text-muted">Vestibulum auctor dapibus neque.</p><small>
                                        <time class="media-meta text-muted" datetime="2015-06-11T18:29:20+08:00">Today</time></small>
                                    </div>
                                </div>
                            </a><a href="javascript:void(0)">
                                <div class="media">
                                    <div class="media-left align-self-center"><i class="ft-check-circle icon-bg-circle bg-cyan mr-0"></i></div>
                                    <div class="media-body">
                                        <h6 class="media-heading">Complete the task</h6><small>
                                        <time class="media-meta text-muted" datetime="2015-06-11T18:29:20+08:00">Last week</time></small>
                                    </div>
                                </div>
                            </a><a href="javascript:void(0)">
                                <div class="media">
                                    <div class="media-left align-self-center"><i class="ft-file icon-bg-circle bg-teal mr-0"></i></div>
                                    <div class="media-body">
                                        <h6 class="media-heading">Generate monthly report</h6><small>
                                        <time class="media-meta text-muted" datetime="2015-06-11T18:29:20+08:00">Last month</time></small>
                                    </div>
                                </div>
                            </a></li>
                            <li class="dropdown-menu-footer"><a class="dropdown-item text-muted text-center" href="javascript:void(0)">Read all notifications</a></li>
                        </ul>
                    </li>

                    <li class="dropdown dropdown-user nav-item"><a class="dropdown-toggle nav-link dropdown-user-link" href="#" data-toggle="dropdown"><span class="mr-1 user-name text-bold-700">
                        <c:if test="${not empty sessionScope.connecte}">
                            <p>Vous êtes connecté avec le rôle : ${sessionScope.connecte}</p>
                        </c:if>
                    </span><span class="avatar avatar-online"><img src="/app-assets/images/portrait/small/avatar-s-19.png" alt="avatar"><i></i></span></a>
                        <div class="dropdown-menu dropdown-menu-right"><a class="dropdown-item" href="/update"><i class="ft-user"></i> Edit Profile</a><a class="dropdown-item" href="app-kanban.html"><i class="ft-clipboard"></i> Todo</a><a class="dropdown-item" href="user-cards.html"><i class="ft-check-square"></i> Task</a>
                            <div class="dropdown-divider"></div><a class="dropdown-item" href="/logout"><i class="ft-power"></i> Logout</a>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>
<!-- END: Header-->


<!-- BEGIN: Main Menu-->

<div class="main-menu menu-fixed menu-light menu-accordion menu-shadow" data-scroll-to-active="true">
    <div class="main-menu-content">
        <ul class="navigation navigation-main" id="main-menu-navigation" data-menu="menu-navigation">
            <!-- Tableau de bord (app) -->

            <!-- Dashboard -->
            <c:if test="${not empty sessionScope.connecte}">
                <c:if test="${sessionScope.connecte == 'RH'}">
                    <li class="nav-item">
                        <a class="menu-item" href="/dashboard">
                            <i class="la la-dashboard"></i>
                            <span>TABLEAU DE BORD</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="menu-item" href="/entreprise/employes">
                            <i class="la la-users"></i>
                            <span>EMPLOYE</span>
                        </a>
                    </li>
                    <!-- Valider Offre -->
                    <li class="nav-item">
                        <a href="index.html">
                            <i class="la la-check-circle"></i>
                            <span class="menu-title" data-i18n="Dashboard">VALIDER OFFRE</span>
                        </a>
                        <ul class="menu-content">
                            <li>
                                <a class="menu-item" href="/admin/offre/rh">
                                    <i class="la la-list-alt"></i>
                                    <span data-i18n="eCommerce">Liste Offre</span>
                                </a>
                            </li>
                        </ul>
                    </li>

                    <!-- QCM -->
                    <li class="nav-item">
                        <a href="index.html">
                            <i class="la la-question-circle"></i>
                            <span class="menu-title" data-i18n="Dashboard">QCM</span>
                        </a>
                        <ul class="menu-content">
                            <li>
                                <a class="menu-item" href="/qcm/resultats">
                                    <i class="la la-file-text"></i>
                                    <span data-i18n="eCommerce">Liste Resultat</span>
                                </a>
                            </li>
                        </ul>
                    </li>

                    <!-- Entretien -->
                    <li class="nav-item">
                        <a href="index.html">
                            <i class="la la-calendar"></i>
                            <span class="menu-title" data-i18n="Dashboard">ENTRETIEN</span>
                        </a>
                        <ul class="menu-content">
                            <li>
                                <a class="menu-item" href="/qcm/entretiens">
                                    <i class="la la-calendar-check-o"></i>
                                    <span data-i18n="eCommerce">Planing entretien</span>
                                </a>
                            </li>
                        </ul>
                    </li>

                </c:if>
            </c:if>

            <!-- Offre -->
            <li class="nav-item">
                <a href="index.html">
                    <i class="la la-briefcase"></i>
                    <span class="menu-title" data-i18n="Dashboard">OFFRE</span>
                </a>
                <ul class="menu-content">
                    <li>
                        <a class="menu-item" href="/admin/offre/${sessionScope.idConnecte}">
                            <i class="la la-list"></i>
                            <span data-i18n="eCommerce">Liste</span>
                        </a>
                    </li>
                    <li>
                        <a class="menu-item" href="/admin/offre/add">
                            <i class="la la-plus-circle"></i>
                            <span data-i18n="Crypto">Nouveau</span>
                        </a>
                    </li>
                </ul>
            </li>

            <!-- Condition RH -->

        </ul>
    </div>
</div>
