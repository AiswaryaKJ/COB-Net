<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | Health Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #2a5bd7;
            --primary-light: #4a7dff;
            --primary-dark: #1a3db0;
            --secondary: #10b981;
            --warning: #f59e0b;
            --info: #3b82f6;
            --light: #f8fafc;
            --dark: #1e293b;
            --gray: #64748b;
            --gray-light: #e2e8f0;
            --border-radius: 10px;
            --transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.08);
            --shadow-md: 0 4px 12px rgba(0,0,0,0.08);
            --shadow-lg: 0 10px 25px rgba(0,0,0,0.1);
        }
        
        * {
            box-sizing: border-box;
        }
        
        body { 
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            color: var(--dark);
            line-height: 1.6;
            min-height: 100vh;
        }
        
        /* Smooth Scrolling */
        html {
            scroll-behavior: smooth;
        }
        
        .container-custom { 
            max-width: 1300px; 
            margin: 0 auto; 
            padding: 0 20px; 
        }
        
        /* Navigation */
        .navbar-custom { 
            background: white;
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.8);
            box-shadow: var(--shadow-sm);
            padding: 16px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            transition: var(--transition);
        }
        
        .navbar-custom:hover {
            box-shadow: var(--shadow-md);
        }
        
        .navbar-brand {
            font-weight: 700;
            color: var(--primary);
            font-size: 1.4rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .navbar-text {
            color: var(--gray);
            font-weight: 500;
        }
        
        /* Welcome Banner */
        .welcome-banner {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
            color: white;
            border-radius: var(--border-radius);
            padding: 40px;
            margin: 30px 0;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
            transform: translateY(0);
            transition: var(--transition);
        }
        
        .welcome-banner:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 30px rgba(42, 91, 215, 0.2);
        }
        
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            transform: translate(30%, -30%);
        }
        
        .amount-badge {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            color: white;
            padding: 16px 28px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1.2rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            display: inline-flex;
            align-items: center;
            gap: 12px;
            transition: var(--transition);
        }
        
        .amount-badge:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: scale(1.02);
        }
        
        /* Dashboard Card Container */
        .dashboard-card { 
            background: white; 
            border-radius: var(--border-radius); 
            padding: 32px; 
            box-shadow: var(--shadow-md);
            border: 1px solid var(--gray-light);
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
            transition: var(--transition);
        }
        
        .dashboard-card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-2px);
        }
        
        .dashboard-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            opacity: 0;
            transition: var(--transition);
        }
        
        .dashboard-card:hover::before {
            opacity: 1;
        }
        
        /* Summary Cards */
        .summary-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 24px;
            height: 100%;
            border: 1px solid var(--gray-light);
            box-shadow: var(--shadow-sm);
            position: relative;
            overflow: hidden;
            transition: var(--transition);
            cursor: pointer;
        }
        
        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-light);
        }
        
        .summary-card::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            transform: translateX(-100%);
            transition: transform 0.6s ease;
        }
        
        .summary-card:hover::after {
            transform: translateX(0);
        }
        
        .card-icon {
            width: 64px;
            height: 64px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            font-size: 28px;
            color: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: var(--transition);
        }
        
        .summary-card:hover .card-icon {
            transform: scale(1.1) rotate(5deg);
        }
        
        .card-icon-primary { 
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
        }
        .card-icon-warning { 
            background: linear-gradient(135deg, #f59e0b, #fbbf24);
        }
        .card-icon-success { 
            background: linear-gradient(135deg, var(--secondary), #34d399);
        }
        .card-icon-info { 
            background: linear-gradient(135deg, var(--info), #60a5fa);
        }
        
        .card-value {
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 8px;
            color: var(--dark);
            background: linear-gradient(135deg, var(--dark), var(--gray));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .card-label {
            font-size: 0.9rem;
            color: var(--gray);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        /* Quick Links */
        .quick-link {
            display: flex;
            align-items: center;
            padding: 20px;
            border: 1px solid var(--gray-light);
            border-radius: var(--border-radius);
            text-decoration: none;
            color: var(--dark);
            background: white;
            transition: var(--transition);
            margin-bottom: 15px;
            position: relative;
            overflow: hidden;
        }
        
        .quick-link::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: var(--primary);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }
        
        .quick-link:hover {
            background: var(--light);
            border-color: var(--primary-light);
            color: var(--primary);
            transform: translateX(8px);
            box-shadow: var(--shadow-md);
        }
        
        .quick-link:hover::before {
            transform: scaleY(1);
        }
        
        .quick-link i {
            font-size: 24px;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            margin-right: 20px;
            color: white;
            flex-shrink: 0;
            transition: var(--transition);
        }
        
        .quick-link:hover i {
            transform: rotate(10deg) scale(1.1);
        }
        
        .quick-link i.text-primary { background: linear-gradient(135deg, var(--primary), var(--primary-light)); }
        .quick-link i.text-info { background: linear-gradient(135deg, var(--info), #60a5fa); }
        .quick-link i.text-success { background: linear-gradient(135deg, var(--secondary), #34d399); }
        .quick-link i.text-warning { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
        
        .quick-link-content {
            flex: 1;
        }
        
        .quick-link strong {
            font-weight: 600;
            display: block;
            margin-bottom: 6px;
            font-size: 1.05rem;
        }
        
        .quick-link small {
            font-size: 0.85rem;
            color: var(--gray);
            line-height: 1.4;
        }
        
        /* Claims Items */
        .claim-item {
            background: white;
            border: 1px solid var(--gray-light);
            border-radius: var(--border-radius);
            padding: 24px;
            margin-bottom: 16px;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }
        
        .claim-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            transition: var(--transition);
        }
        
        .claim-item.submitted::before { background: var(--warning); }
        .claim-item.processed::before { background: var(--info); }
        .claim-item.paid::before { background: var(--secondary); }
        
        .claim-item:hover {
            border-color: var(--primary-light);
            transform: translateX(4px);
            box-shadow: var(--shadow-md);
        }
        
        .claim-item:hover::before {
            width: 6px;
        }
        
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
            letter-spacing: 0.3px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition);
        }
        
        .claim-item:hover .status-badge {
            transform: scale(1.05);
        }
        
        /* Policy Cards */
        .policy-card {
            background: white;
            border: 1px solid var(--gray-light);
            border-radius: var(--border-radius);
            padding: 24px;
            margin-bottom: 16px;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }
        
        .policy-card:hover {
            border-color: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .policy-card::after {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-light), transparent);
            border-radius: 0 0 0 60px;
            opacity: 0.1;
            transition: var(--transition);
        }
        
        .policy-card:hover::after {
            width: 80px;
            height: 80px;
        }
        
        .policy-badge {
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: var(--transition);
        }
        
        .policy-badge.primary { 
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            color: white;
            box-shadow: 0 4px 12px rgba(42, 91, 215, 0.2);
        }
        
        .policy-badge.secondary { 
            background: linear-gradient(135deg, var(--gray), #94a3b8);
            color: white;
        }
        
        .policy-card:hover .policy-badge {
            transform: translateY(-2px);
        }
        
        /* Alerts */
        .alert {
            border-radius: var(--border-radius);
            padding: 24px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }
        
        .alert:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .alert::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
        }
        
        .alert-info {
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            border-color: #bfdbfe;
            color: var(--primary-dark);
        }
        
        .alert-info::before {
            background: var(--info);
        }
        
        .alert-warning {
            background: linear-gradient(135deg, #fffbeb, #fef3c7);
            border-color: #fcd34d;
            color: #92400e;
        }
        
        .alert-warning::before {
            background: var(--warning);
        }
        
        .alert-light {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            border-color: var(--gray-light);
            color: var(--dark);
        }
        
        .alert-light::before {
            background: var(--gray);
        }
        
        /* Buttons */
        .btn {
            border-radius: 8px;
            font-weight: 600;
            padding: 10px 24px;
            transition: var(--transition);
            border: 2px solid transparent;
            position: relative;
            overflow: hidden;
        }
        
        .btn-outline-primary {
            border-color: var(--primary);
            color: var(--primary);
            background: transparent;
        }
        
        .btn-outline-primary:hover {
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            color: white;
            border-color: transparent;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(42, 91, 215, 0.3);
        }
        
        .btn-outline-primary::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 5px;
            height: 5px;
            background: rgba(255, 255, 255, 0.5);
            opacity: 0;
            border-radius: 100%;
            transform: scale(1, 1) translate(-50%);
            transform-origin: 50% 50%;
        }
        
        .btn-outline-primary:focus:not(:active)::after {
            animation: ripple 1s ease-out;
        }
        
        @keyframes ripple {
            0% {
                transform: scale(0, 0);
                opacity: 0.5;
            }
            100% {
                transform: scale(20, 20);
                opacity: 0;
            }
        }
        
        /* Badges */
        .badge {
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
            transition: var(--transition);
        }
        
        .badge:hover {
            transform: scale(1.05);
        }
        
        .bg-warning { 
            background: linear-gradient(135deg, var(--warning), #fbbf24) !important; 
            color: white !important;
        }
        .bg-info { 
            background: linear-gradient(135deg, var(--info), #60a5fa) !important; 
            color: white !important;
        }
        .bg-success { 
            background: linear-gradient(135deg, var(--secondary), #34d399) !important; 
            color: white !important;
        }
        .bg-light { 
            background: linear-gradient(135deg, var(--light), #f1f5f9) !important; 
            color: var(--dark) !important;
            border: 1px solid var(--gray-light);
        }
        
        /* Footer */
        footer {
            background: linear-gradient(135deg, var(--dark), #0f172a);
            color: #94a3b8;
            padding: 32px 0;
            margin-top: 60px;
            position: relative;
            overflow: hidden;
        }
        
        footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--primary-light), transparent);
        }
        
        /* Typography */
        h3, h4, h5, h6 {
            color: var(--dark);
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        h3 { font-size: 1.8rem; }
        h4 { font-size: 1.5rem; }
        h5 { font-size: 1.3rem; }
        
        .text-muted {
            color: var(--gray) !important;
        }
        
        /* Smooth Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .animate-fade-in-up {
            animation: fadeInUp 0.6s ease-out forwards;
        }
        
        .delay-1 { animation-delay: 0.1s; }
        .delay-2 { animation-delay: 0.2s; }
        .delay-3 { animation-delay: 0.3s; }
        .delay-4 { animation-delay: 0.4s; }
        
        /* Responsive */
        @media (max-width: 768px) {
            .container-custom {
                padding: 0 15px;
            }
            
            .dashboard-card {
                padding: 24px;
            }
            
            .welcome-banner {
                padding: 30px 20px;
            }
            
            .card-value {
                font-size: 2rem;
            }
        }
        
        /* Loading Animation */
        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }
        
        .shimmer {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: shimmer 1.5s infinite;
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container-fluid">
            <div class="navbar-brand animate-fade-in-up">
                <i class="fas fa-heartbeat" style="color: var(--primary);"></i>
                <span>HealthPortal</span>
            </div>
            <div class="navbar-text d-flex align-items-center gap-3 animate-fade-in-up delay-1">
                <span class="d-none d-md-block">
                    <i class="fas fa-user-circle me-2"></i>
                    ${patientName}
                </span>
                <a href="/auth/app/logout-exit" class="btn btn-sm btn-outline-primary">
                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                </a>
            </div>
        </div>
    </nav>
    
    <div class="container-custom">
        <!-- Welcome Banner -->
        <div class="welcome-banner animate-fade-in-up delay-2">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h3 class="mb-3">
                        <i class="fas fa-user-injured me-3"></i>
                        Welcome back, ${patientName}
                    </h3>
                    <p class="mb-0 opacity-90">Your complete healthcare management dashboard</p>
                </div>
                <div class="col-md-4 text-md-end mt-4 mt-md-0">
                    <div class="amount-badge">
                        <i class="fas fa-money-bill-wave"></i>
                        <div>
                            <div class="small opacity-90">Total Balance Due</div>
                            <div class="fw-bold">$<fmt:formatNumber value="${totalPendingBills}" pattern="#,##0.00"/></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Summary Cards -->
        <div class="dashboard-card animate-fade-in-up delay-3">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="mb-2">
                        <i class="fas fa-chart-pie me-3" style="color: var(--primary);"></i>
                        Dashboard Overview
                    </h4>
                    <p class="text-muted mb-0">Your healthcare metrics at a glance</p>
                </div>
                <div class="text-muted small d-flex align-items-center">
                    <i class="fas fa-sync-alt me-2"></i>
                    <span>Live Data</span>
                </div>
            </div>
            
            <div class="row g-4">
                <!-- Total Claims -->
                <div class="col-md-3">
                    <div class="summary-card">
                        <div class="card-icon card-icon-primary">
                            <i class="fas fa-file-medical"></i>
                        </div>
                        <div class="card-value">${totalClaims}</div>
                        <div class="card-label">Total Claims</div>
                    </div>
                </div>
                
                <!-- Pending Claims -->
                <div class="col-md-3">
                    <div class="summary-card">
                        <div class="card-icon card-icon-warning">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="card-value">${pendingClaims}</div>
                        <div class="card-label">Pending Review</div>
                    </div>
                </div>
                
                <!-- Processed Claims -->
                <div class="col-md-3">
                    <div class="summary-card">
                        <div class="card-icon card-icon-info">
                            <i class="fas fa-cogs"></i>
                        </div>
                        <div class="card-value">${processedClaims}</div>
                        <div class="card-label">Processed</div>
                    </div>
                </div>
                
                <!-- Paid Claims -->
                <div class="col-md-3">
                    <div class="summary-card">
                        <div class="card-icon card-icon-success">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="card-value">${paidClaims}</div>
                        <div class="card-label">Paid</div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <!-- Left Column: Quick Actions & Insurance -->
            <div class="col-md-4">
                <!-- Quick Actions -->
                <div class="dashboard-card animate-fade-in-up delay-1">
                    <h5 class="mb-4">
                        <i class="fas fa-bolt me-3" style="color: var(--warning);"></i>
                        Quick Actions
                    </h5>
                    
                    <a href="/patient/policies?patientId=${patientId}" class="quick-link">
                        <i class="fas fa-shield-alt text-primary"></i>
                        <div class="quick-link-content">
                            <strong>Insurance Policies</strong>
                            <small>Review coverage and benefits details</small>
                        </div>
                    </a>
                    
                    <a href="/patient/claims?patientId=${patientId}" class="quick-link">
                        <i class="fas fa-file-medical text-info"></i>
                        <div class="quick-link-content">
                            <strong>Claims History</strong>
                            <small>View medical claims and status updates</small>
                        </div>
                    </a>
                    
                    <a href="/patient/bills?patientId=${patientId}" class="quick-link">
                        <i class="fas fa-money-bill-wave text-success"></i>
                        <div class="quick-link-content">
                            <strong>Pay Bills</strong>
                            <small>${pendingClaims} pending payment${pendingClaims != 1 ? 's' : ''}</small>
                        </div>
                    </a>
                    
                    <c:if test="${hasInsurance}">
                        <a href="/patient/insurance-card?patientId=${patientId}" class="quick-link">
                            <i class="fas fa-id-card text-warning"></i>
                            <div class="quick-link-content">
                                <strong>Digital Insurance Card</strong>
                                <small>Access your virtual insurance ID</small>
                            </div>
                        </a>
                    </c:if>
                </div>
                
                <!-- Insurance Summary -->
                <c:if test="${!empty insurancePolicies}">
                    <div class="dashboard-card animate-fade-in-up delay-2">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="mb-0">
                                <i class="fas fa-shield-alt me-3" style="color: var(--primary);"></i>
                                Insurance Coverage
                            </h5>
                            <span class="badge bg-light">${insurancePolicies.size()} active</span>
                        </div>
                        
                        <c:forEach var="policy" items="${insurancePolicies}" varStatus="loop">
                            <c:if test="${loop.index < 2}">
                                <div class="policy-card">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <h6 class="fw-semibold mb-1">${policy.planName}</h6>
                                            <p class="text-muted small mb-0">
                                                <i class="fas fa-building me-1"></i>${policy.payerName}
                                            </p>
                                        </div>
                                        <span class="policy-badge ${policy.primary ? 'primary' : 'secondary'}">
                                            ${policy.primary ? 'Primary' : 'Secondary'}
                                        </span>
                                    </div>
                                    <div class="row g-2">
                                        <div class="col-6">
                                            <div class="d-flex align-items-center">
                                                <i class="fas fa-percentage text-muted me-2 small"></i>
                                                <span class="small">${policy.coveragePercent}% Coverage</span>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="d-flex align-items-center">
                                                <i class="fas fa-dollar-sign text-muted me-2 small"></i>
                                                <span class="small">$${policy.copay} Copay</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        
                        <c:if test="${insurancePolicies.size() > 2}">
                            <div class="text-center mt-3">
                                <a href="/patient/policies?patientId=${patientId}" class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-eye me-2"></i>View All Policies
                                </a>
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </div>
            
            <!-- Right Column: Recent Claims -->
            <div class="col-md-8">
                <div class="dashboard-card animate-fade-in-up delay-2">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h5 class="mb-2">
                                <i class="fas fa-history me-3" style="color: var(--info);"></i>
                                Recent Activity
                            </h5>
                            <p class="text-muted mb-0">Latest claims and healthcare updates</p>
                        </div>
                        <a href="/patient/claims?patientId=${patientId}" class="btn btn-outline-primary">
                            <i class="fas fa-list me-2"></i>View All
                        </a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${!empty recentClaims}">
                            <c:forEach var="claim" items="${recentClaims}">
                                <div class="claim-item ${claim.status.toLowerCase()}">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="flex-grow-1">
                                            <div class="d-flex align-items-center mb-2">
                                                <h6 class="fw-semibold mb-0 me-3">
                                                    <i class="fas fa-file-medical-alt me-2"></i>
                                                    Claim #HC-${claim.claimId}
                                                </h6>
                                                <span class="badge bg-${claim.status == 'Submitted' ? 'warning' : claim.status == 'Processed' ? 'info' : 'success'}">
                                                    ${claim.status}
                                                </span>
                                            </div>
                                            <div class="text-muted small mb-3">
                                                <div class="d-flex flex-wrap gap-3">
                                                    <span>
                                                        <i class="fas fa-calendar me-1"></i>
                                                        ${claim.claimDate}
                                                    </span>
                                                    <span>
                                                        <i class="fas fa-user-md me-1"></i>
                                                        ${claim.provider.name}
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="small">
                                                <span class="text-muted">Diagnosis:</span> ${claim.diagnosisCode} 
                                                <span class="mx-2">•</span>
                                                <span class="text-muted">Procedure:</span> ${claim.procedureCode}
                                            </div>
                                        </div>
                                        <div class="text-end ms-4">
                                            <div class="fw-bold text-primary mb-2 fs-5">
                                                $<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/>
                                            </div>
                                            <div class="d-flex gap-2">
                                                <a href="/patient/claim/${claim.claimId}?patientId=${patientId}" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-eye me-1"></i>Details
                                                </a>
                                                <c:if test="${claim.status == 'Processed'}">
                                                    <a href="/patient/bills?patientId=${patientId}" 
                                                       class="btn btn-sm btn-outline-success">
                                                        <i class="fas fa-credit-card me-1"></i>Pay
                                                    </a>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <div class="mb-4">
                                    <i class="fas fa-file-medical fa-3x text-muted opacity-50"></i>
                                </div>
                                <h5 class="fw-semibold mb-2">No Recent Activity</h5>
                                <p class="text-muted mb-4">You don't have any recent claims or updates.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Important Notices -->
                <div class="dashboard-card animate-fade-in-up delay-3">
                    <h5 class="mb-4">
                        <i class="fas fa-bell me-3" style="color: var(--warning);"></i>
                        Important Updates
                    </h5>
                    
                    <div class="alert alert-info">
                        <div class="d-flex align-items-start">
                            <i class="fas fa-info-circle fa-lg me-3 mt-1"></i>
                            <div>
                                <h6 class="fw-semibold mb-2">Payment Reminder</h6>
                                <p class="mb-0">
                                    <c:choose>
                                        <c:when test="${totalPendingBills!=0}">
                                            You have ${pendingClaims} pending bill${pendingClaims != 1 ? 's' : ''} totaling 
                                            <strong>$<fmt:formatNumber value="${totalPendingBills}" pattern="#,##0.00"/></strong>. 
                                            Please settle payments before due dates to avoid late fees.
                                        </c:when>
                                        <c:otherwise>
                                            You have no pending bills at this time. Any new bills will appear here after insurance processing.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <c:if test="${!hasInsurance}">
                        <div class="alert alert-warning">
                            <div class="d-flex align-items-start">
                                <i class="fas fa-exclamation-triangle fa-lg me-3 mt-1"></i>
                                <div>
                                    <h6 class="fw-semibold mb-2">Insurance Coverage Required</h6>
                                    <p class="mb-0">
                                        No active insurance policies found. Please contact your provider 
                                        or insurance company to update your coverage information.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <div class="alert alert-light">
                        <div class="d-flex align-items-start">
                            <i class="fas fa-question-circle fa-lg me-3 mt-1"></i>
                            <div>
                                <h6 class="fw-semibold mb-2">Need Assistance?</h6>
                                <p class="mb-2">Our support team is available to help with any questions.</p>
                                <div class="d-flex flex-wrap gap-3">
                                    <span class="small">
                                        <i class="fas fa-phone me-1"></i>
                                        (555) 123-4567
                                    </span>
                                    <span class="small">
                                        <i class="fas fa-envelope me-1"></i>
                                        support@healthportal.com
                                    </span>
                                    <span class="small">
                                        <i class="fas fa-clock me-1"></i>
                                        Mon-Fri, 8AM-6PM EST
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer>
        <div class="container-custom">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="mb-0">
                        <i class="fas fa-heartbeat me-2" style="color: var(--primary-light);"></i>
                        <strong>HealthPortal</strong> 
                        <span class="mx-2 opacity-50">•</span>
                        <span class="opacity-75">Secure Patient Dashboard</span>
                    </p>
                </div>
                <div class="col-md-6 text-md-end mt-3 mt-md-0">
                    <div class="small opacity-75">
                        <span class="me-3">Patient ID: ${patientId}</span>
                        <span>© 2024 Health Insurance CoB System</span>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-hide alerts after 8 seconds
        <!--setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const alertInstance = new bootstrap.Alert(alert);
                alertInstance.close();
            });
        }, 8000);-->
        
        // Smooth scroll to top on page load
        window.addEventListener('load', () => {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
        
        // Add ripple effect to buttons
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('btn')) {
                const btn = e.target;
                const ripple = document.createElement('span');
                const rect = btn.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.cssText = `
                    position: absolute;
                    border-radius: 50%;
                    background: rgba(255, 255, 255, 0.7);
                    transform: scale(0);
                    animation: ripple-animation 0.6s linear;
                    width: ${size}px;
                    height: ${size}px;
                    top: ${y}px;
                    left: ${x}px;
                    pointer-events: none;
                `;
                
                btn.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            }
        });
        
        // Add CSS for ripple animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple-animation {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
        
        // Animate elements on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);
        
        // Observe all cards for animation
        document.querySelectorAll('.dashboard-card, .summary-card').forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(card);
        });
    </script>
</body>
</html>