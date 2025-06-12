<%@ page import="java.sql.*, java.util.*, javax.servlet.http.HttpSession" %>
<%
    int quizId = Integer.parseInt(request.getParameter("quizId"));
    String studentId = (String) session.getAttribute("student_id");

    Map<Integer, String> quizAnswers = (Map<Integer, String>) session.getAttribute("quizAnswers");
    int totalScore = 0;

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");

    for (Map.Entry<Integer, String> entry : quizAnswers.entrySet()) {
        int questionId = entry.getKey();
        String userAnswer = entry.getValue();

        PreparedStatement ps = conn.prepareStatement("SELECT correctAnswer FROM questions WHERE id = ?");
        ps.setInt(1, questionId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            if (userAnswer.equalsIgnoreCase(rs.getString("correctAnswer"))) {
                totalScore += 1;
            }
        }
        rs.close();
        ps.close();
    }

    // Simpan result
    PreparedStatement ps = conn.prepareStatement(
        "INSERT INTO quiz_results (quiz_id, student_id, total_score, completed_at) VALUES (?, ?, ?, NOW())");
    ps.setInt(1, quizId);
    ps.setString(2, studentId);
    ps.setInt(3, totalScore);
    ps.executeUpdate();
    ps.close();

    conn.close();
%>

<h2>Quiz Submitted Successfully</h2>
<p>Total Score: <%= totalScore %></p>

<jsp:include page="reviewQuiz.jsp">
    <jsp:param name="quizId" value="<%= quizId %>" />
    <jsp:param name="studentId" value="<%= studentId %>" />
</jsp:include>
