
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(urlPatterns = {"/SubmitFeedbackServlet"})
public class SubmitFeedbackServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = (String) session.getAttribute("email");
        String comment = request.getParameter("comment");
        int rating = Integer.parseInt(request.getParameter("rating"));
        int quizId = Integer.parseInt(request.getParameter("quiz_id"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

            // Get student ID
            PreparedStatement userStmt = conn.prepareStatement("SELECT id FROM users WHERE email=?");
            userStmt.setString(1, email);
            ResultSet rs = userStmt.executeQuery();
            if (!rs.next()) {
                out.println("<script>alert('Pelajar tidak ditemui.'); window.location='studentHome.jsp';</script>");
                return;
            }
            int studentId = rs.getInt("id");

            // Insert feedback
            PreparedStatement fbStmt = conn.prepareStatement(
                "INSERT INTO feedback (student_id, quiz_id, comment, rating) VALUES (?, ?, ?, ?)"
            );
            fbStmt.setInt(1, studentId);
            fbStmt.setInt(2, quizId);
            fbStmt.setString(3, comment);
            fbStmt.setInt(4, rating);
            fbStmt.executeUpdate();

            conn.close();
            out.println("<script>alert('Terima kasih atas maklum balas anda!'); window.location='studentHome.jsp';</script>");
        } catch (Exception e) {
            out.println("<script>alert('Ralat: " + e.getMessage() + "'); window.location='studentHome.jsp';</script>");
        }
    }
}
