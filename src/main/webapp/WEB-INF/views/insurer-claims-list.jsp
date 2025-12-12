<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${claimType} Claims</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI'; }
        .container-custom { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .nav-custom { background: linear-gradient(135deg, #2c3e50, #3498db); }
        .claim-card { background: white; border-radius: 10px; padding: 20px; margin-bottom: 15px; box-shadow: 0 3px 10px rgba(0,0,0,0.05); }
        .status-badge { padding: 5px 10px; border-radius: 15px; font-size: 0.8rem; font-weight: 600; }
        .bg-submitted { background: #fff3cd; color: #856404; }
        .bg-pending { background: #cce5ff; color: #004085; }
        .bg-processed { background: #d4edda; color: #155724; }
        .bg-paid { background: #d1ecf1; color: #0c5460; }
        .bg-denied { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark nav-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="/insurer/dashboard?insurerId=${insurerId}">
                <i class="fas fa-arrow-left me-2"></i>Dashboard
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-clipboard-list me-2"></i>${claimType} Claims - ${insurerName}
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <h3 class="my-4">
            <c:choose>
                <c:when test="${claimType == 'Primary'}">
                    <i class="fas fa-clipboard-list me-2 text-primary"></i>Primary Claims (Submitted)
                </c:when>
                <c:otherwise>
                    <i class="fas fa-clipboard-check me-2 text-success"></i>Secondary Claims (Pending)
                </c:otherwise>
            </c:choose>
        </h3>
        
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
        
        <c:choose>
            <c:when test="${not empty claims and not claims.isEmpty()}">
                <c:forEach var="claim" items="${claims}">
                    <div class="claim-card">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h5>Claim #HC-${claim.claimId}</h5>
                                <p class="mb-1">
                                    <strong>Patient:</strong> ${claim.patient.firstName} ${claim.patient.lastName} 
                                    | <strong>Provider:</strong> ${claim.provider.name}
                                </p>
                                <p class="mb-1">
                                    <strong>Date:</strong> ${claim.claimDate} 
                                    | <strong>Amount:</strong> $<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/>
                                </p>
                                <p class="mb-0">
                                    <strong>Diagnosis:</strong> ${claim.diagnosisCode} 
                                    | <strong>Procedure:</strong> ${claim.procedureCode}
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <div class="mb-2">
                                    <span class="badge bg-${claim.status}">
                                        ${claim.status}
                                    </span>
                                </div>
                                <div class="btn-group">
                                    <a href="/insurer/claim/${claim.claimId}?insurerId=${insurerId}" class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-eye me-1"></i>View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="fas fa-clipboard fa-4x text-muted mb-3"></i>
                    <h4>No ${claimType} Claims Found</h4>
                    <p class="text-muted">
                        <c:choose>
                            <c:when test="${claimType == 'Primary'}">
                                No claims are currently submitted for you to process as primary insurer.
                            </c:when>
                            <c:otherwise>
                                No claims are currently pending for you to process as secondary insurer.
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <a href="/insurer/dashboard?insurerId=${insurerId}" class="btn btn-primary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>