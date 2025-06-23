<%@page import="util.DBConnection"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("teacher")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String submissionIdStr = request.getParameter("submission_id");
    if (submissionIdStr == null) {
        out.println("<script>alert('Submission ID hilang.'); window.location='" + request.getContextPath() + "/listQuiz.jsp';</script>");
        return;
    }

    int submissionId = Integer.parseInt(submissionIdStr);
    Connection conn = DBConnection.getConnection();

    // Ambil quiz_id untuk redirect selepas simpan
    int quizId = 0;
    PreparedStatement quizStmt = conn.prepareStatement("SELECT quiz_id FROM student_submissions WHERE id = ?");
    quizStmt.setInt(1, submissionId);
    ResultSet quizRs = quizStmt.executeQuery();
    if (quizRs.next()) {
        quizId = quizRs.getInt("quiz_id");
    }
    quizRs.close();
    quizStmt.close();

    session.setAttribute("quizId", quizId);

    PreparedStatement pst = conn.prepareStatement(
        "SELECT sa.id, sa.question_id, sa.student_answer, sa.score, q.questionText, q.questionType, q.correctAnswer, q.marks " +
        "FROM student_answers sa JOIN questions q ON sa.question_id = q.id " +
        "WHERE sa.submission_id = ?"
    );
    pst.setInt(1, submissionId);
    ResultSet rs = pst.executeQuery();
%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Evaluate Submission</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css"/>
</head>
<body>
    <div class="container">
        <h2>Evaluate Student Submission</h2>
        <form action="${pageContext.request.contextPath}/EvaluateSubmissionServlet" method="post">
            <input type="hidden" name="submission_id" value="<%= submissionId %>">
            <input type="hidden" name="quiz_id" value="<%= quizId %>">
            <%
            while (rs.next()) {
                int answerId = rs.getInt("id");
                String type = rs.getString("questionType");
                int marks = rs.getInt("marks");
        %>
        <div>
            <p><b>Question:</b> <%= rs.getString("questionText") %></p>
            <p><b>Student Answer:</b> <%= rs.getString("student_answer") %></p>
            <p><b>Correct Answer:</b> <%= rs.getString("correctAnswer") %></p>
            <p><b>Marks:</b> <%= marks %></p>
            <% if ("subjective".equalsIgnoreCase(type)) { %>
                <label>Give Score:</label>
                <input type="number" name="score_<%= answerId %>" min="0" max="<%= marks %>" value="<%= rs.getInt("score") %>">
            <% } else { %>
                <p><b>Auto Score:</b> <%= rs.getInt("score") %></p>
            <% } %>
        </div>
        <hr>
        <% } rs.close(); conn.close(); %>
        <input type="submit" value="Save Evaluation">
    </form>
        <br><a href="javascript:history.back();">Back</a>
    </div>
</body>
</html>
<%
    rs.close();
    pst.close();
    conn.close();
%>
