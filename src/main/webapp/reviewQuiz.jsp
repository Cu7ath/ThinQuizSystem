
<%@page import="util.DBConnection"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"student".equals(role)) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }

    String submissionIdStr = request.getParameter("submission_id");
    if (submissionIdStr == null) {
        out.println("<script>alert('Submission ID tidak dijumpai'); window.location='studentSubmissionHistory.jsp';</script>");
        return;
    }
    int submissionId = Integer.parseInt(submissionIdStr);

    Connection conn = DBConnection.getConnection();

    PreparedStatement pst = conn.prepareStatement(
        "SELECT q.questionText, q.questionType, q.correctAnswer, q.marks, sa.student_answer, sa.score " +
        "FROM student_answers sa JOIN questions q ON sa.question_id = q.id " +
        "WHERE sa.submission_id = ?"
    );
    pst.setInt(1, submissionId);
    ResultSet rs = pst.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Review Quiz</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
<div class="container">
    <h2>Review Your Submission</h2>
    <%
        int qn = 1;
        while (rs.next()) {
    %>
    <div class="question-block">
        <p><b>Q<%= qn++ %>: </b><%= rs.getString("questionText") %> (<%= rs.getString("questionType") %>)</p>
        <p><b>Your Answer:</b> <%= rs.getString("student_answer") %></p>
        <p><b>Correct Answer:</b> <%= rs.getString("correctAnswer") %></p>
        <p><b>Marks Awarded:</b> <span class="score"><%= rs.getInt("score") %> / <%= rs.getInt("marks") %></span></p>
    </div><br><br>
    <% } conn.close(); %>
    <br><a class="btn" href="${pageContext.request.contextPath}/studentSubmissionHistory.jsp">Back to History</a>
</div>
</body>
</html>
