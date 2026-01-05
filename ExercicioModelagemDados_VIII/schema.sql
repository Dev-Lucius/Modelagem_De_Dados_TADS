DROP DATABASE IF EXISTS centro_esportivo;

CREATE DATABASE centro_esportivo;
\c centro_esportivo;

CREATE TABLE aluno(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    data_matricula DATE NOT NULL
);
INSERT INTO aluno(nome, email, data_matricula) VALUES
('Ana Souza', 'ana.souza@email.com', '2024-01-10'),
('Bruno Lima', 'bruno.lima@email.com', '2024-01-15'),
('Carlos Pereira', 'carlos.p@email.com', '2024-02-01'),
('Daniela Rocha', 'daniela.rocha@email.com', '2024-02-10'),
('Eduardo Santos', 'eduardo.santos@email.com', '2024-03-05'),
('Fernanda Alves', 'fernanda.alves@email.com', '2024-03-20'),
('Gabriel Nunes', 'gabriel.nunes@email.com', '2024-04-01'),
('Helena Costa', 'helena.costa@email.com', '2024-04-10');

CREATE TABLE modalidade(
    id serial PRIMARY KEY,
    nome_modalidade VARCHAR(150) NOT NULL,
    valor_mensal NUMERIC(10, 2) NOT NULL,
    CONSTRAINT chk_valor_modalidade CHECK (valor_mensal > 0)
);
INSERT INTO modalidade (nome_modalidade, valor_mensal) VALUES
('Musculação', 120.00), -- 1
('Crossfit', 180.00), -- 2
('Pilates', 150.00), -- 3
('Spinning', 130.00); -- 4

CREATE TABLE professor(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    data_contratacao DATE NOT NULL
);
INSERT INTO professor (nome, cpf, data_contratacao) VALUES
('Marcos Oliveira', '12345678901', '2023-01-15'), -- 1
('Patrícia Mendes', '23456789012', '2023-03-10'), -- 2
('Ricardo Azevedo', '34567890123', '2022-11-05'); -- 3

CREATE TABLE turma(
    id serial PRIMARY KEY,
    nome_turma VARCHAR(100) NOT NULL,
    horario TIME NOT NULL,
    professor_id INTEGER NOT NULL REFERENCES professor(id) ON DELETE RESTRICT
);
INSERT INTO turma (nome_turma, horario, professor_id) VALUES
('Musculação Manhã', '07:00', 1),
('Musculação Noite', '19:00', 1),
('Crossfit Avançado', '18:00', 2),
('Pilates Iniciante', '08:00', 3),
('Spinning Noturno', '20:00', 2);

CREATE TABLE matricula_turma(
    aluno_id INTEGER NOT NULL REFERENCES aluno(id) ON DELETE CASCADE,
    turma_id INTEGER NOT NULL REFERENCES turma(id) ON DELETE RESTRICT,
    status BOOLEAN DEFAULT false,
    observacao TEXT,
    PRIMARY KEY(aluno_id, turma_id)
);
INSERT INTO matricula_turma (aluno_id, turma_id, status, observacao) VALUES
(1, 1, true, 'Aluno regular'),
(1, 3, true, 'Treino avançado'),
(2, 2, true, NULL),
(3, 1, true, NULL),
(3, 4, true, 'Restrição médica'),
(4, 5, true, NULL),
(5, 3, true, NULL),
(6, 4, true, NULL),
(7, 1, true, NULL),
(7, 5, true, 'Primeira matrícula'),
(8, 2, false, 'Aguardando vaga');

CREATE TABLE matricula_modalidade(
    aluno_id INTEGER REFERENCES aluno(id),
    modalidade_id INTEGER REFERENCES modalidade(id),
    status BOOLEAN DEFAULT false,
    observacao TEXT,
    PRIMARY KEY(aluno_id, modalidade_id)
);
INSERT INTO matricula_modalidade (aluno_id, modalidade_id, status, observacao) VALUES
(1, 1, true, NULL), -- Musculação
(1, 2, true, 'Plano premium'), -- Crossfit
(2, 1, true, NULL), -- Musculação
(3, 3, true, 'Acompanhamento fisioterápico'), -- Pilates
(4, 4, true, NULL), --
(5, 2, true, NULL), -- Crossfit
(6, 3, true, NULL), -- Pilates
(7, 1, true, NULL), -- Musculação
(7, 4, true, 'Horário noturno'), --
(8, 1, false, 'Pagamento pendente'); -- Musculação


-- CONSULTAS SQL
-- === NÍVEL BÁSICO ===

-- Listar alunos: retornar id, nome, email ordenado por nome.
SELECT a.id AS id, a.nome AS nome_aluno, a.email AS email_aluno FROM aluno a;

-- Modalidades caras: listar modalidades com valor_mensal > 140.
SELECT nome_modalidade, valor_mensal FROM modalidade WHERE valor_mensal > 140;

-- Contagem total de alunos: usar COUNT(*).
SELECT COUNT(*) FROM aluno;

-- Professores contratados depois de 2023-01-01: filtrar por data_contratacao.
SELECT nome, data_contratacao FROM professor WHERE data_contratacao > '2023-01-01';

-- Turmas com professor: listar turma.id, nome_turma, horario, professor.nome (JOIN).
SELECT
    t.id AS id_turma,
    t.nome_turma,
    t.horario,
    p.id AS id_professor,
    p.nome AS nome_professor
FROM turma t
JOIN professor p
ON t.professor_id = p.id;

-- Alunos de uma turma (id = 1): listar alunos vinculados via matricula_turma.
SELECT
    a.nome AS nome_aluno,
    mt.turma_id
FROM matricula_turma mt
JOIN aluno a
ON mt.aluno_id = a.id
WHERE mt.turma_id = 1
AND mt.status = TRUE;

-- Modalidades de um aluno (id = 1): listar modalidade via matricula_modalidade.
SELECT
    a.nome AS nome_aluno,
    md.modalidade_id
FROM matricula_modalidade md
JOIN aluno a
ON md.aluno_id = a.id
WHERE md.modalidade_id = 1
AND md.status = TRUE;

-- === NÍVEL INTERMEDIÁRIO ===
-- Número de alunos por turma: turma + matricula_turma (GROUP BY).
SELECT
    t.nome_turma AS turma_nome,
    COUNT(mt.aluno_id) AS total_alunos
FROM turma t
JOIN matricula_turma mt
ON t.id = mt.turma_id
GROUP BY t.nome_turma;

-- Turmas com mais de 2 alunos: use HAVING COUNT(*) > 2
-- 1° OBSERVAÇÃO
/*
    A cláusula HAVING não reconhece aliases definidos no SELECT
    O que siginigica que deve-se repetir a Função Agregadora
*/
-- 2° Observação
/*
    Em SQL a ordem correta é,
    - SELECT
    - FROM
    - JOIN
    - GROUP BY
    - HAVING
*/
SELECT
    t.nome_turma AS turma_nome,
    COUNT(mt.aluno_id) AS total_alunos
FROM turma t
JOIN matricula_turma mt
ON t.id = mt.turma_id
GROUP BY t.nome_turma
HAVING COUNT(mt.aluno_id) > 2;

-- Alunos sem turma: LEFT JOIN matricula_turma e WHERE matricula_turma.aluno_id IS NULL.
-- REGRA DO LEFT JOIN
/*
    - Tabela principal → FROM
    - Tabela opcional → LEFT JOIN
    - Filtro de ausência → coluna da tabela opcional IS NULL
*/
SELECT
    a.nome AS nome_aluno,
    mt.aluno_id
FROM aluno a
LEFT JOIN matricula_turma mt
ON a.id = mt.aluno_id
WHERE mt.aluno_id IS NULL;

-- Professores e quantidade de turmas ministradas (incluir 0): LEFT JOIN + GROUP BY.
SELECT
    p.nome AS nome_professor,
    COUNT(t.professor_id) AS total_turma
FROM professor p
LEFT JOIN turma t
ON p.id = t.professor_id
GROUP BY p.nome;

-- Receita mensal por modalidade: contar alunos por modalidade * valor_mensal (JOIN, SUM/COUNT).
-- Regra do JOIN
/*
    NUNCA:
    - PK ↔ PK

    SEMPRE:
    - FK → PK
*/
SELECT
    m.nome_modalidade AS nome,
    COUNT(mm.aluno_id) AS total_aluno,
    m.valor_mensal,
    COUNT(mm.aluno_id) * m.valor_mensal AS receital_mensal
FROM modalidade m
JOIN matricula_modalidade mm
ON m.id = mm.modalidade_id
GROUP BY m.nome_modalidade, m.valor_mensal;

-- Alunos matriculados nas modalidades 'Musculação' e 'Crossfit': usar agregação com HAVING COUNT(DISTINCT nome_modalidade)=2 ou self-joinz
SELECT
    m.nome_modalidade AS modalidade,
    COUNT(mm.aluno_id) AS total_aluno
FROM modalidade m
JOIN matricula_modalidade mm
ON m.id = mm.modalidade_id
WHERE m.nome_modalidade LIKE 'Crossfit' OR m.nome_modalidade LIKE 'Musculação'
GROUP BY m.nome_modalidade;
