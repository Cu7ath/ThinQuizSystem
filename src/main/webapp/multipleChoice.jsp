
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
    <title>Add Multiple Choice Question</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css"/>
</head>
<body>
    <div class="container">
        <h2>Add MCQ Question</h2>
        <form action="${pageContext.request.contextPath}/AddQuestionServlet" method="post">
            <input type="hidden" name="questionType" value="mcq">
            <label>Question Text:</label>
            <textarea name="questionText" rows="3" required></textarea>
            <label>Option A:</label>
            <input type="text" name="optionA" required>
            <label>Option B:</label>
            <input type="text" name="optionB" required>
            <label>Option C:</label>
            <input type="text" name="optionC" required>
            <label>Option D:</label>
            <input type="text" name="optionD" required>
            <label>Correct Answer:</label>
            <select name="correctAnswer" required>
                <option value="A">A</option>
                <option value="B">B</option>
                <option value="C">C</option>
                <option value="D">D</option>
            </select>
            <label>Marks:</label>
            <input type="number" name="marks" min="1" required>
            <label>Time Limit (seconds):</label>
            <input type="number" name="timeLimit" min="10" required>
            <input type="submit" value="Add Question">
        </form>
        
    </div>
    <a class="btn" href="${pageContext.request.contextPath}/teacherHomejsp">Back</a>
</body>
</html>
