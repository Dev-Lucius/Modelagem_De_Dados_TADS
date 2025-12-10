-- Exercício

DROP DATABASE IF EXISTS restaurante;

CREATE DATABASE restaurante;

\c restaurante;

CREATE TABLE clientes(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE,
    telefone VARCHAR(11) NOT NULL
);
INSERT INTO clientes (nome, cpf, telefone) VALUES
('Lucas Oliveira', '84983132015', '53999305193'),
('Maria Gabriela', '78974525650', '53887821694'),
('Marcos Freitas', '12345678952', '53999306247');

CREATE TABLE mesas(
    id serial PRIMARY KEY,
    numero_mesa INTEGER NOT NULL,
    quantidade INTEGER NOT NULL
);
INSERT INTO mesas (numero_mesa, quantidade) VALUES
(1, 5),
(2, 10),
(3, 15);

CREATE TABLE funcionarios(
    id serial PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cargo VARCHAR(50)
);
INSERT INTO funcionarios (nome, cargo) VALUES
('Fabricio Nunes', 'Garçom'),
('Amanda Sanchez', 'Garçom'),
('Ronaldo Silva', 'Atendente');

CREATE TABLE pedidos(
    id serial PRIMARY KEY,
    data_pedido DATE,
    status_pedido TEXT NOT NULL,
    -- Chaves Estrangeiras
    cliente_id INTEGER REFERENCES clientes(id), 
    mesa_id INTEGER REFERENCES mesas(id), 
    funcionario_id INTEGER REFERENCES funcionarios(id) 
);
INSERT INTO pedidos (data_pedido, status_pedido, cliente_id, mesa_id, funcionario_id) VALUES
('2025-12-10', 'ABERTO', 1, 1, 1),
('2025-12-10', 'FECHADO', 2, 2, 2);

CREATE TABLE itens_pedidos(
    id serial PRIMARY KEY,
    pedido_id INTEGER REFERENCES pedidos(id),
    item_nome TEXT NOT NULL,
    quantidade INTEGER NOT NULL,
    valor_unitario NUMERIC(10,2) NOT NULL
);

-- Adicione coluna observacoes em pedidos com TEXT.
ALTER TABLE pedidos ADD COLUMN observacoes TEXT;

-- Seleciona pedidos atendidos por um funcionário cujo nome contenha 'Silva'
SELECT 
    p.id AS pedido_id,
    p.data_pedido,
    p.status_pedido,
    f.nome AS funcionario_nome
FROM pedidos p
JOIN funcionarios f ON f.id = p.funcionario_id   
WHERE f.nome LIKE '%Silva%';                    

