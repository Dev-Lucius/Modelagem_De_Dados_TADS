package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

// Método Responsável por Cadastrar um Novo Evento no Banco de Dados
// DAO = Data Access Object -> Um objeto especializado em lidar com o banco de dados.
// O padrão se Repete para as outras Classes
public class EventoDAO{
    public void cadastrarEvento(String titulo, String descricao, String dataEvento, String local, int idUsuario){

        // Comando SQL parametrizado: evita SQL Injection e permite reutilização eficiente pelo driver.
        // Os sinais de interrogação (?) são "placeholders" que serão substituídos pelos valores Java.
        String sql = "INSERT INTO evento (titulo, descricao, data_evento, local, id_usuario) VALUES (?, ?, ?, ?, ?)";
        
        // OBS!!
        // conn = Instância da Classe Connection, que representa a conexão ativa entre o seu programa Java e o banco de dados.
        // stmt = Instância da Classe PreparedStatement, que representa um comando SQL pré-compilado.
        try (Connection conn = ConnectionFactory.getConnection(); // Abre uma conexão com o banco via a classe ConnectionFactory.
             PreparedStatement stmt = conn.prepareStatement(sql)) // Prepara o comando SQL para execução.
        {
                stmt.setString(1, titulo);
                stmt.setString(2, descricao);
                stmt.setDate(3, java.sql.Date.valueOf(dataEvento));
                stmt.setString(4, local);
                stmt.setInt(5, idUsuario);

                stmt.executeUpdate();
                System.out.println("✅ Evento cadastrado com sucesso!");
        } catch(SQLException e){
            System.out.println("❌ Erro ao cadastrar evento: \" + e.getMessage()");
        }
    }
}