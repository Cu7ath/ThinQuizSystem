
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        res.setContentType("text/html;charset=UTF-8");
        PrintWriter out = res.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

            PreparedStatement stmt = conn.prepareStatement(
                    "SELECT * FROM users WHERE email=? AND password=?");
            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String name = rs.getString("name");
                String role = rs.getString("role");

                HttpSession session = req.getSession();
                session.setAttribute("name", name);
                session.setAttribute("email", email);
                session.setAttribute("role", role);

                if ("student".equalsIgnoreCase(role)) {
                    res.sendRedirect("studentHome.jsp");
                } else if ("teacher".equalsIgnoreCase(role)) {
                    res.sendRedirect("teacherHome.jsp");
                } else {
                    out.println("<script>alert('Peranan tidak sah.'); window.location='login.jsp';</script>");
                }
            } else {
                out.println("<script>alert('Email atau kata laluan salah.'); window.location='login.jsp';</script>");
            }

            conn.close();
        } catch (Exception e) {
            out.println("<script>alert('Ralat: " + e.getMessage() + "'); window.location='login.jsp';</script>");
        }
    }
}
