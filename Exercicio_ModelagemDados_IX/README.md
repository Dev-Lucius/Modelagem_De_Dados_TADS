# 💊 Sistema de Controle de Vendas de Farmácia

## Modelagem de Banco de Dados

Este projeto consiste na **modelagem de um banco de dados relacional** para um  **sistema de controle de vendas de uma farmácia** , desenvolvido com base em um enunciado que define os requisitos mínimos para o gerenciamento de  **clientes, fornecedores, medicamentos e vendas** .
O objetivo é aplicar os conceitos fundamentais de  **Projeto e Modelagem de Banco de Dados** , utilizando um  **Sistema Gerenciador de Banco de Dados Relacional (SGBD)** , como o PostgreSQL.

As correções incorporadas incluem a adição de atributos para melhor controle de estoque e conformidade regulatória, padronização de nomes, chaves compostas em tabelas associativas e restrições de integridade aprimoradas, alinhando o modelo a práticas reais de sistemas de farmácia.

---

## 📌 Objetivo do Sistema

O sistema deve permitir:

* Gerenciar as **vendas realizadas**
* Armazenar dados dos **fornecedores** e os **preços dos medicamentos fornecidos por eles**
* Registrar os  **medicamentos disponíveis** , incluindo estoque e se exigem receita médica
* Armazenar dados dos **clientes**
* Registrar os  **medicamentos vendidos** , informando:
  * Cliente
  * Medicamento
  * Quantidade vendida
  * Data da compra
  * Se o medicamento exige receita médica (propriedade inerente ao medicamento)

---

## 🧠 Descrição do Problema

A farmácia precisa de um sistema que permita controlar:

* Os  **medicamentos disponíveis** , contendo:
  * Nome
  * Descrição da bula
  * Valor
  * Quantidade em estoque
  * Se exige receita médica
* Os  **fornecedores** , contendo:
  * CNPJ
  * Nome do fornecedor
  * Quais medicamentos fornece
  * O preço de cada medicamento fornecido
* Os  **clientes** , contendo:
  * CPF
  * Nome
* As  **vendas realizadas** , registrando:
  * Medicamentos vendidos (incluindo quantidade)
  * Cliente associado à venda
  * Data da compra
  * Informação se o medicamento vendido exige ou não receita médica

---

## 🗂️ Entidades do Sistema

### 🔹 Cliente

* id (SERIAL PRIMARY KEY)
* cpf (VARCHAR(14) NOT NULL UNIQUE)
* nome (VARCHAR(100) NOT NULL)

### 🔹 Medicamento

* id (SERIAL PRIMARY KEY)
* nome (VARCHAR(100) NOT NULL)
* bula (TEXT)
* valor (DECIMAL(10,2) NOT NULL CHECK (valor > 0))
* quantidade_estoque (INTEGER NOT NULL CHECK (quantidade_estoque >= 0))
* exige_receita (BOOLEAN DEFAULT FALSE)

### 🔹 Fornecedor

* id (SERIAL PRIMARY KEY)
* cnpj (VARCHAR(18) NOT NULL UNIQUE)
* nome (VARCHAR(100) NOT NULL)

### 🔹 Venda

* id (SERIAL PRIMARY KEY)
* cliente_id (INTEGER NOT NULL REFERENCES Cliente(id) ON DELETE CASCADE)
* data_compra (DATE NOT NULL)

### 🔹 Medicamento_Venda (Tabela Associativa)

* venda_id (INTEGER NOT NULL)
* medicamento_id (INTEGER NOT NULL)
* quantidade_vendida (INTEGER NOT NULL CHECK (quantidade_vendida > 0))
* PRIMARY KEY (venda_id, medicamento_id)
* FOREIGN KEY (venda_id) REFERENCES Venda(id)
* FOREIGN KEY (medicamento_id) REFERENCES Medicamento(id)

### 🔹 Fornecedor_Medicamento (Tabela Associativa)

* fornecedor_id (INTEGER NOT NULL)
* medicamento_id (INTEGER NOT NULL)
* preco_fornecedor (DECIMAL(10,2) NOT NULL CHECK (preco_fornecedor > 0))
* PRIMARY KEY (fornecedor_id, medicamento_id)
* FOREIGN KEY (fornecedor_id) REFERENCES Fornecedor(id)
* FOREIGN KEY (medicamento_id) REFERENCES Medicamento(id)

---

## 🔗 Relacionamentos

* Um **cliente** pode realizar **várias vendas** (1:N)
* Uma **venda** pertence a **um cliente**
* Uma **venda** pode conter **vários medicamentos** (N:M resolvido por Medicamento_Venda)
* Um **medicamento** pode estar presente em **várias vendas**
* Um **fornecedor** pode fornecer **vários medicamentos** (N:M resolvido por Fornecedor_Medicamento)
* Um **medicamento** pode ser fornecido por **vários fornecedores**
  Os relacionamentos **N:M** são resolvidos por meio de  **tabelas associativas** , conforme as boas práticas de modelagem relacional. Chaves estrangeiras incluem opções como ON DELETE CASCADE para manter a integridade.

---

## 📐 Modelagem de Dados

### 🔹 Modelo Entidade-Relacionamento (ER)

O modelo conceitual contempla:

* Entidades e atributos definidos pelo enunciado, com adições para quantidade vendida e exigência de receita
* Relacionamentos com cardinalidade explícita
* Identificação clara de relacionamentos N:M
* Atributos únicos, como CPF e CNPJ, com restrições CHECK para validação de comprimento

### 🔹 Modelo Relacional

O modelo relacional foi obtido a partir do DER, contemplando:

* Criação das tabelas correspondentes às entidades
* Definição de chaves primárias (incluindo compostas em associativas) e estrangeiras
* Tipos de dados compatíveis com PostgreSQL
* Restrições de integridade:
  * NOT NULL
  * UNIQUE
  * CHECK (ex.: valores positivos para preços e quantidades)
  * FOREIGN KEY com opções de cascading

## Sugestão: Implemente triggers para atualizar o estoque automaticamente ao registrar vendas, subtraindo a quantidade vendida.

## 🛠️ Tecnologias Utilizadas

* **PostgreSQL**
* **SQL**
* **Modelagem Entidade-Relacionamento**
* **Modelo Relacional**

---

## 📁 Consultas SQL

| Número | Descrição                                                                                 | Conceitos Principais                                              | Dificuldade    | Variação Sugerida                                                 |
| ------- | ------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- | -------------- | ------------------------------------------------------------------- |
| 1       | Selecione todos os campos da tabela Medicamento.                                            | SELECT *                                                          | Básico        | Limite a 10 resultados com LIMIT.                                   |
| 2       | Liste os nomes e CPFs dos clientes ordenados alfabeticamente pelo nome.                     | SELECT, ORDER BY                                                  | Básico        | Ordene descendente e adicione WHERE para nomes começando com 'A'.  |
| 3       | Filtre medicamentos onde exige_receita é TRUE.                                             | WHERE, BOOLEAN                                                    | Básico        | Combine com valor > 10.00 usando AND.                               |
| 4       | Encontre vendas realizadas em uma data específica (ex.: '2023-01-01').                     | WHERE com DATE                                                    | Básico        | Use BETWEEN para um intervalo de datas.                             |
| 5       | Selecione fornecedores com CNPJ começando por '00' usando LIKE.                            | LIKE, pattern matching                                            | Básico        | Use ILIKE para case-insensitive.                                    |
| 6       | Liste vendas com o nome do cliente associado.                                               | INNER JOIN, ON                                                    | Intermediário | Use LEFT JOIN para incluir vendas sem cliente (embora improvável). |
| 7       | Para uma venda específica (por ID), liste os medicamentos e quantidades vendidas.          | JOIN múltiplo, WHERE                                             | Intermediário | Calcule subtotal por item (quantidade * valor).                     |
| 8       | Junte Fornecedor e Fornecedor_Medicamento para listar preços por fornecedor e medicamento. | JOIN, SELECT colunas específicas                                 | Intermediário | Ordene por preco_fornecedor ASC.                                    |
| 9       | Agrupe e conte o número de vendas por cliente, ordenando pelo total descendente.           | GROUP BY, COUNT, ORDER BY DESC                                    | Intermediário | Inclua nome do cliente via JOIN.                                    |
| 10      | Calcule o valor total de uma venda somando (quantidade_vendida * valor do medicamento).     | SUM, JOIN, GROUP BY                                               | Intermediário | Use COALESCE para tratar NULLs.                                     |
| 11      | Liste medicamentos com estoque menor que a média de todos os estoques.                     | Subconsulta, AVG                                                  | Avançado      | Use CTE para calcular média primeiro.                              |
| 12      | Liste vendas com detalhes do cliente, medicamentos e se exigem receita.                     | JOINs múltiplos (Venda, Cliente, Medicamento_Venda, Medicamento) | Avançado      | Filtre por exige_receita = TRUE.                                    |
| 13      | Encontre clientes com mais de 3 vendas usando GROUP BY e HAVING.                            | GROUP BY, HAVING, COUNT                                           | Avançado      | Combine com total de valor gasto > 100.                             |
| 14      | Atribua ranking aos medicamentos por valor usando ROW_NUMBER() OVER (ORDER BY valor DESC).  | Funções de janela (WINDOW)                                      | Avançado      | Use RANK() para empates.                                            |


---

📝 Anotações / Observações
------------------------------

## 📝 Anotações / Observações

- Regra de Ouro das Subqueries

  * ***Se a condição depende de um cálculo global, use subquery.***
  * ***Se depende de outra tabela, use JOIN.***
- Regra de ouro para cálculos SQL

  * ***COUNT → conta linhas***
  * ***SUM → soma valores***
  * ***Valor total = SUM(qtd * preço)***
