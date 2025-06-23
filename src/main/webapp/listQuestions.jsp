<%-- 
    Document   : listQuestions
    Created on : 9 Jun 2025, 11:47:10 PM
    Author     : maira
--%>

<%@page import="util.DBConnection"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*, model.Question" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Question List</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    </head>
    <body>

        <h2>Question List</h2>

        <a class="btn" href="${pageContext.request.contextPath}/addQuestion.jsp">+ Add New Question</a>

        <table>
            <tr>
                <th>ID</th>
                <th>Question</th>
                <th>Type</th>
                <th>Answer</th>
                <th>Marks</th>
                <th>Action</th>

            </tr>

            <%
                Connection conn = DBConnection.getConnection();
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM questions");

                    while (rs.next()) {
                        String type = rs.getString("questionType");
            %>
            <tr>
                <td><%= rs.getInt("id")%></td>
                <td><%= rs.getString("questionText")%></td>
                <td><%= type%></td>
                <td>
                    <%
                        if ("MCQ".equalsIgnoreCase(type)) {
                    %>
                    A. <%= rs.getString("optionA")%><br>
                    B. <%= rs.getString("optionB")%><br>
                    C. <%= rs.getString("optionC")%><br>
                    D. <%= rs.getString("optionD")%><br>
                    <b>Answer: <%= rs.getString("correctAnswer")%></b>
                    <%
                    } else {
                    %>
                    <%= rs.getString("correctAnswer")%>
                    <%
                        }
                    %>
                </td>
                <td><%= rs.getInt("marks")%></td>
                <td class="btn-group">
                    <a class="btn" style="background-color: pink" href="${pageContext.request.contextPath}/editQuestion.jsp?id=<%= rs.getInt("id")%>">Edit</a>
                    <a class="btn" style="background-color: red" href="${pageContext.request.contextPath}/deleteQuestion.jsp?id=<%= rs.getInt("id")%>" onclick="return confirm('Are you sure want to delete the Question?')">Delete</a>
                </td>

            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("Ralat: " + e.getMessage());
                } finally {
                    if (rs != null) {
                        rs.close();
                    }
                    if (stmt != null) {
                        stmt.close();
                    }
                    if (conn != null) {
                        conn.close();
                    }
                }
            %>
        </table>
        <br>
        <a class="btn" href="${pageContext.request.contextPath}/teacherHome.jsp">Back to Home</a>

    </body>
</html>