package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class DetectServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String crop = request.getParameter("crop");
        String soil = request.getParameter("soil");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        if (crop == null || soil == null || crop.isEmpty() || soil.isEmpty()) {
            out.println("<p style='color:red;'>Please select both crop and soil.</p>");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/soil", "root", "Sathya@2002");

            String query = "SELECT suitability_level, reason FROM crop_soil_match WHERE crop_name = ? AND soil_type = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, crop);
            stmt.setString(2, soil);

            ResultSet rs = stmt.executeQuery();

            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Detection Result</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; background: url(\"images/bg.jpg\") no-repeat center center fixed;\r\n"
            		+ "background-size: cover;\r\n"
            		+ " display: flex; justify-content: center; align-items: center; min-height: 100vh; }");
            out.println(".container { background: white; padding: 40px; border-radius: 12px; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2); width: 90%; max-width: 800px; }");
            out.println("h2 { color: green; margin-bottom: 20px; }");
            out.println("table { width: 100%; border-collapse: collapse; margin-top: 30px; }");
            out.println("th, td { padding: 10px; border: 1px solid #ccc; text-align: left; }");
            out.println("th { background-color: #28a745; color: white; }");
            out.println("a { display: inline-block; margin-top: 20px; color: #006600; font-weight: bold; text-decoration: none; }");
            out.println("a:hover { text-decoration: underline; }");
            out.println("</style></head><body>");

            out.println("<div class='container'>");
            out.println("<h2>Crop-Soil Detection Result</h2>");

            if (rs.next()) {
                String suitability = rs.getString("suitability_level");
                String reason = rs.getString("reason");

                String color;
                switch (suitability.toLowerCase()) {
                    case "high": color = "green"; break;
                    case "moderate": color = "orange"; break;
                    case "low": color = "red"; break;
                    default: color = "black"; break;
                }

                out.println("<p><strong>Crop:</strong> " + crop + "</p>");
                out.println("<p><strong>Soil:</strong> " + soil + "</p>");
                out.println("<p><strong>Suitability:</strong> <span style='color:" + color + "; font-weight:bold;'>" + suitability.toUpperCase() + "</span></p>");
                out.println("<p><strong>Reason:</strong> " + reason + "</p>");
            } else {
                out.println("<p style='color:red;'>No matching data found for the selected crop and soil.</p>");
            }

            out.println("<a href='detect.jsp'> Try another combination</a>");
            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }
}
