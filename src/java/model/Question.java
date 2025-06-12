/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author maira
 */


public class Question {
    private int id;
    private int quizId;
    private String questionText;
    private String questionType; // "MCQ" or "Subjective"
    private String optionA;
    private String optionB;
    private String optionC;
    private String optionD;
    private String correctOption; // Only for MCQ
    private String correctAnswer; // Only for MCQ
    private int marks;
    private int timeLimit;

    public Question() {
    }

    
    public Question(int id, String questionText, String questionType,
                String optionA, String optionB, String optionC, String optionD,
                int timeLimit, String correctOption, int marks) {
    this.id = id;
    this.questionText = questionText;
    this.questionType = questionType;
    this.optionA = optionA;
    this.optionB = optionB;
    this.optionC = optionC;
    this.optionD = optionD;
    this.timeLimit = timeLimit;
    this.correctOption = correctOption;
    this.marks = marks;
}


    // Getters and setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getQuizId() {
        return quizId;
    }
    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getQuestionText() {
        return questionText;
    }
    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getQuestionType() {
        return questionType;
    }
    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public String getOptionA() {
        return optionA;
    }
    public void setOptionA(String optionA) {
        this.optionA = optionA;
    }

    public String getOptionB() {
        return optionB;
    }
    public void setOptionB(String optionB) {
        this.optionB = optionB;
    }

    public String getOptionC() {
        return optionC;
    }
    public void setOptionC(String optionC) {
        this.optionC = optionC;
    }

    public String getOptionD() {
        return optionD;
    }
    public void setOptionD(String optionD) {
        this.optionD = optionD;
    }

    public String getCorrectOption() {
        return correctOption;
    }

    public void setCorrectOption(String correctOption) {
        this.correctOption = correctOption;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }
    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public int getMarks() {
        return marks;
    }
    public void setMarks(int marks) {
        this.marks = marks;
    }

    public int getTimeLimit() {
        return timeLimit;
    }
    public void setTimeLimit(int timeLimit) {
        this.timeLimit = timeLimit;
    }
}
