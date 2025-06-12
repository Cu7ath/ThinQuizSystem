/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/StartQuizServlet")
public class StartQuizServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int quizId = Integer.parseInt(request.getParameter("quizId"));
        int currentIndex = request.getParameter("index") == null ? 0 : Integer.parseInt(request.getParameter("index"));

        // Save previous question answer (if not the first question)
        if (currentIndex > 0) {
            int prevIndex = currentIndex - 1;
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String answer = request.getParameter("answer");

            Map<Integer, String> quizAnswers = (Map<Integer, String>) request.getSession().getAttribute("quizAnswers");
            if (quizAnswers == null) {
                quizAnswers = new HashMap<>();
            }
            quizAnswers.put(questionId, answer != null ? answer : "");
            request.getSession().setAttribute("quizAnswers", quizAnswers);
        }

        // Fetch questions
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");

            PreparedStatement ps = conn.prepareStatement(
                "SELECT q.* FROM questions q JOIN quiz_question qq ON q.id = qq.question_id WHERE qq.quiz_id = ?");
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();

            List<Map<String, String>> questions = new ArrayList<>();
            while (rs.next()) {
                Map<String, String> q = new HashMap<>();
                q.put("id", rs.getString("id"));
                q.put("text", rs.getString("questionText"));
                q.put("type", rs.getString("questionType"));
                q.put("optionA", rs.getString("optionA"));
                q.put("optionB", rs.getString("optionB"));
                q.put("optionC", rs.getString("optionC"));
                q.put("optionD", rs.getString("optionD"));
                q.put("timeLimit", rs.getString("timeLimit"));
                questions.add(q);
            }
            rs.close();
            ps.close();
            conn.close();

            if (currentIndex >= questions.size()) {
                response.sendRedirect("SubmitQuizServlet?quizId=" + quizId);
                return;
            }

            request.setAttribute("questions", questions);
            request.setAttribute("currentIndex", currentIndex);
            request.setAttribute("quizId", quizId);
            request.getRequestDispatcher("startQuiz.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error loading questions: " + e.getMessage());
        }
    }
}
