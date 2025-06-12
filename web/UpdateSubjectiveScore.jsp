<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Subjective Score</title>
</head>
<body>
<%
    String quizIdStr = request.getParameter("quizId");
    String studentId = request.getParameter("studentId");

    if (quizIdStr == null || studentId == null) {
%>
    <p style="color:red;">Missing required parameters. Please go back and check the form submission.</p>
<%
    } else {
        int quizId = Integer.parseInt(quizIdStr);

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/ThinQuizSystem", "root", "");

        // Loop through all answer IDs submitted
        String[] answerIds = request.getParameterValues("answerIds");
        if (answerIds != null) {
            for (String answerId : answerIds) {
                String finalScoreParam = request.getParameter("finalScore_" + answerId);
                String questionIdParam = request.getParameter("questionId_" + answerId);
                
                if (finalScoreParam != null && questionIdParam != null) {
                    int finalScore = Integer.parseInt(finalScoreParam);
                    int questionId = Integer.parseInt(questionIdParam);

                    // Update score
                    PreparedStatement ps = conn.prepareStatement(
                        "UPDATE student_answers SET final_score=? WHERE quiz_id=? AND question_id=? AND student_id=?");
                    ps.setInt(1, finalScore);
                    ps.setInt(2, quizId);
                    ps.setInt(3, questionId);
                    ps.setString(4, studentId);
                    ps.executeUpdate();
                }
            }
        }

        // Recalculate total score
        PreparedStatement total = conn.prepareStatement(
            "SELECT SUM(final_score) FROM student_answers WHERE quiz_id=? AND student_id=?");
        total.setInt(1, quizId);
        total.setString(2, studentId);
        ResultSet rs = total.executeQuery();
        rs.next();
        int totalScore = rs.getInt(1);

        PreparedStatement updateResult = conn.prepareStatement(
            "UPDATE quiz_results SET total_score=? WHERE quiz_id=? AND student_id=?");
        updateResult.setInt(1, totalScore);
        updateResult.setInt(2, quizId);
        updateResult.setString(3, studentId);
        updateResult.executeUpdate();

        conn.close();
%>
        <p>Score Updated!</p>
        <a href="ViewSubmission.jsp">Back to Submission List</a>
<%
    }
%>
</body>
</html>