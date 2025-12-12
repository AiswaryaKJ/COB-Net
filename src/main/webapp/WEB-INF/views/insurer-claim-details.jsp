<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Claim Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI'; }
        .container-custom { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        .nav-custom { background: linear-gradient(135deg, #2c3e50, #3498db); }
        .detail-card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .section { margin-bottom: 25px; padding-bottom: 20px; border-bottom: 1px solid #eee; }
        .section:last-child { border-bottom: none; }
        .label { font-weight: 600; color: #495057; margin-bottom: 5px; }
        .value { color: #212529; font-size: 1.1rem; }
        .eob-box { background: #f8f9fa; border-radius: 10px; padding: 20px; margin-top: 20px; }
        .action-btn { min-width: 200px; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark nav-custom">
        <div class="container-fluid">
            <c:choose>
                <c:when test="${claim.status == 'submitted' or claim.status == 'pending'}">
                    <a class="navbar-brand" href="/insurer/primary-claims?insurerId=${insurerId}">
                        <i class="fas fa-arrow-left me-2"></i>Back to Claims
                    </a>
                </c:when>
                <c:otherwise>
                    <a class="navbar-brand" href="/insurer/dashboard?insurerId=${insurerId}">
                        <i class="fas fa-arrow-left me-2"></i>Dashboard
                    </a>
                </c:otherwise>
            </c:choose>
            <span class="navbar-text text-white">
                <i class="fas fa-file-medical me-2"></i>Claim Details - ${insurerName}
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
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
        
        <div class="detail-card">
            <!-- Header -->
            <div class="section">
                <h3><i class="fas fa-file-invoice me-2"></i>Claim #HC-${claim.claimId}</h3>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Status</div>
                        <div class="value">
                            <span class="badge bg-${claim.status} p-2">
                                ${claim.status}
                            </span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="label">Billed Amount</div>
                        <div class="value text-primary fw-bold">
                            $<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Patient & Provider Info -->
            <div class="section">
                <h5><i class="fas fa-user me-2"></i>Patient & Provider Information</h5>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Patient</div>
                        <div class="value">
                            ${claim.patient.firstName} ${claim.patient.lastName} (ID: ${claim.patient.patientId})
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="label">Provider</div>
                        <div class="value">
                            ${claim.provider.name} (ID: ${claim.provider.providerId})
                            <c:if test="${claim.provider.networkStatus == 'IN'}">
                                <span class="badge bg-success ms-2">In-Network</span>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Insurer Information -->
            <div class="section">
                <h5><i class="fas fa-shield-alt me-2"></i>Insurance Information</h5>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Primary Insurer</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${claim.primaryInsurer != null}">
                                    ${claim.primaryInsurer.payerName}
                                    <c:if test="${canProcess == 'primary'}">
                                        <span class="badge bg-primary ms-2">You are Primary</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Not assigned</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="label">Secondary Insurer</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${claim.secondaryInsurer != null}">
                                    ${claim.secondaryInsurer.payerName}
                                    <c:if test="${canProcess == 'secondary'}">
                                        <span class="badge bg-success ms-2">You are Secondary</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Not assigned</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Medical Information -->
            <div class="section">
                <h5><i class="fas fa-stethoscope me-2"></i>Medical Information</h5>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Diagnosis Code</div>
                        <div class="value">${claim.diagnosisCode}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="label">Procedure Code</div>
                        <div class="value">${claim.procedureCode}</div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Claim Date</div>
                        <div class="value">${claim.claimDate}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="label">Patient Responsibility</div>
                        <div class="value text-danger fw-bold">
                            <c:choose>
                                <c:when test="${claim.finalOutOfPocket != null}">
                                    $<fmt:formatNumber value="${claim.finalOutOfPocket}" pattern="#,##0.00"/>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">To be calculated</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- EOB Information (if processed) -->
            <c:if test="${not empty eobDetails and (eobDetails.eob1 != null or eobDetails.eob2 != null or eobDetails.eobFinal != null)}">
                <div class="section">
                    <h5><i class="fas fa-file-contract me-2"></i>Explanation of Benefits (EOB)</h5>
                    <div class="eob-box">
                        <c:if test="${eobDetails.eob1 != null}">
                            <h6><i class="fas fa-file-medical me-2 text-primary"></i>Primary EOB (EOB1)</h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="label">Patient Responsibility</div>
                                    <div class="value">
                                        $<fmt:formatNumber value="${eobDetails.eob1.patientResponsibility}" pattern="#,##0.00"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="label">Insurer Payment</div>
                                    <div class="value">
                                        $<fmt:formatNumber value="${eobDetails.eob1.insurerPayment}" pattern="#,##0.00"/>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${eobDetails.eob2 != null}">
                            <h6 class="mt-3"><i class="fas fa-file-medical-alt me-2 text-success"></i>Secondary EOB (EOB2)</h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="label">Patient Responsibility</div>
                                    <div class="value">
                                        $<fmt:formatNumber value="${eobDetails.eob2.patientResponsibility}" pattern="#,##0.00"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="label">Insurer Payment</div>
                                    <div class="value">
                                        $<fmt:formatNumber value="${eobDetails.eob2.insurerPayment}" pattern="#,##0.00"/>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${eobDetails.eobFinal != null}">
                            <h6 class="mt-3"><i class="fas fa-file-invoice-dollar me-2 text-info"></i>Final EOB</h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="label">Total Patient Responsibility</div>
                                    <div class="value text-danger fw-bold">
                                        $<fmt:formatNumber value="${eobDetails.eobFinal.totalPatientResponsibility}" pattern="#,##0.00"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="label">Total Insurance Payment</div>
                                    <div class="value text-success fw-bold">
                                        $<fmt:formatNumber value="${eobDetails.eobFinal.totalInsurancePayment}" pattern="#,##0.00"/>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="mt-3 text-center">
                            <a href="/insurer/eob/${claim.claimId}?insurerId=${insurerId}" class="btn btn-info">
                                <i class="fas fa-external-link-alt me-2"></i>View Full EOB Details
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Action Buttons -->
            <div class="section">
                <h5><i class="fas fa-cogs me-2"></i>Actions</h5>
                <div class="row mt-3">
                    <div class="col-md-12">
                        <div class="d-flex justify-content-between">
                            <c:choose>
                                <c:when test="${claim.status == 'submitted'}">
                                    <a href="/insurer/primary-claims?insurerId=${insurerId}" class="btn btn-secondary action-btn">
                                        <i class="fas fa-arrow-left me-2"></i>Back to Primary Claims
                                    </a>
                                </c:when>
                                <c:when test="${claim.status == 'pending'}">
                                    <a href="/insurer/secondary-claims?insurerId=${insurerId}" class="btn btn-secondary action-btn">
                                        <i class="fas fa-arrow-left me-2"></i>Back to Secondary Claims
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="/insurer/dashboard?insurerId=${insurerId}" class="btn btn-secondary action-btn">
                                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                                    </a>
                                </c:otherwise>
                            </c:choose>
                            
                            <c:choose>
                                <c:when test="${canProcess == 'primary' and claim.status == 'submitted'}">
                                    <form action="/insurer/process-primary/${claim.claimId}?insurerId=${insurerId}" method="POST" class="d-inline">
                                        <button type="submit" class="btn btn-primary action-btn">
                                            <i class="fas fa-cog me-2"></i>Process as Primary Insurer
                                        </button>
                                    </form>
                                </c:when>
                                <c:when test="${canProcess == 'secondary' and claim.status == 'pending'}">
                                    <form action="/insurer/process-secondary/${claim.claimId}?insurerId=${insurerId}" method="POST" class="d-inline">
                                        <button type="submit" class="btn btn-success action-btn">
                                            <i class="fas fa-cog me-2"></i>Process as Secondary Insurer
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${claim.status == 'submitted' or claim.status == 'pending'}">
                                        <button class="btn btn-secondary action-btn" disabled>
                                            <i class="fas fa-lock me-2"></i>Cannot Process
                                        </button>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                            
                            <c:if test="${not empty eobDetails and (eobDetails.eob1 != null or eobDetails.eob2 != null)}">
                                <a href="/insurer/eob/${claim.claimId}?insurerId=${insurerId}" class="btn btn-info action-btn">
                                    <i class="fas fa-file-contract me-2"></i>View EOB
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Status Information -->
            <div class="alert alert-light">
                <h6><i class="fas fa-info-circle me-2"></i>Status Information</h6>
                <p class="mb-0">
                    <c:choose>
                        <c:when test="${claim.status == 'submitted'}">
                            This claim is submitted and waiting for primary insurer processing.
                        </c:when>
                        <c:when test="${claim.status == 'pending'}">
                            This claim has been processed by primary insurer and is waiting for secondary insurer.
                        </c:when>
                        <c:when test="${claim.status == 'processed'}">
                            This claim has been fully processed by all insurers.
                        </c:when>
                        <c:when test="${claim.status == 'paid'}">
                            This claim has been fully paid by the patient.
                        </c:when>
                        <c:when test="${claim.status == 'denied'}">
                            This claim has been denied.
                        </c:when>
                    </c:choose>
                </p>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>