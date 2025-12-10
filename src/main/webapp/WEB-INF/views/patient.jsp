<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f9f9f9; margin:0; }
        header { background:#28a745; color:#fff; padding:15px; text-align:center; }
        .container { padding:30px; }
        .card { background:#fff; padding:20px; margin:15px 0; border-radius:8px; box-shadow:0 4px 10px rgba(0,0,0,0.1); }
        h2 { color:#28a745; }
    </style>
</head>
<body>
<header>
    <h1>Patient Dashboard</h1>
</header>
<div class="container">
    <h2>Welcome, Patient</h2>
    <p>${message}</p>
    <div class="card">
        <h3>My Appointments</h3>
        <p>View upcoming appointments and book new ones.</p>
    </div>
    <div class="card">
        <h3>Medical History</h3>
        <p>Review your past visits and prescriptions.</p>
    </div>
    <a href="/auth/login">Logout</a>
</div>
</body>
</html>
