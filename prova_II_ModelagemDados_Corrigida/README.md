# README – Correção Completa da Prova de Modelagem de Dados

## 1. Introdução

Este documento apresenta um resumo completo e didático dos principais pontos abordados na prova de SQL, incluindo conceitos fundamentais, comandos essenciais e exemplos de aplicação prática. O objetivo é consolidar o aprendizado e servir como material de consulta rápida.

---

## 2. Criação de Tabelas (DDL – Data Definition Language)

A criação de tabelas define a estrutura do banco de dados. No SQL, usamos o comando `CREATE TABLE` para especificar colunas, tipos e restrições.

**Exemplo:**

```sql
CREATE TABLE Cliente (
  id INT PRIMARY KEY,
  nome VARCHAR(100),
  data_nascimento DATE
);
```

### Chave Primária (PRIMARY KEY)

* Identifica de forma única um registro na tabela.
* Não pode ser nula e não pode se repetir.

### Chave Estrangeira (FOREIGN KEY)

* Relaciona tabelas.
* Garante integridade referencial.

**Exemplo:**

```sql
FOREIGN KEY (plano_id) REFERENCES Plano(id)
```

---

## 3. Inserção de Dados (INSERT)

Responsável por adicionar novos registros em uma tabela.

**Exemplo:**

```sql
INSERT INTO Cliente (id, nome, data_nascimento)
VALUES (1, 'João', '2000-01-01');
```

---

## 4. Consulta de Dados (SELECT)

Permite buscar e visualizar dados de uma ou mais tabelas.

**Exemplo:**

```sql
SELECT nome, data_nascimento FROM Cliente;
```

---

## 5. Filtros e Condições (WHERE)

O `WHERE` filtra registros com base em condições lógicas.

**Exemplo:**

```sql
SELECT * FROM Cliente WHERE nome LIKE 'A%';
```

---

## 6. Ordenação (ORDER BY)

Permite ordenar resultados por uma ou mais colunas.

**Exemplo:**

```sql
SELECT * FROM Cliente ORDER BY nome ASC;
```

---

## 7. Atualização de Dados (UPDATE)

Modifica registros existentes.

**Exemplo:**

```sql
UPDATE Cliente SET nome = 'Carlos' WHERE id = 1;
```

---

## 8. Exclusão de Dados (DELETE)

Remove registros de uma tabela.

**Exemplo:**

```sql
DELETE FROM Cliente WHERE id = 1;
```

---

## 9. Relacionamentos com JOIN

O `JOIN` combina dados de tabelas relacionadas.

### INNER JOIN

Retorna registros com correspondência em ambas as tabelas.

```sql
SELECT c.nome, p.nome
FROM Cliente c
INNER JOIN Plano p ON c.plano_id = p.id;
```

### LEFT JOIN

Retorna todos os registros da tabela esquerda, mesmo sem correspondência.

---

## 10. Funções de Agregação

Usadas para cálculos sobre conjuntos de dados.

* `COUNT()` – Conta registros
* `SUM()` – Soma valores
* `AVG()` – Média
* `MAX()` – Máximo
* `MIN()` – Mínimo

**Exemplo:**

```sql
SELECT COUNT(*) FROM Cliente;
```

---

## 11. Agrupamento (GROUP BY)

Agrupa registros para cálculos agregados.

**Exemplo:**

```sql
SELECT plano_id, COUNT(*)
FROM Cliente
GROUP BY plano_id;
```

---

## 12. Filtragem de Grupos (HAVING)

Filtra resultados após o agrupamento.

**Exemplo:**

```sql
SELECT plano_id, COUNT(*)
FROM Cliente
GROUP BY plano_id
HAVING COUNT(*) > 2;
```

---

## 13. Subconsultas (Subqueries)

Consultas dentro de consultas, usadas para recuperar dados intermediários.

**Exemplo:**

```sql
SELECT nome
FROM Cliente
WHERE id IN (SELECT cliente_id FROM Contrato);
```

---

## 14. Alias (Apelidos)

Renomeia campos ou tabelas para facilitar consultas.

**Exemplo:**

```sql
SELECT c.nome AS cliente
FROM Cliente c;
```

---

## 15. Conclusão

O conteúdo apresentado reúne os conceitos essenciais de SQL aplicados durante a avaliação. Compreender a estrutura do banco, manipulação de dados, relacionamentos e consultas avançadas é fundamental para dominar a linguagem e trabalhar com dados de forma eficiente.
