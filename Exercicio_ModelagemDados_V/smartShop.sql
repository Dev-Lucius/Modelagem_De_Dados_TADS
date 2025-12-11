DROP DATABASE IF EXISTS smartshop;

CREATE DATABASE smartshop;
\c smartshop;

CREATE TABLE clientes(
    id_cliente serial PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(120) UNIQUE,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT NOW()
);

CREATE TABLE pedidos(
    id_pedido serial PRIMARY KEY,
    id_cliente INTEGER REFERENCES clientes(id_cliente),
    data_pedido TIMESTAMP DEFAULT NOW(),
    status VARCHAR(30) DEFAULT 'Pendente'
);

CREATE TABLE pagamentos(
    id_pagamentos serial PRIMARY KEY,
    id_pedido INTEGER REFERENCES pedidos(id_pedidos),
    valor NUMERIC(10,2),
    metodo VARCHAR(50) NOT NULL,
    data_pagamento NUMERIC(10,2)
);

CREATE TABLE produtos(
    id_produto serial PRIMARY KEY,
    nome VARCHAR(100),
    categoria VARCHAR(50),
    preco NUMERIC(10,2)
);

CREATE TABLE itens_pedidos(
    id_item serial PRIMARY KEY,
    id_produto INTEGER REFERENCES produtos(id_produto),
    id_pedido INTEGER REFERENCES pedidos(id_pedidos),
    quantidade INTEGER,
    preco_unit NUMERIC(10,2)
);

CREATE TABLE estoque(
    id_produto INTEGER REFERENCES produtos(id_produto),
    quantidade INTEGER
);

-- Inserção de Dados
INSERT INTO clientes (nome, email, telefone) VALUES
('Lucas Oliveira', 'lucas@mail.com', '4899001-2233'),
('Mariana Silva', 'mariana@mail.com', '4899001-4455'),
('João Lima', 'joao@mail.com', '4899001-8899');

INSERT INTO produtos (nome, categoria, preco) VALUES
('Teclado Mecânico', 'Periférico', 350.00),
('Mouse Gamer', 'Periférico', 220.00),
('Monitor 27"', 'Display', 1450.00),
('Headset RGB', 'Áudio', 280.00);

INSERT INTO estoque VALUES
(1, 50),
(2, 80),
(3, 20),
(4, 60);

INSERT INTO pedidos (id_cliente) VALUES
(1), (2), (1);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unit) VALUES
(1, 1, 1, 350.00),
(1, 2, 2, 220.00),
(2, 3, 1, 1450.00),
(3, 4, 1, 280.00);

INSERT INTO pagamentos (id_pedido, valor, metodo) VALUES
(1, 790.00, 'Cartão'),
(2, 1450.00, 'Pix'),
(3, 280.00, 'Dinheiro');
