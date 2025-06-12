
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet(urlPatterns = {"/AddQuestionServlet"})
public class AddQuestionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        PrintWriter out = res.getWriter();
        res.setContentType("text/html;charset=UTF-8");

        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            res.sendRedirect("login.jsp");
            return;
        }

        String type = req.getParameter("questionType");
        String questionText = req.getParameter("questionText");
        String optionA = null, optionB = null, optionC = null, optionD = null, correctAnswer = null;
        int marks = 0;
        int timeLimit = 0;

        if ("mcq".equals(type)) {
            optionA = req.getParameter("optionA");
            optionB = req.getParameter("optionB");
            optionC = req.getParameter("optionC");
            optionD = req.getParameter("optionD");
            correctAnswer = req.getParameter("correctAnswer");
            marks = Integer.parseInt(req.getParameter("marks"));
            timeLimit = Integer.parseInt(req.getParameter("timeLimit"));
        } else if ("subjective".equals(type)) {
            correctAnswer = req.getParameter("correctAnswer");
            marks = Integer.parseInt(req.getParameter("marks"));
            timeLimit = Integer.parseInt(req.getParameter("timeLimit"));
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

            String sql = "INSERT INTO questions (questionText, questionType, optionA, optionB, optionC, optionD, correctAnswer, marks, timeLimit) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, questionText);
            pst.setString(2, type);
            pst.setString(3, optionA);
            pst.setString(4, optionB);
            pst.setString(5, optionC);
            pst.setString(6, optionD);
            pst.setString(7, correctAnswer);
            pst.setInt(8, marks);
            pst.setInt(9, timeLimit);

            int row = pst.executeUpdate();
            conn.close();

            if (row > 0) {
                out.println("<script>alert('Question added successfully'); window.location='addQuestion.jsp';</script>");
            } else {
                out.println("<script>alert('Failed to add question'); window.location='addQuestion.jsp';</script>");
            }
        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='addQuestion.jsp';</script>");
        }
    }
}
