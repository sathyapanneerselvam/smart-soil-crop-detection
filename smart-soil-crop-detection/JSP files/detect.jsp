<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Soil-Based Crop Suggestion</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: url("images/bg.jpg") no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar-space {
            height: 60px; /* adjust to match your navbar height */
        }

        main {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: rgba(255, 255, 255, 0.85); /* made more transparent */
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.25);
            width: 100%;
            max-width: 420px;
            text-align: center;
        }

        h2 {
            color: green;
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 10px;
            text-align: left;
        }

        select {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        button {
            padding: 12px 25px;
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

        .hint {
            margin-top: 15px;
            font-size: 14px;
            color: #555;
        }
    </style>
</head>
<body>

    <!-- ✅ NAVBAR INCLUDE -->
    <jsp:include page="navbar.jsp" />

    <!-- ✅ MAIN CONTENT CENTERED -->
    <main>
        <div class="container">
            <h2>Get Suitable Crops for Soil</h2>

            <form action="soilSuggest" method="post">
                <!-- Soil Dropdown -->
                <label for="soilOnly">Select Soil Type:</label>
                <select name="soilOnly" id="soilOnly" required>
                    <option value="">-- Select Soil --</option>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/soil", "root", "Sathya@2002");
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT DISTINCT soil_type FROM soil_data ORDER BY soil_type");

                            while(rs.next()) {
                                String soil = rs.getString("soil_type");
                    %>
                        <option value="<%= soil %>"><%= soil %></option>
                    <%
                            }
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch(Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </select>

                <!-- Sort Dropdown -->
                <label for="sortBy">Sort By:</label>
                <select name="sortBy" id="sortBy">
                    <option value="yield">Yield (High to Low)</option>
                    <option value="time">Time to Harvest (Low to High)</option>
                </select>

                <button type="submit">Get Crops</button>
                <p class="hint">Filter based on soil and view crop yield or harvest time.</p>
            </form>
        </div>
    </main>

</body>
</html>
