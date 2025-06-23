
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
    <div class="login-container">
        <h2>User Login</h2>
        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="submit" value="Login">
        </form>
        <div class="register-link">
            Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Register here</a>
        </div>
    </div>
</body>
</html>
