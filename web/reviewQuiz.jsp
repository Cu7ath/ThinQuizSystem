
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"student".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String submissionIdStr = request.getParameter("submission_id");
    if (submissionIdStr == null) {
        out.println("<script>alert('Submission ID tidak dijumpai'); window.location='studentSubmissionHistory.jsp';</script>");
        return;
    }
    int submissionId = Integer.parseInt(submissionIdStr);

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

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
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        .container { width: 90%; margin: 30px auto; background: #fff; padding: 20px; border-radius: 8px; }
        .question-block { margin-bottom: 20px; border-bottom: 1px solid #ccc; padding-bottom: 10px; }
        .score { color: green; font-weight: bold; }
    </style>
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
    </div>
    <% } conn.close(); %>
    <a href="studentSubmissionHistory.jsp">Back to History</a>
</div>
</body>
</html>
