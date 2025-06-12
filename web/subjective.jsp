
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("teacher")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Subjective Question</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f9f9f9; }
        .container { width: 500px; margin: 50px auto; background: #fff; padding: 20px; border-radius: 8px; }
        input, textarea { width: 100%; padding: 8px; margin: 8px 0; border-radius: 4px; border: 1px solid #ccc; }
        input[type=submit] { background: #4CAF50; color: #fff; cursor: pointer; }
        input[type=submit]:hover { background: #45a049; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Add Subjective Question</h2>
        <form action="AddQuestionServlet" method="post">
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
        <a href="teacherHome.jsp">Back to Dashboard</a>
    </div>
</body>
</html>
