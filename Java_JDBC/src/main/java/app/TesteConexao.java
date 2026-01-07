package app;

import java.sql.Connection;

public class TesteConexao{
    public static void main(String[] args) {
        try (Connection conn = Conexao.getConnection()) {
            System.out.println("Conexão Realiza com Sucesso");
        } catch (Exception e) {
            System.err.println("Falha na Conexão");
            e.printStackTrace();
        }

        
    }
}