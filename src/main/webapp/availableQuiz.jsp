
<%@page import="util.DBConnection"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String studentName = (String) session.getAttribute("name");
    String studentEmail = (String) session.getAttribute("email");

    if (studentEmail == null) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }

    Connection conn = DBConnection.getConnection();

    Statement stmt = conn.createStatement();
    String query = "SELECT q.id, q.title, u.name AS teacher_name FROM quiz q LEFT JOIN users u ON q.created_by = u.id";
    ResultSet rs = stmt.executeQuery(query);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Available Quizzes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
    <div class="container">
    <h2>Welcome, <%= studentName %>! Here are your available quizzes:</h2>
    
    <table>
        <tr>
            <th>Quiz Title</th>
            <th>Created By</th>
            <th>Action</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getString("teacher_name") %></td>
            <td><a class="btn" href="${pageContext.request.contextPath}/attemptQuiz.jsp?quiz_id=<%= rs.getInt("id") %>">Attempt</a></td>
        </tr>
        <%
            }
            conn.close();
        %>
    </table>
    
    <br>
    <a class="btn" href="${pageContext.request.contextPath}/studentHome.jsp">Back to Home</a>
    </div>
</body>
</html>
