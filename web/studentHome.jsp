
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session == null || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String name = (String) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="student">
    <div class="container">
        <h2>Welcome, <%= name %> (Student)</h2>
        <ul class="nav">
            <li><a href="availableQuiz.jsp">Take Quiz</a></li>
            <li><a href="studentSubmissionHistory.jsp">View Results</a></li>
            <li><a href="LogoutServlet">Logout</a></li>
        </ul>
    </div>
</body>
</html>
