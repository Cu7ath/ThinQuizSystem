<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Start Quiz</title>
</head>
<body>
<%
    int quizId = Integer.parseInt(request.getParameter("quizId"));
    int currentIndex = request.getParameter("index") == null ? 0 : Integer.parseInt(request.getParameter("index"));

    // ✅ Save previous question answer (if not the first question)
    if (currentIndex > 0) {
        int prevIndex = currentIndex - 1;
        int questionId = Integer.parseInt(request.getParameter("questionId"));
        String answer = request.getParameter("answer");

        Map<Integer, String> quizAnswers = (Map<Integer, String>) session.getAttribute("quizAnswers");
        if (quizAnswers == null) {
            quizAnswers = new HashMap<>();
        }
        quizAnswers.put(questionId, answer != null ? answer : "");
        session.setAttribute("quizAnswers", quizAnswers);
    }

    // ✅ Fetch questions
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");

    PreparedStatement ps = conn.prepareStatement(
        "SELECT q.* FROM questions q JOIN quiz_question qq ON q.id = qq.question_id WHERE qq.quiz_id = ?");
    ps.setInt(1, quizId);
    ResultSet rs = ps.executeQuery();

    List<Map<String, String>> questions = new ArrayList<>();
    while (rs.next()) {
        Map<String, String> q = new HashMap<>();
        q.put("id", rs.getString("id"));
        q.put("text", rs.getString("questionText"));
        q.put("type", rs.getString("questionType"));
        q.put("optionA", rs.getString("optionA"));
        q.put("optionB", rs.getString("optionB"));
        q.put("optionC", rs.getString("optionC"));
        q.put("optionD", rs.getString("optionD"));
        q.put("timeLimit", rs.getString("timeLimit"));
        questions.add(q);
    }
    rs.close();
    ps.close();
    conn.close();

    if (currentIndex >= questions.size()) {
        response.sendRedirect("submitQuiz.jsp?quizId=" + quizId);
        return;
    }

    Map<String, String> question = questions.get(currentIndex);
%>

<h3 id="timer"></h3>
<form id="quizForm" action="startQuiz.jsp" method="post">
    <input type="hidden" name="quizId" value="<%= quizId %>">
    <input type="hidden" name="index" value="<%= currentIndex + 1 %>">
    <input type="hidden" name="questionId" value="<%= question.get("id") %>">

    <p><strong>Q<%= currentIndex + 1 %>:</strong> <%= question.get("text") %></p>

    <% if ("MCQ".equalsIgnoreCase(question.get("type"))) { %>
        <label><input type="radio" name="answer" value="A"> <%= question.get("optionA") %></label><br>
        <label><input type="radio" name="answer" value="B"> <%= question.get("optionB") %></label><br>
        <label><input type="radio" name="answer" value="C"> <%= question.get("optionC") %></label><br>
        <label><input type="radio" name="answer" value="D"> <%= question.get("optionD") %></label><br>
    <% } else { %>
        <textarea name="answer" rows="4" cols="50" placeholder="Type your answer"></textarea>
    <% } %>

    <br><br>
    <input type="submit" value="<%= currentIndex == questions.size() - 1 ? "Submit Quiz" : "Next" %>">
</form>

<script>
    let timeLeft = <%= question.get("timeLimit") %>;
    function countdown() {
        if (timeLeft <= 0) {
            document.getElementById("quizForm").submit();
        } else {
            document.getElementById("timer").innerText = timeLeft + " seconds left";
            timeLeft--;
            setTimeout(countdown, 1000);
        }
    }
    window.onload = countdown;
</script>

</body>
</html>
