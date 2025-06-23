<%-- 
    Document   : deleteQuestion
    Created on : 11 Jun 2025, 5:24:59 AM
    Author     : User
--%>

<%@page import="util.DBConnection"%>
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

            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = null;

            try {
                
                ps = conn.prepareStatement("DELETE FROM questions WHERE id = ?");
                ps.setInt(1, id);
                ps.executeUpdate();
                response.sendRedirect(request.getContextPath()+"/listQuestions.jsp");
            } catch (Exception e) {
                out.print("Delete error: " + e.getMessage());
            } finally {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
    </body>
</html>
