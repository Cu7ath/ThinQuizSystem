
<%@page import="util.DBConnection"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("teacher")) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }

    String quizIdStr = request.getParameter("quiz_id");
    if (quizIdStr == null) {
        out.println("<script>alert('Tiada kuiz dipilih.'); window.location='"+ request.getContextPath() +"/listQuiz.jsp';</script>");
        return;
    }
    int quizId = Integer.parseInt(quizIdStr);

    Connection conn = DBConnection.getConnection();

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
<div>
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
                <a class="btn" href="${pageContext.request.contextPath}/evaluateSubjective.jsp?submission_id=<%= rs.getInt("submission_id") %>">View Answers</a>
            </td>
        </tr>
        <% } conn.close(); %>
    </table>
    <br>
    <a class="btn" href="${pageContext.request.contextPath}/listQuiz.jsp">Back to Quizzes</a>
</div>
</body>
</html>
