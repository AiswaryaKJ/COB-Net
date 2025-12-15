<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Receipt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="card">
        <div class="card-header bg-success text-white">
            <h4><i class="fas fa-receipt"></i> Payment Receipt</h4>
        </div>
        <div class="card-body">
            <h5>Transaction: ${paymentDetails.transactionId}</h5>
            <p><strong>Status:</strong> ${paymentDetails.status}</p>
            <p><strong>Paid on:</strong> ${paymentDetails.paymentDate}</p>
            <p><strong>Method:</strong> ${paymentDetails.paymentMethod}</p>
            <hr>
            <h4 class="text-success">Paid: $<fmt:formatNumber value="${paymentDetails.amountPaid}" pattern="#,##0.00"/></h4>
            <a href="/patient/bills?patientId=${patientId}" class="btn btn-primary">Back to Bills</a>
            <button onclick="window.print()" class="btn btn-secondary">Print Receipt</button>
        </div>
    </div>
</div>
</body>
</html>