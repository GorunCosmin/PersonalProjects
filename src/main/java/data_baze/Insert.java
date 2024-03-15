package data_baze;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class Insert {
    public void InsertTable(String tabel,String ... elemts){
        StringBuilder query=new StringBuilder("insert into ");
        query.append(tabel).append(" values (");

        for( String el: elemts){
            query.append("'").append(el).append("',");
        }
        query.deleteCharAt((query.length()-1));
        query.append(")");


        Connection conexiune=ConexiuneDB.conectare();

        if(conexiune!=null) {
            try {
                Statement statement = conexiune.createStatement();
                statement.execute(query.toString());
            } catch (SQLException e) {
                System.out.println("Format gresit");
            }
        }
    }
}
