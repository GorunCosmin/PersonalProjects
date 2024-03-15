package data_baze;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ResultToString {
    public static String resultToString(ResultSet result,String ... columns){
        if(result!=null){
            StringBuilder string=new StringBuilder();
            String format ="";
            for(String col:columns){
                format+=" %-10s ";
            }
            format+="\n";
            string.append(String.format(format,(Object[]) columns));
            try {
                while (result.next()) {
                    String[] values = new String[columns.length];
                    for(int i=0;i< columns.length;i++){
                        values[i]=result.getString(columns[i]);
                    }
                    string.append((String.format(format,(Object[]) values)));
                }
            }catch (SQLException e){
                System.out.println("Elemente gresite!");
            }
            return string.toString();
        }
        return "eroare";
    }

}