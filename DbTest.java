import java.sql.*;
public class DbTest {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=apartment_management;trustServerCertificate=true";
        String user = "sa";
        String pass = "17102005";
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url, user, pass);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM users");
            while(rs.next()) {
                System.out.println("ID: " + rs.getInt("user_id") + " | User: " + rs.getString("username") + " | Pass: " + rs.getString("password_hash") + " | Role: " + rs.getString("role") + " | Status: " + rs.getString("status"));
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}
