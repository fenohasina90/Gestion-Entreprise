



<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="loading" lang="en" data-textdirection="ltr">
<head>
    <title>CV Postule</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimal-ui">
    <meta name="description" content="Modern admin is super flexible, powerful, clean &amp; modern responsive bootstrap 4 admin template with unlimited possibilities with bitcoin dashboard.">
    <meta name="keywords" content="admin template, modern admin template, dashboard template, flat admin template, responsive admin template, web app, crypto dashboard, bitcoin dashboard">
    <meta name="author" content="PIXINVENT">

    <link rel="apple-touch-icon" href="/app-assets/images/ico/apple-icon-120.png">
    <link rel="shortcut icon" type="image/x-icon" href="app-assets/images/ico/favicon.ico">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i%7CQuicksand:300,400,500,700" rel="stylesheet">

    <!-- BEGIN: Vendor CSS-->
    <link rel="stylesheet" type="text/css" href="/app-assets/vendors/css/vendors.min.css">
    <link rel="stylesheet" type="text/css" href="/app-assets/vendors/css/tables/datatable/datatables.min.css">
    <!-- END: Vendor CSS-->

    <!-- BEGIN: Theme CSS-->
    <link rel="stylesheet" type="text/css" href="/app-assets/css/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="/app-assets/css/bootstrap-extended.css">
    <link rel="stylesheet" type="text/css" href="/app-assets/css/colors.css">
    <link rel="stylesheet" type="text/css" href="/app-assets/css/components.css">
    <!-- END: Theme CSS-->

    <!-- BEGIN: Page CSS-->
    <link rel="stylesheet" type="text/css" href="/app-assets/css/core/menu/menu-types/vertical-menu.css">
    <link rel="stylesheet" type="text/css" href="/app-assets/css/core/colors/palette-gradient.css">
    <link rel="stylesheet" type="text/css" href="/app-assets/css/core/colors/palette-tooltip.css">
    <!-- END: Page CSS-->


    <link rel="stylesheet" type="text/css" href="/app-assets/css/plugins/forms/wizard.css">
    <link rel="stylesheet" type="text/css" href="/app-assets/css/plugins/pickers/daterange/daterange.css">
    <link rel="stylesheet" type="text/css" href="/app-assets/vendors/css/pickers/daterange/daterangepicker.css">

    <!-- BEGIN: Custom CSS-->
    <link rel="stylesheet" type="text/css" href="/assets/css/style.css">
    <!-- END: Custom CSS-->
</head>
<body class="vertical-layout vertical-menu 2-columns   fixed-navbar" data-open="click" data-menu="vertical-menu" data-col="2-columns">
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

                        <li class="dropdown dropdown-user nav-item"><a class="dropdown-toggle nav-link dropdown-user-link" href="#" data-toggle="dropdown"><span class="mr-1 user-name text-bold-700">John Doe</span><span class="avatar avatar-online"><img src="/app-assets/images/portrait/small/avatar-s-19.png" alt="avatar"><i></i></span></a>
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

                <!-- Offres -->
                <li class="nav-item">
                    <a href="index.html">
                        <i class="la la-briefcase"></i>
                        <span class="menu-title" data-i18n="Dashboard">OFFRES</span>
                    </a>
                    <ul class="menu-content">
                        <li>
                            <a class="menu-item" href="/offre">
                                <i class="la la-list"></i>
                                <span data-i18n="eCommerce">Liste des offres</span>
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- CV -->
                <li class="nav-item">
                    <a href="index.html">
                        <i class="la la-credit-card"></i>
                        <span class="menu-title" data-i18n="Dashboard">CV</span>
                    </a>
                    <ul class="menu-content">
                        <li>
                            <a class="menu-item" href="/cv/${sessionScope.idUser}">
                                <i class="la la-file-text"></i>
                                <span data-i18n="eCommerce">Liste CV postulé</span>
                            </a>
                        </li>
                    </ul>
                </li>

            </ul>
        </div>
    </div>

    <div class="app-content content">
    <div class="content-overlay"></div>
    <div class="content-wrapper">
        <div class="content-header row">
            <div class="content-header-left col-md-6 col-12 mb-2">
                <h3 class="content-header-title">CV Postulée</h3>
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

            <!-- card actions section start -->
            <section id="card-actions">
                <div class="row">
                    <c:forEach items="${liste}" var="offre" varStatus="status">
                        <div class="col-md-4 col-sm-12">
                            <div class="card">
                                <div class="card-header">
                                    <h4 class="card-title">${offre.poste}</h4>
                                    <br>
                                    <p>Entreprise : ${offre.entreprise}</p>
                                    <p>Unite : ${offre.roleRequis}</p>
                                    <p>Contrat : ${offre.contact}</p>
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

                                        <c:choose>
                                            <c:when test="${offre.estEntretien == false && offre.statut == true}">
                                                <a href="/qcm/reponse/${offre.id}">
                                                    <button class="btn btn-success">Passer entretien</button>
                                                </a>
                                            </c:when>
                                            <c:when test="${offre.estEntretien == true && offre.statut == true}">
                                                <p class="badge badge-success">CV validé et déjà fait le QCM</p>
                                            </c:when>

                                            <c:otherwise>
                                                <p class="badge badge-danger">CV refusé</p>
                                            </c:otherwise>
                                        </c:choose>
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

    <script src="/app-assets/vendors/js/vendors.min.js"></script>

    <!-- BEGIN Vendor JS-->

    <!-- BEGIN: Page Vendor JS-->
    <script src="/app-assets/vendors/js/tables/datatable/datatables.min.js"></script>
    <!-- END: Page Vendor JS-->

    <!-- BEGIN: Theme JS-->
    <script src="/app-assets/js/core/app-menu.js"></script>
    <script src="/app-assets/js/core/app.js"></script>
    <!-- END: Theme JS-->

    <!-- BEGIN: Page JS-->
    <script src="/app-assets/js/scripts/tables/datatables/datatable-styling.js"></script>


    <script src="/app-assets/vendors/js/extensions/jquery.steps.min.js"></script>
    <script src="/app-assets/vendors/js/pickers/dateTime/moment-with-locales.min.js"></script>
    <script src="/app-assets/vendors/js/pickers/daterange/daterangepicker.js"></script>
    <script src="/app-assets/vendors/js/forms/validation/jquery.validate.min.js"></script>
    <script src="/app-assets/js/scripts/forms/wizard-steps.js"></script>

    <script src="/app-assets/js/scripts/tooltip/tooltip.js"></script>
</body>
</html>
