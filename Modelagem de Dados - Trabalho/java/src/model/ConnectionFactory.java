package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {

    // Declaração de constantes (static final = imutáveis e únicas para a classe inteira)
    // URL → caminho do banco de dados PostgreSQL, incluindo o nome do banco ("eventos")
    private static final String URL = "jdbc:postgresql://localhost:5432/eventos";

    // Usuário do banco de dados (aquele criado no PostgreSQL, com permissões para acessar o banco "eventos")
    private static final String USER = "luciustads";

    // Senha correspondente ao usuário acima.
    private static final String PASSWORD = "senha";

    // Método estático que "fabrica" e devolve uma nova conexão com o banco de dados.
    // O tipo de retorno é "Connection", que representa a conexão ativa.
    public static Connection getConnection() {
        try {

            // Tenta abrir a Conexão usando o DriverManager
            // O qual localiza o driver JDBC do PSQL
            return DriverManager.getConnection(URL, USER, PASSWORD);

            // OBS: Por trás das cortinas, o DriverManager chama o driver do PostgreSQL (org.postgresql.Driver)
            // e estabelece uma sessão TCP/IP com o servidor rodando na porta 5432 (padrão do PostgreSQL).
            
        } catch (SQLException e) {

            // Caso ocorra algum erro durante a tentativa de conexão, o bloco catch será executado.
            // Isso pode acontecer, por exemplo, se:
            // - O banco estiver offline
            // - O usuário ou senha estiver incorreto
            // - O driver JDBC não estiver corretamente instalado no projeto
            // - A URL estiver errada
            throw new RuntimeException("Erro ao conectar ao banco de dados: " + e.getMessage(), e);
        }
    }
}

