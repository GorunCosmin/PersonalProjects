package data_baze;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class NewResult {
    public static ResultSet getResult(String query) {
        Connection conexiune=ConexiuneDB.conectare();
        if (conexiune != null) {
            try {
                Statement statement = conexiune.createStatement();
                ResultSet result = statement.executeQuery(query);
                return result;
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                conexiune.close(); // Închide conexiunea după utilizare
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

}