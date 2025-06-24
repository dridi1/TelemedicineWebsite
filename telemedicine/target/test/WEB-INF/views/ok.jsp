<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Telemedicine Dashboard</title>
    <!-- Lien vers le CSS de Bootstrap 5 -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<%
    // Exemple : récupération d'informations en session (ou request)
    // Vous pouvez y mettre vos vraies données issues de la base
    String doctorName = "Dr. John Smith";
    // Statistiques fictives pour la démonstration
    int dailyAppointments = 42;
    int totalPatients = 124;
    double satisfactionRate = 97.8; // en pourcentage
    double avgConsultTime = 15.2; // en minutes
%>

<!-- Barre de navigation Bootstrap -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Telemedicine</a>
        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent"
                aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <!-- Exemple de liens -->
                <li class="nav-item">
                    <a class="nav-link active" href="#">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Patients</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Consultations</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Déconnexion</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Contenu principal -->
<div class="container my-4">

    <!-- Titre ou message de bienvenue -->
    <h1 class="mb-4">Bienvenue sur le Dashboard Télémédecine</h1>
    <p class="lead">Bonjour, <%= doctorName %> ! Voici les statistiques du jour.</p>
    
    <!-- Exemple de "cards" Bootstrap pour présenter des stats -->
    <div class="row">
        <!-- Card 1 : Nombre de consultations du jour -->
        <div class="col-md-3">
            <div class="card text-center mb-4">
                <div class="card-body">
                    <h5 class="card-title">Consultations du jour</h5>
                    <p class="card-text fs-4"><%= dailyAppointments %></p>
                </div>
            </div>
        </div>
        <!-- Card 2 : Nombre total de patients -->
        <div class="col-md-3">
            <div class="card text-center mb-4">
                <div class="card-body">
                    <h5 class="card-title">Patients actifs</h5>
                    <p class="card-text fs-4"><%= totalPatients %></p>
                </div>
            </div>
        </div>
        <!-- Card 3 : Taux de satisfaction -->
        <div class="col-md-3">
            <div class="card text-center mb-4">
                <div class="card-body">
                    <h5 class="card-title">Satisfaction</h5>
                    <p class="card-text fs-4"><%= satisfactionRate %> %</p>
                </div>
            </div>
        </div>
        <!-- Card 4 : Temps moyen de consultation -->
        <div class="col-md-3">
            <div class="card text-center mb-4">
                <div class="card-body">
                    <h5 class="card-title">Durée moyenne</h5>
                    <p class="card-text fs-4"><%= avgConsultTime %> min</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Exemple de zone pour insérer un graphique (ex: Chart.js) -->
    <div class="row">
        <div class="col-md-12">
            <div class="card mb-4">
                <div class="card-header">
                    Évolution mensuelle des consultations
                </div>
                <div class="card-body">
                    <!-- Ici, vous pouvez intégrer un <canvas> pour un graphique Chart.js -->
                    <canvas id="myChart" width="400" height="150"></canvas>
                </div>
            </div>
        </div>
    </div>

</div> <!-- /container -->

<!-- Scripts Bootstrap + dépendances (Popper, etc.) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Exemple d'utilisation de Chart.js (optionnel) -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Exemple de configuration d'un chart si vous souhaitez l'ajouter
    const ctx = document.getElementById('myChart').getContext('2d');
    const myChart = new Chart(ctx, {
        type: 'line', // bar, line, pie, etc.
        data: {
            labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil'],
            datasets: [{
                label: 'Consultations',
                data: [20, 35, 40, 25, 60, 75, 90], // exemple de données fictives
                borderColor: 'rgba(54, 162, 235, 0.7)',
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                fill: true
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'top',
                }
            },
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
</script>

</body>
</html>
