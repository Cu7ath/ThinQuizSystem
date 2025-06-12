
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Enumeration;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(urlPatterns = {"/EvaluateSubmissionServlet"})
public class EvaluateSubmissionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String submissionIdStr = request.getParameter("submission_id");
        if (submissionIdStr == null) {
            out.println("<script>alert('Ralat: ID submission tiada.'); window.location='listQuiz.jsp';</script>");
            return;
        }
        int submissionId = Integer.parseInt(submissionIdStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

            int totalScore = 0;

            // Iterate parameter names to find score inputs
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                if (paramName.startsWith("score_")) {
                    int answerId = Integer.parseInt(paramName.substring(6));
                    int score = Integer.parseInt(request.getParameter(paramName));

                    PreparedStatement updateStmt = conn.prepareStatement("UPDATE student_answers SET score=? WHERE id=?");
                    updateStmt.setInt(1, score);
                    updateStmt.setInt(2, answerId);
                    updateStmt.executeUpdate();

                    totalScore += score;
                }
            }

            // Kemas kini total_score dan status evaluated
            PreparedStatement finalStmt = conn.prepareStatement("UPDATE student_submissions SET total_score=?, evaluated=true WHERE id=?");
            finalStmt.setInt(1, totalScore);
            finalStmt.setInt(2, submissionId);
            finalStmt.executeUpdate();

            conn.close();
            int quizId = (int) session.getAttribute("quizId");
out.println("<script>alert('Penilaian disimpan.'); window.location='viewSubmissions.jsp?quiz_id=" + quizId + "';</script>");

        } catch (Exception e) {
            out.println("<script>alert('Ralat: " + e.getMessage() + "'); window.location='listQuiz.jsp';</script>");
        }
    }
}
