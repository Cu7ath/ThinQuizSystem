<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("teacher")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String quizIdStr = request.getParameter("quiz_id");
    if (quizIdStr == null) {
        out.println("<script>alert('Quiz ID not provided.'); window.location='listQuiz.jsp';</script>");
        return;
    }
    int quizId = Integer.parseInt(quizIdStr);

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

        // Delete from feedback
        PreparedStatement delFeedback = conn.prepareStatement("DELETE FROM feedback WHERE quiz_id = ?");
        delFeedback.setInt(1, quizId);
        delFeedback.executeUpdate();

        // Get all related submission IDs
        PreparedStatement getSubs = conn.prepareStatement("SELECT id FROM student_submissions WHERE quiz_id = ?");
        getSubs.setInt(1, quizId);
        ResultSet subs = getSubs.executeQuery();

        while (subs.next()) {
            int submissionId = subs.getInt("id");

            // Delete answers
            PreparedStatement delAnswers = conn.prepareStatement("DELETE FROM student_answers WHERE submission_id = ?");
            delAnswers.setInt(1, submissionId);
            delAnswers.executeUpdate();
        }

        // Delete submissions
        PreparedStatement delSubs = conn.prepareStatement("DELETE FROM student_submissions WHERE quiz_id = ?");
        delSubs.setInt(1, quizId);
        delSubs.executeUpdate();

        // Delete from quiz_questions
        PreparedStatement delQQ = conn.prepareStatement("DELETE FROM quiz_questions WHERE quiz_id = ?");
        delQQ.setInt(1, quizId);
        delQQ.executeUpdate();

        // Delete from quiz
        PreparedStatement delQuiz = conn.prepareStatement("DELETE FROM quiz WHERE id = ?");
        delQuiz.setInt(1, quizId);
        delQuiz.executeUpdate();

        conn.close();
        out.println("<script>alert('Quiz deleted successfully.'); window.location='listQuiz.jsp';</script>");
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='listQuiz.jsp';</script>");
    }
%>
