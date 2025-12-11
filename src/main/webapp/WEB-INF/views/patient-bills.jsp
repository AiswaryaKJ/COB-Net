<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Bills</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI'; }
        .container-custom { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .navbar-custom { background: linear-gradient(135deg, #2c3e50, #3498db); }
        .summary-card { background: white; border-radius: 15px; padding: 25px; margin-bottom: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .bill-card { background: white; border-radius: 15px; padding: 20px; margin-bottom: 20px; box-shadow: 0 3px 10px rgba(0,0,0,0.05); }
        .bill-status {
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
        }
        .status-submitted { 
            background: #fff3cd; 
            color: #856404; 
        }
        .status-processed { 
            background: #d4edda; 
            color: #155724; 
        }
        .status-denied { 
            background: #f8d7da; 
            color: #721c24; 
        }
        .status-paid { 
            background: #cce5ff; 
            color: #004085; 
        }
        .processing-alert {
            background-color: #e7f1ff;
            border-left: 4px solid #0d6efd;
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="dashboard?patientId=${patientId}">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-file-invoice-dollar me-2"></i>Medical Bills
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <!-- Summary Card -->
        <div class="summary-card">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h3><i class="fas fa-file-medical me-2"></i>Your Medical Bills</h3>
                    <p class="text-muted">View all your medical bills and payment status</p>
                </div>
                <div class="col-md-4 text-end">
                    <a href="bills/pending?patientId=${patientId}" class="btn btn-warning me-2">
                        <i class="fas fa-clock me-2"></i>Submitted (${pendingCount})
                    </a>
                    <a href="bills/history?patientId=${patientId}" class="btn btn-success">
                        <i class="fas fa-history me-2"></i>History (${historyCount})
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Success/Error Messages -->
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle me-2"></i>
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle me-2"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% 
            // DECLARE the allBills variable
            Object billsObj = request.getAttribute("allBills");
            List<Map<String, Object>> allBills = null;
            
            if (billsObj instanceof List) {
                allBills = (List<Map<String, Object>>) billsObj;
            }
            
            if (allBills != null && !allBills.isEmpty()) {
        %>
            <!-- Bill Status Legend -->
            <div class="alert alert-light mb-4">
                <h6 class="mb-2"><i class="fas fa-info-circle me-2"></i>Bill Status Legend:</h6>
                <div class="d-flex flex-wrap gap-3">
                    <div><span class="bill-status status-submitted">Submitted</span> - Claim submitted, processing in progress</div>
                    <div><span class="bill-status status-processed">Processed</span> - Claim processed by provider</div>
                    <div><span class="bill-status status-denied">Denied</span> - Claim denied by insurance</div>
                    <div><span class="bill-status status-paid">Paid</span> - Claim fully paid</div>
                </div>
            </div>
            
            <!-- All Bills List -->
            <% for (Map<String, Object> bill : allBills) { 
                int claimId = (int) bill.get("claimId");
                double billedAmount = (double) bill.get("billedAmount");
                String billStatus = (String) bill.get("billStatus");
                String statusMessage = (String) bill.get("statusMessage");
                Double outOfPocket = (Double) bill.get("finalOutOfPocket");
                String statusClass = "";
                
                // Get status from actual claim status
                String claimStatus = (String) bill.get("status");
                
                if ("Submitted".equals(claimStatus)) {
                    statusClass = "status-submitted";
                } else if ("Processed".equals(claimStatus)) {
                    statusClass = "status-processed";
                } else if ("Denied".equals(claimStatus)) {
                    statusClass = "status-denied";
                } else if ("Paid".equals(claimStatus)) {
                    statusClass = "status-paid";
                }
            %>
                <div class="bill-card">
                    <!-- Processing Notification for Submitted Claims -->
                    <% if ("Submitted".equals(claimStatus)) { %>
                        <div class="processing-alert">
                            <i class="fas fa-sync-alt fa-spin me-2"></i>
                            <strong>Processing:</strong> This claim is currently being processed. 
                            The final amount will be calculated after insurance review.
                        </div>
                    <% } %>
                    
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h5 class="mb-1">Claim #HC-<%= claimId %></h5>
                            <p class="text-muted mb-2">
                                <i class="fas fa-calendar me-1"></i>
                                <%= bill.get("claimDate") != null ? bill.get("claimDate") : "N/A" %>
                                <% if (bill.get("providerName") != null) { %>
                                    • <i class="fas fa-user-md me-1"></i><%= bill.get("providerName") %>
                                <% } %>
                            </p>
							<p class="mb-0">
							    <strong>Billed Amount:</strong> $<%= String.format("%.2f", billedAmount) %>
							    <% if (outOfPocket != null && outOfPocket > 0 && !"Submitted".equals(claimStatus)) { %>
							        • <strong>Amount Due:</strong> $<%= String.format("%.2f", outOfPocket) %>
							    <% } else if (outOfPocket != null && outOfPocket == 0 && !"Submitted".equals(claimStatus)) { %>
							        • <strong>Insurance Covered:</strong> Full amount
							    <% } %>
							</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="mb-2">
                                <span class="bill-status <%= statusClass %>"><%= claimStatus %></span>
                            </div>
                            <div class="btn-group">
                                <a href="bill/details?patientId=${patientId}&claimId=<%= claimId %>" 
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-eye me-1"></i>View Details
                                </a>
<<<<<<< HEAD
                                <!-- Payment button only for Processed status with amount due -->
                                <% if ("Processed".equals(claimStatus) && outOfPocket != null && outOfPocket > 0) { %>
                                    <a href="pay?patientId=${patientId}&claimId=<%= claimId %>" 
                                       class="btn btn-sm btn-success">
                                        <i class="fas fa-credit-card me-1"></i>Pay Now
                                    </a>
=======
                                <% if ("Pending Payment".equals(billStatus) && copayAmount != null) { %>
									<a href="/patient/pay?patientId=${patientId}&claimId=<%= claimId %>" 
									   class="btn btn-sm btn-success">
									    <i class="fas fa-credit-card me-1"></i>Pay Copay
									</a>
>>>>>>> 69f0cfad08c147efed0b8b2186104e80f39902e5
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <div class="mt-2">
                        <small class="text-muted"><i class="fas fa-info-circle me-1"></i><%= statusMessage %></small>
                    </div>
                </div>
            <% } %>
            
        <% } else { %>
            <div class="text-center py-5">
                <i class="fas fa-file-invoice fa-4x text-muted mb-3"></i>
                <h4>No Bills Found</h4>
                <p class="text-muted">You don't have any medical bills at this time.</p>
            </div>
        <% } %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>