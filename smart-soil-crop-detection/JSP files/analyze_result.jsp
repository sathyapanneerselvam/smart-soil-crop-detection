<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Partition Analysis Results</title>
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
            border-radius: 12px;
            margin: 40px auto;
            width: 90%;
            max-width: 1000px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
        }

        h2, h3 {
            text-align: center;
            color: green;
            margin-bottom: 25px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: left;
        }

        th {
            background-color: #f0f0f0;
        }

        .GOOD { color: green; font-weight: bold; }
        .MODERATE { color: orange; font-weight: bold; }
        .NOTGOOD { color: red; font-weight: bold; }
        .INVALID { color: #b30000; font-weight: bold; }

        .back-link, .chart-link {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            font-weight: bold;
            color: #006600;
        }

        .chart-link:hover, .back-link:hover {
            text-decoration: underline;
        }

        #chartContainer {
            margin-top: 30px;
            display: none;
            text-align: center;
        }

        canvas {
            max-width: 700px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Field Partition Analysis Results</h2>

    <%
    List<Map<String, String>> results = (List<Map<String, String>>) request.getAttribute("results");
        if (results != null && !results.isEmpty()) {
            List<Map<String, String>> validResults = new ArrayList<>();
            List<Map<String, String>> invalidResults = new ArrayList<>();
            for (Map<String, String> partition : results) {
                if ("Invalid".equalsIgnoreCase(partition.get("status"))) {
                    invalidResults.add(partition);
                } else {
                    validResults.add(partition);
                }
            }
    %>

    <% if (!validResults.isEmpty()) { %>
    <h3>Valid Partition Results</h3>
    <table>
        <tr>
            <th>Partition</th>
            <th>Crop</th>
            <th>Soil</th>
            <th>Suitability</th>
            <th>Reason</th>
            <th>Time to Yield (days)</th>
            <th>Yield (kg/500sqft)</th>
            <th>Classification</th>
        </tr>
        <% for (Map<String, String> partition : validResults) {
            String classification = partition.get("classification").replaceAll(" ", "").toUpperCase();
        %>
        <tr>
            <td><%= partition.get("partition") %></td>
            <td><%= partition.get("crop") %></td>
            <td><%= partition.get("soil") %></td>
            <td><%= partition.get("suitability") %></td>
            <td><%= partition.get("reason") %></td>
            <td><%= partition.get("time") %></td>
            <td><%= partition.get("yield") %></td>
            <td class="<%= classification %>"><%= partition.get("classification") %></td>
        </tr>
        <% } %>
    </table>
    <% } %>

    <% if (!invalidResults.isEmpty()) { %>
    <h3 style="color: red;">Invalid Partitions</h3>
    <table>
        <tr>
            <th>Partition</th>
            <th>Entered Crop</th>
            <th>Entered Soil</th>
            <th>Status</th>
            <th>Message</th>
        </tr>
        <% for (Map<String, String> partition : invalidResults) { %>
        <tr>
            <td><%= partition.get("partition") %></td>
            <td><%= partition.get("crop") %></td>
            <td><%= partition.get("soil") %></td>
            <td class="INVALID"><%= partition.get("status") %></td>
            <td><%= partition.get("message") %></td>
        </tr>
        <% } %>
    </table>
    <% } %>

    <%-- Top 3 scoring partitions for chart --%>
    <%
        List<Map<String, Object>> scoredResults = new ArrayList<>();
        for (Map<String, String> p : validResults) {
            float yield = Float.parseFloat(p.get("yield"));
            int time = Integer.parseInt(p.get("time"));
            String cls = p.get("classification");
            int scoreWeight = "GOOD".equalsIgnoreCase(cls) ? 3 : "MODERATE".equalsIgnoreCase(cls) ? 2 : 1;
            float score = (scoreWeight * 10) + yield - (time / 10.0f);
            Map<String, Object> map = new HashMap<>();
            map.put("partition", p.get("partition"));
            map.put("score", score);
            scoredResults.add(map);
        }
        scoredResults.sort((a, b) -> Float.compare((float)b.get("score"), (float)a.get("score")));
        List<Map<String, Object>> top3 = scoredResults.subList(0, Math.min(3, scoredResults.size()));
    %>

    <div style="text-align:center;">
        <a href="#" class="chart-link" onclick="toggleChart(); return false;">Show Top 3 Partitions (Chart)</a>
    </div>

    <div id="chartContainer">
        <canvas id="yieldChart"></canvas>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
    function toggleChart() {
        document.getElementById("chartContainer").style.display = 'block';

        const labels = <%= top3.stream().map(p -> "\"Partition " + p.get("partition") + "\"").toList() %>;
        const scores = <%= top3.stream().map(p -> String.valueOf(p.get("score"))).toList() %>;

        new Chart(document.getElementById("yieldChart"), {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Partition Score',
                    data: scores,
                    backgroundColor: ['#4CAF50', '#FFC107', '#03A9F4']
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: 'Top 3 Partitions by Score (Classification + Yield - Time)'
                    }
                }
            }
        });
    }
</script>


    <% } else { %>
    <p style="color:red; text-align:center;">No analysis results available.</p>
    <% } %>

    <div style="text-align:center;">
        <a href="analyze.jsp" class="back-link">&larr; Back to Analyze</a>
    </div>
</div>
</body>
</html>
