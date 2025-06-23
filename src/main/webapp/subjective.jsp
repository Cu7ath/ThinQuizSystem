
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("teacher")) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Subjective Question</title>
    <<link rel="stylesheet" href="${pageContext.request.contextPath}/style.css"/>
</head>
<body>
    <div class="container">
        <h2>Add Subjective Question</h2>
        <form action="${pageContext.request.contextPath}/AddQuestionServlet" method="post">
            <input type="hidden" name="questionType" value="subjective">
            <label>Question Text:</label>
            <textarea name="questionText" rows="3" required></textarea>
            <label>Suggested Answer:</label>
            <textarea name="correctAnswer" rows="2" required></textarea>
            <label>Marks:</label>
            <input type="number" name="marks" min="1" required>
            <label>Time Limit (seconds):</label>
            <input type="number" name="timeLimit" min="10" required>
            <input type="submit" value="Add Question">
        </form>
        
    </div>
    <a class="btn" href="${pageContext.request.contextPath}/teacherHome.jsp">Back</a>
</body>
</html>
