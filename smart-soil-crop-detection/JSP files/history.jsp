<%@ page import="java.util.*" %>
<jsp:include page="navbar.jsp" />
<!DOCTYPE html>
<html>
<head>
    <title>Partition History</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f9f9f9;
            margin: 0;
        }

        .container {
            max-width: 1000px;
            margin: 30px auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #2d7b2f;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: left;
        }

        th {
            background-color: #eee;
        }

        .chart-container {
            width: 100%;
            margin-top: 40px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Partition History</h2>

    <table>
        <tr>
            <th>Partition</th>
            <th>Crop</th>
            <th>Soil</th>
            <th>Suitability</th>
            <th>Yield (kg)</th>
            <th>Time (days)</th>
            <th>Classification</th>
            <th>Date</th>
        </tr>
        <%
            List<Map<String, String>> history = (List<Map<String, String>>) request.getAttribute("history");
            List<String> topPartitions = new ArrayList<>();
            List<String> topYields = new ArrayList<>();

            int count = 0;
            if (history != null) {
                for (Map<String, String> row : history) {
                    String partition = row.get("partition");
                    String crop = row.get("crop");
                    String soil = row.get("soil");
                    String suitability = row.get("suitability");
                    String yield = row.get("yield");
                    String time = row.get("time");
                    String classification = row.get("classification");
                    String date = row.get("date");

                    if (count < 5) {
                        topPartitions.add(partition + " (" + crop + ")");
                        topYields.add(yield);
                        count++;
                    }
        %>
        <tr>
            <td><%= partition %></td>
            <td><%= crop %></td>
            <td><%= soil %></td>
            <td><%= suitability %></td>
            <td><%= yield %></td>
            <td><%= time %></td>
            <td><%= classification %></td>
            <td><%= date %></td>
        </tr>
        <%
                }
            }
        %>
    </table>

    <div class="chart-container">
        <canvas id="yieldChart"></canvas>
    </div>
</div>

<script>
    const ctx = document.getElementById('yieldChart').getContext('2d');
    const yieldChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: <%= topPartitions.toString().replace("[", "['").replace("]", "']").replace(", ", "', '") %>,
            datasets: [{
                label: 'Yield (kg/500 sqft)',
                data: <%= topYields.toString() %>,
                backgroundColor: 'rgba(54, 162, 235, 0.7)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: 'Top 5 Partition Combinations by Yield'
                }
            },
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
</script>

</body>
</html>
