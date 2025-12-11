<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.demo.bean.Claim" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Processed Claims</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI'; }
        .container-custom { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .claim-card { background: white; border-radius: 10px; padding: 20px; margin-bottom: 20px; box-shadow: 0 3px 10px rgba(0,0,0,0.05); border-left: 4px solid #28a745; }
    </style>
</head>
<body>
    <div class="container-custom">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-history me-2"></i>Processed Claims</h2>
            <a href="dashboard" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
        
        <% 
            List<Claim> processedClaims = (List<Claim>) request.getAttribute("processedClaims");
            if (processedClaims != null && !processedClaims.isEmpty()) {
        %>
            <!-- Processed Claims List -->
            <% for (Claim claim : processedClaims) { %>
                <div class="claim-card">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h5>Claim #HC-<%= claim.getClaimId() %></h5>
                            <p class="mb-2">
                                <strong>Patient:</strong> 
                                <%= claim.getPatient().getFirstName() %> <%= claim.getPatient().getLastName() %>
                                | <strong>Provider:</strong> 
                                <%= claim.getProvider() != null ? claim.getProvider().getName() : "N/A" %>
                            </p>
                            <p class="mb-2">
                                <strong>Billed Amount:</strong> $<%= String.format("%.2f", claim.getBilledAmount()) %>
                                | <strong>Patient Responsibility:</strong> $<%= String.format("%.2f", claim.getFinalOutOfPocket()) %>
                            </p>
                            <p class="mb-0">
                                <strong>Processed Date:</strong> <%= claim.getClaimDate() %>
                                | <strong>Status:</strong> <span class="badge bg-success">Processed</span>
                            </p>
                        </div>
                        <div class="col-md-4 text-end">
                            <a href="settlement/<%= claim.getClaimId() %>" class="btn btn-info">
                                <i class="fas fa-file-invoice-dollar me-2"></i>View Settlement
                            </a>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="alert alert-info text-center py-5">
                <i class="fas fa-file fa-3x mb-3"></i>
                <h4>No Processed Claims</h4>
                <p>No claims have been processed yet.</p>
            </div>
        <% } %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>