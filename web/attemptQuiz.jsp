<%-- 
    Document   : attemptQuiz
    Created on : Jun 12, 2025, 10:03:50 PM
    Author     : User
--%>


<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("student")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String quizIdStr = request.getParameter("quiz_id");
    if (quizIdStr == null) {
        out.println("<script>alert('Tiada kuiz dipilih.'); window.location='studentHome.jsp';</script>");
        return;
    }
    int quizId = Integer.parseInt(quizIdStr);
    session.setAttribute("quizId", quizId);

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");
    PreparedStatement stmt = conn.prepareStatement("SELECT q.*, qq.question_id FROM questions q JOIN quiz_questions qq ON q.id = qq.question_id WHERE qq.quiz_id = ?");
    stmt.setInt(1, quizId);
    ResultSet rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Attempt Quiz</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        .container { width: 800px; margin: 30px auto; background: #fff; padding: 20px; border-radius: 8px; }
        h2 { text-align: center; }
        .question-block { margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #ccc; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Quiz Attempt</h2>
        <form action="SubmitQuizServlet" method="post">
            <%
                int questionNo = 1;
                while (rs.next()) {
                    String qType = rs.getString("questionType");
                    int qId = rs.getInt("id");
            %>
            <div class="question-block">
                <p><b>Q<%= questionNo++ %>:</b> <%= rs.getString("questionText") %></p>
                <input type="hidden" name="questionIds" value="<%= qId %>">
                <% if ("mcq".equalsIgnoreCase(qType)) { %>
                    <input type="radio" name="answer_<%= qId %>" value="A" required> <%= rs.getString("optionA") %><br>
                    <input type="radio" name="answer_<%= qId %>" value="B"> <%= rs.getString("optionB") %><br>
                    <input type="radio" name="answer_<%= qId %>" value="C"> <%= rs.getString("optionC") %><br>
                    <input type="radio" name="answer_<%= qId %>" value="D"> <%= rs.getString("optionD") %><br>
                <% } else { %>
                    <textarea name="answer_<%= qId %>" rows="3" cols="80" required></textarea>
                <% } %>
            </div>
            <% } conn.close(); %>
            <input type="submit" value="Submit Quiz">
        </form>
        <a href="studentHome.jsp">Back to Home</a>
    </div>
</body>
</html>
