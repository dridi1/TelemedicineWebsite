package com.example.telemedicine.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {
    

    // Database URL, username, and password for PostgreSQL connection
    private static final String URL = "jdbc:postgresql://localhost:5432/telemedicinedb";
    private static final String USER = "postgres";
    private static final String PASSWORD = "slim";

    // Static block to load the PostgreSQL JDBC driver when the class is loaded
    static {
        try {
            // Load the PostgreSQL JDBC driver class dynamically
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            // Throw a runtime exception if the driver is not found
            throw new RuntimeException("PostgreSQL JDBC Driver not found. Include it in your library path.", e);
        }
    }

    
    public static Connection getConnection() throws SQLException {
        // Return a new connection using the specified URL, user, and password
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
/*
package com.example.telemedicine.util;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DatabaseUtil {
    public static Connection getConnection() throws SQLException {
        try {
            // 1. Initialiser le contexte JNDI
            InitialContext ctx = new InitialContext();
            
            // 2. Chercher la DataSource
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/myDB");
            
            // 3. Obtenir une connexion
            return ds.getConnection();
        } catch (NamingException e) {
            throw new RuntimeException("Configuration JNDI incorrecte", e);
        }
    }
}*/
