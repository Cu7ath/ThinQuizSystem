
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(urlPatterns = {"/SubmitQuizServlet"})
public class SubmitQuizServlet extends HttpServlet {

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
        int quizId = (int) session.getAttribute("quizId");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

            // Dapatkan student_id dari email
            PreparedStatement studentStmt = conn.prepareStatement("SELECT id FROM users WHERE email=?");
            studentStmt.setString(1, email);
            ResultSet studentRs = studentStmt.executeQuery();
            if (!studentRs.next()) {
                out.println("<script>alert('Ralat pelajar.'); window.location='studentHome.jsp';</script>");
                return;
            }
            int studentId = studentRs.getInt("id");

            // Insert ke student_submissions
            PreparedStatement subStmt = conn.prepareStatement("INSERT INTO student_submissions (student_id, quiz_id) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
            subStmt.setInt(1, studentId);
            subStmt.setInt(2, quizId);
            subStmt.executeUpdate();
            ResultSet subRs = subStmt.getGeneratedKeys();
            subRs.next();
            int submissionId = subRs.getInt(1);

            int totalScore = 0;

            // Dapatkan soalan untuk kuiz ini
            PreparedStatement qstmt = conn.prepareStatement("SELECT q.* FROM questions q JOIN quiz_questions qq ON q.id = qq.question_id WHERE qq.quiz_id = ?");
            qstmt.setInt(1, quizId);
            ResultSet questions = qstmt.executeQuery();

            while (questions.next()) {
                int qid = questions.getInt("id");
                String qtype = questions.getString("questionType");
                String correctAnswer = questions.getString("correctAnswer");
                int marks = questions.getInt("marks");

                String studentAnswer = request.getParameter("answer_" + qid);

                int score = 0;
                if ("mcq".equalsIgnoreCase(qtype)) {
                    if (studentAnswer != null && studentAnswer.equalsIgnoreCase(correctAnswer)) {
                        score = marks;
                        totalScore += score;
                    }
                }

                PreparedStatement ansStmt = conn.prepareStatement("INSERT INTO student_answers (submission_id, question_id, student_answer, score) VALUES (?, ?, ?, ?)");
                ansStmt.setInt(1, submissionId);
                ansStmt.setInt(2, qid);
                ansStmt.setString(3, studentAnswer);
                ansStmt.setInt(4, score);
                ansStmt.executeUpdate();
            }

            // Kemas kini total_score
            PreparedStatement updStmt = conn.prepareStatement("UPDATE student_submissions SET total_score=? WHERE id=?");
            updStmt.setInt(1, totalScore);
            updStmt.setInt(2, submissionId);
            updStmt.executeUpdate();

            conn.close();
            out.println("<script>alert('Quiz submitted successfully! Please provide your feedback.'); window.location='feedbackForm.jsp?quiz_id=" + quizId + "';</script>");
        } catch (Exception e) {
            out.println("<script>alert('Ralat: " + e.getMessage() + "'); window.location='studentHome.jsp';</script>");
        }
    }
}
