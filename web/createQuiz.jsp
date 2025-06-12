
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    Integer teacherId = null;
    if (session != null && "teacher".equals(role)) {
        String email = (String) session.getAttribute("email");
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");
        PreparedStatement stmt = conn.prepareStatement("SELECT id FROM users WHERE email=?");
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            teacherId = rs.getInt("id");
            session.setAttribute("teacherId", teacherId);
        }
        conn.close();
    } else {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Quiz</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f9f9f9; }
        .container { width: 600px; margin: 30px auto; background: #fff; padding: 20px; border-radius: 8px; }
        h2 { text-align: center; }
        input, select { width: 100%; padding: 10px; margin: 10px 0; border-radius: 5px; border: 1px solid #ccc; }
        input[type=submit] { background: #4CAF50; color: white; cursor: pointer; }
        input[type=submit]:hover { background: #45a049; }
        .question-list { max-height: 300px; overflow-y: scroll; margin-top: 15px; border: 1px solid #ddd; padding: 10px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Create a New Quiz</h2>
    <form action="CreateQuizServlet" method="post">
        <label>Quiz Title:</label>
        <input type="text" name="title" required>
        <label>Select Questions:</label>
        <div class="question-list">
            <%
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM questions");
                while (rs.next()) {
            %>
            <input type="checkbox" name="questionIds" value="<%= rs.getInt("id") %>">
            <%= rs.getString("questionText") %> (<%= rs.getString("questionType") %>)<br>
            <%
                }
                conn.close();
            %>
        </div>
        <input type="submit" value="Create Quiz">
    </form>
    <a href="teacherHome.jsp">Back to Dashboard</a>
</div>
</body>
</html>
