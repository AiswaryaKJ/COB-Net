<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>COBNet - Register</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #0d6efd, #6c63ff);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.2);
            width: 420px;
            text-align: center;
            animation: fadeIn 0.8s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .logo {
            font-size: 28px;
            font-weight: bold;
            color: #0d6efd;
            margin-bottom: 20px;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        input[type=text], input[type=password], input[type=number], select {
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            width: 100%;
            transition: border-color 0.3s;
        }
        input:focus, select:focus {
            border-color: #0d6efd;
            outline: none;
        }
        button {
            padding: 12px;
            margin-top: 15px;
            background: #0d6efd;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            width: 100%;
            transition: background 0.3s;
        }
        button:hover {
            background: #084298;
        }
        .toggle {
            margin-top: 15px;
            font-size: 14px;
        }
        .toggle a {
            color: #0d6efd;
            text-decoration: none;
        }
        .toggle a:hover {
            text-decoration: underline;
        }
        .error {
            color: #dc3545;
            margin-top: 10px;
            font-weight: bold;
        }
        .success {
            color: #198754;
            margin-top: 10px;
            font-weight: bold;
        }
    </style>
    <script>
        function toggleIdField(role) {
            document.getElementById("patientField").style.display = (role === "PATIENT") ? "block" : "none";
            document.getElementById("providerField").style.display = (role === "PROVIDER") ? "block" : "none";
        }
    </script>
</head>
<body>
<div class="container">
    <div class="logo">COBNet</div>
    <h2>Create Your Account</h2>
    <form action="/auth/register" method="post">
        <input type="text" name="username" placeholder="👤 Username" required/>
        <input type="password" name="password" placeholder="🔒 Password" required/>

        <select name="role" required onchange="toggleIdField(this.value)">
            <option value="">Select Role</option>
            <option value="PATIENT">Patient</option>
            <option value="PROVIDER">Provider</option>
        </select>

        <div id="patientField" style="display:none;">
            <input type="number" name="patientId" placeholder="🆔 Patient ID"/>
        </div>

        <div id="providerField" style="display:none;">
            <input type="number" name="providerId" placeholder="🆔 Provider ID"/>
        </div>

        <button type="submit">🚀 Register</button>
    </form>

    <div class="error">${error}</div>
    <div class="success">${message}</div>

    <div class="toggle">
        Already have an account? <a href="/auth/login">Login here</a>
    </div>
</div>
</body>
</html>
