/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author maira
 */


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String JDBC_URL=System.getenv("DB_URL");

    private static final String JDBC_USERNAME = System.getenv("DB_USER");

    private static final String JDBC_PASSWORD = System.getenv("DB_PASS");

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
    }
}

