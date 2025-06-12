
<%@ page import="javax.servlet.http.*, javax.servlet.*, java.sql.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"student".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String quizIdStr = request.getParameter("quiz_id");
    if (quizIdStr == null) {
        out.println("<script>alert('Tiada kuiz dipilih untuk feedback.'); window.location='studentHome.jsp';</script>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Feedback</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
        .container { width: 500px; margin: 50px auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); }
        textarea, select, input[type=submit] { width: 100%; padding: 10px; margin-top: 10px; border-radius: 5px; border: 1px solid #ccc; }
        input[type=submit] { background-color: #4CAF50; color: white; cursor: pointer; }
        input[type=submit]:hover { background-color: #45a049; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Submit Feedback</h2>
        <form action="SubmitFeedbackServlet" method="post">
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
        <a href="studentHome.jsp">Back to Home</a>
    </div>
</body>
</html>
