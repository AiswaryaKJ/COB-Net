<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payer Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f0f8ff; margin:0; }
        header { background:#17a2b8; color:#fff; padding:15px; text-align:center; }
        .container { padding:30px; }
        .card { background:#fff; padding:20px; margin:15px 0; border-radius:8px; box-shadow:0 4px 10px rgba(0,0,0,0.1); }
        h2 { color:#17a2b8; }
    </style>
</head>
<body>
<header>
    <h1>Payer Dashboard</h1>
</header>
<div class="container">
    <h2>Welcome, Payer</h2>
    <p>${message}</p>
    <div class="card">
        <h3>Billing</h3>
        <p>View invoices and manage payments.</p>
    </div>
    <div class="card">
        <h3>Claims</h3>
        <p>Track insurance claims and reimbursements.</p>
    </div>
    <a href="/auth/login">Logout</a>
</div>
</body>
</html>
