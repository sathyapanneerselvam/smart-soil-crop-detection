package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;

public class SoilSuggestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String soil = request.getParameter("soilOnly");
        String sortBy = request.getParameter("sortBy");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Suitable Crops</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; background: url('images/bg.jpg') no-repeat center center fixed; background-size: cover; margin: 0; height: 100vh; display: flex; justify-content: center; align-items: center; }");
        out.println(".container { background: rgba(255, 255, 255, 0.95); padding: 40px; border-radius: 12px; box-shadow: 0 0 15px rgba(0, 0, 0, 0.25); width: 650px; max-height: 90vh; overflow-y: auto; }");
        out.println("h2 { color: green; margin-bottom: 20px; }");
        out.println("table { width: 100%; border-collapse: collapse; margin-top: 20px; }");
        out.println("th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }");
        out.println("th { background-color: #f0f0f0; }");
        out.println("tr:nth-child(even) { background-color: #f9f9f9; }");
        out.println(".highlight { color: green; font-weight: bold; }");
        out.println(".moderate { color: orange; font-weight: bold; }");
        out.println(".back-link { display: inline-block; margin-top: 20px; color: #006600; text-decoration: none; font-weight: bold; }");
        out.println(".back-link:hover { text-decoration: underline; }");
        out.println("</style></head><body><div class='container'>");

        out.println("<h2>Crops Suitable for " + soil + "</h2>");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/soil", "root", "Sathya@2002");

            String query = "SELECT c.crop_name, c.suitability_level, y.time_to_yield_days, y.yield_per_500sqft_kg FROM crop_soil_match c JOIN crop_yield_info y ON c.crop_name = y.crop_name WHERE c.soil_type = ? AND (c.suitability_level = 'High' OR c.suitability_level = 'Moderate')";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, soil);
            ResultSet rs = stmt.executeQuery();

            List<Map<String, String>> cropList = new ArrayList<>();

            while (rs.next()) {
                Map<String, String> crop = new HashMap<>();
                crop.put("name", rs.getString("crop_name"));
                crop.put("level", rs.getString("suitability_level"));
                crop.put("days", String.valueOf(rs.getInt("time_to_yield_days")));
                crop.put("yield", String.valueOf(rs.getFloat("yield_per_500sqft_kg")));
                cropList.add(crop);
            }

            // Sort by time or yield
            if ("time".equals(sortBy)) {
                cropList.sort((c1, c2) -> Integer.compare(Integer.parseInt(c1.get("days")), Integer.parseInt(c2.get("days"))));
            } else {
                cropList.sort((c1, c2) -> Float.compare(Float.parseFloat(c2.get("yield")), Float.parseFloat(c1.get("yield"))));
            }

            if (cropList.isEmpty()) {
                out.println("<p style='color:red;'>No suitable crops found for the selected soil type.</p>");
            } else {
                out.println("<table><tr><th>Crop</th><th>Suitability</th><th>Time to Yield (days)</th><th>Yield (kg/500 sqft)</th></tr>");
                for (Map<String, String> crop : cropList) {
                    String level = crop.get("level");
                    String cssClass = "";

                    if ("High".equalsIgnoreCase(level)) {
                        cssClass = "highlight";
                    } else if ("Moderate".equalsIgnoreCase(level)) {
                        cssClass = "moderate";
                    }

                    out.println("<tr>");
                    out.println("<td>" + crop.get("name") + "</td>");
                    out.println("<td class='" + cssClass + "'>" + level + "</td>");
                    out.println("<td>" + crop.get("days") + "</td>");
                    out.println("<td>" + crop.get("yield") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }

            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }

        out.println("<a href='detect.jsp' class='back-link'>&larr; Back to Soil Selection</a>");
        out.println("</div></body></html>");
    }
}
