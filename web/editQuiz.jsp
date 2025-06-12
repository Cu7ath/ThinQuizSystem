<%-- 
    Document   : editQuiz
    Created on : 11 Jun 2025, 5:55:11 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Quiz</title>
    </head>
    <body>
        <%
            int quizId = Integer.parseInt(request.getParameter("id"));

            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");

            PreparedStatement quizStmt = conn.prepareStatement("SELECT * FROM quiz WHERE quiz_id=?");
            quizStmt.setInt(1, quizId);
            ResultSet quizRs = quizStmt.executeQuery();
            quizRs.next();

            String title = quizRs.getString("title");
            String description = quizRs.getString("description");

            PreparedStatement allQ = conn.prepareStatement("SELECT * FROM questions");
            ResultSet allQs = allQ.executeQuery();

            PreparedStatement selQ = conn.prepareStatement("SELECT question_id FROM quiz_question WHERE quiz_id=?");
            selQ.setInt(1, quizId);
            ResultSet selectedQs = selQ.executeQuery();

            Set<Integer> selectedIds = new HashSet<>();
            while (selectedQs.next()) selectedIds.add(selectedQs.getInt("question_id"));
        %>
        <h2>Edit Quiz</h2>
        <form action="UpdateQuiz.jsp" method="post">
            <input type="hidden" name="quizId" value="<%= quizId %>">
            <label>Quiz Title:</label><br>
            <input type="text" name="title" value="<%= title %>" required><br><br>

            <label>Description:</label><br>
            <textarea name="description" required><%= description %></textarea><br><br>


            <label>Chosen Question:</label><br>
            
            <%
                while (allQs.next()) {
                    int qid = allQs.getInt("id");
                    String qText = allQs.getString("questionText");
            %>
                <input type="checkbox" name="questionIds" value="<%= qid %>" <%= selectedIds.contains(qid) ? "checked" : "" %>>
            <%= qText %><br>
            <%
                }
                conn.close();
            %>
            <br>
            <input type="submit" value="Update">
        </form>
    </body>
</html>
