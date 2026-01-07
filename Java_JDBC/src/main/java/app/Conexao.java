package app;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao{
    private static final String URL = "jdbc:postgresql://localhost:5432/teste_jdbc";
    private static final String user = "postgres";
    private static final String password = "postgres";

    private Conexao(){

    }

    public static Connection getConnection() throws SQLException{
        return DriverManager.getConnection(URL, user, password);
    }
}