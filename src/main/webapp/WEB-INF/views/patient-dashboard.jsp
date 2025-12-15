<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        }
        .container-custom { 
            max-width: 1300px; 
            margin: 30px auto; 
            padding: 0 20px; 
        }
        .navbar-custom { 
            background: linear-gradient(135deg, #2c3e50, #3498db); 
        }
        .dashboard-card { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); 
            margin-bottom: 30px;
        }
        .summary-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            height: 100%;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
        }
        .summary-card:hover {
            transform: translateY(-5px);
        }
        .card-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            font-size: 24px;
        }
        .card-icon-primary { background-color: rgba(0, 123, 255, 0.1); color: #007bff; }
        .card-icon-warning { background-color: rgba(255, 193, 7, 0.1); color: #ffc107; }
        .card-icon-success { background-color: rgba(40, 167, 69, 0.1); color: #28a745; }
        .card-icon-info { background-color: rgba(23, 162, 184, 0.1); color: #17a2b8; }
        .card-icon-danger { background-color: rgba(220, 53, 69, 0.1); color: #dc3545; }
        .card-value {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        .quick-link {
            display: block;
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            text-decoration: none;
            color: #495057;
            transition: all 0.3s ease;
            margin-bottom: 10px;
        }
        .quick-link:hover {
            background-color: #f8f9fa;
            border-color: #007bff;
            color: #007bff;
            transform: translateX(5px);
        }
        .claim-item {
            border-left: 3px solid #007bff;
            padding: 15px;
            margin-bottom: 10px;
            background: #f8f9fa;
            border-radius: 0 8px 8px 0;
        }
        .claim-item.paid { border-left-color: #28a745; }
        .claim-item.processed { border-left-color: #17a2b8; }
        .claim-item.submitted { border-left-color: #ffc107; }
        .policy-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .policy-badge.primary { background-color: #007bff; color: white; }
        .policy-badge.secondary { background-color: #6c757d; color: white; }
        .amount-badge {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
        }
        .welcome-banner {
            background: linear-gradient(135deg, #3498db, #2c3e50);
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <div class="navbar-brand">
                <i class="fas fa-user-injured me-2"></i>Patient Portal
            </div>
            <div class="navbar-text text-white">
                Welcome, ${patientName}!
                <a href="/auth/app/logout-exit" class="btn btn-sm btn-outline-light ms-3">
                    <i class="fas fa-sign-out-alt me-1"></i>Logout
                </a>
            </div>
        </div>
    </nav>
    
    <div class="container-custom">
        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h3><i class="fas fa-heartbeat me-2"></i>Welcome to Your Health Portal</h3>
                    <p class="mb-0">Manage your insurance, claims, and bills all in one place</p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="amount-badge">
                        <i class="fas fa-money-bill-wave me-2"></i>
                        Total Due: $<fmt:formatNumber value="${totalPendingBills}" pattern="#,##0.00"/>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Summary Cards -->
        <div class="dashboard-card">
            <h4 class="mb-4"><i class="fas fa-tachometer-alt me-2"></i>Quick Overview</h4>
            
            <div class="row g-4">
                <!-- Total Claims -->
                <div class="col-md-3">
                    <div class="summary-card">
                        <div class="card-icon card-icon-primary">
                            <i class="fas fa-file-medical"></i>
                        </div>
                        <div class="card-value">${totalClaims}</div>
                        <div class="card-label text-muted">Total Claims</div>
                    </div>
                </div>
                
                <!-- Pending Claims -->
                <div class="col-md-3">
                    <div class="summary-card">
                        <div class="card-icon card-icon-warning">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="card-value">${pendingClaims}</div>
                        <div class="card-label text-muted">Pending Review</div>
                    </div>
                </div>
                
                <!-- Processed Claims -->
                <div class="col-md-3">
                    <div class="summary-card">
                        <div class="card-icon card-icon-info">
                            <i class="fas fa-cogs"></i>
                        </div>
                        <div class="card-value">${processedClaims}</div>
                        <div class="card-label text-muted">Processed</div>
                    </div>
                </div>
                
                <!-- Paid Claims -->
                <div class="col-md-3">
                    <div class="summary-card">
                        <div class="card-icon card-icon-success">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="card-value">${paidClaims}</div>
                        <div class="card-label text-muted">Paid</div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <!-- Left Column: Quick Actions & Insurance -->
            <div class="col-md-4">
                <!-- Quick Actions -->
                <div class="dashboard-card">
                    <h5 class="mb-3"><i class="fas fa-bolt me-2"></i>Quick Actions</h5>
                    
                    <a href="/patient/policies?patientId=${patientId}" class="quick-link">
                        <i class="fas fa-shield-alt me-2 text-primary"></i>
                        <strong>View Insurance Policies</strong>
                        <small class="text-muted d-block mt-1">Check your coverage details</small>
                    </a>
                    
                    <a href="/patient/claims?patientId=${patientId}" class="quick-link">
                        <i class="fas fa-file-medical me-2 text-info"></i>
                        <strong>View Claims History</strong>
                        <small class="text-muted d-block mt-1">See all your medical claims</small>
                    </a>
                    
                    <a href="/patient/bills?patientId=${patientId}" class="quick-link">
                        <i class="fas fa-money-bill-wave me-2 text-success"></i>
                        <strong>Pay Bills</strong>
                        <small class="text-muted d-block mt-1">${pendingClaims} pending bills</small>
                    </a>
                    
                    <c:if test="${hasInsurance}">
                        <a href="/patient/insurance-card?patientId=${patientId}" class="quick-link">
                            <i class="fas fa-id-card me-2 text-warning"></i>
                            <strong>Digital Insurance Card</strong>
                            <small class="text-muted d-block mt-1">View your insurance card</small>
                        </a>
                    </c:if>
                </div>
                
                <!-- Insurance Summary -->
                <c:if test="${!empty insurancePolicies}">
                    <div class="dashboard-card">
                        <h5 class="mb-3"><i class="fas fa-shield-alt me-2"></i>Your Insurance</h5>
                        
                        <c:forEach var="policy" items="${insurancePolicies}" varStatus="loop">
                            <c:if test="${loop.index < 2}">
                                <div class="mb-3 p-3 border rounded">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <strong>${policy.planName}</strong>
                                        <span class="policy-badge ${policy.primary ? 'primary' : 'secondary'}">
                                            ${policy.primary ? 'Primary' : 'Secondary'}
                                        </span>
                                    </div>
                                    <p class="text-muted mb-1 small">
                                        <i class="fas fa-building me-1"></i>${policy.payerName}
                                    </p>
                                    <p class="text-muted mb-1 small">
                                        <i class="fas fa-id-card me-1"></i>${policy.policyNumber}
                                    </p>
                                    <div class="d-flex justify-content-between mt-2">
                                        <span class="badge bg-light text-dark">
                                            <i class="fas fa-percentage me-1"></i>
                                            ${policy.coveragePercent}% Coverage
                                        </span>
                                        <span class="badge bg-light text-dark">
                                            <i class="fas fa-dollar-sign me-1"></i>
                                            $${policy.copay} Copay
                                        </span>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        
                        <c:if test="${insurancePolicies.size() > 2}">
                            <div class="text-center mt-3">
                                <a href="/patient/policies?patientId=${patientId}" class="btn btn-outline-primary btn-sm">
                                    View All ${insurancePolicies.size()} Policies
                                </a>
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </div>
            
            <!-- Right Column: Recent Claims -->
            <div class="col-md-8">
                <div class="dashboard-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="mb-0"><i class="fas fa-history me-2"></i>Recent Claims</h5>
                        <a href="/patient/claims?patientId=${patientId}" class="btn btn-outline-primary btn-sm">
                            View All
                        </a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${!empty recentClaims}">
                            <c:forEach var="claim" items="${recentClaims}">
                                <div class="claim-item ${claim.status.toLowerCase()}">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <h6 class="mb-1">
                                                <i class="fas fa-file-medical-alt me-2"></i>
                                                Claim #HC-${claim.claimId}
                                            </h6>
                                            <p class="text-muted mb-1 small">
                                                <i class="fas fa-calendar me-1"></i>
                                                ${claim.claimDate} | 
                                                <i class="fas fa-user-md me-1"></i>
                                                ${claim.provider.name}
                                            </p>
                                            <p class="mb-1">
                                                Diagnosis: ${claim.diagnosisCode} | 
                                                Procedure: ${claim.procedureCode}
                                            </p>
                                        </div>
                                        <div class="text-end">
                                            <div class="mb-2">
                                                <span class="badge bg-${claim.status == 'Submitted' ? 'warning' : claim.status == 'Processed' ? 'info' : 'success'}">
                                                    ${claim.status}
                                                </span>
                                            </div>
                                            <div class="text-primary fw-bold">
                                                $<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mt-2">
                                        <a href="/patient/claim/${claim.claimId}?patientId=${patientId}" 
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-eye me-1"></i>View Details
                                        </a>
                                        <c:if test="${claim.status == 'Processed'}">
                                            <a href="/patient/bills?patientId=${patientId}" 
                                               class="btn btn-sm btn-outline-success ms-2">
                                                <i class="fas fa-money-bill-wave me-1"></i>Pay Bill
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-file-medical fa-3x text-muted mb-3"></i>
                                <h5>No Claims Found</h5>
                                <p class="text-muted">You don't have any claims yet.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Important Notices -->
                <div class="dashboard-card">
                    <h5 class="mb-3"><i class="fas fa-bell me-2 text-warning"></i>Important Notices</h5>
                    
                    <div class="alert alert-info">
<<<<<<< HEAD
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Payment Reminder:</strong> 
                        <c:choose>
                            <c:when test="${totalPendingBills > 0}">
                                You have pending bills totaling $<fmt:formatNumber value="${totalPendingBills}" pattern="#,##0.00"/>. 
                                Please pay them before the due date to avoid late fees.
                            </c:when>
                            <c:otherwise>
                                You have no pending bills at this time.
                            </c:otherwise>
                        </c:choose>
=======
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
>>>>>>> b0d70cf4ad689909e146a4ad8b92503b97e7bfa2
                    </div>
                    
                    <c:if test="${!hasInsurance}">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>No Insurance Found:</strong> 
                            You don't have any active insurance policies. Please contact your provider to add coverage.
                        </div>
                    </c:if>
                    
                    <div class="alert alert-light">
                        <i class="fas fa-question-circle me-2"></i>
                        <strong>Need Help?</strong> 
                        Contact our support team at (555) 123-4567 or email support@healthportal.com
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer class="mt-5 py-3 border-top text-center text-muted">
        <div class="container">
            <p class="mb-0">
                <i class="fas fa-shield-alt me-1"></i>
                Health Insurance CoB System &copy; 2024 | 
                Patient ID: ${patientId}
            </p>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
<<<<<<< HEAD
        // Auto-hide alerts after 5 seconds
        setTimeout(() => {
=======
        // Auto-hide alerts after 8 seconds
        <!--setTimeout(() => {
>>>>>>> b0d70cf4ad689909e146a4ad8b92503b97e7bfa2
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const alertInstance = new bootstrap.Alert(alert);
                alertInstance.close();
            });
<<<<<<< HEAD
        }, 5000);
=======
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
>>>>>>> b0d70cf4ad689909e146a4ad8b92503b97e7bfa2
    </script>
</body>
</html>