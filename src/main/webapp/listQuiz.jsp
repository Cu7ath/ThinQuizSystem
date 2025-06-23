<%-- 
    Document   : ListQuiz
    Created on : 11 Jun 2025, 5:53:38 AM
    Author     : User
--%>


<%@page import="util.DBConnection"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    String email = (String) session.getAttribute("email");
    if (role == null || !role.equals("teacher")) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }

    Connection conn = DBConnection.getConnection();
    PreparedStatement pst = conn.prepareStatement("SELECT q.id, q.title, q.created_at, q.time_limit, COUNT(qq.question_id) AS total_questions FROM quiz q LEFT JOIN quiz_questions qq ON q.id = qq.quiz_id WHERE q.created_by = (SELECT id FROM users WHERE email=?) GROUP BY q.id");
    pst.setString(1, email);
    ResultSet rs = pst.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Quizzes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
    
        <h2>My Created Quizzes</h2>
        
        <a class="btn" href="${pageContext.request.contextPath}/createQuiz.jsp">+ Create New Quiz</a>

        <table>
            <tr>
                <th>Title</th>
                <th>Created At</th>
                <th>Total Questions</th>
                <th>Time Limit</th>
                <th>Action</th>
            </tr>
            <%
                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getInt("total_questions") %></td>
                <td><%= rs.getInt("time_limit") %> minutes</td>
                <td>
                    <a class="btn" href="${pageContext.request.contextPath}/viewSubmissions.jsp?quiz_id=<%= rs.getInt("id") %>" style="background-color: pink">View Submissions</a>
                    <a class="btn" href="${pageContext.request.contextPath}/editQuiz.jsp?quiz_id=<%= rs.getInt("id") %>" style="background-color: ">Edit</a>
                    <a class="btn" href="${pageContext.request.contextPath}/deleteQuiz.jsp?quiz_id=<%= rs.getInt("id") %>" style="background-color:red;">Delete</a>
                </td>
            </tr>
            <%
                }
                conn.close();
            %>
        </table>
        <br>
        <a class="btn" href="${pageContext.request.contextPath}/teacherHome.jsp">Back to Dashboard</a>
   
</body>
</html>
