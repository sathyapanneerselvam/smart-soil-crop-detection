<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
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
            margin: 80px auto;
            max-width: 400px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
        }

        h2 {
            text-align: center;
            color: green;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        input[type="text"], input[type="email"], input[type="password"] {
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            padding: 12px;
            background-color: green;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
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
    <h2>Create Your Account</h2>
    <form action="register" method="post">

        <input type="text" name="username" placeholder="Username" required />
        <input type="email" name="email" placeholder="Email" required />
        <input type="password" name="password" placeholder="Password" required />
        <button type="submit">Register</button>
    </form>

    <div class="link">
        Already have an account? <a href="login.jsp">Login here</a>
    </div>
</div>

</body>
</html>
