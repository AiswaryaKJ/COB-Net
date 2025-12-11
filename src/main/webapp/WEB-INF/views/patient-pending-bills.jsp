<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Bills</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .container-custom { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        .navbar-custom { background: linear-gradient(135deg, #2c3e50, #3498db); }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="bills?patientId=${patientId}">
                <i class="fas fa-arrow-left me-2"></i>All Bills
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-clock me-2"></i>Pending Bills
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <h3 class="mb-4">Pending Bills Requiring Payment</h3>
        
        <% 
            Object billsObj = request.getAttribute("pendingBills");
            List<Map<String, Object>> pendingBills = null;
            
            if (billsObj instanceof List) {
                pendingBills = (List<Map<String, Object>>) billsObj;
            }
            
            if (pendingBills != null && !pendingBills.isEmpty()) {
        %>
            <% for (Map<String, Object> bill : pendingBills) { 
                int claimId = (int) bill.get("claimId");
                Double copayAmount = (Double) bill.get("copayAmount");
            %>
                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Claim #HC-<%= claimId %></h5>
                        <p class="card-text">
                            <strong>Total Bill:</strong> $<%= String.format("%.2f", bill.get("billedAmount")) %><br>
                            <strong>Your Copay Due:</strong> $<%= String.format("%.2f", copayAmount) %>
                        </p>
                        <a href="pay?patientId=${patientId}&claimId=<%= claimId %>" 
                           class="btn btn-primary">
                            <i class="fas fa-credit-card me-1"></i>Pay Copay
                        </a>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle me-2"></i>
                You have no pending bills requiring payment.
            </div>
        <% } %>
    </div>
</body>
</html>