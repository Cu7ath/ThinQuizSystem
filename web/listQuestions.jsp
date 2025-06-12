<%-- 
    Document   : listQuestions
    Created on : 9 Jun 2025, 11:47:10 PM
    Author     : maira
--%>

<%@ page import="java.sql.*"%>
<%@ page import="java.util.*, model.Question" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Question List</title>
    <style>
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid black; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        .action-btn { cursor: pointer; margin-right: 5px; }
    </style>
</head>
<body>
    <h2>Question List</h2>

    <a href="addQuestion.jsp">+ Add New Question</a>

    <table>
        <tr>
            <th>ID</th>
            <th>Question</th>
            <th>Type</th>
            <th>Answer</th>
            <th>Marks</th>
            <th>Time Limit (s)</th> <!-- tambah kolum had masa -->
            <th>Action</th>

        </tr>

        <%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM questions");

        while (rs.next()) {
            String type = rs.getString("questionType");
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("questionText") %></td>
        <td><%= type %></td>
        <td>
            <%
                if ("MCQ".equalsIgnoreCase(type)) {
            %>
                A. <%= rs.getString("optionA") %><br>
                B. <%= rs.getString("optionB") %><br>
                C. <%= rs.getString("optionC") %><br>
                D. <%= rs.getString("optionD") %><br>
                <b>Answer: <%= rs.getString("correctAnswer") %></b>
            <%
                } else {
            %>
                <%= rs.getString("correctAnswer") %>
            <%
                }
            %>
        </td>
        <td><%= rs.getInt("marks") %></td>
        <td><%= rs.getInt("timeLimit") %></td>
        <td>
            <a href="editQuestion.jsp?id=<%= rs.getInt("id") %>">Edit</a> |
            <a href="deleteQuestion.jsp?id=<%= rs.getInt("id") %>" onclick="return confirm('Are you sure want to delete the Question?')">Delete</a>
        </td>
    </tr>
<%
        }
    } catch (Exception e) {
        out.println("Ralat: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
    </table>
</body>
</html>