<%@ page session="true" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession navSession = request.getSession(false);
    String username = (navSession != null && navSession.getAttribute("username") != null)
                      ? (String) navSession.getAttribute("username")
                      : "Guest";
    String initial = username.substring(0, 1).toUpperCase();
%>

<style>
    .navbar {
        background: linear-gradient(to right, #e0f2f1, #c8e6c9);
        padding: 12px 30px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-family: 'Segoe UI', sans-serif;
    }

    .nav-left a {
        margin-right: 20px;
        font-weight: 600;
        text-decoration: none;
        color: #2e7d32;
        transition: color 0.3s ease;
    }

    .nav-left a:hover {
        color: #1b5e20;
        text-decoration: underline;
    }

    .nav-right {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: #4caf50;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 18px;
        border: 2px solid #2e7d32;
    }

    .logout-btn {
        background-color: #ff5252;
        color: white;
        padding: 8px 16px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: bold;
        transition: background-color 0.3s ease;
    }

    .logout-btn:hover {
        background-color: #d32f2f;
    }

    @media (max-width: 600px) {
        .navbar {
            flex-direction: column;
            align-items: flex-start;
        }

        .nav-left, .nav-right {
            margin-top: 10px;
            width: 100%;
        }

        .nav-left a {
            display: inline-block;
            margin: 5px 10px 5px 0;
        }

        .logout-btn {
            margin-top: 10px;
        }
    }
</style>

<div class="navbar">
    <div class="nav-left">
        <a href="dashboard.jsp">Home</a>
        <a href="detect.jsp">Detect</a>
        <a href="analyze.jsp">Analyze</a>
        <a href="compare.jsp">Compare</a>
    </div>
    <div class="nav-right">
        <div class="avatar"><%= initial %></div>
        <span><strong><%= username %></strong></span>
        <a href="logout" class="logout-btn">Logout</a>
    </div>
</div>
