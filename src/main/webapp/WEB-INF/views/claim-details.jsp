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
        .container-custom { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .nav-custom { background: linear-gradient(135deg, #2c3e50, #3498db); }
        .detail-card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .section { margin-bottom: 25px; padding-bottom: 20px; border-bottom: 1px solid #eee; }
        .section:last-child { border-bottom: none; }
        .label { font-weight: 600; color: #495057; margin-bottom: 5px; }
        .value { color: #212529; font-size: 1.1rem; }
        .action-btn { min-width: 150px; }
        .status-badge {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
        }
        .status-submitted { background-color: #6c757d; color: white; }
        .status-processed { background-color: #17a2b8; color: white; }
        .status-approved { background-color: #28a745; color: white; }
        .status-denied { background-color: #dc3545; color: white; }
        .status-paid { background-color: #20c997; color: white; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark nav-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="/provider/viewclaims?providerId=${providerId}">
                <i class="fas fa-arrow-left me-2"></i>Back to Claims
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-file-medical me-2"></i>Claim Details
                <span class="badge bg-light text-dark ms-2">Provider: ${provider.name}</span>
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
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h3><i class="fas fa-file-invoice me-2"></i>Claim #${claim.claimId}</h3>
                        <p class="text-muted mb-0">Submitted by ${provider.name}</p>
                    </div>
                    <div class="text-end">
                        <div class="label">Status</div>
                        <c:choose>
                            <c:when test="${claim.status == 'Submitted'}">
                                <span class="status-badge status-submitted">${claim.status}</span>
                            </c:when>
                            <c:when test="${claim.status == 'Processed'}">
                                <span class="status-badge status-processed">${claim.status}</span>
                            </c:when>
                            <c:when test="${claim.status == 'Approved'}">
                                <span class="status-badge status-approved">${claim.status}</span>
                            </c:when>
                            <c:when test="${claim.status == 'Denied'}">
                                <span class="status-badge status-denied">${claim.status}</span>
                            </c:when>
                            <c:when test="${claim.status == 'Paid'}">
                                <span class="status-badge status-paid">${claim.status}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge bg-secondary">${claim.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Billed Amount</div>
                        <div class="value text-primary fw-bold">
                            $<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="label">Claim Date</div>
                        <div class="value">
                            ${claim.claimDate}  <!-- Fixed: Removed fmt:formatDate -->
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Patient Information -->
            <div class="section">
                <h5><i class="fas fa-user me-2"></i>Patient Information</h5>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Patient Name</div>
                        <div class="value">
                            ${claim.patient.firstName} ${claim.patient.lastName}
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="label">Patient ID</div>
                        <div class="value">
                            ${claim.patient.patientId}
                        </div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Date of Birth</div>
                        <div class="value">
                            ${claim.patient.dob}  <!-- Fixed: Removed fmt:formatDate -->
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="label">Gender</div>
                        <div class="value">${claim.patient.gender}</div>
                    </div>
                </div>
            </div>
            
            <!-- Medical Information -->
            <div class="section">
                <h5><i class="fas fa-stethoscope me-2"></i>Medical Information</h5>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Diagnosis Code</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty claim.diagnosisCode}">
                                    ${claim.diagnosisCode}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Not specified</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="label">Procedure Code</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty claim.procedureCode}">
                                    ${claim.procedureCode}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Not specified</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Patient Responsibility</div>
                        <div class="value text-danger fw-bold">
                            <c:choose>
                                <c:when test="${claim.finalOutOfPocket != null}">
                                    $<fmt:formatNumber value="${claim.finalOutOfPocket}" pattern="#,##0.00"/>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Not calculated</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Insurance Information -->
            <div class="section">
                <h5><i class="fas fa-shield-alt me-2"></i>Insurance Information</h5>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Primary Insurer</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${claim.primaryInsurer != null}">
                                    ${claim.primaryInsurer.payerName}
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
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Not assigned</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Provider Information -->
            <div class="section">
                <h5><i class="fas fa-user-md me-2"></i>Provider Information</h5>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="label">Provider Name</div>
                        <div class="value">
                            ${claim.provider.name}
                            <span class="badge ${claim.provider.networkStatus == 'IN' ? 'bg-success' : 'bg-warning'} ms-2">
                                ${claim.provider.networkStatus == 'IN' ? 'In-Network' : 'Out-of-Network'}
                            </span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="label">Provider ID</div>
                        <div class="value">${claim.provider.providerId}</div>
                    </div>
                </div>
                <c:if test="${not empty claim.provider.specialty}">
                    <div class="row mt-3">
                        <div class="col-md-6">
                            <div class="label">Specialty</div>
                            <div class="value">${claim.provider.specialty}</div>
                        </div>
                    </div>
                </c:if>
            </div>
            
            <!-- Action Buttons -->
            <div class="section">
                <h5><i class="fas fa-cogs me-2"></i>Actions</h5>
                <div class="row mt-3">
                    <div class="col-md-12">
                        <div class="d-flex justify-content-between">
                            <!-- Back Button -->
                            <a href="/provider/viewclaims?providerId=${providerId}" class="btn btn-secondary action-btn">
                                <i class="fas fa-arrow-left me-2"></i>Back to Claims
                            </a>
                            
                            <!-- Status Update Form -->
                            <form action="/provider/updatestatus?providerId=${providerId}" method="POST" class="d-inline">
                                <input type="hidden" name="claimId" value="${claim.claimId}">
                                <div class="input-group" style="min-width: 300px;">
                                    
                                   
                                </div>
                            </form>
                            
                            <!-- Delete Button (only for Submitted claims) -->
                            <c:if test="${claim.status == 'Submitted'}">
                                <form action="/provider/deleteclaim?providerId=${providerId}" method="POST" class="d-inline">
                                    <input type="hidden" name="claimId" value="${claim.claimId}">
                                    <button type="submit" 
                                            class="btn btn-danger action-btn" 
                                            onclick="return confirm('Are you sure you want to delete this claim?')">
                                        <i class="fas fa-trash me-2"></i>Delete Claim
                                    </button>
                                </form>
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
                        <c:when test="${claim.status == 'Submitted'}">
                            This claim has been submitted and is waiting for insurer processing.
                        </c:when>
                        <c:when test="${claim.status == 'Processed'}">
                            This claim has been processed by insurers. Patient responsibility has been calculated.
                        </c:when>
                        <c:when test="${claim.status == 'Approved'}">
                            This claim has been approved for payment.
                        </c:when>
                        <c:when test="${claim.status == 'Denied'}">
                            This claim has been denied by insurers.
                        </c:when>
                        <c:when test="${claim.status == 'Paid'}">
                            This claim has been fully paid by the patient.
                        </c:when>
                        <c:otherwise>
                            Claim status: ${claim.status}
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${claim.status == 'Submitted'}">
                        <br><small class="text-muted">Note: Only claims with "Submitted" status can be deleted.</small>
                    </c:if>
                </p>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>