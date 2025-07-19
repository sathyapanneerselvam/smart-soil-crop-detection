<%@ page import="java.util.*,java.sql.*" %>
<%@ page session="true" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Partition Yield Comparison</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url("images/bg.jpg") no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
        }
        .chart-container {
            width: 80%;
            margin: 60px auto;
            background: rgba(255,255,255,0.95);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.25);
        }
        h2 {
            text-align: center;
            color: #2c3e50;
        }
    </style>
</head>
<body>

<%
    Integer userId = (Integer) session.getAttribute("user_id");

    if (userId == null) {
        response.sendRedirect("login.jsp?error=session_expired");
        return;
    }

    List<String> labels = new ArrayList<>();
    List<Float> yields = new ArrayList<>();
    List<String> crops = new ArrayList<>();
    List<String> times = new ArrayList<>();
    List<String> soils = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/soil", "root", "Sathya@2002");

        PreparedStatement ps = conn.prepareStatement(
            "SELECT partition_no, crop_name, soil_type, yield, time_to_yield FROM partition_analysis_history WHERE user_id = ? ORDER BY partition_no"
        );
        ps.setInt(1, userId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            labels.add("Partition " + rs.getInt("partition_no"));
            yields.add(rs.getFloat("yield"));
            crops.add(rs.getString("crop_name"));
            soils.add(rs.getString("soil_type"));
            times.add(String.valueOf(rs.getInt("time_to_yield")));
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
    }
%>

<div class="chart-container">
    <h2>Yield per Partition</h2>

    <% if (labels.isEmpty()) { %>
        <p style="text-align:center; color:red; font-weight:bold;">
            No data found for your account. Try analyzing some partitions first.
        </p>
    <% } else { %>
        <canvas id="yieldChart"></canvas>
    <% } %>
</div>

<% if (!labels.isEmpty()) { %>
<script>
    const labels = [<%
        for (int i = 0; i < labels.size(); i++) {
            out.print("\"" + labels.get(i) + "\"");
            if (i < labels.size() - 1) out.print(", ");
        }
    %>];

    const dataVals = [<%
        for (int i = 0; i < yields.size(); i++) {
            out.print(yields.get(i));
            if (i < yields.size() - 1) out.print(", ");
        }
    %>];

    const crops = [<%
        for (int i = 0; i < crops.size(); i++) {
            out.print("\"" + crops.get(i) + "\"");
            if (i < crops.size() - 1) out.print(", ");
        }
    %>];

    const soils = [<%
        for (int i = 0; i < soils.size(); i++) {
            out.print("\"" + soils.get(i) + "\"");
            if (i < soils.size() - 1) out.print(", ");
        }
    %>];

    const times = [<%
        for (int i = 0; i < times.size(); i++) {
            out.print("\"" + times.get(i) + "\"");
            if (i < times.size() - 1) out.print(", ");
        }
    %>];

    const barColors = dataVals.map(val => {
        if (val >= 35) return 'rgba(76, 175, 80, 0.7)';        // Green
        else if (val >= 20) return 'rgba(255, 152, 0, 0.7)';   // Orange
        else return 'rgba(244, 67, 54, 0.7)';                  // Red
    });

    const ctx = document.getElementById('yieldChart').getContext('2d');

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Yield (kg/hectare)',
                data: dataVals,
                backgroundColor: barColors,
                borderColor: 'rgba(75, 75, 75, 0.9)',
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const i = context.dataIndex;
                            return [
                                labels[i],
                                'Crop: ' + crops[i],
                                'Soil: ' + soils[i],
                                'Yield: ' + dataVals[i] + ' kg',
                                'Harvest Time: ' + times[i] + ' days'
                            ];
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Yield (kg/hectare)'
                    }
                }
            }
        }
    });
</script>
<% } %>

</body>
</html>
