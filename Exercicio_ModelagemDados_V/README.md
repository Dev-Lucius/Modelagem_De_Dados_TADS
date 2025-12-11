# Exercício Completo de Banco de Dados -- SmartShop (PostgreSQL)

Este README documenta todo o exercício prático de modelagem e
implementação de um Banco de Dados relacional completo no PostgreSQL,
utilizando o sistema **SmartShop**, responsável por gerenciar clientes,
pedidos, produtos, estoque e pagamentos.

------------------------------------------------------------------------

## 🎯 Objetivo do Exercício

O aluno deverá:

1.  **Modelar um banco de dados completo**
2.  Criar o **Diagrama Entidade-Relacionamento (DER)**
3.  Criar o **Modelo Lógico (tabelas, atributos, PKs, FKs)**
4.  Inserir dados de teste
5.  Executar consultas SQL de níveis:
    -   **Básico**
    -   **Intermediário**
6.  Validar funcionamento com operações reais (pedidos, itens,
    pagamentos etc.)

------------------------------------------------------------------------

# 🧱 Modelo Conceitual (DER)

### Entidades:

-   **Clientes**
-   **Pedidos**
-   **Produtos**
-   **Estoque**
-   **Itens_Pedidos**
-   **Pagamentos**

### Principais Regras do Negócio:

-   Um cliente **faz** vários pedidos.
-   Um pedido **tem** vários itens.
-   Cada item está sempre vinculado a **um produto**.
-   Um pedido pode receber **múltiplos pagamentos**.
-   Cada produto possui **um único registro de estoque** (1:1).

------------------------------------------------------------------------

# 🧱 Modelo Lógico (Tabelas e Atributos)

## 1. CLIENTES

-   id_cliente (PK)
-   nome
-   email (UNIQUE)
-   telefone
-   data_cadastro (DEFAULT NOW())

## 2. PRODUTOS

-   id_produto (PK)
-   nome
-   categoria
-   preco

## 3. ESTOQUE (1:1 com produtos)

-   id_produto (PK, FK)
-   quantidade

## 4. PEDIDOS

-   id_pedido (PK)
-   id_cliente (FK)
-   data_pedido (DEFAULT NOW())
-   status

## 5. ITENS_PEDIDOS (tabela de interseção N:M entre pedidos e produtos)

-   id_item (PK)
-   id_pedido (FK)
-   id_produto (FK)
-   quantidade
-   preco_unit

## 6. PAGAMENTOS

-   id_pagamento (PK)
-   id_pedido (FK)
-   valor
-   metodo
-   data_pagamento (DEFAULT NOW())

------------------------------------------------------------------------

# 🧪 Consultas SQL -- Nível Básico

### 1. Listar todos os clientes

``` sql
SELECT * FROM clientes;
```

### 2. Listar produtos de uma categoria específica

``` sql
SELECT * FROM produtos WHERE categoria = 'Periféricos';
```

### 3. Buscar pedidos de um cliente

``` sql
SELECT * FROM pedidos WHERE id_cliente = 1;
```

### 4. Ver estoque atual dos produtos

``` sql
SELECT p.nome, e.quantidade
FROM produtos p
JOIN estoque e ON e.id_produto = p.id_produto;
```

------------------------------------------------------------------------

# 🧪 Consultas SQL -- Nível Intermediário

### 5. Listar pedidos com valor total calculado

``` sql
SELECT 
    p.id_pedido,
    SUM(i.quantidade * i.preco_unit) AS total
FROM pedidos p
JOIN itens_pedidos i ON i.id_pedido = p.id_pedido
GROUP BY p.id_pedido;
```

### 6. Listar clientes que gastaram mais de R\$ 500

``` sql
SELECT 
    c.nome,
    SUM(i.quantidade * i.preco_unit) AS total_gasto
FROM clientes c
JOIN pedidos p ON p.id_cliente = c.id_cliente
JOIN itens_pedidos i ON i.id_pedido = p.id_pedido
GROUP BY c.nome
HAVING SUM(i.quantidade * i.preco_unit) > 500;
```

### 7. Verificar produtos mais vendidos

``` sql
SELECT 
    pr.nome,
    SUM(i.quantidade) AS total_vendido
FROM itens_pedidos i
JOIN produtos pr ON pr.id_produto = i.id_produto
GROUP BY pr.nome
ORDER BY total_vendido DESC;
```

### 8. Ver status dos pedidos com pagamentos registrados

``` sql
SELECT 
    p.id_pedido,
    p.status,
    SUM(pg.valor) AS total_pago
FROM pedidos p
LEFT JOIN pagamentos pg ON pg.id_pedido = p.id_pedido
GROUP BY p.id_pedido, p.status;
```

------------------------------------------------------------------------

