<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>

    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body {
            font-family: Arial, sans-serif;
            background: url("images/bg.jpg") no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            margin: 100px auto;
            max-width: 350px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
        }

        h2 {
            text-align: center;
            color: green;
        }

        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }

        input[type="text"],
        input[type="password"] {
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            width: 100%;
            box-sizing: border-box;
        }

        .password-container {
            position: relative;
            margin-bottom: 10px;
        }

        .password-container input {
            width: 100%;
            padding-right: 40px;
            box-sizing: border-box;
        }

        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #555;
        }

        button {
            padding: 12px;
            background-color: green;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            width: 100%;
        }

        button:hover {
            background-color: darkgreen;
        }

        .link {
            text-align: center;
            margin-top: 15px;
        }

        .link a {
            color: #007bff;
            text-decoration: none;
        }

        .link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Login</h2>

    <% 
        String error = request.getParameter("error");
        if ("1".equals(error)) {
    %>
        <p class="error-message">Invalid username or password!</p>
    <% } %>

    <form action="login" method="post">
        <input type="text" name="username" placeholder="Username or Email" required />

        <div class="password-container">
            <input type="password" name="password" id="password" placeholder="Password" required />
            <i class="fas fa-eye toggle-password" id="togglePassword" onclick="togglePassword()"></i>
        </div>

        <button type="submit">Login</button>
    </form>

    <div class="link">
        Don’t have an account? <a href="register.jsp">Register here</a>
    </div>
</div>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById("password");
        const toggleIcon = document.getElementById("togglePassword");

        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            toggleIcon.classList.remove("fa-eye");
            toggleIcon.classList.add("fa-eye-slash");
        } else {
            passwordInput.type = "password";
            toggleIcon.classList.remove("fa-eye-slash");
            toggleIcon.classList.add("fa-eye");
        }
    }
</script>

</body>
</html>
