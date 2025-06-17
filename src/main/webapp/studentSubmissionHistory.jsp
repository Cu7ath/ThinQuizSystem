
<%@page import="util.DBConnection"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    String email = (String) session.getAttribute("email");
    if (role == null || !"student".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = DBConnection.getConnection();

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
    <link rel="stylesheet" href="style.css">
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
