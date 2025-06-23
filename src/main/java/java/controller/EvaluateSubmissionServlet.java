package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Enumeration;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import util.DBConnection;

@WebServlet("/EvaluateSubmissionServlet")
public class EvaluateSubmissionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String submissionIdStr = request.getParameter("submission_id");
        String quizIdStr = request.getParameter("quiz_id");

        if (submissionIdStr == null || quizIdStr == null) {
            out.println("<script>alert('Ralat: submission_id atau quiz_id tiada.'); window.location='" +
                    request.getContextPath() + "/listQuiz.jsp';</script>");
            return;
        }

        try {
            int submissionId = Integer.parseInt(submissionIdStr);
            int quizId = Integer.parseInt(quizIdStr);

            Connection conn = DBConnection.getConnection();
            int totalScore = 0;

            // Ambil semua skor dari student_answers
            PreparedStatement getAllScores = conn.prepareStatement(
                "SELECT id, score FROM student_answers WHERE submission_id = ?");
            getAllScores.setInt(1, submissionId);
            ResultSet rs = getAllScores.executeQuery();

            while (rs.next()) {
                int answerId = rs.getInt("id");
                int score = rs.getInt("score");

                // Override jika cikgu update markah subjective
                String param = request.getParameter("score_" + answerId);
                if (param != null) {
                    score = Integer.parseInt(param);

                    PreparedStatement updateScore = conn.prepareStatement(
                        "UPDATE student_answers SET score = ? WHERE id = ?");
                    updateScore.setInt(1, score);
                    updateScore.setInt(2, answerId);
                    updateScore.executeUpdate();
                    updateScore.close();
                }

                totalScore += score;
            }

            rs.close();
            getAllScores.close();

            PreparedStatement updateSubmission = conn.prepareStatement(
                "UPDATE student_submissions SET total_score = ?, evaluated = true WHERE id = ?");
            updateSubmission.setInt(1, totalScore);
            updateSubmission.setInt(2, submissionId);
            updateSubmission.executeUpdate();
            updateSubmission.close();

            conn.close();

            out.println("<script>alert('Penilaian disimpan.'); window.location='" +
                    request.getContextPath() + "/viewSubmissions.jsp?quiz_id=" + quizId + "';</script>");

        } catch (Exception e) {
            out.println("<script>alert('Ralat: " + e.getMessage() + "'); window.location='" +
                    request.getContextPath() + "/listQuiz.jsp';</script>");
        }
    }
}
