<%-- 
    Document   : index
    Created on : Jun 11, 2025, 8:46:40 AM
    Author     : User
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Welcome to ThinQuiz</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body style="background-image: url('wallpaper.jpg'); background-size: cover; background-repeat: no-repeat;">
    <div class="form-container" style="margin-top: 200px">
        <h1>Welcome to ThinQuiz</h1>
        <p>ThinQuiz is a smart quiz platform for students and teachers.</p>
        <div class="btn-group">
            <a class="btn" href="${pageContext.request.contextPath}/login.jsp">Login</a>
            <a class="btn" href="${pageContext.request.contextPath}/register.jsp">Register</a>
        </div>
    </div>
</body>
</html>
