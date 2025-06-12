
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("teacher")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String quizIdStr = request.getParameter("quiz_id");
    if (quizIdStr == null) {
        out.println("<script>alert('Tiada kuiz dipilih.'); window.location='listQuiz.jsp';</script>");
        return;
    }
    int quizId = Integer.parseInt(quizIdStr);

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

    PreparedStatement pst = conn.prepareStatement(
        "SELECT ss.id AS submission_id, u.name, u.email, ss.submission_time, ss.total_score, ss.evaluated " +
        "FROM student_submissions ss " +
        "JOIN users u ON ss.student_id = u.id " +
        "WHERE ss.quiz_id = ? ORDER BY ss.submission_time DESC"
    );
    pst.setInt(1, quizId);
    ResultSet rs = pst.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submissions</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        .container { width: 90%; margin: 30px auto; background: #fff; padding: 20px; border-radius: 8px; }
        h2 { text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f2f2f2; }
        a.btn { padding: 5px 10px; background: #4CAF50; color: white; text-decoration: none; border-radius: 4px; }
        a.btn:hover { background: #45a049; }
    </style>
</head>
<body>
<div class="container">
    <h2>Student Submissions</h2>
    <table>
        <tr>
            <th>Student Name</th>
            <th>Email</th>
            <th>Submission Time</th>
            <th>Total Score</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getTimestamp("submission_time") %></td>
            <td><%= rs.getInt("total_score") %></td>
            <td><%= rs.getBoolean("evaluated") ? "Evaluated" : "Pending" %></td>
            <td>
                <a class="btn" href="evaluateSubjective.jsp?submission_id=<%= rs.getInt("submission_id") %>">View Answers</a>
            </td>
        </tr>
        <% } conn.close(); %>
    </table>
    <br>
    <a class="btn" href="listQuiz.jsp">Back to Quizzes</a>
</div>
</body>
</html>
