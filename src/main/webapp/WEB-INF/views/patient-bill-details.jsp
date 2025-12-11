<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI'; }
        .card { border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
    </style>
</head>
<body>
    <div class="container mt-5">
		<a href="javascript:history.back()" class="btn btn-secondary mb-3">
		    <i class="fas fa-arrow-left me-2"></i>Back
		</a>


        <div class="card p-4">
            <h3 class="mb-3"><i class="fas fa-file-invoice-dollar me-2"></i>Bill Details</h3>

            <p><strong>Claim ID:</strong> HC-${claimId}</p>
            <p><strong>Total Billed:</strong> $${bill.billedAmount}</p>
            <p><strong>Status:</strong> ${bill.billStatus}</p>
            <p><strong>Message:</strong> ${bill.statusMessage}</p>