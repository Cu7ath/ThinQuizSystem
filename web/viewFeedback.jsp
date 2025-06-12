
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    String email = (String) session.getAttribute("email");
    if (role == null || !role.equals("teacher")) {
        response.sendRedirect("login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

    // Dapatkan semua feedback untuk quiz ciptaan teacher
    PreparedStatement pst = conn.prepareStatement(
        "SELECT q.title, f.comment, f.rating, u.name, f.submitted_at " +
        "FROM feedback f " +
        "JOIN quiz q ON f.quiz_id = q.id " +
        "JOIN users u ON f.student_id = u.id " +
        "WHERE q.created_by = (SELECT id FROM users WHERE email = ?) " +
        "ORDER BY f.submitted_at DESC"
    );
    pst.setString(1, email);
    ResultSet rs = pst.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Feedback Received</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f0f0; }
        .container { width: 90%; margin: 30px auto; background: #fff; padding: 20px; border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Feedback Received for Your Quizzes</h2>
        <table>
            <tr>
                <th>Quiz Title</th>
                <th>Student Name</th>
                <th>Rating</th>
                <th>Comment</th>
                <th>Submitted At</th>
            </tr>
            <%
                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getInt("rating") %> / 5</td>
                <td><%= rs.getString("comment") %></td>
                <td><%= rs.getTimestamp("submitted_at") %></td>
            </tr>
            <%
                } conn.close();
            %>
        </table>
        <br>
        <a href="teacherHome.jsp">Back to Dashboard</a>
    </div>
</body>
</html>
