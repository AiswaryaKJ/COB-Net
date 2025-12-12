<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>EOB Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI'; }
        .container-custom { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        .nav-custom { background: linear-gradient(135deg, #2c3e50, #3498db); }
        .detail-card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .section { margin-bottom: 25px; padding-bottom: 20px; border-bottom: 1px solid #eee; }
        .section:last-child { border-bottom: none; }
        .eob-card { background: #f8f9fa; border-radius: 10px; padding: 20px; margin-bottom: 15px; }
        .primary-card { border-left: 5px solid #007bff; }
        .secondary-card { border-left: 5px solid #28a745; }
        .final-card { border-left: 5px solid #6f42c1; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark nav-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="/insurer/dashboard?insurerId=${insurerId}">
                <i class="fas fa-arrow-left me-2"></i>Dashboard
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-file-contract me-2"></i>EOB Details - ${insurerName}
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <div class="detail-card">
            <!-- Header -->
            <div class="section text-center">
                <h3><i class="fas fa-file-invoice-dollar me-2"></i>Explanation of Benefits</h3>
                <h5 class="text-muted">Claim #HC-${claim.claimId} - ${claim.patient.firstName} ${claim.patient.lastName}</h5>
            </div>
            
            <!-- Total Summary -->
            <div class="section">
                <h5><i class="fas fa-chart-bar me-2"></i>Claim Summary</h5>
                <div class="row">
                    <div class="col-md-4">
                        <div class="card text-white bg-primary mb-3">
                            <div class="card-body text-center">
                                <h6 class="card-title">Total Billed</h6>
                                <h4 class="card-text">$<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/></h4>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-danger mb-3">
                            <div class="card-body text-center">
                                <h6 class="card-title">Patient Responsibility</h6>
                                <h4 class="card-text">
                                    <c:choose>
                                        <c:when test="${eobDetails.eobFinal != null}">
                                            $<fmt:formatNumber value="${eobDetails.eobFinal.totalPatientResponsibility}" pattern="#,##0.00"/>
                                        </c:when>
                                        <c:when test="${claim.finalOutOfPocket != null}">
                                            $<fmt:formatNumber value="${claim.finalOutOfPocket}" pattern="#,##0.00"/>
                                        </c:when>
                                        <c:otherwise>
                                            $0.00
                                        </c:otherwise>
                                    </c:choose>
                                </h4>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-success mb-3">
                            <div class="card-body text-center">
                                <h6 class="card-title">Insurance Payment</h6>
                                <h4 class="card-text">
                                    <c:choose>
                                        <c:when test="${eobDetails.eobFinal != null}">
                                            $<fmt:formatNumber value="${eobDetails.eobFinal.totalInsurancePayment}" pattern="#,##0.00"/>
                                        </c:when>
                                        <c:otherwise>
                                            $0.00
                                        </c:otherwise>
                                    </c:choose>
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Primary EOB Details -->
            <c:if test="${eobDetails.eob1 != null}">
                <div class="section">
                    <h5><i class="fas fa-file-medical me-2 text-primary"></i>Primary Insurance EOB (EOB1)</h5>
                    <div class="eob-card primary-card">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Insurer: ${eobDetails.eob1.insurer.payerName}</h6>
                                <p><strong>Processed On:</strong> ${eobDetails.eob1.createdAt}</p>
                            </div>
                            <div class="col-md-6 text-end">
                                <h6>EOB ID: ${eobDetails.eob1.eob1Id}</h6>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-4">
                                <div class="alert alert-light">
                                    <h6>Deductible Applied</h6>
                                    <h4 class="text-warning">$<fmt:formatNumber value="${eobDetails.eob1.deductibleApplied}" pattern="#,##0.00"/></h4>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="alert alert-light">
                                    <h6>Copay Applied</h6>
                                    <h4 class="text-info">$<fmt:formatNumber value="${eobDetails.eob1.copayApplied}" pattern="#,##0.00"/></h4>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="alert alert-light">
                                    <h6>Coinsurance Applied</h6>
                                    <h4 class="text-secondary">$<fmt:formatNumber value="${eobDetails.eob1.coinsuranceApplied}" pattern="#,##0.00"/></h4>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <div class="alert alert-danger">
                                    <h6>Patient Responsibility</h6>
                                    <h4>$<fmt:formatNumber value="${eobDetails.eob1.patientResponsibility}" pattern="#,##0.00"/></h4>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="alert alert-success">
                                    <h6>Insurance Payment</h6>
                                    <h4>$<fmt:formatNumber value="${eobDetails.eob1.insurerPayment}" pattern="#,##0.00"/></h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Secondary EOB Details -->
            <c:if test="${eobDetails.eob2 != null}">
                <div class="section">
                    <h5><i class="fas fa-file-medical-alt me-2 text-success"></i>Secondary Insurance EOB (EOB2)</h5>
                    <div class="eob-card secondary-card">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Insurer: ${eobDetails.eob2.insurer.payerName}</h6>
                                <p><strong>Processed On:</strong> ${eobDetails.eob2.createdAt}</p>
                            </div>
                            <div class="col-md-6 text-end">
                                <h6>EOB ID: ${eobDetails.eob2.eob2Id}</h6>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-4">
                                <div class="alert alert-light">
                                    <h6>Deductible Applied</h6>
                                    <h4 class="text-warning">$<fmt:formatNumber value="${eobDetails.eob2.deductibleApplied}" pattern="#,##0.00"/></h4>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="alert alert-light">
                                    <h6>Copay Applied</h6>
                                    <h4 class="text-info">$<fmt:formatNumber value="${eobDetails.eob2.copayApplied}" pattern="#,##0.00"/></h4>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="alert alert-light">
                                    <h6>Coinsurance Applied</h6>
                                    <h4 class="text-secondary">$<fmt:formatNumber value="${eobDetails.eob2.coinsuranceApplied}" pattern="#,##0.00"/></h4>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <div class="alert alert-danger">
                                    <h6>Patient Responsibility</h6>
                                    <h4>$<fmt:formatNumber value="${eobDetails.eob2.patientResponsibility}" pattern="#,##0.00"/></h4>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="alert alert-success">
                                    <h6>Insurance Payment</h6>
                                    <h4>$<fmt:formatNumber value="${eobDetails.eob2.insurerPayment}" pattern="#,##0.00"/></h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Final EOB -->
            <c:if test="${eobDetails.eobFinal != null}">
                <div class="section">
                    <h5><i class="fas fa-file-invoice-dollar me-2 text-info"></i>Final EOB Summary</h5>
                    <div class="eob-card final-card">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Final Settlement</h6>
                                <p><strong>Created On:</strong> ${eobDetails.eobFinal.createdAt}</p>
                            </div>
                            <div class="col-md-6 text-end">
                                <h6>Final EOB ID: ${eobDetails.eobFinal.eobFinalId}</h6>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <div class="alert alert-danger">
                                    <h6>Total Patient Responsibility</h6>
                                    <h3>$<fmt:formatNumber value="${eobDetails.eobFinal.totalPatientResponsibility}" pattern="#,##0.00"/></h3>
                                    <p class="mb-0">What the patient needs to pay</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="alert alert-success">
                                    <h6>Total Insurance Payment</h6>
                                    <h3>$<fmt:formatNumber value="${eobDetails.eobFinal.totalInsurancePayment}" pattern="#,##0.00"/></h3>
                                    <p class="mb-0">Total paid by all insurers</p>
                                </div>
                            </div>
                        </div>
                        <div class="alert alert-light mt-3">
                            <h6><i class="fas fa-info-circle me-2"></i>Calculation Details</h6>
                            <p class="mb-0">
                                Total Billed: $<fmt:formatNumber value="${eobDetails.eobFinal.totalBilledAmount}" pattern="#,##0.00"/> = 
                                Patient Responsibility + Insurance Payment
                            </p>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Action Buttons -->
            <div class="section text-center">
                <div class="btn-group">
                    <a href="/insurer/claim/${claim.claimId}?insurerId=${insurerId}" class="btn btn-primary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Claim Details
                    </a>
                    <a href="/insurer/dashboard?insurerId=${insurerId}" class="btn btn-secondary">
                        <i class="fas fa-home me-2"></i>Back to Dashboard
                    </a>
                    <c:if test="${claim.status == 'processed' and claim.finalOutOfPocket > 0}">
                        <a href="/patient/pay?patientId=${claim.patient.patientId}&claimId=${claim.claimId}" class="btn btn-success">
                            <i class="fas fa-credit-card me-2"></i>Make Payment
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>