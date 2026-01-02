DROP DATABASE IF EXISTS clinica_veterinaria;

CREATE DATABASE clinica_veterinaria;
\c clinica_veterinaria;

-- ==================================================
-- Tabelas
-- ==================================================

-- Clientes
CREATE TABLE cliente (
    id_cliente serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE,
    CONSTRAINT cliente_cpf_format CHECK (cpf ~ '^[0-9]{11}$')
);
    -- 1) Listar todos os clientes com seus respectivos animais
    -- Propósito: retornar uma linha por animal contendo o nome do dono e do animal.
    -- Observação: clientes sem animais não aparecem; para incluí-los use LEFT JOIN.
    SELECT c.nome AS cliente_nome, a.nome AS animal_nome
    FROM cliente c
    JOIN animal a ON a.cliente_id = c.id_cliente;

    -- 2) Listar todos os veterinários e suas especialidades
    -- Propósito: navegar na tabela de associação (many-to-many) entre veterinário e especialidade.
    SELECT v.nome AS veterinario, e.nome AS especialidade
    FROM veterinario v
    JOIN veterinario_especialidade ve ON ve.veterinario_id = v.id_veterinario
    JOIN especialidade e ON e.id_especialidade = ve.especialidade_id;

    -- 3) Listar todas as consultas agendadas para uma data específica
    -- Uso: substitua a data literal por parâmetro em aplicações (ex.: $1).
    SELECT * FROM consulta WHERE data = '2025-01-15';

    -- 4) Listar Consultas com Nome do Animal, Nome do Dono, Nome do Veterinário
    -- Observação: LEFT JOIN permite que consultas sem veterinário atribuído apareçam com vet NULL.
    SELECT con.id_consulta, a.nome AS animal, c.nome AS dono, v.nome AS veterinario
    FROM consulta con
    JOIN animal a ON a.id_animal = con.animal_id
    JOIN cliente c ON c.id_cliente = a.cliente_id
    LEFT JOIN veterinario v ON v.id_veterinario = con.veterinario_id;

    -- 5) Listar Exames realizados em uma consulta específica
    -- Retorna nomes dos exames vinculados à consulta indicada (ex.: consulta_id = 2).
    SELECT ex.nome
    FROM exame ex
    JOIN exame_consulta ec ON ec.exame_id = ex.id_exame
    WHERE ec.consulta_id = 2;

    -- 6) Listar Medicamentos prescritos em uma consulta específica
    -- Inclui dose, frequência e duração; calcula total estimado de aplicações.
    SELECT m.nome, mc.dose, mc.frequencia_por_dia, mc.duracao_dias,
           (mc.frequencia_por_dia * mc.duracao_dias) AS total_aplicacoes
    FROM medicamento m
    JOIN medicamento_consulta mc ON mc.medicamento_id = m.id_medicamento
    WHERE mc.consulta_id = 2;

    -- 7) Listar Vacinas administradas a um animal específico
    -- Histórico de vacinas; ordenar por data para ver as mais recentes primeiro.
    SELECT v.nome, vac.data_vacinacao, vac.dose, vac.observacao
    FROM vacinacao vac
    JOIN vacina v ON v.id_vacina = vac.vacina_id
    WHERE vac.animal_id = 1
    ORDER BY vac.data_vacinacao DESC;

    -- 8) Veterinário que mais realizou consultas
    -- Considera apenas consultas com veterinário atribuído.
    SELECT v.nome, COUNT(con.id_consulta) AS total_consultas
    FROM veterinario v
    JOIN consulta con ON con.veterinario_id = v.id_veterinario
    GROUP BY v.nome
    ORDER BY total_consultas DESC
    LIMIT 1;

    -- 9) Animais que nunca passaram por consulta
    -- Usa LEFT JOIN para encontrar animais sem correspondência em `consulta`.
    SELECT a.id_animal, a.nome
    FROM animal a
    LEFT JOIN consulta con ON con.animal_id = a.id_animal
    WHERE con.id_consulta IS NULL;

    -- 10) Clientes com mais de 3 animais
    SELECT c.id_cliente, c.nome, COUNT(a.id_animal) AS total_animais
    FROM cliente c
    JOIN animal a ON a.cliente_id = c.id_cliente
    GROUP BY c.id_cliente, c.nome
    HAVING COUNT(a.id_animal) > 3
    ORDER BY total_animais DESC;

    -- 11) Exames nunca solicitados
    -- Encontra exames do catálogo que não aparecem em `exame_consulta`.
    SELECT e.id_exame, e.nome
    FROM exame e
    LEFT JOIN exame_consulta ec ON ec.exame_id = e.id_exame
    WHERE ec.exame_id IS NULL;

    -- 12) Custo total de uma consulta
    -- Observação: o esquema fornece `procedimento_consulta.custo`; medicamentos não têm preço.
    -- Retorna o custo total dos procedimentos realizados numa consulta (consulta_id = $1).
    SELECT con.id_consulta,
           COALESCE(SUM(pc.custo), 0) AS custo_total_procedimentos
    FROM consulta con
    LEFT JOIN procedimento_consulta pc ON pc.consulta_id = con.id_consulta
    WHERE con.id_consulta = 1
    GROUP BY con.id_consulta;

    -- 13) Histórico completo de um animal
    -- Junta eventos de consultas, vacinações e exames num histórico ordenado por data.
    -- Uso: substituir `1` pelo id do animal desejado (ex.: $1).
    SELECT evento, data_evento, detalhe
    FROM (
        SELECT 'consulta' AS evento, con.data AS data_evento, con.anotacao AS detalhe, con.data AS ordem FROM consulta con WHERE con.animal_id = 1
        UNION ALL
        SELECT 'vacinacao' AS evento, vac.data_vacinacao AS data_evento, v.nome || ' - ' || COALESCE(vac.dose, '') AS detalhe, vac.data_vacinacao AS ordem
        FROM vacinacao vac JOIN vacina v ON v.id_vacina = vac.vacina_id WHERE vac.animal_id = 1
        UNION ALL
        SELECT 'exame' AS evento, ec.data_realizacao AS data_evento, ex.nome || ' - ' || COALESCE(ec.observacao, '') AS detalhe, ec.data_realizacao AS ordem
        FROM exame_consulta ec JOIN exame ex ON ex.id_exame = ec.exame_id JOIN consulta con2 ON con2.id_consulta = ec.consulta_id WHERE con2.animal_id = 1
    ) AS historico
    ORDER BY ordem DESC;

    -- 14) Animais com vacinas atrasadas
    -- Observação: sem um calendário de doses, assumimos intervalo padrão de 1 ano para demonstração.
    SELECT a.id_animal, a.nome, v.nome AS vacina, MAX(vac.data_vacinacao) AS ultima_dose
    FROM vacinacao vac
    JOIN vacina v ON v.id_vacina = vac.vacina_id
    JOIN animal a ON a.id_animal = vac.animal_id
    GROUP BY a.id_animal, a.nome, v.nome
    HAVING MAX(vac.data_vacinacao) < (CURRENT_DATE - INTERVAL '1 year')
    ORDER BY ultima_dose ASC;

    -- 15) Relatório mensal de consultas por veterinário
    -- Conta consultas por mês para cada veterinário; útil para indicadores e bônus.
    SELECT v.id_veterinario, v.nome AS veterinario, DATE_TRUNC('month', con.data) AS mes, COUNT(*) AS total_consultas
    FROM consulta con
    JOIN veterinario v ON v.id_veterinario = con.veterinario_id
    GROUP BY v.id_veterinario, v.nome, DATE_TRUNC('month', con.data)
    ORDER BY mes DESC, total_consultas DESC;

-- Veterinários
CREATE TABLE veterinario (
    id_veterinario serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cfmv VARCHAR(20) UNIQUE NOT NULL
);

INSERT INTO veterinario (nome, cfmv) VALUES
('Dra. Clara Rocha','CFMV12345'),
('Dr. João Pereira','CFMV67890');

-- Especialidades e associação
CREATE TABLE especialidade (
    id_especialidade serial PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL,
    descricao TEXT
);

INSERT INTO especialidade (nome, descricao) VALUES
('Cirurgia','Especialista em cirurgias'),
('Dermatologia','Pele e pelagem');

CREATE TABLE veterinario_especialidade (
    veterinario_id INTEGER NOT NULL REFERENCES veterinario(id_veterinario) ON DELETE CASCADE,
    especialidade_id INTEGER NOT NULL REFERENCES especialidade(id_especialidade) ON DELETE CASCADE,
    observacao TEXT,
    PRIMARY KEY (veterinario_id, especialidade_id)
);

INSERT INTO veterinario_especialidade (veterinario_id, especialidade_id, observacao) VALUES
(1,1,'Cirurgias gerais'),
(1,2,'Atuação em dermatologia'),
(2,1,'Cirurgias de pequeno porte');

-- Consultas
CREATE TABLE consulta (
    id_consulta serial PRIMARY KEY,
    anotacao TEXT,
    status VARCHAR(100) NOT NULL,
    data DATE,
    hora TIME,
    animal_id INTEGER NOT NULL REFERENCES animal(id_animal) ON DELETE CASCADE,
    veterinario_id INTEGER REFERENCES veterinario(id_veterinario)
);

INSERT INTO consulta (anotacao, status, data, hora, animal_id, veterinario_id) VALUES
('Rotina de vacinação','agendada','2025-01-15','09:00:00',1,1),
('Exames de Rotina','agendada','2025-01-16','09:00:00',2,1),
('Corte de unhas','concluida','2025-01-10','14:30:00',2,2);

-- Procedimentos (normalizados)
CREATE TABLE procedimento (
    id_procedimento serial PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    custo_base NUMERIC(10,2)
);

INSERT INTO procedimento (nome, descricao, custo_base) VALUES
('Tosa','Tosa completa',50.00),
('Sutura','Sutura simples',200.00);

CREATE TABLE procedimento_consulta (
    consulta_id INTEGER NOT NULL REFERENCES consulta(id_consulta) ON DELETE CASCADE,
    procedimento_id INTEGER NOT NULL REFERENCES procedimento(id_procedimento),
    custo NUMERIC(10,2),
    PRIMARY KEY (consulta_id, procedimento_id)
);

INSERT INTO procedimento_consulta (consulta_id, procedimento_id, custo) VALUES
(1,1,50.00),(2,1,50.00);

-- Exames
CREATE TABLE exame (
    id_exame serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo TEXT
);

INSERT INTO exame (nome, tipo) VALUES
('Hemograma','Sangue'),
('Urina','Bioquímica');

CREATE TABLE exame_consulta (
    consulta_id INTEGER NOT NULL REFERENCES consulta(id_consulta) ON DELETE CASCADE,
    exame_id INTEGER NOT NULL REFERENCES exame(id_exame),
    data_realizacao DATE,
    observacao TEXT,
    PRIMARY KEY (consulta_id, exame_id)
);

INSERT INTO exame_consulta (consulta_id, exame_id, data_realizacao, observacao) VALUES
(2,1,'2025-01-10','Resultados normais');

-- Medicamentos
CREATE TABLE medicamento (
    id_medicamento serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    principio_ativo VARCHAR(100)
);

INSERT INTO medicamento (nome, principio_ativo) VALUES
('Antibiótico A','Amoxicilina'),
('Antiparasitário B','Ivermectina');

CREATE TABLE medicamento_consulta (
    consulta_id INTEGER NOT NULL REFERENCES consulta(id_consulta) ON DELETE CASCADE,
    medicamento_id INTEGER NOT NULL REFERENCES medicamento(id_medicamento),
    dose VARCHAR(50),
    frequencia_por_dia INTEGER,
    duracao_dias INTEGER NOT NULL,
    PRIMARY KEY (consulta_id, medicamento_id)
);

INSERT INTO medicamento_consulta (consulta_id, medicamento_id, dose, frequencia_por_dia, duracao_dias) VALUES
(2,1,'500mg',2,7);

-- Indexes (opcionais)
CREATE INDEX idx_animal_cliente ON animal(cliente_id);
CREATE INDEX idx_telefone_cliente_cliente ON telefone_cliente(cliente_id);
CREATE INDEX idx_email_cliente_cliente ON email_cliente(cliente_id);

-- ==================================================
-- Exercícios de consulta (exemplos a serem usados)

-- 1) Listar todos os clientes com seus respectivos animais:
-- Explicação
/*
    Utilizamos um JOIN entre as tabelas cliente e animal para obter os nomes dos clientes
    junto com os nomes dos seus animais de estimação. A condição de junção é feita
    através do campo cliente_id na tabela animal que referencia o id_cliente na tabela cliente.

    A função do JOIN nesta consulta é juntar os dados de duas tabelas relacionadas, de tal modo a
    permitir a visualização conjunta das informações pertinentes a clientes e seus animais.
*/
SELECT c.nome AS cliente_nome, a.nome AS animal_nome FROM cliente c JOIN animal a ON a.cliente_id = c.id_cliente;

-- 2) Listar todos os veterinários e suas especialidades:
-- Explicação
/*
    Nesta consulta, realizamos múltiplos JOINs para conectar as tabelas veterinario, veterinario_especialidade
    e especialidade. O objetivo é listar cada veterinário junto com suas especialidades associadas.
    A junção é feita através dos campos veterinario_id e especialidade_id que relacionam as tabelas.

    O JOIN aqui serve para combinar informações de várias tabelas relacionadas, permitindo a exibição
    das especialidades de cada veterinário de forma clara e organizada.
*/
   SELECT v.nome AS veterinario, e.nome AS especialidade FROM veterinario v      
   JOIN veterinario_especialidade ve ON ve.veterinario_id = v.id_veterinario
   JOIN especialidade e ON e.id_especialidade = ve.especialidade_id;

-- 3) Listar todas as consultas agendadas para uma data específica:
SELECT * FROM consulta WHERE data = '2025-01-15';

-- 4) Listar Consultas com Nome do Animal, Nome do Dono, Nome do Veterinário:
    SELECT con.id_consulta, a.nome AS animal, c.nome AS dono, v.nome AS veterinario
    FROM consulta con
    JOIN animal a ON a.id_animal = con.animal_id
    JOIN cliente c ON c.id_cliente = a.cliente_id
    LEFT JOIN veterinario v ON v.id_veterinario = con.veterinario_id;

-- 5) Listar Exames realizados em uma consulta específica:
    SELECT ex.nome FROM exame ex JOIN exame_consulta ec ON ec.exame_id = ex.id_exame WHERE ec.consulta_id = 2;

-- 6) Listar Medicamentos prescritos em uma consulta específica:
    SELECT m.nome, mc.dose, mc.frequencia_por_dia, mc.duracao_dias FROM medicamento m
    JOIN medicamento_consulta mc ON mc.medicamento_id = m.id_medicamento WHERE mc.consulta_id = 2;

-- 7) Listar Vacinas administradas a um animal específico:
    SELECT v.nome, vac.data_vacinacao FROM vacinacao vac 
    JOIN vacina v ON v.id_vacina = vac.vacina_id WHERE vac.animal_id = 1;

-- 8) Veterinário que mais realizou consultas
    SELECT v.nome, COUNT(con.id_consulta) AS total_consultas FROM veterinario v
    JOIN consulta con ON con.veterinario_id = v.id_veterinario
    GROUP BY v.nome ORDER BY total_consultas DESC LIMIT 1;

-- 9) Animais que nunca passaram por consulta
    SELECT a.nome FROM animal a LEFT JOIN consulta con ON con.animal_id = a.id_animal WHERE con.id_consulta IS NULL;

-- 10) Clientes com mais de 3 animais
    SELECT c.nome, COUNT(a.id_animal) AS total_animais FROM cliente c 
    JOIN animal a ON a.cliente_id = c.id_cliente GROUP BY c.nome HAVING COUNT(a.id_animal) > 3;

-- 11) Exames nunca solicitados
    SELECT e.id_exame, e.nome
    FROM exame e
    LEFT JOIN exame_consulta ec ON ec.exame_id = e.id_exame
    WHERE ec.exame_id IS NULL;

-- 12) Custo total de uma consulta
-- Observação: o esquema fornece `procedimento_consulta.custo`; medicamentos não têm preço definido aqui.
-- Retorna o custo total dos procedimentos realizados numa consulta (substitua `1` pelo id desejado ou use parâmetro $1).
SELECT con.id_consulta AS consulta_id,
       COALESCE(SUM(pc.custo), 0) AS custo_total_procedimentos
FROM consulta con
LEFT JOIN procedimento_consulta pc ON pc.consulta_id = con.id_consulta
WHERE con.id_consulta = 1
GROUP BY con.id_consulta;

-- 13) Histórico completo de um animal
-- Junta eventos de consultas, vacinações e exames num único histórico ordenado por data.
-- Substitua `1` por $1 para uso em aplicações.
SELECT evento, data_evento, detalhe
FROM (
    SELECT 'consulta' AS evento, con.data AS data_evento, con.anotacao AS detalhe, con.data AS ordem
    FROM consulta con
    WHERE con.animal_id = 1
    UNION ALL
    SELECT 'vacinacao' AS evento, vac.data_vacinacao AS data_evento, v.nome || ' - ' || COALESCE(vac.dose, '') AS detalhe, vac.data_vacinacao AS ordem
    FROM vacinacao vac
    JOIN vacina v ON v.id_vacina = vac.vacina_id
    WHERE vac.animal_id = 1
    UNION ALL
    SELECT 'exame' AS evento, ec.data_realizacao AS data_evento, ex.nome || ' - ' || COALESCE(ec.observacao, '') AS detalhe, ec.data_realizacao AS ordem
    FROM exame_consulta ec
    JOIN exame ex ON ex.id_exame = ec.exame_id
    JOIN consulta con2 ON con2.id_consulta = ec.consulta_id
    WHERE con2.animal_id = 1
) AS historico
ORDER BY ordem DESC;

-- 14) Animais com vacinas atrasadas
-- Sem um calendário oficial de doses, assumimos que está atrasada se a última dose foi há mais de 1 ano.
SELECT a.id_animal, a.nome, v.nome AS vacina, MAX(vac.data_vacinacao) AS ultima_dose
FROM vacinacao vac
JOIN vacina v ON v.id_vacina = vac.vacina_id
JOIN animal a ON a.id_animal = vac.animal_id
GROUP BY a.id_animal, a.nome, v.nome
HAVING MAX(vac.data_vacinacao) < (CURRENT_DATE - INTERVAL '1 year')
ORDER BY ultima_dose ASC;

-- 15) Relatório mensal de consultas por veterinário
-- Conta consultas por mês para cada veterinário; substitua filtros conforme necessário.
SELECT v.id_veterinario, v.nome AS veterinario, DATE_TRUNC('month', con.data) AS mes, COUNT(*) AS total_consultas
FROM consulta con
JOIN veterinario v ON v.id_veterinario = con.veterinario_id
GROUP BY v.id_veterinario, v.nome, DATE_TRUNC('month', con.data)
ORDER BY mes DESC, total_consultas DESC;