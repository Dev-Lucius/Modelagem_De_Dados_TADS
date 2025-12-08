DROP DATABASE IF EXISTS escola;
CREATE DATABASE escola;
\c escola;

CREATE TABLE alunos(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE cursos(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    carga_horaria INTEGER NOT NULL,
    modalidade VARCHAR(100) NOT NULL DEFAULT 'presencial'
);

CREATE TABLE matriculas(
    id serial PRIMARY KEY,
    aluno_id INTEGER NOT NULL REFERENCES alunos(id),
    curso_id INTEGER NOT NULL REFERENCES cursos(id),
    data_matricula DATE NOT NULL
);

CREATE TABLE avaliacoes(
    id serial PRIMARY KEY,
    matricula_id INTEGER NOT NULL REFERENCES matriculas(id),
    nota NUMERIC(10,2) NOT NULL,
    data_avaliacao DATE NOT NULL
);

-- Inserindo Alunos
INSERT INTO alunos (nome, email) VALUES
('Lucas Oliveira', 'lucas@gmail.com'),
('Natasha Medina', 'natmed@gmail.com'),
('Pedro Sanchez', 'sanchezpp@gmail.com');

-- Inserindo Cursos
INSERT INTO cursos (nome, carga_horaria) VALUES
('Direito', 5400),
('Engenharia Mecânica', 5200);

-- Inserindo Matrículas
INSERT INTO matriculas (aluno_id, curso_id, data_matricula) VALUES
(1, 1, '2025-03-12'),
(2, 1, '2025-04-13'),
(3, 2, '2025-05-14');

-- Inserindo Avaliações
INSERT INTO avaliacoes (matricula_id, nota, data_avaliacao) VALUES
(1, 7, '2025-05-15'),
(2, 8, '2025-05-20'),
(3, 10, '2025-04-17'),
(1, 6, '2025-05-13');

-- Selecione avaliações entre datas
SELECT
    a.nome AS aluno,
    c.nome AS curso,
    av.nota,
    av.data_avaliacao
FROM avaliacoes av
JOIN matriculas m ON m.id = av.matricula_id
JOIN alunos a ON a.id = m.aluno_id
JOIN cursos c ON c.id = m.curso_id
WHERE av.data_avaliacao BETWEEN '2024-01-01' AND '2025-12-25';

-- Alunos cujo nome termina com 'o'
SELECT * FROM alunos WHERE nome LIKE '%o';

-- Cursos com carga horária > 60
SELECT nome, carga_horaria FROM cursos WHERE carga_horaria > 60;

-- Avaliações onde alunos possuem letra 'a' no nome
SELECT av.*
FROM avaliacoes av 
JOIN matriculas m ON m.id = av.matricula_id
JOIN alunos a ON a.id = m.aluno_id
WHERE a.nome ILIKE '%a%';

-- Média das notas por aluno
SELECT 
    a.nome,
    AVG(av.nota) AS media
FROM avaliacoes av
JOIN matriculas m ON m.id = av.matricula_id
JOIN alunos a ON a.id = m.aluno_id
GROUP BY a.nome
ORDER BY media DESC;
