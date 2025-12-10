<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>COBNet - Login</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #007bff, #00c6ff);
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
            color: #007bff;
            margin-bottom: 20px;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        input[type=text], input[type=password] {
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            width: 100%;
        }
        button {
            padding: 12px;
            margin-top: 15px;
            background: #007bff;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            width: 100%;
        }
        button:hover {
            background: #0056b3;
        }
        .toggle {
            margin-top: 15px;
        }
        .toggle a {
            color: #007bff;
            text-decoration: none;
        }
        .toggle a:hover {
            text-decoration: underline;
        }
        .error {
            color: red;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="logo">COBNet</div>
    <h2>Login</h2>
    <form action="/auth/login" method="post">
        <input type="text" name="username" placeholder="Username" required/>
        <input type="password" name="password" placeholder="Password" required/>
        <button type="submit">Login</button>
    </form>
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
    <div class="toggle">
        <p>New user? <a href="/auth/register">Register here</a></p>
    </div>
</div>
</body>
</html>
