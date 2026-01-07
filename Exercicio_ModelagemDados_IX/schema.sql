DROP DATABASE IF EXISTS farmacia;
CREATE DATABASE farmacia;
\c farmacia;

-- Tabelas Para As Entidades Fortes
CREATE TABLE cliente(
    id serial PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE CHECK(LENGTH(cpf) = 14),
    nome VARCHAR(100) NOT NULL
);
INSERT INTO cliente(cpf, nome) VALUES
('123.456.789-00', 'Maria Silva'),
('234.567.890-11', 'José Santos'),
('345.678.901-22', 'Ana Oliveira'),
('456.789.012-33', 'João Souza'),
('567.890.123-44', 'Francisco Costa'),
('678.901.234-55', 'Antônio Pereira'),
('789.012.345-66', 'Pedro Alves'),
('890.123.456-77', 'Lucas Rodrigues'),
('901.234.567-88', 'Carlos Ferreira'),
('012.345.678-99', 'Miguel Gomes');

CREATE TABLE medicamento(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    bula TEXT,
    valor NUMERIC(10, 2) NOT NULL CHECK (valor > 0),
    qtd_estoque INTEGER NOT NULL CHECK (valor > 0),
    exige_receita BOOLEAN DEFAULT FALSE
);
INSERT INTO medicamento (nome, bula, valor, qtd_estoque, exige_receita) VALUES
('Paracetamol', 'Indicado para redução da febre e alívio temporário de dores leves a moderadas, como dores associadas a gripes, resfriados comuns, dor de cabeça, dor de dente, dor nas costas, dores musculares, dores leves de artrite e dismenorreia.', 5.50, 150, FALSE),
('Ibuprofeno', 'Indicado para redução da febre e alívio de dores, tais como dores decorrentes de gripes e resfriados, dor de garganta, dor de cabeça, dor de dente, dor nas costas, dores musculares ou dores leves de artrite.', 8.90, 120, FALSE),
('Dipirona', 'Utilizado no tratamento da dor e febre, com tempo médio de início de ação de 30 a 60 minutos após a administração e geralmente dura 4 a 6 horas.', 4.20, 200, FALSE),
('Amoxicilina', 'Antibiótico de amplo espectro indicado para o tratamento de infecções bacterianas causadas por germes sensíveis, como infecções dos pulmões, amígdalas, seios da face, trato urinário, ouvidos, nariz e garganta.', 15.30, 80, TRUE),
('Omeprazol', 'Indicado para tratar certas condições em que ocorra muita produção de ácido no estômago, como úlceras gástricas e duodenais, esofagite de refluxo e síndrome de Zollinger-Ellison.', 12.00, 100, TRUE),
('Losartana', 'Indicado para o tratamento da hipertensão arterial, redução do risco de morbidade e mortalidade cardiovascular em pacientes hipertensos com hipertrofia ventricular esquerda.', 18.75, 90, TRUE),
('Metformina', 'Indicado para o tratamento do diabetes mellitus tipo 2, especialmente em pacientes com excesso de peso, quando o regime alimentar e o exercício físico não são suficientes para controlar adequadamente a glicemia.', 10.50, 110, TRUE),
('Simvastatina', 'Indicado para reduzir os níveis de colesterol total, LDL-colesterol e triglicerídeos em pacientes com hipercolesterolemia primária ou dislipidemia mista.', 14.80, 95, TRUE),
('Dorflex', 'Indicado para o alívio da dor associada a contraturas musculares, incluindo cefaleia tensional.', 7.60, 140, FALSE),
('Xarelto', 'Anticoagulante indicado para prevenção de tromboembolismo venoso em pacientes submetidos a cirurgias ortopédicas, tratamento de trombose venosa profunda e prevenção de recorrências.', 45.00, 60, TRUE),
('Neosaldina', 'Indicado para o tratamento de diversos tipos de dor de cabeça, incluindo enxaquecas.', 6.40, 130, FALSE),
('Saxenda', 'Indicado como adjuvante a uma dieta de baixa caloria e aumento da atividade física para o controle de peso em adultos com IMC ≥ 30 kg/m² ou ≥ 27 kg/m² com comorbidades.', 250.00, 30, TRUE);

CREATE TABLE fornecedor(
    id serial PRIMARY kEY,
    cnpj VARCHAR(18) NOT NULL UNIQUE CHECK(LENGTH(cnpj) = 18),
    nome VARCHAR(100) NOT NULL
);
INSERT INTO fornecedor (cnpj, nome) VALUES
('12.345.678/0001-90', 'Aché Laboratórios'),
('23.456.789/0001-01', 'Eurofarma'),
('34.567.890/0001-12', 'EMS'),
('45.678.901/0001-23', 'Sanofi'),
('56.789.012/0001-34', 'Bayer'),
('67.890.123/0001-45', 'Pfizer'),
('78.901.234/0001-56', 'Novartis'),
('89.012.345/0001-67', 'Cimed');

CREATE TABLE venda(
    id serial PRIMARY KEY,
    cliente_id INTEGER REFERENCES cliente(id) ON DELETE CASCADE,
    data_compra DATE NOT NULL
);
INSERT INTO venda (cliente_id, data_compra) VALUES
(1, '2023-01-15'), -- Maria
(2, '2023-02-20'), -- José
(3, '2023-03-10'), -- Ana
(4, '2023-04-05'), -- João
(5, '2023-05-12'), -- Francisco
(6, '2023-06-18'), -- Antônio
(7, '2023-07-22'), -- Pedro
(8, '2023-08-30'); -- Lucas

-- Tabelas Para as Entidades Associativas
CREATE TABLE medicamento_venda(
    venda_id INTEGER REFERENCES venda(id),
    medicamento_id INTEGER REFERENCES medicamento(id),
    qtd_vendida INTEGER NOT NULL CHECK (qtd_vendida > 0),
    PRIMARY KEY(venda_id, medicamento_id)
);
INSERT INTO medicamento_venda(venda_id, medicamento_id, qtd_vendida) VALUES
(1, 1, 2),  -- Venda 1: Paracetamol
(1, 2, 1),  -- Ibuprofeno
(2, 3, 3),  -- Dipirona
(2, 4, 1),  -- Amoxicilina
(3, 5, 2),  -- Omeprazol
(3, 6, 1),  -- Losartana
(4, 7, 1),  -- Metformina
(4, 8, 2),  -- Simvastatina
(7, 1, 1),  -- Paracetamol
(7, 3, 2),  -- Dipirona
(8, 2, 1),  -- Ibuprofeno
(8, 4, 1);  -- Amoxicilina

CREATE TABLE fornecedor_medicamento(
    medicamento_id INTEGER REFERENCES medicamento(id),
    fornecedor_id INTEGER REFERENCES fornecedor(id),
    preco_fornecedor INTEGER NOT NULL CHECK (preco_fornecedor > 0),
    PRIMARY KEY(medicamento_id, fornecedor_id)
);
INSERT INTO fornecedor_medicamento(medicamento_id, fornecedor_id, preco_fornecedor) VALUES
INSERT INTO fornecedor_medicamento (medicamento_id, fornecedor_id, preco_fornecedor) VALUES
(1, 1, 4.00),
(2, 1, 7.00),
(3, 2, 3.50),
(4, 2, 12.00),
(5, 3, 9.50),
(6, 3, 15.00),
(7, 4, 8.00),
(8, 4, 12.50),
(9, 5, 40.00),
(10, 6, 5.00),
(11, 6, 200.00),
(1, 7, 3.80),
(3, 7, 3.20),
(2, 8, 6.50),
(4, 8, 11.00);


-- Consultas SQL

-- Ex 1°: Selecione todos os campos da tabela Medicamento.
SELECT * FROM medicamento;

-- Ex 2°: Liste os nomes e CPFs dos clientes ordenados alfabeticamente pelo nome.
SELECT c.nome AS cliente_nome, c.cpf AS cliente_cpf 
FROM cliente c 
ORDER BY c.nome ASC;

-- Ex 3°: Filtre medicamentos onde exige_receita é TRUE.
SELECT m.nome AS medicamento_nome, m.exige_receita AS receita
FROM medicamento m
WHERE m.exige_receita = TRUE
ORDER BY m.nome ASC;

-- Ex 4°: Encontre vendas realizadas em uma data específica (ex.: '2023-01-01').
SELECT v.data_compra AS data
FROM venda v
WHERE data_compra = '2023-01-01';

-- Ex 5°: Selecione fornecedores com CNPJ começando por '00' usando LIKE.
SELECT f.nome AS nome_fornecedor, f.cnpj AS cnpj_fornecedor
FROM fornecedor f
WHERE f.cnpj LIKE '00%';

-- Ex 6°: Liste vendas com o nome do cliente associado.
-- Observação
/*
    - v.cliente_id é FK que referencia cliente(id)
    - O JOIN respeita corretamente o relacionamento do modelo
    - Nesse caso, Não há necessidade de GROUP BY (não há agregações)
*/
SELECT 
    c.nome AS nome_cliente,
    v.id AS vendas_id
FROM venda v
INNER JOIN cliente c
ON c.id = v.cliente_id; -- FK → PK

-- Ex 7°: Para uma venda específica (por ID), liste os medicamentos e quantidades vendidas.
-- Medicamento / medicamento_venda / venda
SELECT
    m.nome AS nome_medicamento,
    m.id AS medicamento_id,
    mv.qtd_vendida AS vendas,
    v.id AS venda_id
FROM medicamento m
JOIN medicamento_venda mv
    ON mv.medicamento_id = m.id
JOIN venda v
    ON mv.venda_id = v.id;

-- Ex 8°: Junte Fornecedor e Fornecedor_Medicamento para listar preços por fornecedor e medicamento.
-- Fornecedor / fornecedor_medicamento / medicamento
SELECT
    f.nome AS fornecedor_nome,
    fm.preco_fornecedor AS preco,
    m.nome AS nome_medicamento
FROM fornecedor f
JOIN fornecedor_medicamento fm
    ON fm.fornecedor_id = f.id
JOIN medicamento m
    ON fm.medicamento_id = m.id;

-- Ex 9°: Agrupe e conte o número de vendas por cliente, ordenando pelo total descendente.
SELECT
    c.nome AS cliente_nome,
    COUNT(v.id) AS total_vendas_por_cliente
FROM cliente c
JOIN venda v
    ON c.id = v.cliente_id
GROUP BY c.nome
ORDER BY total_vendas_por_cliente DESC;

-- Ex 10°: Calcule o valor total de uma venda somando (quantidade_vendida * valor do medicamento).
SELECT
    v.id AS venda_id,
    m.nome AS medicamento,
    mv.qtd_vendida,
    m.valor,
    (mv.qtd_vendida * m.valor) AS subtotal
FROM venda v
JOIN medicamento_venda mv
    ON v.id = mv.venda_id
JOIN medicamento m
    ON m.id = mv.medicamento_id
ORDER BY v.id;

-- Ex 11°: Liste medicamentos com estoque menor que a média de todos os estoques.
-- A ideia é usar uma Subconsulta dentro da Consulta Principal
SELECT
    m.nome AS nome_medicamento,
    m.qtd_estoque
FROM medicamento m WHERE m.qtd_estoque < (
    -- Calculando a Media da qtd_estoque
    -- do Medicamento
    SELECT AVG(qtd_estoque)
    FROM medicamento
);

-- Ex 12°: Liste vendas com detalhes do cliente, medicamentos e se exigem receita.
/*
    Join Múltiplo Seguindo o Seguinte Caminho:
    Venda -> Cliente
    Venda -> Medicamento_venda -> Medicamento

    - Where serve para filtrar somento medicamentos controlados (exige_receita = TRUE)
    - Como não há agragações, não há necessidade de GROUP BY
*/
SELECT
    c.nome AS cliente_nome,
    v.data_compra,
    m.exige_receita AS receita,
    v.id AS venda_id
FROM venda v
JOIN cliente c
    ON c.id = v.cliente_id
JOIN medicamento_venda mv
    ON v.id = mv.venda_id
JOIN medicamento m
    ON m.id = mv.medicamento_id
WHERE m.exige_receita = TRUE;

-- Ex 13°: Encontre clientes com mais de 3 vendas usando GROUP BY e HAVING.
SELECT
    c.nome AS cliente_nome,
    COUNT(v.id) AS total_vendas,
    c.cpf AS cliente_cpf
FROM cliente c
LEFT JOIN venda v
    ON c.id = v.cliente_id
GROUP BY c.nome, c.cpf
HAVING COUNT(v.id) > 2;

-- Ex 14°: Atribua ranking aos medicamentos por valor usando ROW_NUMBER() OVER (ORDER BY valor DESC).
