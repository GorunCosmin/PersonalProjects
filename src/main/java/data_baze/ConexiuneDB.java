package data_baze;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ConexiuneDB {
    public static Connection conectare() {
        try {
            String url = "jdbc:mysql://@localhost:3306/colocviu";
            String username = "root";
            String password = "1234";

            return DriverManager.getConnection(url, username, password);
        } catch (SQLException e) {
            System.out.println("Eroare conectare!");
            return null;
        }
    }
}