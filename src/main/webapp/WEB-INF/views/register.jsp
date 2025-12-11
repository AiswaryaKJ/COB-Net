<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>COBNet - Register</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; }
        .container { width: 400px; margin: 50px auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
        h2 { text-align: center; margin-bottom: 20px; }
        input, select, button { width: 100%; padding: 10px; margin: 8px 0; border-radius: 6px; border: 1px solid #ccc; }
        button { background: #0d6efd; color: #fff; font-weight: bold; border: none; cursor: pointer; }
        button:hover { background: #0b5ed7; }
        .error { color: red; text-align: center; }
        .success { color: green; text-align: center; }
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
    <h2>Register</h2>
    <form action="/auth/register" method="post">
        <input type="text" name="username" placeholder="Choose a username" required/>
        <input type="password" name="password" placeholder="Choose a password" required/>

        <select name="role" required onchange="toggleIdField(this.value)">
            <option value="">Select Role</option>
            <option value="PATIENT">Patient</option>
            <option value="PROVIDER">Provider</option>
        </select>

        <div id="patientField" style="display:none;">
            <input type="number" name="patientId" placeholder="Enter Patient ID"/>
        </div>

        <div id="providerField" style="display:none;">
            <input type="number" name="providerId" placeholder="Enter Provider ID"/>
        </div>

        <button type="submit">Register</button>
    </form>

    <div class="error">${error}</div>
    <div class="success">${message}</div>
</div>
</body>
</html>
