DROP DATABASE IF EXISTS academia;
CREATE DATABASE academia;
\c academia;

CREATE TABLE cliente(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE CHECK(LENGTH(cpf) = 14),
    data_cadastro DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

CREATE TABLE instrutor(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    data_admissao DATE NOT NULL,
    especialidade TEXT
);

CREATE TABLE plano(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco_mensal NUMERIC(10, 2) NOT NULL CHECK(preco_mensal > 0),
    descricao TEXT,
    ativo BOOLEAN DEFAULT FALSE
);

CREATE TABLE aula(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    horario TIME NOT NULL,
    data_cadastro DATE NOT NULL,
    instrutor_id INTEGER REFERENCES instrutor(id)
);

-- Relação de Cliente -> Plano é de N:M
-- Trata-se de uma Tabela Intermediária 
CREATE TABLE cliente_plano(
    cliente_id INTEGER REFERENCES cliente(id),
    plano_id INTEGER REFERENCES plano(id),
    data_inicio DATE NOT NULL,
    data_fim DATE,
    PRIMARY KEY(cliente_id, plano_id)
);

-- Relação de Cliente -> Aula é de N:M
-- Trata-se de uma Tabela Intermediária 
CREATE TABLE matricula_aula(
    cliente_id INTEGER REFERENCES cliente(id),
    aula_id INTEGER REFERENCES aula(id),
    data_matricula DATE NOT NULL,
    PRIMARY KEY(cliente_id, aula_id)
);


-- Lista de Consultas

-- INSERT
-- Insira três clientes na tabela Cliente.
INSERT INTO cliente (nome, email, cpf, data_cadastro, telefone) VALUES
('João Pereira', 'joao@gmail.com', '123.456.789-00', '2024-02-10', '51999990001'),
('Maria Oliveira', 'maria@yahoo.com', '987.654.321-00', '2024-03-15', '51999990002'),
('Carlos Santos', 'carlos@hotmail.com', '456.789.123-00', '2023-11-20', '51999990003'),
('Marcos Aurélio', ',marcosaul@hotmail.com', '789.456.123-77', '2025-11-20', '51888880003');


-- Adicione dois instrutores na tabela Instrutor.
INSERT INTO instrutor (nome, email, data_admissao, especialidade) VALUES
('Ricardo Lima', 'ricardo@academia.com', '2022-06-01', 'Musculação'),
('Fernanda Alves', 'fernanda@academia.com', '2023-08-15', 'Aulas Coletivas'),
('Paulo Rocha', 'paulo@academia.com', '2025-01-10', 'Cross Training');

-- Cadastre três planos diferentes na tabela Plano.
INSERT INTO plano (nome, preco_mensal, descricao, ativo) VALUES
('Plano Básico', 80.00, 'Acesso à musculação', TRUE),
('Plano Intermediário', 120.00, 'Musculação + aulas coletivas', TRUE),
('Plano Premium', 200.00, 'Acesso total + personal', TRUE),
('Plano Antigo', 60.00, 'Plano descontinuado', FALSE);

-- Insira quatro aulas diferentes na tabela Aula.
INSERT INTO aula (nome, horario, data_cadastro, instrutor_id) VALUES
('Musculação Funcional', '08:00', '2024-01-10', 1),
('Spinning', '18:00', '2024-02-05', 2),
('Yoga', '19:00', '2024-02-20', 2),
('Cross Training', '07:00', '2025-01-15', 3);

-- Relacione clientes e planos na tabela Cliente_Plano.
INSERT INTO cliente_plano (cliente_id, plano_id, data_inicio, data_fim) VALUES
(1, 2, '2024-02-10', NULL), -- João No Plano Intermediário
(2, 3, '2024-03-15', NULL), -- Maria no Plano Premium
(3, 1, '2023-11-20', '2024-11-20'), -- Carlos no Plano Básico
(4, 2, '2025-01-05', NULL); -- Marcos no Plano Premium

-- Matricule clientes em aulas na tabela Matricula_Aula.
INSERT INTO matricula_aula (cliente_id, aula_id, data_matricula) VALUES
(1, 1, '2024-02-12'), -- João Fazendo Musculação Funcional
(1, 2, '2024-02-15'), -- João Fazendo Spinning
(2, 2, '2024-03-20'), -- Maria Fazendo Spinning
(2, 3, '2024-03-22'), -- Maria Fazendo Yoga
(4, 4, '2025-01-20'); -- Marcos Fazendo Cross Training


-- UPDATE
-- Atualize o email de um cliente específico.
/*
    Atualizando o Email do Cliente com ID = 1
*/
UPDATE cliente SET email = 'ricardolima11@gmail.com' WHERE id = 1;

-- Altere o nome de um cliente para “Maria Silva”.
/*
    Atualizando o Nome do Cliente com ID = 4
*/
UPDATE cliente SET nome = 'Maria Silva' WHERE id = 2;

-- Modifique o valor mensal de um plano para 120.00.
/*
    Atualizando o valor mensal do Plano com ID = 4
*/
UPDATE plano SET valor_mensal = 120.00 WHERE id = 4;

-- Mude o nome de uma aula de “Spinning” para “Ciclismo Indoor”.
UPDATE aula SET nome = 'Ciclismo Indoor' WHERE id = 2;

-- DELETE
-- Remova um cliente específico (apagando antes os registros nas tabelas associativas).
/*
    Removendo o Marcos Aurélio
*/
DELETE FROM cliente WHERE id = 4;

-- Exclua uma aula que não possui alunos matriculados.
DELETE FROM aula
WHERE id NOT IN (
    SELECT aula_id
    FROM matricula_aula
)

-- Delete um plano que não está mais disponível.
DELETE FROM plano WHERE ativo = FALSE;

-- SELECT
-- Liste todos os clientes cadastrados.
SELECT 
    c.nome AS cliente_nome,
    c.cpf AS cliente_cpf,
    c.email AS cliente_email,
    c.telefone AS cliente_telefone,
    c.data_cadastro 
FROM cliente c
ORDER BY c.nome;

-- Mostre o nome e o preço mensal de todos os planos.
SELECT
    p.nome AS plano_nome,
    p.preco_mensal AS preco
FROM plano p
ORDER BY p.preco_mensal ASC;

-- Exiba as aulas e seus respectivos horários.
SELECT
    a.nome AS nome_aula,
    a.horario AS horario_da_aula
FROM aula a
ORDER BY a.horario ASC;

-- Liste os nomes dos instrutores e a data de admissão.
SELECT
    i.nome AS nome_instrutor,
    i.data_admissao
FROM instrutor i
ORDER BY i.data_admissao ASC;


-- WHERE
-- Liste os clientes cadastrados após 2024-01-01.
SELECT
    c.nome AS cliente_nome,
    c.data_cadastro
FROM cliente c
WHERE c.data_cadastro > '2024-01-01'
ORDER BY c.nome ASC;

-- Mostre as aulas que acontecem no horário das 18h.
SELECT
    a.nome AS aula_nome,
    a.horario
FROM aula a
WHERE horario = '18:00:00';

-- Encontre os planos cujo preço mensal seja maior que 100.
SELECT
    p.nome AS nome_plano,
    p.preco_mensal AS preco
FROM plano p
WHERE p.preco_mensal > 100.00;

-- Liste os instrutores contratados antes de 2023-01-01.
SELECT
    i.nome AS nome_instrutor,
    i.data_admissao
FROM instrutor i
WHERE i.data_admissao < '2023-01-01';

-- Condicionais Lógicas
-- AND, OR, NOT
-- Mostre os clientes cadastrados depois de 2024-01-01 e cujo email termina com @gmail.com.
SELECT
    c.nome AS nome_cliente,
    c.email AS cliente_email,
    c.data_cadastro
FROM cliente c
WHERE c.data_cadastro > '2024-01-01' AND c.email LIKE '%@gmail.com';

-- Liste os planos com preço entre 80 e 200.
SELECT
    p.nome AS nome_plano,
    p.preco_mensal AS preco
FROM plano p
WHERE p.preco_mensal >= 80.00 AND p.preco_mensal <= 200.00;

-- Mostre as aulas ministradas por instrutores não contratados em 2025.
SELECT
    a.nome AS nome_aula,
    i.nome AS nome_instrutor,
    i.data_admissao
FROM aula a
RIGHT JOIN instrutor i
    ON i.id = a.instrutor_id
WHERE i.data_admissao < '2025-01-01';

-- Operadores de conjunto e subconsultas
-- Liste os clientes que ainda não estão matriculados em nenhuma aula (NOT IN).
SELECT
    c.nome AS nome_cliente
FROM cliente c 
WHERE c.id NOT IN(
    SELECT ma.cliente_id
    FROM matricula_aula ma 
);

-- Mostre os planos que não foram contratados por nenhum cliente.
SELECT
    p.nome AS nome_plano
FROM plano p
WHERE p.id NOT IN(
    SELECT cp.plano_id
    FROM cliente_plano cp
);

-- Encontre as aulas que não possuem nenhum aluno matriculado (NOT EXISTS).
/*
    NOT EXISTS não compara valores (a.id),
    Ele apenas testa a existência de linhas retornadas por uma subconsulta

    EM OUTRAS PALAVRAS ...
    - Para cada uma aula a
    - Existe alguma matricula_aula com esse aula_id
        * Se existe → a aula tem alunos → não entra
        * Se não existe → a aula não tem alunos → entra no resultado
*/
SELECT
    a.nome AS nome_aula
FROM aula a
WHERE NOT EXISTS(
    SELECT 1 
    FROM matricula_aula ma
    WHERE ma.aula_id = a.id
);

-- ALTERNATIVA COM LEFT JOIN
SELECT
    a.nome AS nome_aula
FROM aula a
LEFT JOIN matricula_aula ma
    ON a.id = ma.aula_id
WHERE ma.aula_id IS NULL;

-- ORDER BY, LIMIT
-- Liste os clientes em ordem alfabética.
SELECT
    c.nome AS cliente_nome,
    c.id AS cliente_id
FROM cliente c
ORDER BY c.nome ASC;

-- Mostre os planos do mais caro para o mais barato.
SELECT
    p.nome AS plano_nome,
    p.preco_mensal AS preco
FROM plano p
ORDER BY p.preco_mensal DESC;

-- Exiba as três aulas cadastradas mais recentemente.
SELECT
    a.nome AS aula_nome,
    a.data_cadastro
FROM aula a
ORDER BY a.data_cadastro ASC
LIMIT 3;

-- Liste os instrutores do mais antigo ao mais novo.
SELECT
    i.nome AS nome_instrutor,
    i.data_admissao
FROM instrutor i
ORDER BY i.data_admissao DESC; 
    
-- Definição e alteração de estrutura (DDL)
-- Crie a tabela Equipamento (id, nome, tipo, data_aquisicao).
CREATE TABLE equipamento(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo TEXT,
    data_aquisicao DATE NOT NULL
);

-- Adicione a coluna RG à tabela Cliente.
ALTER TABLE cliente 
ADD COLUMN registro_geral VARCHAR(20) UNIQUE 
CHECK (LENGTH(registro_geral) = 20);

-- Renomeie a coluna preco_mensal para valor_mensal na tabela Plano.
ALTER TABLE plano
RENAME preco_mensal TO valor_mensal;

-- Remova a tabela Equipamento.
DROP TABLE IF EXISTS equipamento;

-- Funções de texto e data
-- Mostre apenas o primeiro nome dos clientes.
/*
    Explicando a Função SPLIT_PART
    SPLIT_PART(texto, separador, posição)
        * Divide o Nome pelo espaço ' '
        * Retorna apenas a Primeira Palavra
*/
SELECT
    SPLIT_PART(nome, ' ', 1) AS primeiro_nome
FROM cliente;

-- Exiba o ano de admissão dos instrutores.
/*
    Explicando a Função EXTRACT
    EXTRACT(YEAR FROM <data>)
        * Retorna apenas o Ano da Data
*/
SELECT
    i.nome AS instrutor_nome,
    EXTRACT(YEAR FROM data_admissao) AS ano_admissao
FROM instrutor i;

-- Liste clientes cujo email não contém “hotmail”.
-- LIKE ==> Sensível a Letras Maiúsculas e Minúsculas (case-sensitive)
-- ILIKE ==> Não é Sensível a Letras Maiúsculas e Minúsculas (case-sensitive)
SELECT
    c.nome AS cliente_nome,
    c.email AS cliente_email
FROM cliente c
WHERE c.email NOT ILIKE '%hotmail%';

-- Liste clientes pela data mais recente de cadastro.
SELECT
    c.nome AS cliente_nome,
    c.data_cadastro AS cadastro
FROM cliente c
ORDER BY c.data_cadastro DESC;

-- Mostre os nomes das aulas em letras maiúsculas.
SELECT
    UPPER(a.nome) AS nome_aula_maiscula,
    a.nome AS nome_aula_minuscula
FROM aula a;
