/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EvaluateSubjectiveServlet")
public class EvaluateSubjectiveServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String quizIdParam = request.getParameter("quizId");
        String studentId = request.getParameter("studentId");

        if (quizIdParam == null || studentId == null) {
            response.getWriter().println("Missing quizId or studentId in the request.");
            return;
        }

        int quizId = Integer.parseInt(quizIdParam);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");

            PreparedStatement ps = conn.prepareStatement(
                "SELECT sa.*, q.questionText FROM student_answers sa JOIN questions q ON sa.question_id = q.id WHERE sa.quiz_id=? AND sa.student_id=?");
            ps.setInt(1, quizId);
            ps.setString(2, studentId);
            ResultSet rs = ps.executeQuery();

            request.setAttribute("quizId", quizId);
            request.setAttribute("studentId", studentId);
            request.setAttribute("results", rs);
            request.getRequestDispatcher("evaluateSubjective.jsp").forward(request, response);

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error evaluating subjective answers: " + e.getMessage());
        }
    }
}
