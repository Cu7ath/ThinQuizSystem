
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String studentName = (String) session.getAttribute("name");
    String studentEmail = (String) session.getAttribute("email");

    if (studentEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

    Statement stmt = conn.createStatement();
    String query = "SELECT q.id, q.title, u.name AS teacher_name FROM quiz q LEFT JOIN users u ON q.created_by = u.id";
    ResultSet rs = stmt.executeQuery(query);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Available Quizzes</title>
    <style>
        table {
            width: 80%;
            margin: auto;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        h2 {
            text-align: center;
        }
        .back-btn {
            display: block;
            width: 150px;
            margin: 20px auto;
            padding: 10px;
            text-align: center;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
    </style>
</head>
<body>
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
            <td><a href="attemptQuiz.jsp?quiz_id=<%= rs.getInt("id") %>">Attempt</a></td>
        </tr>
        <%
            }
            conn.close();
        %>
    </table>
    <a class="back-btn" href="studentHome.jsp">Back to Home</a>
</body>
</html>
