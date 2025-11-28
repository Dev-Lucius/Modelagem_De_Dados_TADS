# 🗄️ Projeto Banco de Dados — Sistema de Gerenciamento de Eventos (Java + PostgreSQL)

## 📘 Visão Geral
Este projeto implementa um **sistema de gerenciamento de eventos** com integração completa entre **PostgreSQL** e **Java (via JDBC)**.  
O sistema permite **cadastrar usuários, eventos, participantes e inscrições**, com estrutura relacional sólida e suporte a consultas como:

- Listar eventos por organizador (usuário)
- Listar participantes de um evento
- Registrar novas inscrições

O foco principal foi compreender e aplicar o fluxo completo:
1. Criação e configuração do banco de dados no PostgreSQL;
2. Manipulação via terminal (`psql`) e interface (`pgAdmin4`);
3. Integração do banco com Java utilizando JDBC;
4. Organização profissional da estrutura de pastas do projeto.

---

## 🧩 Estrutura Física do Banco de Dados

### 1️⃣ Criação do Banco de Dados

```sql
CREATE DATABASE eventos;
```

---

### 2️⃣ Criação das Tabelas

```sql
-- Tabela de Usuários
CREATE TABLE usuario(
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Eventos
CREATE TABLE evento(
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descricao TEXT,
    data_evento DATE NOT NULL,
    local VARCHAR(200) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario INTEGER REFERENCES usuario(id_usuario)
);

-- Tabela de Participantes
CREATE TABLE participante(
    id_participante SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP  
);

-- Tabela de Inscrições
CREATE TABLE inscricao(
    id_inscricao SERIAL PRIMARY KEY,
    id_participante INTEGER REFERENCES participante(id_participante),
    id_evento INTEGER REFERENCES evento(id_evento),
    data_inscricao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 💾 Inserção de Dados Iniciais

### Usuários (Organizadores)
```sql
INSERT INTO usuario (nome, email, senha) VALUES
('Lucas Oliveira', 'lucas@gmail.com', '1234'),
('Mariana Silva', 'mariana@email.com', 'abcd'),
('Rafael Souza', 'rafael@email.com', 'xyz123'),
('Ana Pereira', 'ana@email.com', 'senha123'),
('Carlos Lima', 'carlos@email.com', 'pass456');
```

### Eventos
```sql
INSERT INTO evento (titulo, descricao, data_evento, local, id_usuario) VALUES
('Tech Conference 2025', 'Evento sobre inovação tecnológica', '2025-12-10', 'Auditório Central', 1),
('Workshop de IA', 'Introdução prática à Inteligência Artificial', '2025-12-15', 'Laboratório 3', 2),
('Encontro de Startups', 'Networking para empreendedores', '2025-12-20', 'Centro de Inovação', 3),
('Fórum de Cibersegurança', 'Debates sobre segurança digital', '2026-01-05', 'Auditório Sul', 4),
('Maratona de Programação', 'Competição de lógica e algoritmos', '2026-01-10', 'Campus Central', 1);
```

### Participantes
```sql
INSERT INTO participante (nome, email, telefone) VALUES
('Rafaela Costa', 'rafaela.costa@email.com', '(51)99999-0001'),
('João Santos', 'joao.santos@email.com', '(51)98888-0002'),
('Camila Torres', 'camila.torres@email.com', '(51)97777-0003'),
('André Barros', 'andre.barros@email.com', '(51)96666-0004'),
('Fernanda Souza', 'fernanda.souza@email.com', '(51)95555-0005');
```

### Inscrições
```sql
INSERT INTO inscricao (id_participante, id_evento) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4);
```

---

## ⚙️ Comandos Essenciais via Terminal (psql)

### Conectar-se ao PostgreSQL
```bash
sudo -i -u postgres
psql
```

### Criar um novo usuário e conceder permissões
```sql
CREATE USER luciustads WITH PASSWORD '1234';
GRANT ALL PRIVILEGES ON DATABASE eventos TO luciustads;
```

### Entrar no banco
```sql
\c eventos;
```

### Listar tabelas e dados
```sql
\dt
SELECT * FROM usuario;
SELECT * FROM evento;
SELECT * FROM participante;
SELECT * FROM inscricao;
```

### Deletar o banco de dados
```sql
\c postgres;
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'eventos';
DROP DATABASE eventos;
```

---

## 🧠 Consultas Importantes

### 1️⃣ Listar eventos por organizador
```sql
SELECT e.titulo, e.data_evento, u.nome AS organizador
FROM evento e
JOIN usuario u ON e.id_usuario = u.id_usuario;
```

### 2️⃣ Listar participantes de um evento
```sql
SELECT p.nome, p.email
FROM participante p
JOIN inscricao i ON p.id_participante = i.id_participante
WHERE i.id_evento = 1;
```

### 3️⃣ Registrar uma nova inscrição
```sql
INSERT INTO inscricao (id_participante, id_evento) VALUES (3, 1);
```

---

## ☕ Integração Java + JDBC

### Estrutura de Pastas do Projeto
```
📂 database/
 ┣ 📜 eventos.sql
 ┣ 📜 relacionalLogico.drawio
 ┣ 📜 Modelo Lógico e Relacional do Banco de Dados.png
📂 java/
 ┣ 📂 src/model/
 ┃ ┣ 📜 Conexao.java
 ┃ ┣ 📜 Usuario.java
 ┃ ┣ 📜 Evento.java
 ┃ ┣ 📜 Participante.java
 ┃ ┣ 📜 Inscricao.java
 ┃ ┣ 📜 Main.java
 ┣ 📂 lib/
 ┃ ┣ 📜 postgresql-42.7.8.jar
 📖 README.md
```

---

### Exemplo de Conexão (Conexao.java)
```java
package model;
import java.sql.Connection;
import java.sql.DriverManager;

public class Conexao {
    private static final String URL = "jdbc:postgresql://localhost:5432/eventos";
    private static final String USER = "luciustads";
    private static final String PASSWORD = "1234";

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            throw new RuntimeException("Erro ao conectar ao banco de dados: " + e.getMessage());
        }
    }
}
```

---

### Exemplo de Inserção (UsuarioDAO.java)
```java
package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import model.Conexao;

public class UsuarioDAO {
    public void cadastrarUsuario(String nome, String email, String senha) {
        String sql = "INSERT INTO usuario (nome, email, senha) VALUES (?, ?, ?)";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nome);
            stmt.setString(2, email);
            stmt.setString(3, senha);
            stmt.executeUpdate();
            System.out.println("Usuário cadastrado com sucesso!");
        } catch (Exception e) {
            System.out.println("Erro ao cadastrar usuário: " + e.getMessage());
        }
    }
}
```

---

### Exemplo de Execução no Terminal
Compilação:
```bash
javac -cp ".:postgresql-42.7.3.jar" model/*.java dao/*.java main/*.java
```

Execução:
```bash
java -cp ".:postgresql-42.7.3.jar" main.Main
```

---

## 🧭 Fluxo de Operações do Sistema
1. **Usuário** é cadastrado com nome, email e senha.  
2. **Evento** é criado e associado a um usuário organizador.  
3. **Participantes** se cadastram com nome, email e telefone.  
4. **Inscrições** são registradas relacionando participantes e eventos.  
5. **Consultas SQL** permitem listar, buscar e associar entidades.

---

## 🧱 Tecnologias Utilizadas
- **PostgreSQL 16**
- **pgAdmin 4**
- **psql (CLI)**
- **Java 17**
- **JDBC PostgreSQL Driver 42.7.3**

---

## 📌 Conclusão
Este projeto consolidou conceitos fundamentais de **modelagem relacional**, **integração Java com banco de dados** e **manipulação SQL via terminal**.  
A estrutura física foi planejada para garantir eficiência em consultas e facilitar futuras expansões — como autenticação, relatórios e dashboards.