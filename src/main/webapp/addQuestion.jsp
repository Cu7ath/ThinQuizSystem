<%-- 
    Document   : addQuestion
    Created on : 10 Jun 2025, 12:52:20 AM
    Author     : maira
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Select Question Type</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css"/>
</head>
<body>
    <h2>Select Question Type that you want to add</h2>
    <ul class="nav">
        <li><a href="${pageContext.request.contextPath}/multipleChoice.jsp">Multiple Choice Question (MCQ)</a></li>
        <li><a href="${pageContext.request.contextPath}/subjective.jsp">Subjective Question</a></li>
    </ul>
    <a class="btn" href="${pageContext.request.contextPath}/teacherHome.jsp">Back to Home</a>
</body>
</html>