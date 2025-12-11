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
        .bill-status { padding: 5px 12px; border-radius: 20px; font-weight: 600; font-size: 0.85rem; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-waiting { background: #d1ecf1; color: #0c5460; }
        .status-processed { background: #d4edda; color: #155724; }
        .tabs { display: flex; border-bottom: 2px solid #dee2e6; margin-bottom: 20px; }
        .tab { padding: 10px 20px; cursor: pointer; border-bottom: 3px solid transparent; }
        .tab.active { border-bottom-color: #007bff; font-weight: 600; color: #007bff; }
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
                        <i class="fas fa-clock me-2"></i>Pending (${pendingCount})
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
        
        <!-- All Bills -->
        <% 
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
                    <div><span class="bill-status status-pending">Pending Payment</span> - Copay not paid yet</div>
                    <div><span class="bill-status status-waiting">Waiting for Processing</span> - Copay paid, waiting for provider</div>
                    <div><span class="bill-status status-processed">Processed</span> - Claim processed by provider</div>
                </div>
            </div>
            
            <!-- All Bills List -->
            <% for (Map<String, Object> bill : allBills) { 
                int claimId = (int) bill.get("claimId");
                double billedAmount = (double) bill.get("billedAmount");
                String billStatus = (String) bill.get("billStatus");
                String statusMessage = (String) bill.get("statusMessage");
                Double copayAmount = (Double) bill.get("copayAmount");
                Double outOfPocket = (Double) bill.get("finalOutOfPocket");
                String statusClass = "";
                
                if ("Pending Payment".equals(billStatus)) {
                    statusClass = "status-pending";
                } else if ("Waiting for Processing".equals(billStatus)) {
                    statusClass = "status-waiting";
                } else if ("Processed".equals(billStatus)) {
                    statusClass = "status-processed";
                }
            %>
                <div class="bill-card">
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
                                <strong>Total Bill:</strong> $<%= String.format("%.2f", billedAmount) %>
                                <% if (copayAmount != null && outOfPocket == null) { %>
                                    • <strong>Your Copay:</strong> $<%= String.format("%.2f", copayAmount) %>
                                <% } else if (outOfPocket != null) { %>
                                    • <strong>You Paid:</strong> $<%= String.format("%.2f", outOfPocket) %>
                                <% } %>
                            </p>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="mb-2">
                                <span class="bill-status <%= statusClass %>"><%= billStatus %></span>
                            </div>
                            <div class="btn-group">
                                <a href="bill/details?patientId=${patientId}&claimId=<%= claimId %>" 
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-eye me-1"></i>View Details
                                </a>
                                <% if ("Pending Payment".equals(billStatus) && copayAmount != null) { %>
									<a href="/patient/pay?patientId=${patientId}&claimId=<%= claimId %>" 
									   class="btn btn-sm btn-success">
									    <i class="fas fa-credit-card me-1"></i>Pay Copay
									</a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <div class="mt-2">
                        <small class="text-muted"><%= statusMessage %></small>
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