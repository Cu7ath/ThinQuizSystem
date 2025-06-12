<%-- 
    Document   : updateQuestion
    Created on : 11 Jun 2025, 5:08:44 AM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Question</title>
    </head>
    <body>
        <%
            int id = Integer.parseInt(request.getParameter("id"));

            String questionText = "", questionType = "", optionA = "", optionB = "", optionC = "", optionD = "", correctOption = "", correctAnswer = "";
            int marks = 0, timeLimit = 0;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM questions WHERE id=?");
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    questionText = rs.getString("questionText");
                    questionType = rs.getString("questionType");
                    marks = rs.getInt("marks");
                    timeLimit = rs.getInt("timeLimit");
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

        <h2>Edit Question</h2>

        <form action="updateQuestion.jsp" method="post">
            <input type="hidden" name="id" value="<%= id %>">
            <input type="hidden" name="questionType" value="<%= questionType %>">

            <label>Question Text:</label><br>
            <textarea name="questionText" rows="4" cols="50"><%= questionText %></textarea><br><br>

            <% if ("MCQ".equalsIgnoreCase(questionType)) { %>
                <label>Option A:</label><br>
                <input type="text" name="optionA" value="<%= optionA %>"><br>
                <label>Option B:</label><br>
                <input type="text" name="optionB" value="<%= optionB %>"><br>
                <label>Option C:</label><br>
                <input type="text" name="optionC" value="<%= optionC %>"><br>
                <label>Option D:</label><br>
                <input type="text" name="optionD" value="<%= optionD %>"><br>
                <label>Correct Option (A/B/C/D):</label><br>
                <input type="text" name="correctAnswer" value="<%= correctAnswer %>"><br>
            <% } else { %>
                <label>Correct Answer:</label><br>
                <textarea name="correctAnswer" rows="3" cols="50"><%= correctAnswer %></textarea><br>
            <% } %>

            <label>Marks:</label><br>
            <input type="number" name="marks" value="<%= marks %>"><br>

            <label>Time Limit (in seconds):</label><br>
            <input type="number" name="timeLimit" value="<%= timeLimit %>"><br><br>

            <input type="submit" value="Update Question">
        </form>

    </body>
</html>