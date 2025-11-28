package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    // ✅ Cadastrar novo usuário
    public void cadastrarUsuario(String nome, String email, String senha) {
        String sql = "INSERT INTO usuario (nome, email, senha) VALUES (?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Estamos setando um "dado" dentro da tabela
            stmt.setString(1, nome); 
            stmt.setString(2, email); 
            stmt.setString(3, senha); 

            stmt.executeUpdate();
            System.out.println("✅ Usuário cadastrado com sucesso!");

        } catch (SQLException e) {
            System.out.println("❌ Erro ao cadastrar usuário: " + e.getMessage());
        }
    }

    // ✅ Buscar usuário por e-mail
    public void buscarUsuarioPorEmail(String email) {
        String sql = "SELECT * FROM usuario WHERE email = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                System.out.println("👤 Usuário encontrado:");
                System.out.println("ID: " + rs.getInt("id_usuario"));
                System.out.println("Nome: " + rs.getString("nome"));
                System.out.println("Email: " + rs.getString("email"));
                System.out.println("Data de Cadastro: " + rs.getTimestamp("data_cadastro"));
            } else {
                System.out.println("⚠️ Nenhum usuário encontrado com este e-mail.");
            }

        } catch (SQLException e) {
            System.out.println("❌ Erro ao buscar usuário: " + e.getMessage());
        }
    }

    // ✅ Autenticar usuário (login simples)
    public boolean autenticarUsuario(String email, String senha) {
        String sql = "SELECT * FROM usuario WHERE email = ? AND senha = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, senha);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                System.out.println("✅ Login bem-sucedido! Bem-vindo, " + rs.getString("nome"));
                return true;
            } else {
                System.out.println("❌ E-mail ou senha incorretos.");
                return false;
            }

        } catch (SQLException e) {
            System.out.println("❌ Erro ao autenticar usuário: " + e.getMessage());
            return false;
        }
    }
}
