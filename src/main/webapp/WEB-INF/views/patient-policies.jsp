<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insurance Policies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        }
        .container-custom { 
            max-width: 1200px; 
            margin: 30px auto; 
            padding: 0 20px; 
        }
        .navbar-custom { 
            background: linear-gradient(135deg, #2c3e50, #3498db); 
        }
        .insurance-card { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); 
        }
        .policy-card { 
            border: 1px solid #e0e0e0; 
            border-radius: 10px; 
            padding: 25px; 
            margin-bottom: 25px; 
            transition: all 0.3s ease;
        }
        .policy-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .policy-card.primary { 
            border-left: 4px solid #007bff; 
            background-color: #f8f9ff; 
        }
        .policy-card.secondary { 
            border-left: 4px solid #6c757d; 
        }
        .policy-card.inactive {
            border-left: 4px solid #dc3545;
            opacity: 0.8;
            background-color: #f8f9fa;
        }
        .financial-box { 
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 10px; 
            padding: 15px; 
            margin: 10px 0;
            border: 1px solid #dee2e6;
        }
        .detail-label { 
            font-weight: 600; 
            color: #495057; 
            font-size: 0.9rem;
        }
        .detail-value { 
            color: #212529; 
            font-size: 1.1rem;
            font-weight: 600;
        }
        .coverage-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: conic-gradient(#28a745 0% var(--percentage), #e9ecef 0);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            position: relative;
        }
        .coverage-circle::before {
            content: '';
            position: absolute;
            width: 70px;
            height: 70px;
            background: white;
            border-radius: 50%;
        }
        .coverage-text {
            position: relative;
            z-index: 1;
            font-size: 1rem;
            font-weight: 600;
            color: #28a745;
        }
        .status-badge {
            padding: 6px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
        }
        .status-badge.active {
            background-color: #28a745;
            color: white;
        }
        .status-badge.inactive {
            background-color: #dc3545;
            color: white;
        }
        .progress-tracker {
            height: 8px;
            border-radius: 4px;
            background-color: #e9ecef;
            overflow: hidden;
            margin-top: 5px;
        }
        .progress-fill {
            height: 100%;
            border-radius: 4px;
        }
        .deductible-fill { background-color: #ffc107; }
        .oop-fill { background-color: #17a2b8; }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="/patient/dashboard?patientId=${patientId}">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-shield-alt me-2"></i>Insurance Policies
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <div class="insurance-card">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3><i class="fas fa-shield-alt me-2"></i>Your Insurance Policies</h3>
                    <p class="text-muted mb-0">${patientName} - Manage your insurance coverage</p>
                </div>
				<span class="badge bg-primary fs-6">
				    ${insurancePolicies.size()} ${insurancePolicies.size() == 1 ? 'Policy' : 'Policies'}
				</span>
            </div>
            
            <c:choose>
                <c:when test="${!empty insurancePolicies}">
                    <!-- Insurance Policies List -->
                    <c:forEach var="policy" items="${insurancePolicies}" varStatus="loop">
                        <div class="policy-card ${policy.isPrimary ? 'primary' : 'secondary'} ${!policy.isActive ? 'inactive' : ''}">
                            <!-- Header -->
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="flex-grow-1">
                                    <div class="d-flex align-items-center mb-2">
                                        <h4 class="mb-0">
                                            <i class="fas fa-hospital me-2"></i>${policy.planName}
                                        </h4>
                                        <div class="ms-3">
                                            <c:choose>
                                                <c:when test="${policy.isPrimary}">
                                                    <span class="badge bg-primary">Primary</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Secondary</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="status-badge ${policy.isActive ? 'active' : 'inactive'} ms-2">
                                                ${policy.isActive ? 'Active' : 'Inactive'}
                                            </span>
                                        </div>
                                    </div>
                                    <p class="text-muted mb-1">
                                        <i class="fas fa-building me-1"></i>
                                        <strong>Payer:</strong> ${policy.payerName}
                                    </p>
                                    <p class="text-muted mb-1">
                                        <i class="fas fa-id-card me-1"></i>
                                        <strong>Policy #:</strong> ${policy.policyNumber}
                                    </p>
                                    <p class="text-muted mb-1">
                                        <i class="fas fa-sort-numeric-up me-1"></i>
                                        <strong>Coverage Order:</strong> #${policy.coverageOrder}
                                    </p>
                                    <p class="text-muted mb-0">
                                        <i class="fas fa-calendar-alt me-1"></i>
                                        <strong>Effective:</strong> ${policy.effectiveDate} 
                                        <c:if test="${policy.terminationDate != null}">
                                            to ${policy.terminationDate}
                                        </c:if>
                                    </p>
                                </div>
                                <div class="text-end">
                                    <div class="coverage-circle" style="--percentage: ${policy.coveragePercent}%">
                                        <div class="coverage-text">${policy.coveragePercent}%</div>
                                    </div>
                                    <small class="text-muted mt-2 d-block">Coverage Percentage</small>
                                </div>
                            </div>
                            
                            <!-- Financial Details -->
                            <div class="row mt-4">
                                <div class="col-md-3">
                                    <div class="financial-box">
                                        <div class="detail-label">Copay Amount</div>
                                        <div class="detail-value text-primary">
                                            $<fmt:formatNumber value="${policy.copay}" pattern="#,##0.00"/>
                                        </div>
                                        <small class="text-muted">Per visit</small>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="financial-box">
                                        <div class="detail-label">Annual Deductible</div>
                                        <div class="detail-value">
                                            $<fmt:formatNumber value="${policy.deductible}" pattern="#,##0.00"/>
                                        </div>
                                        <small class="text-muted">
                                            <c:choose>
                                                <c:when test="${policy.deductiblePaid != null && policy.deductiblePaid > 0}">
                                                    Paid: $<fmt:formatNumber value="${policy.deductiblePaid}" pattern="#,##0.00"/>
                                                    <div class="progress-tracker">
                                                        <div class="progress-fill deductible-fill" 
                                                             style="width: ${(policy.deductiblePaid / policy.deductible) * 100}%"></div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    Not started
                                                </c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="financial-box">
                                        <div class="detail-label">Coinsurance</div>
                                        <div class="detail-value">${policy.coinsurance}%</div>
                                        <small class="text-muted">Your share after deductible</small>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="financial-box">
                                        <div class="detail-label">OOP Max</div>
                                        <div class="detail-value text-info">
                                            $<fmt:formatNumber value="${policy.outOfPocketMax}" pattern="#,##0.00"/>
                                        </div>
                                        <small class="text-muted">
                                            <c:choose>
                                                <c:when test="${policy.oopPaid != null && policy.oopPaid > 0}">
                                                    Paid: $<fmt:formatNumber value="${policy.oopPaid}" pattern="#,##0.00"/>
                                                    <div class="progress-tracker">
                                                        <div class="progress-fill oop-fill" 
                                                             style="width: ${(policy.oopPaid / policy.outOfPocketMax) * 100}%"></div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    Not started
                                                </c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Additional Details -->
                            <div class="row mt-4">
                                <div class="col-md-6">
                                    <div class="card bg-light">
                                        <div class="card-body">
                                            <h6 class="card-title">
                                                <i class="fas fa-chart-line me-2"></i>Coverage Summary
                                            </h6>
                                            <div class="row">
                                                <div class="col-6">
                                                    <small class="text-muted">Plan Type</small>
                                                    <div class="fw-bold">${policy.planType}</div>
                                                </div>
                                                <div class="col-6">
                                                    <small class="text-muted">Coverage</small>
                                                    <div class="fw-bold text-success">${policy.coveragePercent}%</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card bg-light">
                                        <div class="card-body">
                                            <h6 class="card-title">
                                                <i class="fas fa-calculator me-2"></i>Deductible & OOP Status
                                            </h6>
                                            <div class="row">
                                                <div class="col-6">
                                                    <small class="text-muted">Deductible Remaining</small>
                                                    <div class="fw-bold text-warning">
                                                        $<fmt:formatNumber value="${policy.deductibleRemaining != null ? policy.deductibleRemaining : policy.deductible}" pattern="#,##0.00"/>
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <small class="text-muted">OOP Remaining</small>
                                                    <div class="fw-bold text-info">
                                                        $<fmt:formatNumber value="${policy.oopRemaining != null ? policy.oopRemaining : policy.outOfPocketMax}" pattern="#,##0.00"/>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Explanation -->
                            <div class="alert alert-light mt-3 mb-0">
                                <small class="text-muted">
                                    <i class="fas fa-lightbulb me-1"></i>
                                    <strong>How this works:</strong>
                                    <c:choose>
                                        <c:when test="${policy.isPrimary}">
                                            This is your <strong>primary</strong> insurance. Your copay of 
                                            $<fmt:formatNumber value="${policy.copay}" pattern="#,##0.00"/> will be applied first. 
                                            After meeting your $<fmt:formatNumber value="${policy.deductible}" pattern="#,##0.00"/> 
                                            deductible, you'll pay ${policy.coinsurance}% of covered services until you reach your 
                                            $<fmt:formatNumber value="${policy.outOfPocketMax}" pattern="#,##0.00"/> out-of-pocket maximum.
                                        </c:when>
                                        <c:otherwise>
                                            This is your <strong>secondary</strong> insurance. It covers remaining costs after your 
                                            primary insurance pays its share. Your copay is 
                                            $<fmt:formatNumber value="${policy.copay}" pattern="#,##0.00"/> and coinsurance is 
                                            ${policy.coinsurance}% after deductible.
                                        </c:otherwise>
                                    </c:choose>
                                </small>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- CoB Explanation -->
                    <div class="alert alert-info mt-4">
                        <h5><i class="fas fa-random me-2"></i>Coordination of Benefits (CoB)</h5>
                        <p class="mb-0">
                            When you have multiple insurance policies, they coordinate benefits in this order:
                            <strong>Primary → Secondary</strong>. Your primary insurance pays first, then your secondary 
                            insurance may cover some of the remaining costs. This system automatically handles the CoB 
                            calculations for your claims.
                        </p>
                    </div>
                    
                </c:when>
                <c:otherwise>
                    <!-- No Policies Message -->
                    <div class="text-center py-5">
                        <div class="py-4">
                            <i class="fas fa-shield-alt fa-4x text-muted mb-4"></i>
                            <h4>No Insurance Policies Found</h4>
                            <p class="text-muted mb-4">
                                You don't have any insurance policies registered in our system.
                            </p>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Important:</strong> Without insurance coverage, you will be responsible for 
                                100% of medical costs. Please contact your provider or HR department to add insurance.
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <!-- Footer Actions -->
            <div class="mt-4 pt-3 border-top">
                <div class="row">
                    <div class="col-md-6">
                        <a href="/patient/dashboard?patientId=${patientId}" class="btn btn-outline-secondary">
                            <i class="fas fa-home me-2"></i>Back to Dashboard
                        </a>
                        <a href="/patient/claims?patientId=${patientId}" class="btn btn-outline-primary ms-2">
                            <i class="fas fa-file-medical me-2"></i>View Claims
                        </a>
                    </div>
                    <div class="col-md-6 text-end">
                        <c:if test="${!empty insurancePolicies}">
                            <div class="btn-group">
                                <button type="button" class="btn btn-light">
                                    <i class="fas fa-print me-2"></i>Print Summary
                                </button>
                                
                            </div>
                        </c:if>
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
                Patient: ${patientName}
            </p>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function to print insurance summary
        function printSummary() {
            window.print();
        }
        
        // Add event listeners for buttons
        document.addEventListener('DOMContentLoaded', function() {
            const printBtn = document.querySelector('button:contains("Print Summary")');
            if (printBtn) {
                printBtn.addEventListener('click', printSummary);
            }
        });
    </script>
</body>
</html>