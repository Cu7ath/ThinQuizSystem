<%-- 
    Document   : ListQuiz
    Created on : 11 Jun 2025, 5:53:38 AM
    Author     : User
--%>


<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    String email = (String) session.getAttribute("email");
    if (role == null || !role.equals("teacher")) {
        response.sendRedirect("login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

    PreparedStatement pst = conn.prepareStatement("SELECT q.id, q.title, q.created_at, COUNT(qq.question_id) AS total_questions FROM quiz q LEFT JOIN quiz_questions qq ON q.id = qq.quiz_id WHERE q.created_by = (SELECT id FROM users WHERE email=?) GROUP BY q.id");
    pst.setString(1, email);
    ResultSet rs = pst.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Quizzes</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f9f9f9; }
        .container { width: 90%; margin: 30px auto; background: #fff; padding: 20px; border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f2f2f2; }
        a.btn { padding: 5px 10px; background: #4CAF50; color: white; text-decoration: none; border-radius: 4px; }
        a.btn:hover { background: #45a049; }
    </style>
</head>
<body>
    <div class="container">
        <h2>My Created Quizzes</h2>
        
        <a class="btn" href="createQuiz.jsp" style="background-color: #2196F3;">+ Create New Quiz</a>

        <table>
            <tr>
                <th>Title</th>
                <th>Created At</th>
                <th>Total Questions</th>
                <th>Action</th>
            </tr>
            <%
                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getInt("total_questions") %></td>
                <td>
                    <a class="btn" href="viewSubmissions.jsp?quiz_id=<%= rs.getInt("id") %>">View Submissions</a>
                    <a class="btn" href="deleteQuiz.jsp?quiz_id=<%= rs.getInt("id") %>" style="background-color:red;">Delete</a>
                </td>
            </tr>
            <%
                }
                conn.close();
            %>
        </table>
        <br>
        <a class="btn" href="teacherHome.jsp">Back to Dashboard</a>
    </div>
</body>
</html>
