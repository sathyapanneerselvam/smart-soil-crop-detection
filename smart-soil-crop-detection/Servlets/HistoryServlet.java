package servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class HistoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map<String, String>> history = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/soil", "root", "Sathya@2002");

            String query = "SELECT * FROM partition_history ORDER BY tried_at DESC LIMIT 100";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("partition", rs.getString("partition_label"));
                row.put("crop", rs.getString("crop_name"));
                row.put("soil", rs.getString("soil_type"));
                row.put("suitability", rs.getString("suitability_level"));
                row.put("yield", String.valueOf(rs.getFloat("yield_per_500sqft_kg")));
                row.put("time", String.valueOf(rs.getInt("time_to_yield_days")));
                row.put("classification", rs.getString("classification"));
                row.put("date", rs.getString("tried_at"));
                history.add(row);
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("history", history);
        RequestDispatcher rd = request.getRequestDispatcher("history.jsp");
        rd.forward(request, response);
    }
}
