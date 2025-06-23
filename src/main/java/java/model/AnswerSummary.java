/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author User
 */


public class AnswerSummary {
    private String question;
    private String yourAnswer;
    private String correctAnswer;
    private int marks;

    public AnswerSummary(String question, String yourAnswer, String correctAnswer, int marks) {
        this.question = question;
        this.yourAnswer = yourAnswer;
        this.correctAnswer = correctAnswer;
        this.marks = marks;
    }

    public String getQuestion() { return question; }
    public String getYourAnswer() { return yourAnswer; }
    public String getCorrectAnswer() { return correctAnswer; }
    public int getMarks() { return marks; }
}

