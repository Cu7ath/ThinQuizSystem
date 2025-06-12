<%-- 
    Document   : updateQuestion
    Created on : 11 Jun 2025, 5:35:08 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Question</title>
    </head>
    <body>
        <%
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String questionText = request.getParameter("questionText");
                String questionType = request.getParameter("questionType");
                int marks = Integer.parseInt(request.getParameter("marks"));
                int timeLimit = Integer.parseInt(request.getParameter("timeLimit"));

                Connection conn = null;
                PreparedStatement ps = null;

                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");

                if ("MCQ".equalsIgnoreCase(questionType)) {
                    String optionA = request.getParameter("optionA");
                    String optionB = request.getParameter("optionB");
                    String optionC = request.getParameter("optionC");
                    String optionD = request.getParameter("optionD");
                    String correctOption = request.getParameter("correctAnswer");

                    ps = conn.prepareStatement("UPDATE questions SET questionText=?, optionA=?, optionB=?, optionC=?, optionD=?, correctAnswer=?, marks=?, timeLimit=? WHERE id=?");
                    ps.setString(1, questionText);
                    ps.setString(2, optionA);
                    ps.setString(3, optionB);
                    ps.setString(4, optionC);
                    ps.setString(5, optionD);
                    ps.setString(6, correctOption);
                    ps.setInt(7, marks);
                    ps.setInt(8, timeLimit);
                    ps.setInt(9, id);
                } else {
                    String correctAnswer = request.getParameter("correctAnswer");

                    ps = conn.prepareStatement("UPDATE questions SET questionText=?, correctAnswer=?, marks=?, timeLimit=? WHERE id=?");
                    ps.setString(1, questionText);
                    ps.setString(2, correctAnswer);
                    ps.setInt(3, marks);
                    ps.setInt(4, timeLimit);
                    ps.setInt(5, id);
                }

                ps.executeUpdate();
                ps.close();
                conn.close();

                response.sendRedirect("listQuestions.jsp");
            } catch (Exception e) {
                out.print("Update error: " + e.getMessage());
            }
        %>
    </body>
</html>
