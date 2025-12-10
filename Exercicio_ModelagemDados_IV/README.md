# Banco de Dados Restaurante – README

## Visão Geral
Este banco simula as operações básicas de um restaurante, incluindo clientes, mesas, funcionários, pedidos e itens de pedidos. Ele serve como base para estudos de SQL, modelagem e consultas relacionais.

## Modelo Relacional
Tabelas principais:
- **clientes**: armazena clientes.
- **mesas**: registra mesas e capacidades.
- **funcionarios**: funcionários do estabelecimento.
- **pedidos**: pedidos feitos por clientes.
- **itens_pedidos**: itens pertencentes a um pedido.

## Diagrama Simplificado

clientes (1) ----- (N) pedidos (1) ----- (N) itens_pedidos  
mesas (1) ----- (N) pedidos  
funcionarios (1) ----- (N) pedidos  

## Estrutura das Tabelas

### clientes
- id (PK)
- nome
- cpf (único)
- telefone

### mesas
- id (PK)
- numero_mesa
- quantidade

### funcionarios
- id (PK)
- nome
- cargo

### pedidos
- id (PK)
- data_pedido
- status_pedido
- cliente_id (FK)
- mesa_id (FK)
- funcionario_id (FK)
- observacoes

### itens_pedidos
- id (PK)
- pedido_id (FK)
- item_nome
- quantidade
- valor_unitario

## Tipos de Consultas Possíveis

### 1. Listar todos os pedidos com cliente, mesa e funcionário
```sql
SELECT p.id, c.nome AS cliente, m.numero_mesa, f.nome AS funcionario
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id
JOIN mesas m ON p.mesa_id = m.id
JOIN funcionarios f ON p.funcionario_id = f.id;
```

### 2. Listar itens de um pedido específico
```sql
SELECT item_nome, quantidade, valor_unitario
FROM itens_pedidos
WHERE pedido_id = 1;
```

### 3. Total gasto por pedido
```sql
SELECT pedido_id, SUM(quantidade * valor_unitario) AS total
FROM itens_pedidos
GROUP BY pedido_id;
```

### 4. Pedidos com observações
```sql
SELECT id, observacoes
FROM pedidos
WHERE observacoes IS NOT NULL;
```

### 5. Clientes que já fizeram pedidos
```sql
SELECT DISTINCT c.nome
FROM clientes c
JOIN pedidos p ON p.cliente_id = c.id;
```

## Exercícios Extras

1. Liste os pedidos realizados por funcionários cujo cargo seja "Garçom".
2. Mostre o total de itens vendidos por funcionário.
3. Exiba a média de valor por item em todos os pedidos.
4. Liste mesas que já foram usadas em pedidos.
5. Mostre os clientes que nunca fizeram pedidos.

---

Arquivo gerado automaticamente.
