package servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password"); // TODO: hash & salt in production

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/soil", "root", "Sathya@2002");

            String sql = "SELECT id, username FROM users " +
                         "WHERE (username = ? OR email = ?) AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            ps.setString(3, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("id");
                String username = rs.getString("username");

                HttpSession session = request.getSession(true);
                session.setAttribute("user_id", userId);   // consistent key across app
                session.setAttribute("username", username);

                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("login.jsp?error=1");
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=1");
        }
    }
}
