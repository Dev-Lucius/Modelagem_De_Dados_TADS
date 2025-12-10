/*
    ================================
    SISTEMA DE LOJA DE ELETRÔNICOS
    ================================

    Entidades:
        clientes, produtos, pedidos, itens_pedido

    Objetivos:
        - Modelagem correta com PK, FK, NOT NULL, UNIQUE
        - Manipular dados com INSERT, UPDATE
        - Consultas com filtros, intervalos e padrões
        - Criar índice
*/

-----------------------------------------------------
-- CRIAÇÃO DO BANCO
-----------------------------------------------------
DROP DATABASE IF EXISTS loja_eletronico;
CREATE DATABASE loja_eletronico;

-- Conecta ao banco recém criado
\c loja_eletronico;

-----------------------------------------------------
-- TABELA CLIENTES
-----------------------------------------------------
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,               -- Identificador único do cliente
    nome VARCHAR(100) NOT NULL,          -- Nome obrigatório
    cidade VARCHAR(50) NOT NULL,         -- Cidade obrigatória
    cpf VARCHAR(14) UNIQUE               -- CPF único; tamanho ajustado pois tem pontos e hífen
);

-- Inserção de 5 clientes
INSERT INTO clientes (nome, cidade, cpf) VALUES
('João Silva', 'São Paulo', '123.456.789-00'),
('Maria Santos', 'Rio de Janeiro', '234.567.890-11'),
('Pedro Oliveira', 'Belo Horizonte', '345.678.901-22'),
('Ana Costa', 'Salvador', '456.789.012-33'),
('Carlos Ferreira', 'Fortaleza', '567.890.123-44');

-----------------------------------------------------
-- TABELA PRODUTOS
-----------------------------------------------------
CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco NUMERIC(10,2) NOT NULL,
    estoque INTEGER NOT NULL DEFAULT 0,  -- Estoque com valor padrão 0
    categoria VARCHAR(50) NOT NULL       -- Campo obrigatório (exigido na tarefa)
);

-- Inserção de 6 produtos
INSERT INTO produtos (nome, preco, estoque, categoria) VALUES
('Teclado Ajax', 150.00, 5, 'Periféricos'),
('Mouse Óptico', 45.00, 7, 'Periféricos'),
('Monitor 24"', 899.00, 10, 'Monitores'),
('Notebook Gamer', 4500.00, 15, 'Computadores'),
('Headset Wireless', 199.00, 2, 'Audio'),
('Webcam HD', 89.99, 1, 'Periféricos');

-----------------------------------------------------
-- TABELA PEDIDOS
-----------------------------------------------------
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),  -- FK que vincula cliente ao pedido
    data_hora DATE NOT NULL                              -- Data do pedido
);

-- Inserção de 1 pedido (com 2 itens)
INSERT INTO pedidos (cliente_id, data_hora) VALUES
(1, '2025-12-01');

-----------------------------------------------------
-- TABELA ITENS DO PEDIDO
-----------------------------------------------------
CREATE TABLE itens_pedido (
    id SERIAL PRIMARY KEY,
    pedido_id INTEGER NOT NULL REFERENCES pedidos(id),     -- FK para pedido
    produto_id INTEGER NOT NULL REFERENCES produtos(id),   -- FK para produto
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),    -- Quantidade positiva
    valor_unitario NUMERIC(10,2) NOT NULL                  -- Preço na data da compra
);

-- Inserção de 2 itens para o pedido 1
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, valor_unitario) VALUES
(1, 1, 1, 150.00),
(1, 3, 2, 899.00);

-----------------------------------------------------
-- ADICIONAR COLUNA COM VALOR PADRÃO
-----------------------------------------------------
ALTER TABLE produtos ADD COLUMN garantia_meses INTEGER DEFAULT 12;

-----------------------------------------------------
-- SELECIONAR PEDIDOS ENTRE DATAS
-----------------------------------------------------
/*
    Importante:
        - Mostrar id do pedido
        - Data
        - Nome do cliente
*/
SELECT 
    p.id AS pedido_id,
    p.data_hora,
    c.nome AS cliente
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id
WHERE p.data_hora BETWEEN '2025-01-01' AND '2025-12-25';

-----------------------------------------------------
-- LISTAR PRODUTOS COM ESTOQUE MENOR QUE 5
-----------------------------------------------------
SELECT id, nome, estoque
FROM produtos
WHERE estoque < 5;

-----------------------------------------------------
-- CLIENTES CUJA CIDADE TERMINE COM "a"
-----------------------------------------------------
/*
    LIKE '%a' -> último caractere é "a"
*/
SELECT nome, cidade
FROM clientes
WHERE cidade LIKE '%a';

-----------------------------------------------------
-- ATUALIZAR ESTOQUE AO CONFIRMAR PEDIDO
-- Exemplo: reduzir estoque no pedido 1
-----------------------------------------------------
UPDATE produtos
SET estoque = estoque - (
    SELECT SUM(quantidade)
    FROM itens_pedido it
    WHERE it.produto_id = produtos.id AND it.pedido_id = 1
)
WHERE id IN (
    SELECT produto_id
    FROM itens_pedido
    WHERE pedido_id = 1
);

-----------------------------------------------------
-- CRIAR ÍNDICE EM "categoria"
-----------------------------------------------------
CREATE INDEX idx_produtos_categoria ON produtos(categoria);
