# 📘 README -- Fundamentos Práticos de PostgreSQL

## 🧠 Objetivo

Este documento apresenta um estudo claro, objetivo e estruturado sobre
os principais conceitos utilizados em consultas SQL no PostgreSQL.\
São abordados:

-   DDL\
-   DML\
-   DQL\
-   JOIN\
-   LIKE / ILIKE\
-   INNER JOIN\
-   ORDER BY\
-   GROUP BY e Funções de Agregação

O foco está em explicar os conceitos, casos de uso, boas práticas e
exemplos reais.

## 📚 Enunciado

## Você deve modelar um sistema com alunos, cursos, matrículas e avaliações.

### 📌 Tabela alunos
```
id (PK)
nome
email (único)
```

### 📌 Tabela cursos
```
id (PK)
nome
carga_horaria
```

### 📌 Tabela matriculas
```
id (PK)
aluno_id (FK de alunos.id)
curso_id (FK de cursos.id)
data_matricula
```

### 📌 Tabela avaliacoes
```
id (PK)
matricula_id (FK de matriculas.id)
nota
data_avaliacao
```

### ✔ (2,0) Crie as tabelas acima usando DDL, garantindo:

   - A criação correta das PKs, FKs e cláusulas
   - Tipos adequados
   - Restrições de integridade

**Sugestão: Use tipos apropriados como VARCHAR, INTEGER, DATE, NUMERIC, etc.**

### ✔ (0,5) Insira dados nas tabelas:
- Inserir 3 alunos
- Inserir 2 cursos
- Inserir 3 matrículas
- Inserir 4 avaliações

**Use dados fictícios realistas**

### ✔ (0,5) Use DDL para adicionar uma nova coluna na tabela cursos chamada modalidade, com valor padrão 'presencial'.
### ✔ (0,5) Selecione as avaliações feitas entre duas datas específicas, exibindo:

    - nome do aluno
    - nome do curso
    - nota
    - data da avaliação
**Dica: usar JOIN + BETWEEN.**

## ✔ (0,5) Selecione os cursos com carga horária maior que 60, exibindo apenas o nome e a carga horária.
## ✨ (2,0) DQL – Filtros Textuais e Manipulação
## ✔ (1,0) Liste os alunos cujo nome termine com a letra 'o'.
## ✔ (1,0) Liste todas as avaliações cujos alunos têm a letra 'a' no nome.

**Dica: pode ser necessário usar JOIN ou SUBSELECT.**

## 📌 EXERCÍCIO EXTRA (opcional)

Liste a média das notas por aluno, ordenada da maior para a menor.

---

## 🏗️ 1. DDL -- Data Definition Language

DDL é o conjunto de comandos responsável por definir ou modificar a
estrutura do banco de dados.

### Principais comandos

-   CREATE
-   ALTER
-   DROP
-   TRUNCATE

### Exemplo

``` sql
CREATE TABLE alunos (
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);
```

## ✍️ 2. DML -- Data Manipulation Language

Manipula dados armazenados.

### Principais comandos

-   INSERT
-   UPDATE
-   DELETE

``` sql
INSERT INTO alunos (nome, email) VALUES ('Lucas', 'lucas@gmail.com');
```

## 🔍 3. DQL -- Data Query Language

Consulta dados.

``` sql
SELECT nome, email FROM alunos;
```

## 🔗 4. JOIN -- Combinando Tabelas

## 🔐 5. INNER JOIN

Retorna apenas dados onde existe relacionamento válido.

``` sql
SELECT a.nome, c.nome AS curso
FROM alunos a
INNER JOIN matriculas m ON m.aluno_id = a.id
INNER JOIN cursos c ON c.id = m.curso_id;
```

## 🔤 6. LIKE / ILIKE

``` sql
SELECT * FROM alunos WHERE nome LIKE 'L%';
SELECT * FROM alunos WHERE nome ILIKE '%a%';
```

## 🧮 7. ORDER BY

``` sql
SELECT nome, nota FROM avaliacoes ORDER BY nota DESC;
```

## 📊 8. GROUP BY e Funções de Agregação

``` sql
SELECT 
    a.nome,
    AVG(av.nota) AS media
FROM avaliacoes av
JOIN matriculas m ON m.id = av.matricula_id
JOIN alunos a ON a.id = m.aluno_id
GROUP BY a.nome
ORDER BY media DESC;
```

## 🙌 Conclusão

Este README consolida os principais conceitos usados em consultas SQL
reais no PostgreSQL.