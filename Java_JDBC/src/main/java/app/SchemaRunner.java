package app;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.Statement;

public class SchemaRunner {

    public static void main(String[] args) {
        executarSchema();
    }

    public static void executarSchema() {
        try (
            Connection conn = Conexao.getConnection();
            Statement stmt = conn.createStatement()
        ) {

            InputStream is = SchemaRunner.class
                .getClassLoader()
                .getResourceAsStream("schema.sql");

            BufferedReader reader =
                new BufferedReader(new InputStreamReader(is));

            StringBuilder sql = new StringBuilder();
            String linha;

            while ((linha = reader.readLine()) != null) {
                sql.append(linha);
                if (linha.trim().endsWith(";")) {
                    stmt.execute(sql.toString());
                    sql.setLength(0);
                }
            }

            System.out.println("✅ Schema executado com sucesso!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
