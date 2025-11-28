-- Removendop o banco de dados se ele já existir
DROP DATABASE IF EXISTS eventos;

-- Criando um novo banco de dados chamado "Eventos"
CREATE DATABASE eventos;

\c eventos; -- Conexão ao Banco

-- Tabela de usuários
CREATE TABLE usuarios(
    id_usuario serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de eventos
CREATE TABLE evento(
    id_evento serial PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descricao TEXT,
    data_evento DATE NOT NULL,
    local VARCHAR(200) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario INTEGER REFERENCES usuario(id_usuario)
);

-- Tabela de participantes
CREATE TABLE participante(
    id_participante serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP  
);

-- Tabela de inscrições
CREATE TABLE inscricao(
    id_inscricao serial PRIMARY KEY,
    id_participante INTEGER REFERENCES participante(id_participante),
    id_evento INTEGER REFERENCES evento(id_evento),
    data_inscricao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ====================================
--    INSERÇÃO DE DADOS NAS TABELAS
-- ====================================

-- Inserindo Usuarios
INSERT INTO usuarios (nome, email, senha) VALUES
('Lucas Oliveira', 'lucas@gmail.com', '1234'),
('Marcos Freitas', 'freimarcos@gmail.com', 'frei123'),
('Ana Coelho', 'bunnyann@gmail.com', 'bunny'),
('Maria Sanchez', 'samaria@gmail.com', 'sam12345');

-- Inserindo Eventos
INSERT INTO evento (titulo, descricao, data_evento, local, id_usuario) VALUES
('Workshop de Tecnologia', 'Evento sobre inovações e tendências em TI.', '2025-11-30', 'Auditório Central IFRS', 1),
('Seminário de Sustentabilidade', 'Discussão sobre práticas ecológicas e energia verde.', '2025-12-10', 'Centro Verde', 2),
('Feira de Startups', 'Apresentação de projetos empreendedores universitários.', '2026-01-15', 'Parque Tecnológico', 3),
('Congresso de IA', 'Painéis e palestras sobre Inteligência Artificial aplicada.', '2026-02-20', 'Universidade Anhanguera', 4),
('Hackathon Universitário', 'Competição de programação com foco em soluções sociais.', '2026-03-05', 'Universidade FURG', 5);

-- Inserindo Participante
INSERT INTO participante (nome, email, telefone) VALUES
('Rafaela Costa', 'rafaela.costa@email.com', '(11) 91234-5678'),
('Gustavo Almeida', 'gustavo.almeida@email.com', '(21) 99876-5432'),
('Isabela Rocha', 'isabela.rocha@email.com', '(31) 97777-4444'),
('Felipe Martins', 'felipe.martins@email.com', '(41) 96543-2198'),
('Juliana Barbosa', 'juliana.barbosa@email.com', '(85) 98877-6655');

-- Inserindo Inscrição
INSERT INTO inscricao (id_participante, id_evento) VALUES
(1, 1),  -- Rafaela no Workshop de Tecnologia
(2, 1),  -- Gustavo no Workshop de Tecnologia
(3, 2),  -- Isabela no Seminário de Sustentabilidade
(4, 4),  -- Felipe no Congresso de IA
(5, 5);  -- Juliana no Hackathon Universitário


-- ====================================
--      CONSULTAS DE VALIDAÇÃO
-- ====================================

-- Listando todos os Usuários
SELECT * FROM usuario;

-- Consultando todos os Eventos
SELECT * FROM eventos;

-- Consultando Os Eventos e o seus respectivos Criadores
SELECT * FROM eventos JOIN titulos ON id_usuario;

