/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String JDBC_URL=System.getenv("DB_URL");

    private static final String JDBC_USERNAME = System.getenv("DB_USERNAME");

    private static final String JDBC_PASSWORD = System.getenv("DB_PASSWORD");

    public static Connection getConnection() throws SQLException {
        try {
            // Pastikan driver dimuat terlebih dahulu
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }

        return DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
    }
}


