<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .bill-header { background: #f8f9fa; padding: 20px; border-radius: 10px; }
        .amount-due { font-size: 2rem; color: #dc3545; font-weight: bold; }
        .due-date { color: #ffc107; font-weight: bold; }
    </style>
</head>
<body>
<nav class="navbar navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="/patient/bills?patientId=${patientId}">
            <i class="fas fa-arrow-left"></i> Back to Bills
        </a>
    </div>
</nav>

<div class="container mt-4">
    <div class="card">
        <div class="card-header bg-primary text-white">
            <h4><i class="fas fa-file-invoice-dollar"></i> Bill Details - Claim #HC-${claim.claimId}</h4>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <h5>Patient Information</h5>
                    <p><strong>Name:</strong> ${billDetails.patientName}</p>
                    <p><strong>Claim Date:</strong> ${billDetails.serviceDate}</p>
                    
                    <h5 class="mt-4">Service Details</h5>
                    <p><strong>Provider:</strong> ${billDetails.providerName}</p>
                    <p><strong>Diagnosis:</strong> ${billDetails.diagnosis}</p>
                    <p><strong>Procedure:</strong> ${billDetails.procedure}</p>
                </div>
                
                <div class="col-md-6">
                    <div class="bill-header">
                        <h5>Billing Summary</h5>
                        <p><strong>Total Billed:</strong> $<fmt:formatNumber value="${billDetails.billedAmount}" pattern="#,##0.00"/></p>
                        <p><strong>Insurance Paid:</strong> $<fmt:formatNumber value="${billDetails.insurancePayment}" pattern="#,##0.00"/></p>
                        <hr>
                        <p class="amount-due">Amount Due: $<fmt:formatNumber value="${billDetails.amountDue}" pattern="#,##0.00"/></p>
                        <p class="due-date">Due Date: ${billDetails.dueDate}</p>
                    </div>
                    
                    <div class="mt-4">
                        <a href="/patient/pay?patientId=${patientId}&claimId=${claim.claimId}" 
                           class="btn btn-success btn-lg w-100">
                            <i class="fas fa-credit-card"></i> Pay Now
                        </a>
                        <a href="/patient/eob/${claim.claimId}?patientId=${patientId}" 
                           class="btn btn-info btn-lg w-100 mt-2">
                            <i class="fas fa-file-contract"></i> View EOB
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>