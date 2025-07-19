package servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class AnalyzeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int partitionCount = 0;
        List<Map<String, String>> results = new ArrayList<>();

        try {
            partitionCount = Integer.parseInt(request.getParameter("partitionCount"));
            System.out.println("✅ Received partitionCount: " + partitionCount);
        } catch (Exception e) {
            System.err.println("❌ Invalid partitionCount.");
        }

        // MySQL credentials
        String dbURL = "jdbc:mysql://localhost:3306/soil";
        String dbUser = "root";
        String dbPassword = "Sathya@2002";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            HttpSession session = request.getSession();
            int userId = (int) session.getAttribute("user_id");

            for (int i = 1; i <= partitionCount; i++) {
                String crop = request.getParameter("crop" + i);
                String soil = request.getParameter("soil" + i);

                if (crop == null || soil == null || crop.trim().isEmpty() || soil.trim().isEmpty()) {
                    System.out.println("⚠️ Partition " + i + " skipped: crop/soil missing.");
                    continue;
                }

                crop = crop.trim();
                soil = soil.trim();
                System.out.println("🔍 Checking Partition " + i + ": Crop = [" + crop + "], Soil = [" + soil + "]");

                // 1. Get suitability from crop_soil_match
                PreparedStatement stmt1 = conn.prepareStatement(
                    "SELECT suitability_level, reason FROM crop_soil_match WHERE crop_name = ? AND soil_type = ?"
                );
                stmt1.setString(1, crop);
                stmt1.setString(2, soil);
                ResultSet rs1 = stmt1.executeQuery();

                String suitability = "Unknown", reason = "No match found";
                if (rs1.next()) {
                    suitability = rs1.getString("suitability_level");
                    reason = rs1.getString("reason");
                }

                // 2. Get yield info from crop_yield_info
                PreparedStatement stmt2 = conn.prepareStatement(
                    "SELECT time_to_yield_days, yield_per_500sqft_kg FROM crop_yield_info WHERE crop_name = ?"
                );
                stmt2.setString(1, crop);
                ResultSet rs2 = stmt2.executeQuery();

                int timeToYield = -1;
                float yield = -1;
                if (rs2.next()) {
                    timeToYield = rs2.getInt("time_to_yield_days");
                    yield = rs2.getFloat("yield_per_500sqft_kg");
                }

                // 3. Classification logic
                String classification;
                if ("High".equalsIgnoreCase(suitability)) classification = "GOOD";
                else if ("Moderate".equalsIgnoreCase(suitability)) classification = "MODERATE";
                else classification = "NOT GOOD";

                // 4. Add to results
                Map<String, String> row = new HashMap<>();
                row.put("partition", String.valueOf(i));
                row.put("crop", crop);
                row.put("soil", soil);
                row.put("suitability", suitability);
                row.put("reason", reason);
                row.put("yield", (yield >= 0) ? String.valueOf(yield) : "N/A");
                row.put("time", (timeToYield >= 0) ? String.valueOf(timeToYield) : "N/A");
                row.put("classification", classification);
                results.add(row);

                // 5. Insert into partition_analysis_history with user_id from session
                PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO partition_analysis_history " +
                    "(user_id, partition_no, crop_name, soil_type, suitability_level, yield, time_to_yield, classification) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
                );
                insert.setInt(1, userId); // ✅ use session user ID
                insert.setInt(2, i);
                insert.setString(3, crop);
                insert.setString(4, soil);
                insert.setString(5, suitability);
                if (yield >= 0)
                    insert.setFloat(6, yield);
                else
                    insert.setNull(6, Types.FLOAT);
                if (timeToYield >= 0)
                    insert.setInt(7, timeToYield);
                else
                    insert.setNull(7, Types.INTEGER);
                insert.setString(8, classification);
                insert.executeUpdate();
            }

            conn.close();
        } catch (SQLException sqle) {
            System.err.println("❌ SQL Error: " + sqle.getMessage());
        } catch (Exception e) {
            System.err.println("❌ General Error: " + e.getMessage());
        }

        request.setAttribute("results", results);
        RequestDispatcher rd = request.getRequestDispatcher("analyze_result.jsp");
        rd.forward(request, response);
    }
}
