
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%

    if (session == null || !"teacher".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String title = request.getParameter("title");
    String description = request.getParameter("description");
    int createdBy = (int) session.getAttribute("userId");

    String[] questionTexts = request.getParameterValues("questionText");
    String[] questionTypes = request.getParameterValues("questionType");
    String[] optionA = request.getParameterValues("optionA");
    String[] optionB = request.getParameterValues("optionB");
    String[] optionC = request.getParameterValues("optionC");
    String[] optionD = request.getParameterValues("optionD");
    String[] correctAnswers = request.getParameterValues("correctAnswer");
    String[] timeLimits = request.getParameterValues("timeLimit");
    String[] marks = request.getParameterValues("marks");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thinquizsystem", "root", "");

        // Insert into quiz table
        String quizSql = "INSERT INTO quiz (title, description, created_by) VALUES (?, ?, ?)";
        PreparedStatement quizStmt = conn.prepareStatement(quizSql, Statement.RETURN_GENERATED_KEYS);
        quizStmt.setString(1, title);
        quizStmt.setString(2, description);
        quizStmt.setInt(3, createdBy);
        quizStmt.executeUpdate();

        ResultSet rs = quizStmt.getGeneratedKeys();
        int quizId = 0;
        if (rs.next()) {
            quizId = rs.getInt(1);
        }

        // Insert each question
        String questionSql = "INSERT INTO questions (quiz_id, questionText, questionType, optionA, optionB, optionC, optionD, correctAnswer, timeLimit, marks) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement questionStmt = conn.prepareStatement(questionSql);

        for (int i = 0; i < questionTexts.length; i++) {
            questionStmt.setInt(1, quizId);
            questionStmt.setString(2, questionTexts[i]);
            questionStmt.setString(3, questionTypes[i]);
            questionStmt.setString(4, optionA[i]);
            questionStmt.setString(5, optionB[i]);
            questionStmt.setString(6, optionC[i]);
            questionStmt.setString(7, optionD[i]);
            questionStmt.setString(8, correctAnswers[i]);
            questionStmt.setInt(9, Integer.parseInt(timeLimits[i]));
            questionStmt.setInt(10, Integer.parseInt(marks[i]));
            questionStmt.addBatch();
        }
        questionStmt.executeBatch();

        conn.close();
        out.println("<script>alert('Quiz berjaya disimpan!'); location='ListQuiz.jsp';</script>");

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Ralat semasa menyimpan kuiz: " + e.getMessage().replace("'", "\'") + "'); location='createQuiz.jsp';</script>");
    }
%>
