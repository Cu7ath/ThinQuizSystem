
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session == null || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }
    String name = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body class="student">
    <div class="container">
        <h2>Welcome, <%= name %> (Student)</h2>
        <ul class="nav">
            <li><a href="${pageContext.request.contextPath}/availableQuiz.jsp">Take Quiz</a></li>
            <li><a href="${pageContext.request.contextPath}/studentSubmissionHistory.jsp">View Results</a></li>
            <li><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
        </ul>
    </div>
</body>
</html>
