
<%@ page import="javax.servlet.http.*, javax.servlet.*, java.sql.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"student".equals(role)) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }

    String quizIdStr = request.getParameter("quiz_id");
    if (quizIdStr == null) {
        out.println("<script>alert('Tiada kuiz dipilih untuk feedback.'); window.location='"+ request.getContextPath() +"/studentHome.jsp';</script>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Feedback</title>
    <<link rel="stylesheet" href="${pageContext.request.contextPath}/style.css"/>
</head>
<body>
    <div class="container">
        <h2>Submit Feedback</h2>
        <form action="${pageContext.request.contextPath}/SubmitFeedbackServlet" method="post">
            <input type="hidden" name="quiz_id" value="<%= quizIdStr %>">
            <label for="rating">Rating (1 = Poor, 5 = Excellent):</label>
            <select name="rating" required>
                <option value="">-- Select Rating --</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
            </select>

            <label for="comment">Your Comment:</label>
            <textarea name="comment" rows="5" placeholder="Write your feedback here..." required></textarea>

            <input type="submit" value="Submit Feedback">
        </form>
        <br>
        <a href="${pageContext.request.contextPath}/studentHome.jsp">Back to Home</a>
    </div>
</body>
</html>
