<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Provider Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background:#eef2f7; margin:0; }
        header { background:#0069d9; color:#fff; padding:15px; text-align:center; }
        .container { padding:30px; }
        .card { background:#fff; padding:20px; margin:15px 0; border-radius:8px; box-shadow:0 4px 10px rgba(0,0,0,0.1); }
        h2 { color:#0069d9; }
    </style>
</head>
<body>
<header>
    <h1>Provider Dashboard</h1>
</header>
<div class="container">
    <h2>Welcome, Provider</h2>
    <p>${message}</p>
    <div class="card">
        <h3>Appointments</h3>
        <p>Manage patient appointments and schedules.</p>
    </div>
    <div class="card">
        <h3>Patient Records</h3>
        <p>Access and update patient medical records.</p>
    </div>
    <a href="/auth/login">Logout</a>
</div>
</body>
</html>
