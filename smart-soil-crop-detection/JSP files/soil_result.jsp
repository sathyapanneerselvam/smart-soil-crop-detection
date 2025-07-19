soil_result.jsp <%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Suitable Crops Result</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url("images/bg.jpg") no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.25);
            width: 90%;
            max-width: 800px;
            overflow-x: auto;
        }

        h2 {
            color: green;
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px 15px;
            border: 1px solid #ccc;
            text-align: left;
        }

        th {
            background-color: #f0f0f0;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .high {
            color: green;
            font-weight: bold;
        }

        .moderate {
            color: orange;
            font-weight: bold;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #006600;
            text-decoration: none;
            font-weight: bold;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Crop Suggestions Based on Soil</h2>

    <%
        List<Map<String, String>> cropList = (List<Map<String, String>>) request.getAttribute("cropList");
        boolean hasResults = false;
    %>

    <table>
        <tr>
            <th>Crop</th>
            <th>Suitability</th>
            <th>Reason</th>
            <th>Time to Yield (Days)</th>
            <th>Yield (kg/500sqft)</th>
        </tr>
        <%
            for (Map<String, String> crop : cropList) {
                String suitability = crop.get("suitability");
                if (!"High".equalsIgnoreCase(suitability) && !"Moderate".equalsIgnoreCase(suitability)) {
                    continue; // Skip "Low"
                }
                hasResults = true;
                String colorClass = "High".equalsIgnoreCase(suitability) ? "high" : "moderate";
        %>
        <tr>
            <td><%= crop.get("name") %></td>
            <td class="<%= colorClass %>"><%= suitability %></td>
            <td><%= crop.get("reason") %></td>
            <td><%= crop.get("days") %></td>
            <td><%= crop.get("yield") %></td>
        </tr>
        <%
            }
        %>
    </table>

    <%
        if (!hasResults) {
    %>
        <p style="color: red; margin-top: 20px; text-align: center;">
            No suitable crops with High or Moderate suitability found.
        </p>
    <%
        }
    %>

    <div style="text-align:center;">
        <a href="detect.jsp" class="back-link">&larr; Back to Soil Selection</a>
    </div>
</div>
</body>
</html>
