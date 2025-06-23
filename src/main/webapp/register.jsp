
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    
</head>
<body>
    <div class="register-container">
        <h2>User Registration</h2>
        <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
            <input type="text" name="name" placeholder="Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <select name="role" required>
                <option value="" disabled selected>Select Role</option>
                <option value="student">Student</option>
                <option value="teacher">Teacher</option>
            </select>
            <input type="submit" value="Register">
        </form>
        <div class="login-link">
            Already registered? <a href="${pageContext.request.contextPath}/login.jsp">Login here</a>
        </div>
    </div>
</body>
</html>
