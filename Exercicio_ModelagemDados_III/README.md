# README -- Estudo Completo em PostgreSQL

## 📌 Resumo do Domínio

Este estudo aborda comandos fundamentais do PostgreSQL, com foco em
JOIN, LIKE/ILIKE, INNER JOIN, além das categorias DDL e DML. Inclui
explicações conceituais, consultas comentadas, um diagrama lógico das
tabelas e exercícios práticos para aprofundar o entendimento.

## 🗂️ Diagrama de Tabelas (Modelo Conceitual)

**Cliente(id_cliente, nome, email, id_plano)**\
**Instrutor(id_instrutor, nome, especialidade)**\
**Plano(id_plano, nome, valor)**\
**Aula(id_aula, nome, id_instrutor)**\
**Cliente_Aula(id_cliente, id_aula)**

Relacionamentos:\
- Cliente → Plano (N:1)\
- Instrutor → Aula (1:N)\
- Cliente ↔ Aula (N:N)

## 🧰 Explicações dos Comandos

### 🔹 LIKE / ILIKE

-   `LIKE` → busca textual sensível a maiúsculas e minúsculas.\
-   `ILIKE` → busca textual *case-insensitive*.

Ex.:

``` sql
SELECT * FROM cliente WHERE nome ILIKE '%ana%';
```

### 🔹 JOIN

Combina registros de tabelas diferentes com base em chaves relacionadas.

### 🔹 INNER JOIN

Retorna apenas registros que possuem correspondência entre as tabelas.

``` sql
SELECT c.nome, p.nome
FROM cliente c
INNER JOIN plano p ON p.id_plano = c.id_plano;
```

### 🔹 DDL (Data Definition Language)

Responsável por **criar**, **alterar** e **excluir** estruturas no
banco.

Ex.:

``` sql
CREATE TABLE plano (
  id_plano SERIAL PRIMARY KEY,
  nome VARCHAR(50),
  valor NUMERIC(10,2)
);
```

### 🔹 DML (Data Manipulation Language)

Manipula dados *dentro* das tabelas: `INSERT`, `UPDATE`, `DELETE`,
`SELECT`.

## 📝 Consultas Comentadas

### 1. Buscar clientes com plano e instrutor responsável pela aula:

``` sql
SELECT c.nome AS cliente, p.nome AS plano, i.nome AS instrutor
FROM cliente c
JOIN plano p ON p.id_plano = c.id_plano
JOIN cliente_aula ca ON ca.id_cliente = c.id_cliente
JOIN aula a ON a.id_aula = ca.id_aula
JOIN instrutor i ON i.id_instrutor = a.id_instrutor;
-- Combina cinco tabelas para produzir dados relacionais completos.
```

### 2. Listar aulas de um instrutor específico:

``` sql
SELECT a.nome
FROM aula a
JOIN instrutor i ON i.id_instrutor = a.id_instrutor
WHERE i.nome ILIKE '%Carlos%';
-- Busca aulas ministradas por instrutores que contenham 'Carlos' no nome.
```

### 3. Encontrar clientes que não possuem aulas cadastradas:

``` sql
SELECT c.nome
FROM cliente c
LEFT JOIN cliente_aula ca ON ca.id_cliente = c.id_cliente
WHERE ca.id_cliente IS NULL;
-- Usa LEFT JOIN para identificar ausência de vínculos.
```

## 🧠 Insights Teóricos

-   **Joins representam relações entre conjuntos** --- exatamente como
    relações formais da Álgebra Relacional.\
-   **Case sensitivity** importa em PostgreSQL, o que torna `ILIKE`
    importante para buscas amigáveis ao usuário.\
-   **Chaves estrangeiras** são a base para manter integridade entre
    tabelas.\
-   **Tabelas N:N** devem sempre ser resolvidas com uma tabela
    associativa.\
-   **DDL + DML** estruturam a infraestrutura e a movimentação dos
    dados, respectivamente.

## 🏋️ Exercícios Extras Avançados

### **1. Liste o cliente, seu plano, as aulas que ele faz e o valor total pago no mês (somatório do plano + quantidade de aulas x 10 reais).**

### **2. Crie uma consulta que retorne o instrutor mais requisitado (com mais alunos vinculados a suas aulas).**

### **3. Crie um relatório ordenado por faturamento total dos planos (quantidade de clientes × valor do plano).**

### **4. Liste clientes que fazem aulas com instrutores de especialidade 'Funcional', mas que possuem plano 'Básico'.**

### **5. Identifique clientes que fazem aulas com *todos* os instrutores cadastrados (quantificação universal).**

------------------------------------------------------------------------

📄 **Arquivo gerado automaticamente por IA --- PostgreSQL Study Pack**