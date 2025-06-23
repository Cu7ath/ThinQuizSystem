
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import util.DBConnection;

@WebServlet(urlPatterns = {"/CreateQuizServlet"})
public class CreateQuizServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");

        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() +"/login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String[] questionIds = request.getParameterValues("questionIds");
        int timeLimit = Integer.parseInt(request.getParameter("time_limit"));
        int teacherId = (Integer) session.getAttribute("teacherId");

        if (title == null || questionIds == null || questionIds.length == 0) {
            out.println("<script>alert('Sila isi tajuk dan pilih sekurang-kurangnya satu soalan.'); window.location='"+ request.getContextPath() +"/createQuiz.jsp';</script>");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();


            // Insert into quiz table
            PreparedStatement pst = conn.prepareStatement("INSERT INTO quiz (title, created_by, time_limit) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
            pst.setString(1, title);
            pst.setInt(2, teacherId);
            pst.setInt(3, timeLimit);
            int row = pst.executeUpdate();

            if (row > 0) {
                ResultSet rs = pst.getGeneratedKeys();
                if (rs.next()) {
                    int quizId = rs.getInt(1);

                    // Insert into quiz_questions
                    PreparedStatement pst2 = conn.prepareStatement("INSERT INTO quiz_questions (quiz_id, question_id) VALUES (?, ?)");
                    for (String qid : questionIds) {
                        pst2.setInt(1, quizId);
                        pst2.setInt(2, Integer.parseInt(qid));
                        pst2.addBatch();
                    }
                    pst2.executeBatch();
                }
            }

            conn.close();
            out.println("<script>alert('Quiz berjaya dicipta.'); window.location='"+ request.getContextPath() +"/listQuiz.jsp';</script>");
        } catch (Exception e) {
            out.println("<script>alert('Ralat: " + e.getMessage() + "'); window.location='"+ request.getContextPath() +"/createQuiz.jsp';</script>");
        }
    }
}
