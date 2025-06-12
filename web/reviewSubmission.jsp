<%-- 
    Document   : reviewSubmission
    Created on : Jun 12, 2025, 9:10:41 PM
    Author     : User
--%>


<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("userId");
    String role = (String) session.getAttribute("role");

    String attemptIdStr = request.getParameter("attemptId");
    if (attemptIdStr == null) {
        out.println("No attempt selected.");
        return;
    }
    int attemptId = Integer.parseInt(attemptIdStr);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Review Submission</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h2>Review Quiz Submission</h2>
        <table border="1" cellpadding="10">
            <tr>
                <th>Question</th>
                <th>Your Answer</th>
                <th>Correct Answer</th>
                <th>Marks Awarded</th>
            </tr>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

                    String query = "SELECT q.question_text, q.correct_answer, qa.answer_text, qa.awarded_marks " +
                                   "FROM answers qa " +
                                   "JOIN questions q ON qa.question_id = q.question_id " +
                                   "WHERE qa.attempt_id = ?";
                    PreparedStatement pst = conn.prepareStatement(query);
                    pst.setInt(1, attemptId);
                    ResultSet rs = pst.executeQuery();

                    while (rs.next()) {
                        String question = rs.getString("question_text");
                        String correct = rs.getString("correct_answer");
                        String answer = rs.getString("answer_text");
                        int marks = rs.getInt("awarded_marks");
            %>
            <tr>
                <td><%= question %></td>
                <td><%= answer %></td>
                <td><%= correct %></td>
                <td><%= marks %></td>
            </tr>
            <%
                    }
                    conn.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
        <br>
        <% if ("student".equals(role)) { %>
            <a href="StudentSubmissionHistory.jsp">?? Back to History</a>
        <% } else if ("teacher".equals(role)) { %>
            <a href="ViewSubmission.jsp">?? Back to Submissions</a>
        <% } %>
    </div>
</body>
</html>
