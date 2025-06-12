
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session == null || !"teacher".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String user = (String) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Teacher Dashboard - ThinQuiz</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="teacher">
    <div class="container">
        <h2>Welcome, <%= user %> (Teacher)</h2>
        <ul class="nav">
            <li><a href="listQuiz.jsp">Manage Quiz</a></li>
            <li><a href="listQuestions.jsp">Manage Questions</a></li>
            <li><a href="viewFeedback.jsp">View Feedback</a></li>
            <li><a href="viewAnalytics.jsp">Analytics</a></li>
            <li><a href="LogoutServlet">Logout</a></li>
        </ul>
    </div>
</body>
</html>
