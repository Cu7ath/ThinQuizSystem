<%-- 
    Document   : attemptQuiz
    Created on : Jun 12, 2025, 10:03:50 PM
    Author     : User
--%>


<%@page import="util.DBConnection"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("student")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String quizIdStr = request.getParameter("quiz_id");
    if (quizIdStr == null) {
        out.println("<script>alert('Tiada kuiz dipilih.'); window.location='" + request.getContextPath() + "/studentHome.jsp';</script>");
        return;
    }

    int quizId = Integer.parseInt(quizIdStr);
    session.setAttribute("quizId", quizId);

    Connection conn = DBConnection.getConnection();

    //Dapatkan student ID dari email
    String email = (String) session.getAttribute("email");
    int studentId = 0;
    PreparedStatement userStmt = conn.prepareStatement("SELECT id FROM users WHERE email = ?");
    userStmt.setString(1, email);
    ResultSet userRs = userStmt.executeQuery();
    if (userRs.next()) {
        studentId = userRs.getInt("id");
    }
    userRs.close();
    userStmt.close();

    //Insert new submission ke student_submissions
    int submissionId = 0;
    PreparedStatement insertStmt = conn.prepareStatement(
        "INSERT INTO student_submissions (student_id, quiz_id, submission_time, start_time) VALUES (?, ?, NOW(), NOW())",
        Statement.RETURN_GENERATED_KEYS
    );
    insertStmt.setInt(1, studentId);
    insertStmt.setInt(2, quizId);
    insertStmt.executeUpdate();

    ResultSet generatedKeys = insertStmt.getGeneratedKeys();
    if (generatedKeys.next()) {
        submissionId = generatedKeys.getInt(1);
        session.setAttribute("submissionId", submissionId); // untuk digunakan masa submit
    }
    insertStmt.close();

    //Dapatkan soalan-soalan kuiz
    PreparedStatement stmt = conn.prepareStatement("SELECT q.*, qq.question_id FROM questions q JOIN quiz_questions qq ON q.id = qq.question_id WHERE qq.quiz_id = ?");
    stmt.setInt(1, quizId);
    ResultSet rs = stmt.executeQuery();

    //Dapatkan masa limit dari table quiz
    int timeLimit = 0;
    PreparedStatement quizStmt = conn.prepareStatement("SELECT time_limit FROM quiz WHERE id = ?");
    quizStmt.setInt(1, quizId);
    ResultSet quizRs = quizStmt.executeQuery();
    if (quizRs.next()) {
        timeLimit = quizRs.getInt("time_limit"); // dalam minit
    }
    quizRs.close();
    quizStmt.close();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Attempt Quiz</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
        <script src="${pageContext.request.contextPath}/script.js"></script>

    </head>
    <body>
        <div class="container">
            <h2>Quiz Attempt</h2>
            <h3>Time Remaining: 
                <span id="timer" data-timeleft="<%= timeLimit * 60%>" style="color:red; font-weight:bold;"></span>
            </h3>

            <form id="quizForm" action="${pageContext.request.contextPath}/SubmitQuizServlet" method="post">
                <input type="hidden" name="submission_id" value="<%= submissionId %>">

                <%
                    int questionNo = 1;
                    while (rs.next()) {
                        String qType = rs.getString("questionType");
                        int qId = rs.getInt("id");
                %>
                <div class="question-block">
                    <p><b>Q<%= questionNo++%>:</b> <%= rs.getString("questionText")%></p>
                    <input type="hidden" name="questionIds" value="<%= qId%>">
                    <% if ("mcq".equalsIgnoreCase(qType)) {%>
                    <input type="radio" name="answer_<%= qId%>" value="A" required> <%= rs.getString("optionA")%><br>
                    <input type="radio" name="answer_<%= qId%>" value="B"> <%= rs.getString("optionB")%><br>
                    <input type="radio" name="answer_<%= qId%>" value="C"> <%= rs.getString("optionC")%><br>
                    <input type="radio" name="answer_<%= qId%>" value="D"> <%= rs.getString("optionD")%><br>
                    <% } else {%>
                    <textarea name="answer_<%= qId%>" rows="3" cols="80" required></textarea>
                    <% } %>
                </div>
                <% }
                conn.close();%>
                <input type="submit" value="Submit Quiz">
            </form>
            <a href="${pageContext.request.contextPath}/availableQuiz.jsp">Back to Home</a>
        </div>
    </body>
</html>
