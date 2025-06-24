<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Virtual Health Companion</title>
    
    <!-- Same dependencies as other pages -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        /* Inherited styles */
        body {
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            min-height: 100vh;
        }
        
        .dashboard-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 25px;
            transition: transform 0.3s ease;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        
        .nav-wrapper {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg nav-wrapper">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="material-icons text-primary">admin_panel_settings</i>
                Admin Dashboard
            </a>
            <button class="btn btn-danger" onclick="logout()">
                <i class="material-icons">logout</i> Logout
            </button>
        </div>
    </nav>

    <div class="container py-5">
        <div class="row">
            <!-- Users Card -->
            <div class="col-md-4">
                <div class="dashboard-card">
                    <h5><i class="material-icons text-primary">people</i> User Management</h5>
                    <div class="list-group mt-3">
                        <a href="#" class="list-group-item list-group-item-action">
                            <i class="material-icons">person_add</i> Add New User
                        </a>
                        <a href="#" class="list-group-item list-group-item-action">
                            <i class="material-icons">list_alt</i> View All Users
                        </a>
                    </div>
                </div>
            </div>

            <!-- Analytics Card -->
            <div class="col-md-4">
                <div class="dashboard-card">
                    <h5><i class="material-icons text-success">analytics</i> System Analytics</h5>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between">
                            <span>Total Users:</span>
                            <strong>1,234</strong>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span>Active Doctors:</span>
                            <strong>89</strong>
                        </div>
                    </div>
                </div>
            </div>

            <!-- System Controls -->
            <div class="col-md-4">
                <div class="dashboard-card">
                    <h5><i class="material-icons text-danger">settings</i> System Controls</h5>
                    <div class="mt-3">
                        <button class="btn btn-warning w-100 mb-2">
                            <i class="material-icons">backup</i> Backup System
                        </button>
                        <button class="btn btn-secondary w-100">
                            <i class="material-icons">history</i> Audit Logs
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function logout() {
            window.location.href = "${pageContext.request.contextPath}/logout";
        }
    </script>
</body>
</html>