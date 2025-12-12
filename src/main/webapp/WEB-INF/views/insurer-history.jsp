<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Claims History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI'; }
        .container-custom { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .nav-custom { background: linear-gradient(135deg, #2c3e50, #3498db); }
        .history-card { background: white; border-radius: 10px; padding: 20px; margin-bottom: 20px; box-shadow: 0 3px 10px rgba(0,0,0,0.05); }
        .primary-header { border-left: 5px solid #007bff; }
        .secondary-header { border-left: 5px solid #28a745; }
        .empty-state { text-align: center; padding: 40px; }
        .tab-content { padding: 20px 0; }
        .nav-tabs .nav-link { color: #495057; font-weight: 500; }
        .nav-tabs .nav-link.active { color: #0d6efd; border-bottom: 3px solid #0d6efd; }
        .status-badge { padding: 5px 10px; border-radius: 15px; font-size: 0.8rem; font-weight: 600; }
        .badge-processed { background: #d4edda; color: #155724; }
        .badge-paid { background: #cce5ff; color: #004085; }
        .badge-denied { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark nav-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="/insurer/dashboard?insurerId=${insurerId}">
                <i class="fas fa-arrow-left me-2"></i>Dashboard
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-history me-2"></i>Claims History - ${insurerName}
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <h3 class="my-4"><i class="fas fa-history me-2"></i>Claims Processing History</h3>
        
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
        
        <!-- Tabs for Primary/Secondary History -->
        <ul class="nav nav-tabs" id="historyTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="primary-tab" data-bs-toggle="tab" 
                        data-bs-target="#primary" type="button" role="tab">
                    <i class="fas fa-user-md me-2"></i>Primary Claims History
                    <span class="badge bg-primary ms-2">${primaryHistory.size()}</span>
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="secondary-tab" data-bs-toggle="tab" 
                        data-bs-target="#secondary" type="button" role="tab">
                    <i class="fas fa-user-nurse me-2"></i>Secondary Claims History
                    <span class="badge bg-success ms-2">${secondaryHistory.size()}</span>
                </button>
            </li>
        </ul>
        
        <div class="tab-content" id="historyTabsContent">
            <!-- Primary Claims Tab -->
            <div class="tab-pane fade show active" id="primary" role="tabpanel">
                <c:choose>
                    <c:when test="${not empty primaryHistory and not primaryHistory.isEmpty()}">
                        <c:forEach var="claim" items="${primaryHistory}">
                            <div class="history-card">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h5>
                                            <i class="fas fa-file-medical text-primary me-2"></i>
                                            Claim #HC-${claim.claimId}
                                            <span class="status-badge badge-${claim.status} ms-2">
                                                ${claim.status}
                                            </span>
                                        </h5>
                                        <p class="mb-1">
                                            <strong>Patient:</strong> ${claim.patient.firstName} ${claim.patient.lastName} 
                                            | <strong>Provider:</strong> ${claim.provider.name}
                                        </p>
                                        <p class="mb-1">
                                            <strong>Date:</strong> ${claim.claimDate} 
                                            | <strong>Billed Amount:</strong> 
                                            <span class="text-primary fw-bold">
                                                $<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/>
                                            </span>
                                        </p>
                                        <p class="mb-0">
                                            <strong>Patient Responsibility:</strong> 
                                            <c:choose>
                                                <c:when test="${claim.finalOutOfPocket != null}">
                                                    <span class="text-danger fw-bold">
                                                        $<fmt:formatNumber value="${claim.finalOutOfPocket}" pattern="#,##0.00"/>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Not calculated</span>
                                                </c:otherwise>
                                            </c:choose>
                                            | <strong>Status:</strong> ${claim.status}
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <div class="btn-group">
                                            <a href="/insurer/claim/${claim.claimId}?insurerId=${insurerId}" 
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-eye me-1"></i>View Details
                                            </a>
                                            <a href="/insurer/eob/${claim.claimId}?insurerId=${insurerId}" 
                                               class="btn btn-sm btn-info">
                                                <i class="fas fa-file-contract me-1"></i>View EOB
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-12">
                                        <small class="text-muted">
                                            <i class="fas fa-info-circle me-1"></i>
                                            <c:choose>
                                                <c:when test="${claim.status == 'processed'}">
                                                    Processed as primary insurer. Patient responsibility calculated.
                                                </c:when>
                                                <c:when test="${claim.status == 'paid'}">
                                                    Fully paid by patient on ${claim.claimDate}.
                                                </c:when>
                                                <c:when test="${claim.status == 'denied'}">
                                                    Claim denied. Reason: Not covered by insurance.
                                                </c:when>
                                            </c:choose>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-clipboard-list fa-4x text-muted mb-3"></i>
                            <h4>No Primary Claims History</h4>
                            <p class="text-muted">
                                You haven't processed any claims as primary insurer yet.
                            </p>
                            <a href="/insurer/primary-claims?insurerId=${insurerId}" class="btn btn-primary">
                                <i class="fas fa-tasks me-2"></i>Process Primary Claims
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Secondary Claims Tab -->
            <div class="tab-pane fade" id="secondary" role="tabpanel">
                <c:choose>
                    <c:when test="${not empty secondaryHistory and not secondaryHistory.isEmpty()}">
                        <c:forEach var="claim" items="${secondaryHistory}">
                            <div class="history-card">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h5>
                                            <i class="fas fa-file-medical-alt text-success me-2"></i>
                                            Claim #HC-${claim.claimId}
                                            <span class="status-badge badge-${claim.status} ms-2">
                                                ${claim.status}
                                            </span>
                                        </h5>
                                        <p class="mb-1">
                                            <strong>Patient:</strong> ${claim.patient.firstName} ${claim.patient.lastName} 
                                            | <strong>Provider:</strong> ${claim.provider.name}
                                        </p>
                                        <p class="mb-1">
                                            <strong>Date:</strong> ${claim.claimDate} 
                                            | <strong>Billed Amount:</strong> 
                                            <span class="text-primary fw-bold">
                                                $<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/>
                                            </span>
                                        </p>
                                        <p class="mb-0">
                                            <strong>Patient Responsibility:</strong> 
                                            <c:choose>
                                                <c:when test="${claim.finalOutOfPocket != null}">
                                                    <span class="text-danger fw-bold">
                                                        $<fmt:formatNumber value="${claim.finalOutOfPocket}" pattern="#,##0.00"/>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Not calculated</span>
                                                </c:otherwise>
                                            </c:choose>
                                            | <strong>Primary Insurer:</strong> 
                                            <c:choose>
                                                <c:when test="${claim.primaryInsurer != null}">
                                                    ${claim.primaryInsurer.payerName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Not assigned</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <div class="btn-group">
                                            <a href="/insurer/claim/${claim.claimId}?insurerId=${insurerId}" 
                                               class="btn btn-sm btn-outline-success">
                                                <i class="fas fa-eye me-1"></i>View Details
                                            </a>
                                            <a href="/insurer/eob/${claim.claimId}?insurerId=${insurerId}" 
                                               class="btn btn-sm btn-info">
                                                <i class="fas fa-file-contract me-1"></i>View EOB
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-12">
                                        <small class="text-muted">
                                            <i class="fas fa-info-circle me-1"></i>
                                            <c:choose>
                                                <c:when test="${claim.status == 'processed'}">
                                                    Processed as secondary insurer after primary processing.
                                                </c:when>
                                                <c:when test="${claim.status == 'paid'}">
                                                    Fully paid by patient on ${claim.claimDate}.
                                                </c:when>
                                                <c:when test="${claim.status == 'denied'}">
                                                    Claim denied. Reason: Not covered by insurance.
                                                </c:when>
                                            </c:choose>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-clipboard-check fa-4x text-muted mb-3"></i>
                            <h4>No Secondary Claims History</h4>
                            <p class="text-muted">
                                You haven't processed any claims as secondary insurer yet.
                            </p>
                            <a href="/insurer/secondary-claims?insurerId=${insurerId}" class="btn btn-success">
                                <i class="fas fa-tasks me-2"></i>Process Secondary Claims
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Summary Stats -->
        <div class="card mt-4">
            <div class="card-body">
                <h5 class="card-title"><i class="fas fa-chart-pie me-2"></i>History Summary</h5>
                <div class="row">
                    <div class="col-md-3">
                        <div class="text-center p-3">
                            <h3 class="text-primary">${primaryHistory.size()}</h3>
                            <p class="mb-0">Primary Claims Processed</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="text-center p-3">
                            <h3 class="text-success">${secondaryHistory.size()}</h3>
                            <p class="mb-0">Secondary Claims Processed</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="text-center p-3">
                            <h3 class="text-info">${primaryHistory.size() + secondaryHistory.size()}</h3>
                            <p class="mb-0">Total Claims Processed</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="text-center p-3">
                            <h3 class="text-warning">
                                <c:set var="paidCount" value="0" />
                                <c:forEach var="claim" items="${primaryHistory}">
                                    <c:if test="${claim.status == 'paid'}">
                                        <c:set var="paidCount" value="${paidCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                <c:forEach var="claim" items="${secondaryHistory}">
                                    <c:if test="${claim.status == 'paid'}">
                                        <c:set var="paidCount" value="${paidCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${paidCount}
                            </h3>
                            <p class="mb-0">Claims Paid</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Help Text -->
        <div class="alert alert-light mt-4">
            <h6><i class="fas fa-question-circle me-2"></i>About Claims History</h6>
            <p class="mb-2">This page shows claims you have already processed. Here's what you can do:</p>
            <ul class="mb-0">
                <li><strong>View Details:</strong> See complete claim information</li>
                <li><strong>View EOB:</strong> See detailed Explanation of Benefits</li>
                <li><strong>Track Status:</strong> Monitor which claims have been paid by patients</li>
                <li><strong>History:</strong> Review your processing activity over time</li>
            </ul>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Initialize tabs
        document.addEventListener('DOMContentLoaded', function() {
            const triggerTabList = [].slice.call(document.querySelectorAll('#historyTabs button'));
            triggerTabList.forEach(function (triggerEl) {
                const tabTrigger = new bootstrap.Tab(triggerEl);
                triggerEl.addEventListener('click', function (event) {
                    event.preventDefault();
                    tabTrigger.show();
                });
            });
        });
    </script>
</body>
</html>