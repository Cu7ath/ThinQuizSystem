
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("teacher")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String submissionIdStr = request.getParameter("submission_id");
    if (submissionIdStr == null) {
        out.println("<script>alert('Submission ID hilang.'); window.location='listQuiz.jsp';</script>");
        return;
    }
    int submissionId = Integer.parseInt(submissionIdStr);

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

    PreparedStatement pst = conn.prepareStatement(
        "SELECT sa.id, sa.question_id, sa.student_answer, sa.score, q.questionText, q.questionType, q.correctAnswer, q.marks " +
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
    <title>Evaluate Submission</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        .container { width: 90%; margin: 30px auto; background: #fff; padding: 20px; border-radius: 8px; }
        .question-block { margin-bottom: 20px; border-bottom: 1px solid #ccc; padding-bottom: 10px; }
        label { font-weight: bold; }
        textarea, input[type=number] { width: 100%; margin-top: 5px; padding: 8px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Evaluate Student Submission</h2>
        <form action="EvaluateSubmissionServlet" method="post">
            <input type="hidden" name="submission_id" value="<%= submissionId %>">
            <%
                while (rs.next()) {
                    String type = rs.getString("questionType");
                    int answerId = rs.getInt("id");
                    int qid = rs.getInt("question_id");
            %>
            <div class="question-block">
                <p><b>Question:</b> <%= rs.getString("questionText") %> (<%= type %>)</p>
                <p><b>Student Answer:</b> <%= rs.getString("student_answer") %></p>
                <p><b>Correct Answer:</b> <%= rs.getString("correctAnswer") %></p>
                <p><b>Max Marks:</b> <%= rs.getInt("marks") %></p>
                <% if ("subjective".equalsIgnoreCase(type)) { %>
                    <label>Give Score:</label>
                    <input type="number" name="score_<%= answerId %>" value="<%= rs.getInt("score") %>" min="0" max="<%= rs.getInt("marks") %>">
                <% } else { %>
                    <p><b>Auto Score:</b> <%= rs.getInt("score") %></p>
                <% } %>
            </div>
            <% } conn.close(); %>
            <input type="submit" value="Save Evaluation">
        </form>
        <br>
        <a href="javascript:history.back();">Back</a>
    </div>
</body>
</html>
