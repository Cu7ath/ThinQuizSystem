<%-- 
    Document   : saveQuestion
    Created on : 11 Jun 2025, 4:47:19 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Save Question</title>
    </head>
    <body>
        <%Connection conn = null;
        PreparedStatement ps = null;
        
        String type = request.getParameter("questionType");
        String question = request.getParameter("questionText");
        int marks = Integer.parseInt(request.getParameter("marks"));
        int time = Integer.parseInt(request.getParameter("timeLimit"));
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");
        

            if ("MCQ".equalsIgnoreCase(type)) {
                String a = request.getParameter("optionA");
                String b = request.getParameter("optionB");
                String c = request.getParameter("optionC");
                String d = request.getParameter("optionD");
                String correct = request.getParameter("correctAnswer");

                ps = conn.prepareStatement("INSERT INTO questions (questionText, questionType, optionA, optionB, optionC, optionD, correctAnswer, marks, timeLimit) VALUES (?,?,?,?,?,?,?,?,?)");
                ps.setString(1, question);
                ps.setString(2, type);
                ps.setString(3, a);
                ps.setString(4, b);
                ps.setString(5, c);
                ps.setString(6, d);
                ps.setString(7, correct);
                ps.setInt(8, marks);
                ps.setInt(9, time);
            } else {
                String answer = request.getParameter("correctAnswer");
                ps = conn.prepareStatement("INSERT INTO questions (questionText, questionType, correctAnswer, marks, timeLimit) VALUES (?,?,?,?,?)");
                ps.setString(1, question);
                ps.setString(2, type);
                ps.setString(3, answer);
                ps.setInt(4, marks);
                ps.setInt(5, time);
            }

            ps.executeUpdate();
            out.println("<p>Soalan berjaya disimpan. <a href='addQuestion.jsp'>Tambah Lagi?</a></p>");
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        %>

    </body>
</html>