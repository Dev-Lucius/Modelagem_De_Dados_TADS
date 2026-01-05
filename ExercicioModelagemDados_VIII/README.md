# 🏋️ Sistema de Gerenciamento de Centro Esportivo

Este projeto tem como objetivo o desenvolvimento da **modelagem de um banco de dados relacional** para um **Centro Esportivo**, contemplando desde a **análise das regras de negócio** até a **criação do modelo relacional e consultas SQL**, utilizando o **PostgreSQL**.

O sistema visa organizar informações relacionadas a **alunos**, **professores**, **modalidades esportivas** e **turmas de treino**, permitindo um controle eficiente das matrículas e atividades oferecidas.

---

## 📌 Objetivos do Projeto

- Aplicar conceitos de **Modelagem Entidade-Relacionamento (ER)**  
- Identificar e modelar **relacionamentos 1:N e N:M**
- Transformar o modelo conceitual em **Modelo Relacional**
- Definir **chaves primárias, chaves estrangeiras e restrições**
- Desenvolver **consultas SQL** utilizando PostgreSQL

---

## 🧠 Regras de Negócio

- Um aluno pode se matricular em **várias modalidades esportivas**
- Um aluno pode participar de **várias turmas**
- Uma modalidade pode possuir **vários alunos**
- Uma turma pode ter **vários alunos**
- Um professor pode ministrar **várias turmas**
- Cada turma é ministrada por **apenas um professor**

---

## 🗂️ Entidades do Sistema

### 🔹 Aluno
- id
- nome
- email (único)
- data_matricula

### 🔹 Professor
- id
- nome
- cpf (único)
- data_contratacao

### 🔹 Modalidade
- id
- nome_modalidade
- valor_mensal

### 🔹 Turma
- id
- nome_turma
- horario

---

## 🧩 Modelagem de Dados

O projeto contempla:

### 📐 Modelo Entidade-Relacionamento (ER)
- Entidades e atributos principais
- Relacionamentos com cardinalidade
- Identificação de relacionamentos **N:M**
- Atributos únicos (email, CPF)

### 🗃️ Modelo Relacional
- Tabelas correspondentes às entidades
- Tabelas associativas para relacionamentos N:M
- Definição de chaves primárias e estrangeiras
- Tipos de dados no padrão PostgreSQL
- Restrições de integridade (`NOT NULL`, `UNIQUE`, `CHECK`)

---

## 🔍 Consultas SQL

Foram desenvolvidas consultas SQL para:

### 🔍 Nível Básico

- Ex1 — Listar alunos: retornar id, nome, email ordenado por nome.
- Ex2 — Modalidades caras: listar modalidades com valor_mensal > 140.
- Ex3 — Contagem total de alunos: usar COUNT(*).
- Ex4 — Professores contratados depois de 2023-01-01: filtrar por data_contratacao.
- Ex5 — Turmas com professor: listar turma.id, nome_turma, horario, professor.nome (JOIN).
- Ex6 — Alunos de uma turma (id = 1): listar alunos vinculados via matricula_turma.
- Ex7 — Modalidades de um aluno (id = 1): listar modalidade via matricula_modalidade.

---

### 🔍 Nível Intermediário

- Ex8 — Número de alunos por turma: turma + matricula_turma (GROUP BY).
- Ex9 — Número de alunos por modalidade (ordenado): matricula_modalidade + modalidade (GROUP BY, ORDER BY DESC).
- Ex10 — Turmas com mais de 2 alunos: use HAVING COUNT(*) > 2.
- Ex11 — Alunos sem turma: LEFT JOIN matricula_turma e WHERE matricula_turma.aluno_id IS NULL.
- Ex12 — Professores e quantidade de turmas ministradas (incluir 0): LEFT JOIN + GROUP BY.
- Ex13 — Receita mensal por modalidade: contar alunos por modalidade * valor_mensal (JOIN, SUM/COUNT).
- Ex14 — Alunos matriculados nas modalidades 'Musculação' e 'Crossfit': usar agregação com HAVING COUNT(DIS

---

### 🔍 Nível Avançado

- Ex15 — Top 3 alunos mais recentes por turma: usar window function ROW_NUMBER() sobre aluno.data_matricula particionado por turma_id.
- Ex16 — Professores sem turmas: LEFT JOIN turma WHERE turma.professor_id IS NULL.
- Ex17 — Modalidades com valor acima da média: calcular média global e filtrar (subquery ou CTE).
- Ex18 — Mover matrícula de um aluno entre turmas (transação segura): exemplo de BEGIN; UPDATE ...; COMMIT; com checagens de integridade.
- Ex19 — View resumo do aluno: criar v_aluno_resumo com id, nome, qtd_turmas, qtd_modalidades.
- Ex20 — Detectar emails duplicados (sanity check): identificar email com COUNT>1.
- Ex21 — Alunos que estão em ao menos uma turma ativa e ao menos uma modalidade ativa: usar CTEs para combinar matricula_turma e - matricula_modalidade com status = true.

---

## 🛠️ Tecnologias Utilizadas

- **PostgreSQL**
- **SQL**
- **Modelagem ER**
- **Modelo Relacional**

---

## 📝 Anotações / Observações

- A função do **JOIN** é a de Unir dados de Tabelas Distintas quando as mesmas possuem um Relacionamento em Comum
- A Sintaxe Básica do **JOIN** é
    ```
    SELECT colunas
    FROM tabela1
    JOIN tabela2
    ON condição_de_ligação;
    ```
- **INNER JOIN** É usado para retornar os registros que existem em ambas as tabelas
- **LEFT JOIN** É usado para trazer todos os registros da tabelas esquerda, ainda que não tenha quaisquer correspondências com a direita
- **RIGHT JOIN** É usado para trazer todos os registros da tabelas Direita, ainda que não tenha quaisquer correspondências com a Esquerda
- **FULL JOIN** É usado para trazer todos os registros de ambas as tabelas, com ou sem correspondência
- Jamais se esqueça da *Ordem* em que o **SQL** *Opera* suas Instruções
    ```
    - SELECT
    - FROM
    - JOIN
    - GROUP BY
    - HAVING
    ```
- Assim, a Regra de Ouro dos JOINs pode ser resumida na simples regra da Cláusula **ON**
    ```
    NUNCA:
    - PK ↔ PK

    SEMPRE:
    - FK → PK
    ```
- Lembre-se das Funções Agregadoras Mais Importantes

    | Situação                | Use     |
    | ----------------------- | ------- |
    | Quantidade de registros | `COUNT` |
    | Total de valores        | `SUM`   |
    | Média                   | `AVG`   |
    | Maior valor             | `MAX`   |
    | Menor valor             | `MIN`   |

- 🏆 **REGRA DE OURO DAS CARDINALIDADES**
    ```
    🔑 Leia o relacionamento sempre em forma de FRASE, nos DOIS SENTIDOS.
    
    🧠 Se a frase fizer sentido dos dois lados, a cardinalidade está certa.
    ```       
- Em outras Palavras, sempre responda essas duas perguntas
    * 1️⃣ Para UM registro de A, quantos de B podem existir?
    * 2️⃣ Para UM registro de B, quantos de A podem existir?
- Tabela Mental

    | Resposta         | Cardinalidade |
    | ---------------- | ------------- |
    | “Um e apenas um” | 1             |
    | “Zero ou um”     | 0..1          |
    | “Vários”         | N             |

---

## 📁 Estrutura Sugerida do Projeto

```text
📦 centro-esportivo
 ┣ 📄 README.md
 ┣ 📄 modelo_er.png
 ┣ 📄 modelo_relacional.sql
 ┣ 📄 create_tables.sql
 ┣ 📄 inserts.sql
 ┗ 📄 consultas.sql
