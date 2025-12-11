<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Claim Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Claim Details</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">${error}</div>
        <% } %>
        <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success">${message}</div>
        <% } %>
        
        <% com.example.demo.bean.Claim claim = (com.example.demo.bean.Claim) request.getAttribute("claim");
           if (claim != null) { %>
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Claim ID: ${claim.claimId}</h5>
                    <table class="table">
                        <tr><th>Patient ID:</th><td>${claim.patient.patientId}</td></tr>
                        <tr><th>Provider ID:</th><td>${claim.provider.providerId}</td></tr>
                        <tr><th>Billed Amount:</th><td>$${claim.billedAmount}</td></tr>
                        <tr><th>Claim Date:</th><td>${claim.claimDate}</td></tr>
                        <tr><th>Diagnosis Code:</th><td>${claim.diagnosisCode != null ? claim.diagnosisCode : 'N/A'}</td></tr>
                        <tr><th>Procedure Code:</th><td>${claim.procedureCode != null ? claim.procedureCode : 'N/A'}</td></tr>
                        <tr><th>Status:</th><td>${claim.status}</td></tr>
                        <tr><th>Final Out of Pocket:</th><td>${claim.finalOutOfPocket != null ? '$' + claim.finalOutOfPocket : 'N/A'}</td></tr>
                    </table>
                </div>
            </div>
        <% } %>
        
        <div class="mt-3">
            <a href="viewclaims" class="btn btn-secondary">Back to Claims</a>
            <a href="submitclaim" class="btn btn-primary">Submit New Claim</a>
        </div>
    </div>
</body>
</html>