<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>COBNet - Register</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #28a745, #85e085);
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
            width: 400px;
            text-align: center;
        }
        .logo {
            font-size: 28px;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 20px;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        input[type=text], input[type=password], select {
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            width: 100%;
        }
        button {
            padding: 12px;
            margin-top: 15px;
            background: #28a745;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            width: 100%;
        }
        button:hover {
            background: #218838;
        }
        .toggle {
            margin-top: 15px;
        }
        .toggle a {
            color: #28a745;
            text-decoration: none;
        }
        .toggle a:hover {
            text-decoration: underline;
        }
        .success {
            color: green;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="logo">COBNet</div>
    <h2>Register</h2>
    <form action="/auth/register" method="post">
        <input type="text" name="username" placeholder="Choose a username" required/>
        <input type="password" name="password" placeholder="Choose a password" required/>
        <select name="role" required>
            <option value="">Select Role</option>
            <option value="ADMIN">Admin</option>
            <option value="PROVIDER">Provider</option>
            <option value="PATIENT">Patient</option>
            <option value="PAYER">Payer</option>
        </select>
        <button type="submit">Register</button>
    </form>
    <c:if test="${not empty message}">
        <div class="success">${message}</div>
    </c:if>
    <div class="toggle">
        <p>Already have an account? <a href="/auth/login">Login here</a></p>
    </div>
</div>
</body>
</html>
