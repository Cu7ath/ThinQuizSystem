<%-- 
    Document   : updateQuestion
    Created on : 11 Jun 2025, 5:08:44 AM
    Author     : User
--%>

<%@page import="util.DBConnection"%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Question</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    </head>
    <body>
        <%
            int id = Integer.parseInt(request.getParameter("id"));

            String questionText = "", questionType = "", optionA = "", optionB = "", optionC = "", optionD = "", correctOption = "", correctAnswer = "";
            int marks = 0;

            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM questions WHERE id=?");
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    questionText = rs.getString("questionText");
                    questionType = rs.getString("questionType");
                    marks = rs.getInt("marks");
                    if ("MCQ".equalsIgnoreCase(questionType)) {
                        optionA = rs.getString("optionA");
                        optionB = rs.getString("optionB");
                        optionC = rs.getString("optionC");
                        optionD = rs.getString("optionD");
                        correctOption = rs.getString("correctAnswer");
                    } else {
                        correctAnswer = rs.getString("correctAnswer");
                    }
                }
                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                out.print("Error: " + e.getMessage());
            }
        %>
        <div class="form-container">
        <h2>Edit Question</h2>

        <form action="${pageContext.request.contextPath}/updateQuestion.jsp" method="post">
            <input type="hidden" name="id" value="<%= id %>">
            <input type="hidden" name="questionType" value="<%= questionType %>">

            <label>Question Text:</label>
            <textarea name="questionText" rows="4" cols="50"><%= questionText %></textarea>

            <% if ("MCQ".equalsIgnoreCase(questionType)) { %>
                <label>Option A:</label>
                <input type="text" name="optionA" value="<%= optionA %>">
                <label>Option B:</label>
                <input type="text" name="optionB" value="<%= optionB %>">
                <label>Option C:</label>
                <input type="text" name="optionC" value="<%= optionC %>">
                <label>Option D:</label>
                <input type="text" name="optionD" value="<%= optionD %>">
                <label>Correct Option (A/B/C/D):</label>
                <input type="text" name="correctAnswer" value="<%= correctAnswer %>">
            <% } else { %>
                <label>Correct Answer:</label>
                <textarea name="correctAnswer" rows="3" cols="50"><%= correctAnswer %></textarea>
            <% } %>

            <label>Marks:</label>
            <input type="number" name="marks" value="<%= marks %>">

            <input type="submit" value="Update Question">
        </form>
        </div>
    </body>
</html>