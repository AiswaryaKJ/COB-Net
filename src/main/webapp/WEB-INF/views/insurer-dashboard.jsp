<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insurer Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI'; }
        .dashboard-container { max-width: 1200px; margin: 30px auto; padding: 20px; }
        .card { border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .stat-card { background: white; padding: 25px; text-align: center; margin-bottom: 20px; }
        .primary-card { border-left: 5px solid #007bff; }
        .secondary-card { border-left: 5px solid #28a745; }
        .nav-custom { background: linear-gradient(135deg, #2c3e50, #3498db); }
        .welcome-card { background: linear-gradient(135deg, #667eea, #764ba2); color: white; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark nav-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-shield-alt me-2"></i>Insurer Portal
            </a>
            <div class="navbar-text text-white">
                ${insurerName} | ID: ${insurerId}
            </div>
            <div class="navbar-nav">
                <a class="nav-link" href="/auth/logout">
                    <i class="fas fa-sign-out-alt me-1"></i>Logout
                </a>
            </div>
        </div>
    </nav>
    
    <div class="dashboard-container">
        <!-- Welcome Card -->
        <div class="card welcome-card p-4 mb-4">
            <h2><i class="fas fa-home me-2"></i>Insurer Dashboard</h2>
            <p class="mb-0">Welcome, ${insurerName}! Manage your claims and processing.</p>
        </div>
        
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
        
        <!-- Quick Stats -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="stat-card primary-card">
                    <h4><i class="fas fa-clipboard-list me-2 text-primary"></i>Primary Claims</h4>
                    <h1 class="display-4 text-primary">${primaryClaimsCount}</h1>
                    <p>Claims awaiting your processing as primary insurer</p>
                    <a href="/insurer/primary-claims?insurerId=${insurerId}" class="btn btn-primary">
                        <i class="fas fa-eye me-2"></i>View & Process
                    </a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="stat-card secondary-card">
                    <h4><i class="fas fa-clipboard-check me-2 text-success"></i>Secondary Claims</h4>
                    <h1 class="display-4 text-success">${secondaryClaimsCount}</h1>
                    <p>Claims pending your processing as secondary insurer</p>
                    <a href="/insurer/secondary-claims?insurerId=${insurerId}" class="btn btn-success">
                        <i class="fas fa-eye me-2"></i>View & Process
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="card p-4 mb-4">
            <h4 class="mb-3"><i class="fas fa-bolt me-2"></i>Quick Actions</h4>
            <div class="row">
                <div class="col-md-3 mb-3">
                    <a href="/insurer/primary-claims?insurerId=${insurerId}" class="btn btn-primary w-100">
                        <i class="fas fa-tasks me-2"></i>Primary Claims
                    </a>
                </div>
                <div class="col-md-3 mb-3">
                    <a href="/insurer/secondary-claims?insurerId=${insurerId}" class="btn btn-success w-100">
                        <i class="fas fa-tasks me-2"></i>Secondary Claims
                    </a>
                </div>
                <div class="col-md-3 mb-3">
                    <a href="/insurer/history?insurerId=${insurerId}" class="btn btn-info w-100">
                        <i class="fas fa-history me-2"></i>View History
                    </a>
                </div>
                <div class="col-md-3 mb-3">
                    <a href="/auth/logout" class="btn btn-warning w-100">
                        <i class="fas fa-sign-out-alt me-2"></i>Logout
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Instructions -->
        <div class="card p-4">
            <h4><i class="fas fa-info-circle me-2"></i>How to Process Claims</h4>
            <div class="row">
                <div class="col-md-6">
                    <div class="alert alert-primary">
                        <h5><i class="fas fa-user-md me-2"></i>As Primary Insurer:</h5>
                        <ol class="mb-0">
                            <li>Go to "Primary Claims"</li>
                            <li>View claim details</li>
                            <li>Click "Process as Primary"</li>
                            <li>System creates EOB1</li>
                            <li>Claim sent to secondary (if exists)</li>
                        </ol>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="alert alert-success">
                        <h5><i class="fas fa-user-nurse me-2"></i>As Secondary Insurer:</h5>
                        <ol class="mb-0">
                            <li>Go to "Secondary Claims"</li>
                            <li>View claim & EOB1 details</li>
                            <li>Click "Process as Secondary"</li>
                            <li>System creates EOB2 & EOBFinal</li>
                            <li>Claim marked as processed</li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>