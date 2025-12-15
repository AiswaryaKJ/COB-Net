<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EOB Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        }
        .container-custom { 
            max-width: 1000px; 
            margin: 30px auto; 
            padding: 0 20px; 
        }
        .navbar-custom { 
            background: linear-gradient(135deg, #2c3e50, #3498db); 
        }
        .eob-card { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); 
        }
        .section { 
            margin-bottom: 25px; 
            padding-bottom: 20px; 
            border-bottom: 1px solid #eee; 
        }
        .section:last-child { 
            border-bottom: none; 
        }
        .eob-detail-card { 
            background: #f8f9fa; 
            border-radius: 10px; 
            padding: 20px; 
            margin-bottom: 15px; 
        }
        .primary-card { 
            border-left: 5px solid #007bff; 
        }
        .secondary-card { 
            border-left: 5px solid #28a745; 
        }
        .final-card { 
            border-left: 5px solid #6f42c1; 
        }
        .summary-box {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 10px;
            padding: 20px;
            margin: 15px 0;
        }
        .amount-large {
            font-size: 2rem;
            font-weight: 700;
            margin: 10px 0;
        }
        .amount-paid { color: #28a745; }
        .amount-due { color: #dc3545; }
        .breakdown-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .breakdown-item:last-child {
            border-bottom: none;
        }
        .coverage-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }
        .badge-primary-coverage { background-color: rgba(0, 123, 255, 0.1); color: #007bff; }
        .badge-secondary-coverage { background-color: rgba(40, 167, 69, 0.1); color: #28a745; }
        .coordination-note {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            border: 1px solid #ffc107;
            border-radius: 10px;
            padding: 15px;
            margin: 20px 0;
        }
        .payment-status {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 25px;
            font-weight: 600;
        }
        .status-paid { background-color: #d4edda; color: #155724; }
        .status-pending { background-color: #fff3cd; color: #856404; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="/patient/claim/${claim.claimId}?patientId=${patientId}">
                <i class="fas fa-arrow-left me-2"></i>Back to Claim
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-file-contract me-2"></i>Explanation of Benefits
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <div class="eob-card">
            <!-- Header -->
            <div class="section text-center">
                <h3><i class="fas fa-file-invoice-dollar me-2"></i>Explanation of Benefits</h3>
                <h5 class="text-muted">Claim #HC-${claim.claimId} - ${patientName}</h5>
                <div class="payment-status ${claim.status == 'Paid' ? 'status-paid' : 'status-pending'} mt-2">
                    <c:choose>
                        <c:when test="${claim.status == 'Paid'}">
                            <i class="fas fa-check-circle me-2"></i>PAID
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-clock me-2"></i>PENDING PAYMENT
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Total Summary -->
            <div class="section">
                <h5><i class="fas fa-chart-bar me-2"></i>Claim Summary</h5>
                <div class="row">
                    <div class="col-md-4">
                        <div class="summary-box text-center">
                            <h6 class="text-muted">Total Billed Amount</h6>
                            <div class="amount-large">$<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/></div>
                            <small>Original charge from provider</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="summary-box text-center">
                            <h6 class="text-muted">Insurance Payment</h6>
                            <c:choose>
                                <c:when test="${eobDetails.eobFinal != null}">
                                    <div class="amount-large text-success">$<fmt:formatNumber value="${eobDetails.eobFinal.totalInsurancePayment}" pattern="#,##0.00"/></div>
                                </c:when>
                                <c:otherwise>
                                    <div class="amount-large text-success">$0.00</div>
                                </c:otherwise>
                            </c:choose>
                            <small>Paid by insurance companies</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="summary-box text-center">
                            <h6 class="text-muted">Your Responsibility</h6>
                            <c:choose>
                                <c:when test="${eobDetails.eobFinal != null}">
                                    <div class="amount-large amount-due">$<fmt:formatNumber value="${eobDetails.eobFinal.totalPatientResponsibility}" pattern="#,##0.00"/></div>
                                </c:when>
                                <c:when test="${claim.finalOutOfPocket != null}">
                                    <div class="amount-large amount-due">$<fmt:formatNumber value="${claim.finalOutOfPocket}" pattern="#,##0.00"/></div>
                                </c:when>
                                <c:otherwise>
                                    <div class="amount-large amount-due">$0.00</div>
                                </c:otherwise>
                            </c:choose>
                            <small>Your share to pay</small>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Coordination of Benefits Explanation -->
            <div class="coordination-note">
                <h6><i class="fas fa-random me-2"></i>Coordination of Benefits (CoB) Applied</h6>
                <p class="mb-0">
                    You have multiple insurance policies. Benefits were coordinated in this order:
                    <strong>Primary → Secondary</strong>. This means your primary insurance paid first, 
                    then your secondary insurance covered some of the remaining costs.
                </p>
            </div>
            
            <!-- Primary EOB Details -->
            <c:if test="${eobDetails.eob1 != null}">
                <div class="section">
                    <h5><i class="fas fa-file-medical me-2 text-primary"></i>Primary Insurance EOB</h5>
                    <div class="eob-detail-card primary-card">
                        <div class="row mb-3">
                            <div class="col-md-8">
                                <h6>
                                    <i class="fas fa-building me-2"></i>
                                    ${eobDetails.eob1.insurer.payerName}
                                    <span class="coverage-badge badge-primary-coverage ms-2">Primary Coverage</span>
                                </h6>
                                <p class="text-muted mb-1">
                                    <i class="fas fa-calendar me-1"></i>
                                    Processed on: ${eobDetails.eob1.createdAt}
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <span class="badge bg-primary">EOB #${eobDetails.eob1.eob1Id}</span>
                            </div>
                        </div>
                        
                        <!-- Breakdown -->
                        <h6 class="mt-4 mb-3">Payment Breakdown</h6>
                        <div class="breakdown-item">
                            <span>Billed Amount</span>
                            <span class="fw-bold">$<fmt:formatNumber value="${eobDetails.eob1.billedAmount}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="breakdown-item">
                            <span>
                                <i class="fas fa-minus-circle text-warning me-1"></i>
                                Deductible Applied
                            </span>
                            <span class="text-warning">$<fmt:formatNumber value="${eobDetails.eob1.deductibleApplied}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="breakdown-item">
                            <span>
                                <i class="fas fa-minus-circle text-info me-1"></i>
                                Copay Applied
                            </span>
                            <span class="text-info">$<fmt:formatNumber value="${eobDetails.eob1.copayApplied}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="breakdown-item">
                            <span>
                                <i class="fas fa-minus-circle text-secondary me-1"></i>
                                Coinsurance Applied
                            </span>
                            <span class="text-secondary">$<fmt:formatNumber value="${eobDetails.eob1.coinsuranceApplied}" pattern="#,##0.00"/></span>
                        </div>
                        
                        <!-- Totals -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <div class="alert alert-danger">
                                    <h6>Your Responsibility After Primary</h6>
                                    <h4>$<fmt:formatNumber value="${eobDetails.eob1.patientResponsibility}" pattern="#,##0.00"/></h4>
                                    <small class="mb-0">What goes to secondary insurance</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="alert alert-success">
                                    <h6>Primary Insurance Payment</h6>
                                    <h4>$<fmt:formatNumber value="${eobDetails.eob1.insurerPayment}" pattern="#,##0.00"/></h4>
                                    <small class="mb-0">Paid by ${eobDetails.eob1.insurer.payerName}</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Secondary EOB Details -->
            <c:if test="${eobDetails.eob2 != null}">
                <div class="section">
                    <h5><i class="fas fa-file-medical-alt me-2 text-success"></i>Secondary Insurance EOB</h5>
                    <div class="eob-detail-card secondary-card">
                        <div class="row mb-3">
                            <div class="col-md-8">
                                <h6>
                                    <i class="fas fa-building me-2"></i>
                                    ${eobDetails.eob2.insurer.payerName}
                                    <span class="coverage-badge badge-secondary-coverage ms-2">Secondary Coverage</span>
                                </h6>
                                <p class="text-muted mb-1">
                                    <i class="fas fa-calendar me-1"></i>
                                    Processed on: ${eobDetails.eob2.createdAt}
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <span class="badge bg-success">EOB #${eobDetails.eob2.eob2Id}</span>
                            </div>
                        </div>
                        
                        <!-- Breakdown -->
                        <h6 class="mt-4 mb-3">Payment Breakdown</h6>
                        <div class="breakdown-item">
                            <span>Amount from Primary EOB</span>
                            <span class="fw-bold">$<fmt:formatNumber value="${eobDetails.eob2.billedAmount}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="breakdown-item">
                            <span>
                                <i class="fas fa-minus-circle text-warning me-1"></i>
                                Deductible Applied
                            </span>
                            <span class="text-warning">$<fmt:formatNumber value="${eobDetails.eob2.deductibleApplied}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="breakdown-item">
                            <span>
                                <i class="fas fa-minus-circle text-info me-1"></i>
                                Copay Applied
                            </span>
                            <span class="text-info">$<fmt:formatNumber value="${eobDetails.eob2.copayApplied}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="breakdown-item">
                            <span>
                                <i class="fas fa-minus-circle text-secondary me-1"></i>
                                Coinsurance Applied
                            </span>
                            <span class="text-secondary">$<fmt:formatNumber value="${eobDetails.eob2.coinsuranceApplied}" pattern="#,##0.00"/></span>
                        </div>
                        
                        <!-- Totals -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <div class="alert alert-danger">
                                    <h6>Your Final Responsibility</h6>
                                    <h4>$<fmt:formatNumber value="${eobDetails.eob2.patientResponsibility}" pattern="#,##0.00"/></h4>
                                    <small class="mb-0">What you need to pay</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="alert alert-success">
                                    <h6>Secondary Insurance Payment</h6>
                                    <h4>$<fmt:formatNumber value="${eobDetails.eob2.insurerPayment}" pattern="#,##0.00"/></h4>
                                    <small class="mb-0">Paid by ${eobDetails.eob2.insurer.payerName}</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Final EOB Summary -->
            <c:if test="${eobDetails.eobFinal != null}">
                <div class="section">
                    <h5><i class="fas fa-file-invoice me-2 text-info"></i>Final Settlement Summary</h5>
                    <div class="eob-detail-card final-card">
                        <div class="row mb-3">
                            <div class="col-md-8">
                                <h6>Complete Claim Settlement</h6>
                                <p class="text-muted mb-1">
                                    <i class="fas fa-calendar me-1"></i>
                                    Finalized on: ${eobDetails.eobFinal.createdAt}
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <span class="badge bg-info">Final EOB #${eobDetails.eobFinal.eobFinalId}</span>
                            </div>
                        </div>
                        
                        <!-- Final Calculation -->
                        <div class="row">
                            <div class="col-md-8">
                                <div class="alert alert-light">
                                    <h6><i class="fas fa-calculator me-2"></i>Final Calculation</h6>
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span>Total Billed:</span>
                                        <span class="fw-bold">$<fmt:formatNumber value="${eobDetails.eobFinal.totalBilledAmount}" pattern="#,##0.00"/></span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span>Total Insurance Payment:</span>
                                        <span class="fw-bold text-success">$<fmt:formatNumber value="${eobDetails.eobFinal.totalInsurancePayment}" pattern="#,##0.00"/></span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span>Your Responsibility:</span>
                                        <span class="fw-bold text-danger">$<fmt:formatNumber value="${eobDetails.eobFinal.totalPatientResponsibility}" pattern="#,##0.00"/></span>
                                    </div>
                                    <hr>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span><strong>Net Result:</strong></span>
                                        <span>
                                            <strong>
                                                $<fmt:formatNumber value="${eobDetails.eobFinal.totalInsurancePayment}" pattern="#,##0.00"/>
                                            </strong> (Insurance) + 
                                            <strong>
                                                $<fmt:formatNumber value="${eobDetails.eobFinal.totalPatientResponsibility}" pattern="#,##0.00"/>
                                            </strong> (You) = 
                                            <strong>
                                                $<fmt:formatNumber value="${eobDetails.eobFinal.totalBilledAmount}" pattern="#,##0.00"/>
                                            </strong>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-center">
                                    <div class="mb-3">
                                        <div class="fs-1 text-success">
                                            <i class="fas fa-percentage"></i>
                                        </div>
                                        <div class="fw-bold">
                                            <c:choose>
                                                <c:when test="${eobDetails.eobFinal.totalBilledAmount > 0}">
                                                    <fmt:formatNumber 
                                                        value="${(eobDetails.eobFinal.totalInsurancePayment / eobDetails.eobFinal.totalBilledAmount) * 100}" 
                                                        pattern="#0"/>
                                                </c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>%
                                        </div>
                                        <small class="text-muted">Covered by Insurance</small>
                                    </div>
                                    <div class="mt-3">
                                        <div class="fs-1 text-danger">
                                            <i class="fas fa-user-md"></i>
                                        </div>
                                        <div class="fw-bold">
                                            <c:choose>
                                                <c:when test="${eobDetails.eobFinal.totalBilledAmount > 0}">
                                                    <fmt:formatNumber 
                                                        value="${(eobDetails.eobFinal.totalPatientResponsibility / eobDetails.eobFinal.totalBilledAmount) * 100}" 
                                                        pattern="#0"/>
                                                </c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>%
                                        </div>
                                        <small class="text-muted">Your Share</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Next Steps -->
            <div class="section">
                <h5><i class="fas fa-forward me-2"></i>Next Steps</h5>
                <div class="row">
                    <div class="col-md-8">
                        <div class="alert alert-light">
                            <c:choose>
                                <c:when test="${claim.status == 'Paid'}">
                                    <h6><i class="fas fa-check-circle text-success me-2"></i>Payment Complete</h6>
                                    <p class="mb-2">This claim has been fully paid. Thank you for your payment!</p>
                                    <p class="mb-0">You can download this EOB as a receipt for your records.</p>
                                </c:when>
                                <c:otherwise>
                                    <h6><i class="fas fa-money-bill-wave text-warning me-2"></i>Payment Due</h6>
                                    <p class="mb-2">
                                        Your share of 
                                        <strong>$<fmt:formatNumber value="${eobDetails.eobFinal != null ? eobDetails.eobFinal.totalPatientResponsibility : claim.finalOutOfPocket}" pattern="#,##0.00"/></strong> 
                                        is now due.
                                    </p>
                                    <p class="mb-0">Please make your payment within 30 days to avoid late fees.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="d-grid gap-2">
                            <c:choose>
                                <c:when test="${claim.status == 'Processed'}">
                                    <a href="/patient/pay?patientId=${patientId}&claimId=${claim.claimId}" 
                                       class="btn btn-success btn-lg">
                                        <i class="fas fa-credit-card me-2"></i>Pay Now
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-secondary btn-lg" disabled>
                                        <i class="fas fa-check-circle me-2"></i>Already Paid
                                    </button>
                                </c:otherwise>
                            </c:choose>
                            <a href="/patient/claims?patientId=${patientId}" class="btn btn-outline-primary">
                                <i class="fas fa-list me-2"></i>View All Claims
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Footer Actions -->
            <div class="section text-center">
                <div class="btn-group">
                    <a href="/patient/claim/${claim.claimId}?patientId=${patientId}" class="btn btn-primary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Claim Details
                    </a>
                    <a href="/patient/dashboard?patientId=${patientId}" class="btn btn-secondary">
                        <i class="fas fa-home me-2"></i>Dashboard
                    </a>
                    <button onclick="window.print()" class="btn btn-info">
                        <i class="fas fa-print me-2"></i>Print EOB
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>