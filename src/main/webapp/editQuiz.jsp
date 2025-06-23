<%-- 
    Document   : editQuiz
    Created on : 11 Jun 2025, 5:55:11 AM
    Author     : User
--%>

<%@page import="util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Quiz</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    </head>
    <body>
        <%
            String idStr = request.getParameter("quiz_id");
            if (idStr == null || idStr.isEmpty()) {
                out.println("<script>alert('Quiz ID tidak dijumpai.'); window.location='listQuiz.jsp';</script>");
                return;
            }

            int quizId = Integer.parseInt(idStr);
            Connection conn = DBConnection.getConnection();

            PreparedStatement quizStmt = conn.prepareStatement("SELECT * FROM quiz WHERE id=?");
            quizStmt.setInt(1, quizId);
            ResultSet quizRs = quizStmt.executeQuery();

            if (!quizRs.next()) {
                out.println("<script>alert('Quiz tidak dijumpai.'); window.location='listQuiz.jsp';</script>");
                return;
            }

            String title = quizRs.getString("title");
            int timeLimit = quizRs.getInt("time_limit");

            PreparedStatement allQ = conn.prepareStatement("SELECT * FROM questions");
            ResultSet allQs = allQ.executeQuery();

            PreparedStatement selQ = conn.prepareStatement("SELECT question_id FROM quiz_questions WHERE quiz_id=?");
            selQ.setInt(1, quizId);
            ResultSet selectedQs = selQ.executeQuery();

            Set<Integer> selectedIds = new HashSet<>();
            while (selectedQs.next())
                selectedIds.add(selectedQs.getInt("question_id"));
        %>
        <h2>Edit Quiz</h2>
        <form class="form-container" action="${pageContext.request.contextPath}/UpdateQuiz.jsp" method="post">
            <input type="hidden" name="quizId" value="<%= quizId%>">

            <label>Quiz Title:</label>
            <input type="text" name="title" value="<%= title%>" required>

            <label>Time Limit (minutes):</label>
            <input type="number" name="time_limit" value="<%= timeLimit%>" min="1" required>

            <label>Chosen Questions:</label>
            <div class="question-list">

            <%
                while (allQs.next()) {
                    int qid = allQs.getInt("id");
                    String qText = allQs.getString("questionText");
            %>
            <input type="checkbox" name="questionIds" value="<%= qid%>" <%= selectedIds.contains(qid) ? "checked" : ""%> >
            <%= qText%><br>
            <%
                }
                conn.close();
            %>
            </div>
            <input type="submit" value="Update">
        </form>
    </body>
</html>
