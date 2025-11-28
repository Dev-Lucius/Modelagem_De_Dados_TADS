package  model;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ParticipanteDAO{
    public void cadastrarParticipante(String nome, String email, String telefone){
        String sql = "INSERT INTO participante (nome, email, telefone) VALUES (?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)){

            stmt.setString(1, nome);
            stmt.setString(2, email);
            stmt.setString(3, telefone);
            stmt.executeUpdate();

            System.out.println("✅ Participante cadastrado com sucesso!");
        } catch (Exception e) {
            System.out.println("❌ Erro ao cadastrar participante: " + e.getMessage());
        }
    }
}