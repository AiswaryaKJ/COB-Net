<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Claim Details</title>
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
        .detail-card { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); 
        }
        .info-section {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        .info-value {
            color: #212529;
            font-size: 1.1rem;
            font-weight: 600;
        }
        .status-badge-large {
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1rem;
            display: inline-block;
        }
        .badge-submitted { background-color: #ffc107; color: #212529; }
        .badge-processed { background-color: #17a2b8; color: white; }
        .badge-paid { background-color: #28a745; color: white; }
        .timeline {
            position: relative;
            padding-left: 30px;
            margin: 20px 0;
        }
        .timeline::before {
            content: '';
            position: absolute;
            left: 7px;
            top: 0;
            bottom: 0;
            width: 2px;
            background-color: #dee2e6;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 20px;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -33px;
            top: 5px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background-color: #007bff;
            border: 3px solid white;
            box-shadow: 0 0 0 2px #007bff;
        }
        .timeline-item.completed::before {
            background-color: #28a745;
            box-shadow: 0 0 0 2px #28a745;
        }
        .timeline-item.current::before {
            background-color: #ffc107;
            box-shadow: 0 0 0 2px #ffc107;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(255, 193, 7, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(255, 193, 7, 0); }
            100% { box-shadow: 0 0 0 0 rgba(255, 193, 7, 0); }
        }
        .amount-box {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
        }
        .amount-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        .amount-value {
            font-size: 2rem;
            font-weight: 700;
            margin: 10px 0;
        }
        .action-card {
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
            height: 100%;
        }
        .action-card:hover {
            border-color: #007bff;
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .action-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 24px;
        }
        .icon-primary { background-color: rgba(0, 123, 255, 0.1); color: #007bff; }
        .icon-success { background-color: rgba(40, 167, 69, 0.1); color: #28a745; }
        .icon-info { background-color: rgba(23, 162, 184, 0.1); color: #17a2b8; }
        .icon-warning { background-color: rgba(255, 193, 7, 0.1); color: #ffc107; }
        .provider-card {
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="/patient/claims?patientId=${patientId}">
                <i class="fas fa-arrow-left me-2"></i>Back to Claims
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-file-medical me-2"></i>Claim Details
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <div class="detail-card">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3><i class="fas fa-file-medical-alt me-2"></i>Claim Details</h3>
                    <p class="text-muted mb-0">Claim #HC-${claim.claimId}</p>
                </div>
                <div>
                    <span class="status-badge-large badge-${claim.status.toLowerCase()}">
                        <c:choose>
                            <c:when test="${claim.status == 'submitted'}">
                                <i class="fas fa-clock me-2"></i>Pending Review
                            </c:when>
                            <c:when test="${claim.status == 'processed'}">
                                <i class="fas fa-cogs me-2"></i>Processed
                            </c:when>
                            <c:when test="${claim.status == 'paid'}">
                                <i class="fas fa-check-circle me-2"></i>Paid
                            </c:when>
                            <c:otherwise>
                                ${claim.status}
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
            
            <div class="row">
                <!-- Left Column: Claim Information -->
                <div class="col-md-8">
                    <!-- Claim Information -->
                    <div class="info-section">
                        <h5 class="mb-3"><i class="fas fa-info-circle me-2"></i>Claim Information</h5>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Claim Date</div>
                                <div class="info-value">
                                    <i class="fas fa-calendar me-2"></i>${claim.claimDate}
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Billed Amount</div>
                                <div class="info-value text-primary">
                                    <i class="fas fa-dollar-sign me-2"></i>
                                    $<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Diagnosis Code</div>
                                <div class="info-value">
                                    <i class="fas fa-stethoscope me-2"></i>${claim.diagnosisCode}
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Procedure Code</div>
                                <div class="info-value">
                                    <i class="fas fa-procedures me-2"></i>${claim.procedureCode}
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Patient Responsibility -->
                    <c:if test="${claim.status == 'processed' or claim.status == 'paid'}">
                        <div class="info-section">
                            <h5 class="mb-3"><i class="fas fa-calculator me-2"></i>Patient Responsibility</h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="amount-box">
                                        <div class="amount-label">Your Responsibility</div>
                                        <div class="amount-value">
                                            $<fmt:formatNumber value="${claim.finalOutOfPocket != null ? claim.finalOutOfPocket : 0}" pattern="#,##0.00"/>
                                        </div>
                                        <div class="amount-label">
                                            <c:choose>
                                                <c:when test="${claim.status == 'paid'}">
                                                    <i class="fas fa-check-circle me-1"></i>Paid on ${claim.claimDate}
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-clock me-1"></i>Due in 30 days
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mt-3">
                                        <p><strong>Insurance Payments:</strong></p>
                                        <ul class="list-unstyled">
                                            <li>
                                                <i class="fas fa-building text-primary me-2"></i>
                                                Primary: 
                                                <c:if test="${not empty claim.primaryInsurerName}">
                                                    ${claim.primaryInsurerName}
                                                </c:if>
                                            </li>
                                            <li>
                                                <i class="fas fa-building text-success me-2"></i>
                                                Secondary: 
                                                <c:if test="${not empty claim.secondaryInsurerName}">
                                                    ${claim.secondaryInsurerName}
                                                </c:if>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- Provider Information -->
                    <div class="provider-card">
                        <h5 class="mb-3"><i class="fas fa-user-md me-2"></i>Provider Information</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-label">Provider Name</div>
                                <div class="info-value">${claim.provider.name}</div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Provider ID</div>
                                <div class="info-value">${claim.provider.providerId}</div>
                            </div>
                            <div class="col-md-6 mt-3">
                                <div class="info-label">Specialty</div>
                                <div class="info-value">${claim.provider.specialty != null ? claim.provider.specialty : 'General'}</div>
                            </div>
                            <!-- Removed address section to fix the error -->
                        </div>
                    </div>
                </div>
                
                <!-- Right Column: Timeline & Actions -->
                <div class="col-md-4">
                    <!-- Claim Timeline -->
                    <div class="info-section">
                        <h5 class="mb-3"><i class="fas fa-history me-2"></i>Claim Timeline</h5>
                        <div class="timeline">
                            <div class="timeline-item completed">
                                <h6>Claim Submitted</h6>
                                <p class="text-muted small mb-0">${claim.claimDate}</p>
                                <p class="small">Claim #HC-${claim.claimId} was submitted to insurance</p>
                            </div>
                            
                            <c:choose>
                                <c:when test="${claim.status == 'submitted'}">
                                    <div class="timeline-item current">
                                        <h6>Under Review</h6>
                                        <p class="text-muted small mb-0">Current Status</p>
                                        <p class="small">Insurance company is reviewing your claim</p>
                                    </div>
                                    
                                    <div class="timeline-item">
                                        <h6>Processing</h6>
                                        <p class="text-muted small mb-0">Next Step</p>
                                        <p class="small">Claim will be processed and EOB generated</p>
                                    </div>
                                    
                                    <div class="timeline-item">
                                        <h6>Payment</h6>
                                        <p class="text-muted small mb-0">Final Step</p>
                                        <p class="small">Pay your share of the medical bill</p>
                                    </div>
                                </c:when>
                                
                                <c:when test="${claim.status == 'processed'}">
                                    <div class="timeline-item completed">
                                        <h6>Under Review</h6>
                                        <p class="text-muted small mb-0">Completed</p>
                                        <p class="small">Insurance company reviewed your claim</p>
                                    </div>
                                    
                                    <div class="timeline-item completed">
                                        <h6>Processing</h6>
                                        <p class="text-muted small mb-0">Completed</p>
                                        <p class="small">Claim processed and EOB generated</p>
                                    </div>
                                    
                                    <div class="timeline-item current">
                                        <h6>Awaiting Payment</h6>
                                        <p class="text-muted small mb-0">Current Status</p>
                                        <p class="small">Ready for payment - view EOB for details</p>
                                    </div>
                                </c:when>
                                
                                <c:when test="${claim.status == 'paid'}">
                                    <div class="timeline-item completed">
                                        <h6>Under Review</h6>
                                        <p class="text-muted small mb-0">Completed</p>
                                        <p class="small">Insurance company reviewed your claim</p>
                                    </div>
                                    
                                    <div class="timeline-item completed">
                                        <h6>Processing</h6>
                                        <p class="text-muted small mb-0">Completed</p>
                                        <p class="small">Claim processed and EOB generated</p>
                                    </div>
                                    
                                    <div class="timeline-item completed">
                                        <h6>Payment Completed</h6>
                                        <p class="text-muted small mb-0">Completed</p>
                                        <p class="small">Payment received and claim closed</p>
                                    </div>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Available Actions -->
                    <div class="mt-4">
                        <h5 class="mb-3"><i class="fas fa-bolt me-2"></i>Available Actions</h5>
                        <div class="row g-3">
                            <!-- View EOB -->
                            <c:if test="${eobAvailable}">
                                <div class="col-12">
                                    <a href="/patient/eob/${claim.claimId}?patientId=${patientId}" 
                                       class="action-card text-decoration-none">
                                        <div class="action-icon icon-info">
                                            <i class="fas fa-file-invoice-dollar"></i>
                                        </div>
                                        <h6>View EOB</h6>
                                        <p class="text-muted small mb-0">
                                            See explanation of benefits and payment details
                                        </p>
                                    </a>
                                </div>
                            </c:if>
                            
                            <!-- Pay Bill -->
                            <c:if test="${claim.status == 'processed'}">
                                <div class="col-12">
                                    <a href="/patient/pay?patientId=${patientId}&claimId=${claim.claimId}" 
                                       class="action-card text-decoration-none">
                                        <div class="action-icon icon-success">
                                            <i class="fas fa-money-bill-wave"></i>
                                        </div>
                                        <h6>Pay Bill</h6>
                                        <p class="text-muted small mb-0">
                                            Pay your share: $<fmt:formatNumber value="${claim.finalOutOfPocket != null ? claim.finalOutOfPocket : 0}" pattern="#,##0.00"/>
                                        </p>
                                    </a>
                                </div>
                            </c:if>
                            
                            <!-- Download Documents -->
                            <div class="col-12">
                                <div class="action-card">
                                    <div class="action-icon icon-primary">
                                        <i class="fas fa-download"></i>
                                    </div>
                                    <h6>Download Documents</h6>
                                    <p class="text-muted small mb-0">
                                        Download claim summary and receipts
                                    </p>
                                    <button class="btn btn-sm btn-outline-primary mt-2">
                                        <i class="fas fa-file-pdf me-1"></i>PDF
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Get Help -->
                            <div class="col-12">
                                <div class="action-card">
                                    <div class="action-icon icon-warning">
                                        <i class="fas fa-question-circle"></i>
                                    </div>
                                    <h6>Need Help?</h6>
                                    <p class="text-muted small mb-0">
                                        Contact support for questions about this claim
                                    </p>
                                    <button class="btn btn-sm btn-outline-warning mt-2">
                                        <i class="fas fa-phone me-1"></i>Contact
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Footer Actions -->
            <div class="mt-4 pt-3 border-top">
                <div class="row">
                    <div class="col-md-6">
                        <a href="/patient/claims?patientId=${patientId}" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Claims
                        </a>
                        <a href="/patient/dashboard?patientId=${patientId}" class="btn btn-outline-primary ms-2">
                            <i class="fas fa-home me-2"></i>Dashboard
                        </a>
                    </div>
                    <div class="col-md-6 text-end">
                        <div class="btn-group">
                            <button type="button" class="btn btn-light" onclick="window.print()">
                                <i class="fas fa-print me-2"></i>Print Details
                            </button>
                            <button type="button" class="btn btn-light">
                                <i class="fas fa-share-alt me-2"></i>Share
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer class="mt-5 py-3 border-top text-center text-muted">
        <div class="container">
            <p class="mb-0">
                <i class="fas fa-file-medical me-1"></i>
                Health Insurance CoB System &copy; 2024 | 
                Claim #HC-${claim.claimId}
            </p>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Print functionality
        function printClaimDetails() {
            window.print();
        }
        
        // Share functionality (placeholder)
        function shareClaim() {
            alert('Share functionality would be implemented here. In a real app, this would share claim details.');
        }
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Add event listeners to buttons
            const printBtn = document.querySelector('button:contains("Print Details")');
            const shareBtn = document.querySelector('button:contains("Share")');
            
            if (printBtn) {
                printBtn.addEventListener('click', printClaimDetails);
            }
            
            if (shareBtn) {
                shareBtn.addEventListener('click', shareClaim);
            }
        });
    </script>
</body>
</html>