
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session == null || !"teacher".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }
    String user = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Teacher Dashboard - ThinQuiz</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body class="teacher">
    <div class="container">
        <h2>Welcome, <%= user %> (Teacher)</h2>
        <ul class="nav">
            <li><a href="${pageContext.request.contextPath}/listQuiz.jsp">Manage Quiz</a></li>
            <li><a href="${pageContext.request.contextPath}/listQuestions.jsp">Manage Questions</a></li>
            <li><a href="${pageContext.request.contextPath}/viewFeedback.jsp">View Feedback</a></li>
            <li><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
        </ul>
    </div>
</body>
</html>
