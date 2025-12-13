<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Provider Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .welcome-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
        }
        .action-card {
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
        }
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .stat-card {
            background: white;
            border-left: 4px solid;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .stat-primary { border-color: #007bff; }
        .stat-success { border-color: #28a745; }
        .stat-info { border-color: #17a2b8; }
        .stat-warning { border-color: #ffc107; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-hospital-alt text-primary me-2"></i>
                <span class="fw-bold">Provider Portal</span>
            </a>
            <div class="navbar-text">
                <span class="badge bg-primary">
                    <i class="fas fa-user-md me-1"></i>${provider.name} (ID: ${providerId})
                </span>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Welcome Card -->
        <div class="welcome-card">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-5 fw-bold">
                        <i class="fas fa-hand-wave me-3"></i>
                        Welcome, ${provider.name}!
                    </h1>
                    <p class="lead mb-0">
                        Manage your healthcare claims efficiently with our provider portal.
                        <c:if test="${provider.specialty != null}">
                            <br><small>Specialty: ${provider.specialty}</small>
                        </c:if>
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <span class="badge bg-light text-dark fs-6 p-3">
                        <i class="fas fa-shield-alt me-2"></i>
                        Network: ${provider.networkStatusBadge}
                    </span>
                </div>
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stat-card stat-primary">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-1">Total Claims</h6>
                            <h3 class="mb-0">0</h3>
                        </div>
                        <i class="fas fa-file-invoice fa-2x text-primary"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-success">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-1">Submitted</h6>
                            <h3 class="mb-0">0</h3>
                        </div>
                        <i class="fas fa-paper-plane fa-2x text-success"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-info">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-1">Processed</h6>
                            <h3 class="mb-0">0</h3>
                        </div>
                        <i class="fas fa-cogs fa-2x text-info"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-warning">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-1">Pending</h6>
                            <h3 class="mb-0">0</h3>
                        </div>
                        <i class="fas fa-clock fa-2x text-warning"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <h3 class="mb-4">
            <i class="fas fa-bolt text-warning me-2"></i>Quick Actions
        </h3>
        
        <div class="row g-4">
            <!-- Submit New Claim -->
            <div class="col-md-6 col-lg-4">
                <div class="card action-card border-primary">
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <i class="fas fa-file-medical fa-3x text-primary"></i>
                        </div>
                        <h5 class="card-title">Submit New Claim</h5>
                        <p class="card-text text-muted">Create and submit a new healthcare claim for a patient.</p>
                        <a href="/provider/submitclaim?providerId=${providerId}" 
                           class="btn btn-primary w-100">
                            <i class="fas fa-plus me-2"></i>New Claim
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- View All Claims -->
            <div class="col-md-6 col-lg-4">
                <div class="card action-card border-success">
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <i class="fas fa-list-alt fa-3x text-success"></i>
                        </div>
                        <h5 class="card-title">View All Claims</h5>
                        <p class="card-text text-muted">View and manage all your submitted claims.</p>
                        <a href="/provider/viewclaims?providerId=${providerId}" 
                           class="btn btn-success w-100">
                            <i class="fas fa-eye me-2"></i>View Claims
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Search by Patient -->
            <div class="col-md-6 col-lg-4">
                <div class="card action-card border-info">
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <i class="fas fa-search fa-3x text-info"></i>
                        </div>
                        <h5 class="card-title">Search by Patient</h5>
                        <p class="card-text text-muted">Search claims by patient ID.</p>
                        <a href="/provider/searchpatient?providerId=${providerId}" 
                           class="btn btn-info w-100">
                            <i class="fas fa-search me-2"></i>Search
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity (Placeholder) -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-history me-2"></i>Recent Activity
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <p class="text-muted">No recent activity to display</p>
                            <p class="small text-muted">Your claims and activities will appear here.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="mt-5 pt-4 border-top">
            <div class="row">
                <div class="col-md-6">
                    <h6 class="text-muted">
                        <i class="fas fa-info-circle me-2"></i>Provider Information
                    </h6>
                    <ul class="list-unstyled">
                        <li><strong>Provider ID:</strong> ${providerId}</li>
                        <li><strong>Name:</strong> ${provider.name}</li>
                        <c:if test="${provider.specialty != null}">
                            <li><strong>Specialty:</strong> ${provider.specialty}</li>
                        </c:if>
                        <c:if test="${provider.npi != null}">
                            <li><strong>NPI:</strong> ${provider.npi}</li>
                        </c:if>
                        <li><strong>Network Status:</strong> 
                            <span class="badge ${provider.networkStatus == 'IN' ? 'bg-success' : 'bg-warning'}">
                                ${provider.networkStatusBadge}
                            </span>
                        </li>
                    </ul>
                </div>
                <div class="col-md-6 text-end">
                    <p class="text-muted">
                        <i class="fas fa-shield-alt me-1"></i> Secure Provider Portal
                        <br>
                        <small>Last login: Today at <span id="currentTime"></span></small>
                    </p>
                    <a href="/auth/login" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-sign-out-alt me-1"></i>Logout
                    </a>
                </div>
            </div>
        </footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Update current time
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
            document.getElementById('currentTime').textContent = timeString;
        }
        updateTime();
        setInterval(updateTime, 60000);
    </script>
</body>
</html>