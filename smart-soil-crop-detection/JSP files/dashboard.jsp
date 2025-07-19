<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*, java.util.*" %>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");

    String[] quotes = {
        "“To forget how to dig the earth and to tend the soil is to forget ourselves.” – Mahatma Gandhi",
        "“The ultimate goal of farming is not the growing of crops, but the cultivation of human beings.” – Masanobu Fukuoka",
        "“Agriculture is the most healthful, most useful and most noble employment of man.” – George Washington",
        "“Farming is a profession of hope.” – Brian Brett",
        "“The farmer is the only man in our economy who buys everything at retail, sells everything at wholesale, and pays the freight both ways.” – John F. Kennedy"
    };
    Random rand = new Random();
    String quote = quotes[rand.nextInt(quotes.length)];
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: url("images/bg.jpg") no-repeat center center fixed;
            background-size: cover;
        }

        .container {
            max-width: 1000px;
            margin: 80px auto;
            padding: 30px;
            background: rgba(255, 255, 255, 0.85);
            border-radius: 16px;
            box-shadow: 0 0 20px rgba(0, 128, 0, 0.2);
            text-align: center;
        }

        .user-info {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 25px;
        }

        .user-info img {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin-right: 15px;
            border: 2px solid green;
        }

        .user-info h2 {
            color: #2f8f2f;
            margin: 0;
        }

        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .card {
            padding: 25px;
            background-color: #f5fff5;
            border: 2px solid #e0f2e0;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }

        .card:hover {
            transform: translateY(-5px);
            background-color: #ebfdeb;
        }

        .card i {
            font-size: 30px;
            color: #2f8f2f;
            margin-bottom: 10px;
        }

        .card h3 {
            margin: 10px 0;
            color: #2f8f2f;
        }

        .card p {
            font-size: 14px;
            color: #555;
        }

        .card a {
            display: inline-block;
            margin-top: 15px;
            padding: 8px 16px;
            background-color: #2f8f2f;
            color: white;
            border-radius: 6px;
            text-decoration: none;
        }

        .card a:hover {
            background-color: #256b25;
        }

       .footer {
        background: rgba(230, 255, 230, 0.85); /* ⬅ updated here */
        margin-top: 50px;
        padding: 20px;
        text-align: center;
        border-top: 2px solid #c2f0c2;
    }

    .quote {
        font-style: italic;
        font-size: 16px;
        color: #006600;
        margin-bottom: 10px;
        animation: fadeIn 2s ease-in-out;
    }

    .footer-animation {
        margin-top: 15px;
    }

    @keyframes fadeIn {
        0% { opacity: 0; transform: translateY(10px); }
        100% { opacity: 1; transform: translateY(0); }
    }

    .copyright {
        font-size: 13px;
        color: #444;
        margin-top: 15px;
    }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container">
    <div class="user-info">
        <img src="images/user.png" alt="User Image" />
        <h2>Welcome, <%= username %> 👋</h2>
    </div>

    <div class="card-grid">
     <div class="card">
            <i class="fas fa-search-location"></i>
            <h3>Detect Crop</h3>
            <p>Get crops based on soil type and harvesting time.</p>
            <a href="detect.jsp">Detect</a>
        </div>
        <div class="card">
            <i class="fas fa-seedling"></i>
            <h3>Analyze Field</h3>
            <p>Run crop-soil partition analysis to optimize your field.</p>
            <a href="analyze.jsp">Analyze</a>
        </div>
        <div class="card">
            <i class="fas fa-chart-line"></i>
            <h3>Compare Graph</h3>
            <p>Visualize the yield of your recent crop-soil partitions.</p>
            <a href="compare.jsp">Compare</a>
        </div>
    </div>
</div>

<div class="footer">
    <div class="quote"><%= quote %></div>
    <div class="footer-animation">
        <img src="images/soil_nature.gif" width="100" height="80" alt="Soil and Nature Animation">
    </div>
    <div class="copyright">
        &copy; 2025 Smart Crop-Soil Detection | All Rights Reserved.
    </div>
</div>

</body>
</html>
