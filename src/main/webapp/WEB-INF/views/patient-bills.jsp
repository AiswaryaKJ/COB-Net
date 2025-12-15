<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bills</title>
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
        .bills-card { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); 
        }
        .summary-card {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .summary-value {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        .summary-label {
            font-size: 1rem;
            opacity: 0.9;
        }
        .bill-card {
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        .bill-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .bill-card.pending {
            border-left: 4px solid #dc3545;
            background-color: #fff5f5;
        }
        .bill-card.paid {
            border-left: 4px solid #28a745;
            background-color: #f8fff9;
        }
        .bill-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .amount-badge {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 1.2rem;
        }
        .amount-badge.paid {
            background: linear-gradient(135deg, #28a745, #1e7e34);
        }
        .due-badge {
            background-color: #ffc107;
            color: #212529;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .paid-badge {
            background-color: #28a745;
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        .empty-icon {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 20px;
        }
        .tab-content {
            margin-top: 20px;
        }
        .nav-tabs .nav-link {
            border: none;
            color: #495057;
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 8px 8px 0 0;
        }
        .nav-tabs .nav-link.active {
            background-color: #007bff;
            color: white;
        }
        .progress-tracker {
            height: 6px;
            border-radius: 3px;
            background-color: #e9ecef;
            overflow: hidden;
            margin-top: 5px;
        }
        .progress-fill {
            height: 100%;
            border-radius: 3px;
            background: linear-gradient(135deg, #dc3545, #c82333);
        }
        .status-indicator {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-overdue {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-paid {
            background-color: #d4edda;
            color: #155724;
        }
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
                <i class="fas fa-money-bill-wave me-2"></i>My Bills & Payments
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <div class="bills-card">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3><i class="fas fa-money-bill-wave me-2"></i>My Bills</h3>
                    <p class="text-muted mb-0">${patientName} - Manage your medical bills and payments</p>
                </div>
                <div>
                    <span class="badge bg-primary fs-6">
                        ${pendingBills.size() + paidBills.size()} Bill<c:if test="${pendingBills.size() + paidBills.size() != 1}">s</c:if>
                    </span>
                </div>
            </div>
            
            <!-- Summary Card -->
            <c:if test="${totalPendingAmount > 0}">
                <div class="summary-card">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <div class="summary-value">
                                $<fmt:formatNumber value="${totalPendingAmount}" pattern="#,##0.00"/>
                            </div>
                            <div class="summary-label">
                                Total Amount Due
                                <c:if test="${!pendingBills.isEmpty()}">
                                    (${pendingBills.size()} bill<c:if test="${pendingBills.size() != 1}">s</c:if>)
                                </c:if>
                            </div>
                        </div>
                        <div class="col-md-4 text-end">
                            <a href="#pendingBills" class="btn btn-light btn-lg">
                                <i class="fas fa-credit-card me-2"></i>View All Bills
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Tabs -->
            <ul class="nav nav-tabs" id="billsTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="pending-tab" data-bs-toggle="tab" 
                            data-bs-target="#pending" type="button" role="tab">
                        <i class="fas fa-clock me-2"></i>Pending Bills
                        <c:if test="${!pendingBills.isEmpty()}">
                            <span class="badge bg-danger ms-2">${pendingBills.size()}</span>
                        </c:if>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="paid-tab" data-bs-toggle="tab" 
                            data-bs-target="#paid" type="button" role="tab">
                        <i class="fas fa-check-circle me-2"></i>Paid Bills
                        <c:if test="${!paidBills.isEmpty()}">
                            <span class="badge bg-success ms-2">${paidBills.size()}</span>
                        </c:if>
                    </button>
                </li>
            </ul>
            
            <!-- Tab Content -->
            <div class="tab-content" id="billsTabContent">
                <!-- Pending Bills Tab -->
                <div class="tab-pane fade show active" id="pending" role="tabpanel">
                    <c:choose>
                        <c:when test="${!empty pendingBills}">
                            <div id="pendingBills">
                                <c:forEach var="bill" items="${pendingBills}">
                                    <div class="bill-card pending">
                                        <div class="bill-header">
                                            <div>
                                                <h5 class="mb-1">
                                                    <i class="fas fa-file-medical-alt me-2"></i>
                                                    Claim #HC-${bill.claimId}
                                                </h5>
                                                <p class="text-muted mb-1">
                                                    <i class="fas fa-user-md me-1"></i>
                                                    ${bill.providerName} | 
                                                    <i class="fas fa-calendar me-1"></i>
                                                    ${bill.claimDate}
                                                </p>
                                                <p class="mb-0">
                                                    ${bill.description}
                                                </p>
                                            </div>
                                            <div class="text-end">
                                                <div class="amount-badge">
                                                    $<fmt:formatNumber value="${bill.amountDue}" pattern="#,##0.00"/>
                                                </div>
                                                <div class="mt-2">
                                                    <span class="due-badge">
                                                        <i class="fas fa-calendar-day me-1"></i>
                                                        Due: ${bill.dueDate}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row align-items-center">
                                            <div class="col-md-8">
                                                <!-- Status Indicator -->
                                                <div class="mt-2">
                                                    <c:choose>
                                                        <c:when test="${bill.daysUntilDue != null && bill.daysUntilDue < 0}">
                                                            <span class="status-indicator status-overdue">
                                                                <i class="fas fa-exclamation-triangle me-1"></i>
                                                                OVERDUE! - ${bill.daysUntilDue * -1} days late
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${bill.daysUntilDue != null && bill.daysUntilDue <= 7}">
                                                            <span class="status-indicator status-pending">
                                                                <i class="fas fa-exclamation-circle me-1"></i>
                                                                Due in ${bill.daysUntilDue} days
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-indicator">
                                                                <i class="fas fa-info-circle me-1"></i>
                                                                <c:choose>
                                                                    <c:when test="${bill.daysUntilDue != null}">
                                                                        Due in ${bill.daysUntilDue} days
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        Payment required
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="col-md-4 text-end">
                                                <div class="action-buttons">
                                                    <!-- Pay Now Button -->
                                                    <a href="/patient/pay?patientId=${patientId}&claimId=${bill.claimId}" 
                                                       class="btn btn-success btn-sm">
                                                        <i class="fas fa-credit-card me-1"></i>Pay Now
                                                    </a>
                                                    <!-- View Bill Details Button -->
                                                    <!--<a href="/patient/claim/${bill.claimId}?patientId=${patientId}" 
                                                       class="btn btn-outline-primary btn-sm">
                                                        <i class="fas fa-file-invoice me-1"></i>View Bill
                                                    </a>-->
													<a href="/patient/bill/${bill.claimId}?patientId=${patientId}" 
													   class="btn btn-outline-primary btn-sm">
													   <i class="fas fa-file-invoice me-1"></i>View Bill
													</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            
                        </c:when>
                        <c:otherwise>
                            <!-- Empty State for Pending Bills -->
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <h4>No Pending Bills</h4>
                                <p class="text-muted mb-4">
                                    You're all caught up! There are no bills requiring payment at this time.
                                </p>
                                <div class="alert alert-success">
                                    <i class="fas fa-thumbs-up me-2"></i>
                                    <strong>Great job!</strong> All your bills are paid. New bills will appear here 
                                    after insurance processes your claims.
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Paid Bills Tab -->
                <div class="tab-pane fade" id="paid" role="tabpanel">
                    <c:choose>
                        <c:when test="${!empty paidBills}">
                            <c:forEach var="bill" items="${paidBills}">
                                <div class="bill-card paid">
                                    <div class="bill-header">
                                        <div>
                                            <h5 class="mb-1">
                                                <i class="fas fa-file-invoice-dollar me-2"></i>
                                                Claim #HC-${bill.claimId}
                                            </h5>
                                            <p class="text-muted mb-1">
                                                <i class="fas fa-user-md me-1"></i>
                                                ${bill.providerName} | 
                                                <i class="fas fa-calendar me-1"></i>
                                                Paid on: ${bill.paidDate}
                                            </p>
                                            <p class="mb-0">
                                                ${bill.description}
                                            </p>
                                        </div>
                                        <div class="text-end">
                                            <div class="amount-badge paid">
                                                $<fmt:formatNumber value="${bill.amountPaid}" pattern="#,##0.00"/>
                                            </div>
                                            <div class="mt-2">
                                                <span class="paid-badge">
                                                    <i class="fas fa-check-circle me-1"></i>
                                                    PAID
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row align-items-center">
                                        <div class="col-md-8">
                                            <span class="status-indicator status-paid">
                                                <i class="fas fa-receipt me-1"></i>
                                                Payment completed
                                            </span>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <div class="action-buttons">
                                                <!-- View Receipt Button -->
                                                <!--<a href="/patient/claim/${bill.claimId}?patientId=${patientId}" 
                                                   class="btn btn-outline-success btn-sm">
                                                    <i class="fas fa-file-invoice me-1"></i>View Receipt
                                                </a>-->
												<a href="/patient/receipt/${bill.claimId}?patientId=${patientId}" 
												   class="btn btn-outline-success btn-sm">
												   <i class="fas fa-file-invoice me-1"></i>View Receipt
												</a>
                                                <button class="btn btn-outline-secondary btn-sm" 
                                                        onclick="downloadReceipt(${bill.claimId})">
                                                    <i class="fas fa-download me-1"></i>Download
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <!-- Paid Summary -->
                            <div class="alert alert-light mt-4">
                                <div class="row">
                                    <div class="col-md-8">
                                        <h6><i class="fas fa-chart-line me-2"></i>Payment History</h6>
                                        <p class="mb-0 small">
                                            You've paid <strong>${paidBills.size()} bills</strong>
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <button class="btn btn-outline-primary" onclick="window.print()">
                                            <i class="fas fa-print me-2"></i>Print History
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                        </c:when>
                        <c:otherwise>
                            <!-- Empty State for Paid Bills -->
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-history"></i>
                                </div>
                                <h4>No Payment History</h4>
                                <p class="text-muted mb-4">
                                    You haven't paid any bills yet through this portal.
                                </p>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Paid bills will appear here after you complete payments.
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Payment Information -->
            <div class="card bg-light mt-4">
                <div class="card-body">
                    <h5 class="card-title mb-3">
                        <i class="fas fa-credit-card me-2"></i>Payment Information
                    </h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <h6><i class="fas fa-shield-alt me-2"></i>Secure Payments</h6>
                                <p class="small text-muted mb-0">
                                    All payments are processed securely using 256-bit SSL encryption. 
                                    We never store your full payment details.
                                </p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <h6><i class="fas fa-question-circle me-2"></i>Need Help?</h6>
                                <p class="small text-muted mb-0">
                                    Contact our billing department at 
                                    <strong>(555) 123-4567</strong> or email 
                                    <strong>billing@healthportal.com</strong>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
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
                        <c:if test="${totalPendingAmount > 0}">
                            <div class="btn-group">
                                <button type="button" class="btn btn-light" onclick="setupAutoPay()">
                                    <i class="fas fa-sync-alt me-2"></i>Setup Auto-Pay
                                </button>
                                <button type="button" class="btn btn-light" onclick="schedulePayment()">
                                    <i class="fas fa-calendar-plus me-2"></i>Schedule Payment
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
                <i class="fas fa-money-bill-wave me-1"></i>
                Health Insurance CoB System &copy; 2024 | 
                Patient: ${patientName}
            </p>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Initialize tabs
        document.addEventListener('DOMContentLoaded', function() {
            const triggerTabList = [].slice.call(document.querySelectorAll('#billsTab button'));
            triggerTabList.forEach(function (triggerEl) {
                const tabTrigger = new bootstrap.Tab(triggerEl);
                triggerEl.addEventListener('click', function (event) {
                    event.preventDefault();
                    tabTrigger.show();
                });
            });
        });
        
        // Download receipt function
        function downloadReceipt(claimId) {
            alert('Receipt download for claim #' + claimId + ' would start here. In a real app, this would generate a PDF.');
        }
        
        // Setup auto-pay
        function setupAutoPay() {
            alert('Auto-pay setup would open here. This feature allows automatic payments for future bills.');
        }
        
        // Schedule payment
        function schedulePayment() {
            alert('Payment scheduling would open here. This allows you to schedule payments for a future date.');
        }
    </script>
</body>
</html>