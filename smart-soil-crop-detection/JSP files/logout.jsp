<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate session
    session.invalidate();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Logging Out...</title>
    <meta http-equiv="refresh" content="2;url=login.jsp">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url("images/bg.jpg") no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
        }

        .message-box {
            width: 400px;
            margin: 150px auto;
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.2);
        }

        h2 {
            color: green;
        }

        p {
            font-size: 16px;
            color: #555;
        }
    </style>
</head>
<body>
    <div class="message-box">
        <h2>You have been logged out</h2>
        <p>Redirecting to login page...</p>
    </div>
</body>
</html>
