package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class InscricaoDAO{
    public void cadastrarInscricao(int idParticipante, int idEvento){
        String sql = "INSERT INTO inscricao (id_participante, id_evento) VALUES (?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)){
            stmt.setInt(1, idParticipante);
            stmt.setInt(2, idEvento);

            stmt.executeUpdate();
            System.out.println("✅ Inscrição registrada com sucesso!");
        } catch (SQLException e) {
            System.out.println("❌ Erro ao registrar inscrição: " + e.getMessage());
        }
    }
}