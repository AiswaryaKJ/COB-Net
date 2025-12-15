<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Claims History</title>
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
        .claims-card { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); 
        }
        .filter-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }
        .claim-row {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
            position: relative;
        }
        .claim-row:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .claim-row.submitted { border-left: 4px solid #ffc107; }
        .claim-row.processed { border-left: 4px solid #17a2b8; }
        .claim-row.paid { border-left: 4px solid #28a745; }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
        }
        .badge-submitted { background-color: #ffc107; color: #212529; }
        .badge-processed { background-color: #17a2b8; color: white; }
        .badge-paid { background-color: #28a745; color: white; }
        .badge-denied { background-color: #dc3545; color: white; }
        .action-btn {
            padding: 6px 15px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        .action-btn:hover {
            transform: translateY(-2px);
        }
        .pagination-custom .page-link {
            border-radius: 8px;
            margin: 0 3px;
            border: none;
            color: #495057;
        }
        .pagination-custom .page-item.active .page-link {
            background-color: #007bff;
            color: white;
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
        .stats-card {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .stats-value {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        .search-box {
            position: relative;
        }
        .search-box input {
            padding-left: 40px;
            border-radius: 8px;
        }
        .search-box i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        .amount-cell {
            font-weight: 600;
            font-size: 1.1rem;
        }
        .provider-cell {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
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
                <i class="fas fa-file-medical me-2"></i>Claims History
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <div class="claims-card">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3><i class="fas fa-file-medical me-2"></i>Your Medical Claims</h3>
                    <p class="text-muted mb-0">${patientName} - View and manage your claims</p>
                </div>
                <div class="text-end">
                    <a href="/patient/bills?patientId=${patientId}" class="btn btn-success">
                        <i class="fas fa-money-bill-wave me-2"></i>Pay Bills
                    </a>
                </div>
            </div>
            
			<!-- Statistics -->
			<div class="row mb-4">
			    <div class="col-md-3">
			        <div class="stats-card">
			            <div class="stats-value">${claims.size()}</div>
			            <div class="stats-label">Total Claims</div>
			            <i class="fas fa-file-medical-alt mt-2"></i>
			        </div>
			    </div>
			    <div class="col-md-3">
			        <div class="stats-card" style="background: linear-gradient(135deg, #ffc107, #e0a800);">
			            <div class="stats-value">
			                <c:set var="submittedCount" value="0" />
			                <c:forEach var="claim" items="${claims}">
			                    <c:if test="${claim.status == 'submitted'}">
			                        <c:set var="submittedCount" value="${submittedCount + 1}" />
			                    </c:if>
			                </c:forEach>
			                ${submittedCount}
			            </div>
			            <div class="stats-label">Submitted</div>
			            <i class="fas fa-clock mt-2"></i>
			        </div>
			    </div>
			    <div class="col-md-3">
			        <div class="stats-card" style="background: linear-gradient(135deg, #17a2b8, #138496);">
			            <div class="stats-value">
			                <c:set var="processedCount" value="0" />
			                <c:forEach var="claim" items="${claims}">
			                    <c:if test="${claim.status == 'processed'}">
			                        <c:set var="processedCount" value="${processedCount + 1}" />
			                    </c:if>
			                </c:forEach>
			                ${processedCount}
			            </div>
			            <div class="stats-label">Processed</div>
			            <i class="fas fa-cogs mt-2"></i>
			        </div>
			    </div>
			    <div class="col-md-3">
			        <div class="stats-card" style="background: linear-gradient(135deg, #28a745, #1e7e34);">
			            <div class="stats-value">
			                <c:set var="paidCount" value="0" />
			                <c:forEach var="claim" items="${claims}">
			                    <c:if test="${claim.status == 'paid'}">
			                        <c:set var="paidCount" value="${paidCount + 1}" />
			                    </c:if>
			                </c:forEach>
			                ${paidCount}
			            </div>
			            <div class="stats-label">Paid</div>
			            <i class="fas fa-check-circle mt-2"></i>
			        </div>
			    </div>
			</div>
            
            <!-- Filters -->
            <div class="filter-card">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" class="form-control" placeholder="Search claims by ID, provider, or diagnosis..." 
                                   id="searchInput" onkeyup="filterClaims()">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="d-flex justify-content-end">
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-outline-primary active" onclick="filterByStatus('all')">All</button>
                                <button type="button" class="btn btn-outline-warning" onclick="filterByStatus('submitted')">Submitted</button>
                                <button type="button" class="btn btn-outline-info" onclick="filterByStatus('processed')">Processed</button>
                                <button type="button" class="btn btn-outline-success" onclick="filterByStatus('paid')">Paid</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <c:choose>
                <c:when test="${!empty claims}">
                    <!-- Claims List -->
                    <div id="claimsList">
                        <c:forEach var="claim" items="${claims}">
                            <div class="claim-row ${claim.status.toLowerCase()}" data-status="${claim.status.toLowerCase()}">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <div class="d-flex align-items-center">
                                            <div class="me-3">
                                                <h5 class="mb-1">
                                                    <i class="fas fa-file-medical-alt me-2"></i>
                                                    Claim #HC-${claim.claimId}
                                                </h5>
                                                <div class="text-muted small">
                                                    <i class="fas fa-calendar me-1"></i>
                                                    ${claim.claimDate} | 
                                                    <i class="fas fa-user-md me-1"></i>
                                                    <span class="provider-cell">${claim.provider.name}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="mt-2">
                                            <span class="badge bg-light text-dark me-2">
                                                <i class="fas fa-stethoscope me-1"></i>
                                                ${claim.diagnosisCode}
                                            </span>
                                            <span class="badge bg-light text-dark">
                                                <i class="fas fa-procedures me-1"></i>
                                                ${claim.procedureCode}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="text-end">
                                            <!-- Status Badge -->
                                            <div class="mb-2">
                                                <span class="status-badge badge-${claim.status.toLowerCase()}">
                                                    <c:choose>
                                                        <c:when test="${claim.status == 'submitted'}">
                                                            <i class="fas fa-clock me-1"></i>Pending
                                                        </c:when>
                                                        <c:when test="${claim.status == 'processed'}">
                                                            <i class="fas fa-cogs me-1"></i>Processed
                                                        </c:when>
                                                        <c:when test="${claim.status == 'paid'}">
                                                            <i class="fas fa-check-circle me-1"></i>Paid
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${claim.status}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            
                                            <!-- Amount -->
                                            <div class="amount-cell text-primary mb-2">
                                                $<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/>
                                            </div>
                                            
                                            <!-- Actions -->
                                            <div class="d-flex justify-content-end gap-2">
                                                <a href="/patient/claim/${claim.claimId}?patientId=${patientId}" 
                                                   class="action-btn btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-eye me-1"></i>Details
                                                </a>
                                                
                                                <c:choose>
                                                    <c:when test="${claim.status == 'processed'}">
                                                        <!-- Show EOB button if available -->
                                                        <a href="/patient/eob/${claim.claimId}?patientId=${patientId}" 
                                                           class="action-btn btn btn-sm btn-outline-info">
                                                            <i class="fas fa-file-invoice-dollar me-1"></i>View EOB
                                                        </a>
                                                        <!-- Pay button -->
                                                        <a href="/patient/pay?patientId=${patientId}&claimId=${claim.claimId}" 
                                                           class="action-btn btn btn-sm btn-success">
                                                            <i class="fas fa-money-bill-wave me-1"></i>Pay
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${claim.status == 'paid'}">
                                                        <!-- View EOB for paid claims -->
                                                        <a href="/patient/eob/${claim.claimId}?patientId=${patientId}" 
                                                           class="action-btn btn btn-sm btn-outline-success">
                                                            <i class="fas fa-file-invoice me-1"></i>Receipt
                                                        </a>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Summary -->
                    <div class="alert alert-light mt-4">
                        <div class="row">
                            <div class="col-md-6">
                                <h6><i class="fas fa-info-circle me-2"></i>Claim Status Guide</h6>
                                <div class="row">
                                    <div class="col-4">
                                        <span class="badge-submitted status-badge d-inline-block mb-1">Pending</span>
                                        <small class="text-muted d-block">Awaiting insurance processing</small>
                                    </div>
                                    <div class="col-4">
                                        <span class="badge-processed status-badge d-inline-block mb-1">Processed</span>
                                        <small class="text-muted d-block">EOB available, bill ready</small>
                                    </div>
                                    <div class="col-4">
                                        <span class="badge-paid status-badge d-inline-block mb-1">Paid</span>
                                        <small class="text-muted d-block">Payment completed</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-question-circle me-2"></i>Need Help?</h6>
                                <p class="mb-0 small">
                                    If you have questions about a claim, contact our billing department at 
                                    <strong>(555) 123-4567</strong> or email <strong>claims@healthportal.com</strong>
                                </p>
                            </div>
                        </div>
                    </div>
                    
                </c:when>
                <c:otherwise>
                    <!-- Empty State -->
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-file-medical"></i>
                        </div>
                        <h4>No Claims Found</h4>
                        <p class="text-muted mb-4">
                            You haven't submitted any medical claims yet.
                        </p>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Claims will appear here after you receive medical services and your provider submits them to insurance.
                        </div>
                        <a href="/patient/dashboard?patientId=${patientId}" class="btn btn-primary mt-3">
                            <i class="fas fa-home me-2"></i>Back to Dashboard
                        </a>
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
                        <a href="/patient/policies?patientId=${patientId}" class="btn btn-outline-primary ms-2">
                            <i class="fas fa-shield-alt me-2"></i>View Policies
                        </a>
                    </div>
                    <div class="col-md-6 text-end">
                        <div class="btn-group">
                            <button type="button" class="btn btn-light" onclick="window.print()">
                                <i class="fas fa-print me-2"></i>Print List
                            </button>
                            <button type="button" class="btn btn-light">
                                <i class="fas fa-download me-2"></i>Export
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
                Patient: ${patientName}
            </p>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Filter claims by status
        function filterByStatus(status) {
            const claims = document.querySelectorAll('.claim-row');
            const buttons = document.querySelectorAll('.btn-group .btn');
            
            // Update active button
            buttons.forEach(btn => {
                if (btn.textContent.toLowerCase().includes(status) || 
                    (status === 'all' && btn.textContent.includes('All'))) {
                    btn.classList.add('active');
                } else {
                    btn.classList.remove('active');
                }
            });
            
            // Show/hide claims
            claims.forEach(claim => {
                if (status === 'all' || claim.dataset.status === status) {
                    claim.style.display = 'block';
                } else {
                    claim.style.display = 'none';
                }
            });
        }
        
        // Search filter
        function filterClaims() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const claims = document.querySelectorAll('.claim-row');
            
            claims.forEach(claim => {
                const text = claim.textContent.toLowerCase();
                if (text.includes(filter)) {
                    claim.style.display = 'block';
                } else {
                    claim.style.display = 'none';
                }
            });
        }
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Add click handlers to status filter buttons
            document.querySelectorAll('.btn-group .btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    const status = this.textContent.toLowerCase();
                    filterByStatus(status);
                });
            });
        });
    </script>
</body>
</html>

