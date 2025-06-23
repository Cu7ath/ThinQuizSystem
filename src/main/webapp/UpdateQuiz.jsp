<%-- 
    Document   : UpdateQuiz
    Created on : 11 Jun 2025, 6:01:43 AM
    Author     : User
--%>

<%@page import="util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Quiz</title>
    </head>
    <body>
        <%
            try {
                int quizId = Integer.parseInt(request.getParameter("quizId"));
                String title = request.getParameter("title");
                String[] questionIds = request.getParameterValues("questionIds");
                int timeLimit = Integer.parseInt(request.getParameter("time_limit")); // ← Ambil dari borang

                Connection conn = DBConnection.getConnection();

                // Kemaskini kuiz
                PreparedStatement updateQuiz = conn.prepareStatement(
                        "UPDATE quiz SET title = ?, time_limit = ? WHERE id = ?"
                );
                updateQuiz.setString(1, title);
                updateQuiz.setInt(2, timeLimit);
                updateQuiz.setInt(3, quizId);
                updateQuiz.executeUpdate();
                updateQuiz.close();

                // Kosongkan soalan lama dan tambah semula
                PreparedStatement deleteQs = conn.prepareStatement("DELETE FROM quiz_questions WHERE quiz_id = ?");
                deleteQs.setInt(1, quizId);
                deleteQs.executeUpdate();
                deleteQs.close();

                if (questionIds != null && questionIds.length > 0) {
                    PreparedStatement insertQ = conn.prepareStatement("INSERT INTO quiz_questions (quiz_id, question_id) VALUES (?, ?)");
                    for (String qid : questionIds) {
                        insertQ.setInt(1, quizId);
                        insertQ.setInt(2, Integer.parseInt(qid));
                        insertQ.executeUpdate();
                    }
                    insertQ.close();
                }

                conn.close();
        %>
        <script>
            alert("Kuiz berjaya dikemaskini!");
            window.location = "<%= request.getContextPath()%>/listQuiz.jsp";
        </script>
        <%
        } catch (Exception e) {
        %>
        <script>
        alert("Ralat semasa mengemaskini kuiz: <%= e.getMessage()%>");
        window.history.back();
        </script>
        <%
            }
        %>
    </body>
</html>


