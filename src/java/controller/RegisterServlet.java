
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet(urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        res.setContentType("text/html;charset=UTF-8");
        PrintWriter out = res.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

            // Semak jika email telah digunakan
            PreparedStatement checkStmt = conn.prepareStatement("SELECT id FROM users WHERE email = ?");
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                out.println("<script>alert('Email telah didaftarkan. Sila guna email lain.'); window.location='register.jsp';</script>");
            } else {
                PreparedStatement pst = conn.prepareStatement("INSERT INTO users(name, email, password, role) VALUES (?, ?, ?, ?)");
                pst.setString(1, name);
                pst.setString(2, email);
                pst.setString(3, password);
                pst.setString(4, role);

                int row = pst.executeUpdate();
                if (row > 0) {
                    out.println("<script>alert('Pendaftaran berjaya. Sila log masuk.'); window.location='login.jsp';</script>");
                } else {
                    out.println("<script>alert('Pendaftaran gagal.'); window.location='register.jsp';</script>");
                }
            }

            conn.close();
        } catch (Exception e) {
            out.println("<script>alert('Ralat: " + e.getMessage() + "'); window.location='register.jsp';</script>");
        }
    }
}
