
<%@page import="util.DBConnection"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    String email = (String) session.getAttribute("email");
    if (role == null || !role.equals("teacher")) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }

    Connection conn = DBConnection.getConnection();

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
    
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
        <a class="btn" href="${pageContext.request.contextPath}/teacherHome.jsp">Back to Dashboard</a>
    
</body>
</html>
