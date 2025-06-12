<%-- 
    Document   : UpdateQuiz
    Created on : 11 Jun 2025, 6:01:43 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Quiz</title>
    </head>
    <body>
        <%
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String[] questionIds = request.getParameterValues("questionIds");

            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");

            // Update quiz
            PreparedStatement stmt = conn.prepareStatement("UPDATE quiz SET title=?, description=? WHERE quiz_id=?");
            stmt.setString(1, title);
            stmt.setString(2, description);
            stmt.setInt(3, quizId);
            stmt.executeUpdate();

            // Clear and reinsert quiz questions
            stmt = conn.prepareStatement("DELETE FROM quiz_question WHERE quiz_id=?");
            stmt.setInt(1, quizId);
            stmt.executeUpdate();

            if (questionIds != null) {
                stmt = conn.prepareStatement("INSERT INTO quiz_question (quiz_id, question_id) VALUES (?, ?)");
                for (String qid : questionIds) {
                    stmt.setInt(1, quizId);
                    stmt.setInt(2, Integer.parseInt(qid));
                    stmt.executeUpdate();
                }
            }

            conn.close();
            response.sendRedirect("ListQuiz.jsp");
        %>
    </body>
</html>


