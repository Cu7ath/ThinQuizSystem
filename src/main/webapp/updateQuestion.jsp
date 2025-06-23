<%-- 
    Document   : updateQuestion
    Created on : 11 Jun 2025, 5:35:08 AM
    Author     : User
--%>

<%@page import="util.DBConnection"%>
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
                
                PreparedStatement ps = null;

                Connection conn = DBConnection.getConnection();

                if ("MCQ".equalsIgnoreCase(questionType)) {
                    String optionA = request.getParameter("optionA");
                    String optionB = request.getParameter("optionB");
                    String optionC = request.getParameter("optionC");
                    String optionD = request.getParameter("optionD");
                    String correctOption = request.getParameter("correctAnswer");

                    ps = conn.prepareStatement("UPDATE questions SET questionText=?, optionA=?, optionB=?, optionC=?, optionD=?, correctAnswer=?, marks=? WHERE id=?");
                    ps.setString(1, questionText);
                    ps.setString(2, optionA);
                    ps.setString(3, optionB);
                    ps.setString(4, optionC);
                    ps.setString(5, optionD);
                    ps.setString(6, correctOption);
                    ps.setInt(7, marks);
                    ps.setInt(8, id);
                } else {
                    String correctAnswer = request.getParameter("correctAnswer");

                    ps = conn.prepareStatement("UPDATE questions SET questionText=?, correctAnswer=?, marks=? WHERE id=?");
                    ps.setString(1, questionText);
                    ps.setString(2, correctAnswer);
                    ps.setInt(3, marks);
                    ps.setInt(4, id);
                }

                ps.executeUpdate();
                ps.close();
                conn.close();

                response.sendRedirect(request.getContextPath()+"/listQuestions.jsp");
            } catch (Exception e) {
                out.print("Update error: " + e.getMessage());
            }
        %>
    </body>
</html>
