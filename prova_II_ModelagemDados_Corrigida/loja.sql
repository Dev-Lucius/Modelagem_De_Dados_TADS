DROP DATABASE IF EXISTS loja;

CREATE DATABASE loja;
\c loja;

CREATE TABLE clientes(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(60),
    cpf VARCHAR(11) UNIQUE 
);

CREATE TABLE produtos(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco NUMERIC(10,2) NOT NULL,
    categoria VARCHAR(100) NOT NULL DEFAULT 'Variados'
);

CREATE TABLE pedidos(
    id serial PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    data_hora TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE pedidos_itens(
    id serial PRIMARY KEY,
    pedido_id INTEGER NOT NULL REFERENCES pedidos(id),
    produto_id INTEGER NOT NULL REFERENCES produtos(id),
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    valor_unitario NUMERIC(10, 2) NOT NULL
);

-- Adicionando uma nova Coluna na Tabela produtos
ALTER TABLE produtos ADD COLUMN categoria VARCHAR(100) DEFAULT 'Diversos';

-- DQL — Selecionar pedidos entre duas datas
SELECT 
    id AS pedido_id,
    data_hora,
    to_char(data_hora, 'YYYY-MM-DD HH24:MI:SS') AS data_formatada 
FROM pedidos
WHERE data_hora BETWEEN '2025-01-01' AND '2025-12-31';

-- Clientes cuja cidade começa com 'S'
SELECT *
FROM clientes
WHERE cidade LIKE 'S%';

-- Pedidos cujos clientes têm a letra 'a' no nome
SELECT p.*
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id
WHERE LOWER(c.nome) LIKE '%a%';
