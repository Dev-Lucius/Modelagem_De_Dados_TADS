DROP DATABASE IF EXISTS clinica;

CREATE DATABASE clinica;
\c clinica;

-------------------------------------------------------
-- TABELA CLIENTE
-------------------------------------------------------
CREATE TABLE cliente (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    bairro TEXT,
    rua TEXT,
    complemento TEXT,
    ponto_ref TEXT,
    nro VARCHAR(10),
    data_nascimento DATE
);
-------------------------------------------------------
-- INSERINDO DADOS NA TABELA CLIENTE
-------------------------------------------------------
INSERT INTO cliente(cpf, nome, bairro, rua, complemento, ponto_ref, nro, data_nascimento) VALUES
('12345678901', 'João Silva', 'Centro', 'Rua Principal', 'Apto 101', 'Próximo ao supermercado', '123', '1980-05-15'),
('23456789012', 'Maria Oliveira', 'Jardim', 'Avenida das Flores', NULL, 'Em frente ao parque', '456', '1992-11-20'),
('34567890123', 'Pedro Santos', 'Vila Nova', 'Travessa do Sol', 'Casa 2', NULL, '789', '1975-03-10');

-------------------------------------------------------
-- TELEFONES DO CLIENTE
-------------------------------------------------------
CREATE TABLE telefones (
    cliente_cpf CHAR(11) NOT NULL REFERENCES cliente(cpf),
    numero VARCHAR(11) NOT NULL,
    PRIMARY KEY (cliente_cpf, numero)
);
-------------------------------------------------------
-- INSERINDO DADOS NA TABELA TELEFONES
-------------------------------------------------------
INSERT INTO telefones(cliente_cpf, numero) VALUES
('12345678901', '11987654321'),
('12345678901', '11912345678'),
('23456789012', '21976543210'),
('34567890123', '31965432109');

-------------------------------------------------------
-- TABELA RACAS
-------------------------------------------------------
CREATE TABLE racaCachorro (
    codigo SERIAL PRIMARY KEY,
    nome TEXT NOT NULL
);

CREATE TABLE racaGato (
    codigo SERIAL PRIMARY KEY,
    nome TEXT NOT NULL
);
-------------------------------------------------------
-- INSERINDO DADOS NAS TABELA DE RAÇAS
-------------------------------------------------------
INSERT INTO racaCachorro(nome) VALUES
('Labrador Retriever'),
('Poodle'),
('Bulldog');

INSERT INTO racaGato(nome) VALUES
('Siamês'),
('Persa'),
('Maine Coon');

-------------------------------------------------------
-- TABELA ANIMAL
-------------------------------------------------------
CREATE TABLE animal (
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    observacao TEXT
);
-------------------------------------------------------
-- INSERINDO DADOS NA TABELA ANIMAL
-------------------------------------------------------
INSERT INTO animal (nome, data_nascimento, observacao) VALUES 
('Rex', '2018-07-01', 'Cachorro ativo e brincalhão'),
('Fifi', '2020-02-15', 'Gato calmo, gosta de dormir'),
('Max', '2019-10-10', 'Cachorro com histórico de alergia'),
('Luna', '2021-05-20', 'Gato curioso e explorador');

-------------------------------------------------------
-- TABELA CLIENTE_ANIMAL (RELACIONAMENTO N:N)
-------------------------------------------------------
CREATE TABLE cliente_animal (
    animal_codigo INTEGER NOT NULL REFERENCES animal(codigo),
    cliente_cpf CHAR(11) NOT NULL REFERENCES cliente(cpf),
    PRIMARY KEY (animal_codigo, cliente_cpf)
);
-------------------------------------------------------
-- INSERINDO DADOS NA TABELA CLIENTE_ANIMAL
-------------------------------------------------------
INSERT INTO cliente_animal(animal_codigo, cliente_cpf) VALUES
(1, '12345678901'),  -- Rex pertence a João
(2, '12345678901'),  -- Fifi pertence a João
(3, '23456789012'),  -- Max pertence a Maria
(4, '34567890123');  -- Luna pertence a Pedro

-------------------------------------------------------
-- TABELAS ESPECÍFICAS: CACHORRO E GATO
-------------------------------------------------------
CREATE TABLE cachorro (
    animal_codigo INTEGER PRIMARY KEY REFERENCES animal(codigo),
    decibeis_latido REAL CHECK (decibeis_latido >= 0),
    raca_cachorro_codigo INTEGER REFERENCES racaCachorro(codigo)
);

CREATE TABLE gato (
    animal_codigo INTEGER PRIMARY KEY REFERENCES animal(codigo),
    qtd_bigodes INTEGER CHECK (qtd_bigodes >= 0),
    raca_gato_codigo INTEGER REFERENCES racaGato(codigo)
);
-------------------------------------------------------
-- INSERINDO DADOS NAS TABELAS CACHORRO / GATO
-------------------------------------------------------
INSERT INTO cachorro(animal_codigo, decibeis_latido, raca_cachorro_codigo) VALUES
(1, 75.5, 1),  -- Rex: Labrador, latido de 75.5 dB
(3, 60.0, 2);  -- Max: Poodle, latido de 60 dB

INSERT INTO gato(animal_codigo, qtd_bigodes, raca_gato_codigo) VALUES
(2, 24, 1),  -- Fifi: Siamês, 24 bigodes
(4, 30, 2);  -- Luna: Persa, 30 bigodes

-------------------------------------------------------
-- VETERINÁRIO
-------------------------------------------------------
CREATE TABLE veterinario (
    crmv CHAR(7) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);
-------------------------------------------------------
-- INSERINDO DADOS NA TABELA VETERINARIO
-------------------------------------------------------
INSERT INTO veterinario(crmv, nome) VALUES
('CRMV001', 'Dr. Ana Costa'),
('CRMV002', 'Dr. Carlos Mendes');

-------------------------------------------------------
-- CONSULTA
-------------------------------------------------------
CREATE TABLE consulta (
    codigo SERIAL PRIMARY KEY,
    data_hora TIMESTAMP,
    diagnostico TEXT,
    valor NUMERIC(10,2) CHECK (valor >= 0),
    animal_codigo INTEGER REFERENCES animal(codigo),
    veterinario_crmv CHAR(7) REFERENCES veterinario(crmv)
);
-------------------------------------------------------
-- INSERINDO DADOS NA TABELA CONSULTA
-------------------------------------------------------
INSERT INTO CONSULTA(data_hora, diagnostico, valor, animal_codigo, veterinario_crmv) VALUES
('2025-11-01 10:00:00', 'Vacinação anual realizada com sucesso', 150.00, 1, 'CRMV001'),  -- Consulta para Rex
('2025-11-15 14:30:00', 'Tratamento para pulgas, animal saudável', 200.00, 2, 'CRMV002'),  -- Consulta para Fifi
('2025-11-20 09:15:00', 'Exame de alergia, medicação prescrita', 180.00, 3, 'CRMV001');  -- Consulta para Max

-------------------------------------------------------
-- PROCEDIMENTOS
-------------------------------------------------------
CREATE TABLE procedimento (
    codigo SERIAL PRIMARY KEY,
    descricao TEXT NOT NULL,
    valor NUMERIC(10,2) CHECK (valor >= 0)
);
-------------------------------------------------------
-- INSERINDO DADOS NA TABELA PROCEDIMENTO
-------------------------------------------------------
INSERT INTO procedimento(descricao, valor) VALUES
('Vacinação antirrábica', 50.00),
('Exame de sangue', 100.00),
('Tratamento antipulgas', 80.00),
('Consulta de rotina', 70.00);

-------------------------------------------------------
-- CONSULTA + PROCEDIMENTO (N:N)
-------------------------------------------------------
CREATE TABLE consulta_procedimento (
    consulta_codigo INTEGER NOT NULL REFERENCES consulta(codigo),
    procedimento_codigo INTEGER NOT NULL REFERENCES procedimento(codigo),
    data_hora TIMESTAMP,
    valor_pago NUMERIC(10,2),
    PRIMARY KEY (consulta_codigo, procedimento_codigo)
);
-------------------------------------------------------
-- INSERINDO DADOS NA TABELA CONSULTA_PROCEDIMENTO
-------------------------------------------------------
INSERT INTO consulta_procedimento(consulta_codigo, procedimento_codigo ,data_hora, valor_pago) VALUES
(1, 1, '2025-11-01 10:15:00', 50.00),  -- Vacinação em consulta 1
(1, 4, '2025-11-01 10:00:00', 70.00),  -- Consulta de rotina em consulta 1
(2, 3, '2025-11-15 14:45:00', 80.00),  -- Antipulgas em consulta 2
(3, 2, '2025-11-20 09:30:00', 100.00); -- Exame de sangue em consulta 3
