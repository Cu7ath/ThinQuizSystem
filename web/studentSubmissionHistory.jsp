
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    String email = (String) session.getAttribute("email");
    if (role == null || !"student".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

    // Dapatkan student_id
    PreparedStatement getId = conn.prepareStatement("SELECT id FROM users WHERE email=?");
    getId.setString(1, email);
    ResultSet idRs = getId.executeQuery();
    int studentId = 0;
    if (idRs.next()) {
        studentId = idRs.getInt("id");
    }

    PreparedStatement pst = conn.prepareStatement(
        "SELECT ss.id AS submission_id, q.title, ss.total_score, ss.submission_time, ss.evaluated " +
        "FROM student_submissions ss " +
        "JOIN quiz q ON ss.quiz_id = q.id " +
        "WHERE ss.student_id = ? ORDER BY ss.submission_time DESC"
    );
    pst.setInt(1, studentId);
    ResultSet rs = pst.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submission History</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        .container { width: 90%; margin: 30px auto; background: #fff; padding: 20px; border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: left; }
        th { background-color: #f2f2f2; }
        a.btn { padding: 5px 10px; background: #4CAF50; color: white; text-decoration: none; border-radius: 4px; }
        a.btn:hover { background: #45a049; }
    </style>
</head>
<body>
<div class="container">
    <h2>Your Quiz Submission History</h2>
    <table>
        <tr>
            <th>Quiz Title</th>
            <th>Submitted At</th>
            <th>Total Score</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getTimestamp("submission_time") %></td>
            <td><%= rs.getInt("total_score") %></td>
            <td><%= rs.getBoolean("evaluated") ? "Evaluated" : "Pending" %></td>
            <td><a class="btn" href="reviewQuiz.jsp?submission_id=<%= rs.getInt("submission_id") %>">Review</a></td>
        </tr>
        <% } conn.close(); %>
    </table>
    <br>
    <a class="btn" href="studentHome.jsp">Back to Home</a>
</div>
</body>
</html>
