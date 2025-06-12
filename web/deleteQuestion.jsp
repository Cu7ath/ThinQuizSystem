<%-- 
    Document   : deleteQuestion
    Created on : 11 Jun 2025, 5:24:59 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Delete Question</title>
    </head>
    <body>
        <%
            int id = Integer.parseInt(request.getParameter("id"));

            Connection conn = null;
            PreparedStatement ps = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");
                ps = conn.prepareStatement("DELETE FROM questions WHERE id = ?");
                ps.setInt(1, id);
                ps.executeUpdate();
                response.sendRedirect("listQuestions.jsp");
            } catch (Exception e) {
                out.print("Delete error: " + e.getMessage());
            } finally {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
    </body>
</html>
