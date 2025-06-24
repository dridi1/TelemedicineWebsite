<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Erreur de Connexion</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
            height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .error-card {
            max-width: 400px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            border: none;
            border-radius: 10px;
        }
        .error-card .card-header {
            background-color: #dc3545;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .error-card .card-header h4 {
            margin: 0;
            color: #fff;
        }
        .error-icon {
            font-size: 80px;
            margin-bottom: 20px;
            color: #dc3545;
        }
        .btn-return {
            border-radius: 50px;
            padding: 10px 30px;
        }
    </style>
</head>
<body>
    <div class="card error-card">
        <div class="card-header text-center">
            <h4>Erreur de Connexion</h4>
        </div>
        <div class="card-body text-center">
            <div class="error-icon">&#128577;</div> <!-- Emoji visage triste -->
            <h5 class="card-title">Oups ! La connexion a échoué.</h5>
            <p class="card-text">
                Vos identifiants sont incorrects ou il y a un problème technique. Veuillez réessayer.
            </p>
            <a href="auth/login.jsp" class="btn btn-danger btn-return">Retour à la connexion</a>
        </div>
    </div>
    
    <!-- Bootstrap JS Bundle (inclut Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
