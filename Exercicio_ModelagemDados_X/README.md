# 🏋️ Exercício de Modelagem de Dados em PostgreSQL — **Sistema de Academia**

## 🎯 Objetivo Geral
Projetar e implementar um **banco de dados relacional em PostgreSQL** para o contexto de uma **academia**, contemplando **tabelas principais**, **tabelas associativas**, seus **atributos**, **chaves primárias (PK)** e **chaves estrangeiras (FK)**.  
O exercício visa consolidar conhecimentos em **modelagem de dados**, **normalização**, **integridade referencial** e **SQL (DDL e DML)**.

---

## 🧩 Contexto do Problema
Uma academia deseja informatizar o controle de seus **clientes**, **instrutores**, **planos**, **aulas** e **matrículas**.  
O sistema deve permitir registrar dados cadastrais, controlar vínculos entre clientes e planos, gerenciar aulas ministradas por instrutores e acompanhar a participação dos clientes nessas aulas.

---

## 🗂️ Estrutura do Banco de Dados

### 🔹 Tabela: **Cliente**
Armazena os dados dos alunos da academia.

**Atributos:**
- `id` (PK)
- `nome`
- `email`
- `cpf`
- `data_cadastro`
- `telefone`

---

### 🔹 Tabela: **Instrutor**
Armazena os dados dos profissionais que ministram aulas.

**Atributos:**
- `id` (PK)
- `nome`
- `email`
- `data_admissao`
- `especialidade`

---

### 🔹 Tabela: **Plano**
Armazena os planos oferecidos pela academia.

**Atributos:**
- `id` (PK)
- `nome`
- `preco_mensal`
- `descricao`
- `ativo`

---

### 🔹 Tabela: **Aula**
Armazena as aulas disponíveis na academia.

**Atributos:**
- `id` (PK)
- `nome`
- `horario`
- `data_cadastro`
- `instrutor_id` (FK → Instrutor.id)

---

## 🔗 Tabelas Associativas

### 🔸 Tabela: **Cliente_Plano**
Relaciona clientes aos planos contratados.  
Representa um relacionamento **N : N** entre Cliente e Plano.

**Atributos:**
- `id` (PK)
- `cliente_id` (FK → Cliente.id)
- `plano_id` (FK → Plano.id)
- `data_inicio`
- `data_fim`

---

### 🔸 Tabela: **Matricula_Aula**
Relaciona clientes às aulas em que estão matriculados.  
Representa um relacionamento **N : N** entre Cliente e Aula.

**Atributos:**
- `id` (PK)
- `cliente_id` (FK → Cliente.id)
- `aula_id` (FK → Aula.id)
- `data_matricula`

---

## 🧠 Lista de Exercícios SQL – Academia

### 🔹 1. Inserção de dados (INSERT)
- Insira três clientes na tabela **Cliente**.
- Adicione dois instrutores na tabela **Instrutor**.
- Cadastre três planos diferentes na tabela **Plano**.
- Insira quatro aulas diferentes na tabela **Aula**.
- Relacione clientes e planos na tabela **Cliente_Plano**.
- Matricule clientes em aulas na tabela **Matricula_Aula**.

---

### 🔹 2. Atualização de dados (UPDATE)
- Atualize o email de um cliente específico.
- Altere o nome de um cliente para **“Maria Silva”**.
- Modifique o valor mensal de um plano para **120.00**.
- Mude o nome de uma aula de **“Spinning”** para **“Ciclismo Indoor”**.

---

### 🔹 3. Exclusão de dados (DELETE)
- Remova um cliente específico *(apagando antes os registros nas tabelas associativas)*.
- Exclua uma aula que não possui alunos matriculados.
- Delete um plano que não está mais disponível.

---

### 🔹 4. Seleção simples (SELECT)
- Liste todos os clientes cadastrados.
- Mostre o nome e o preço mensal de todos os planos.
- Exiba as aulas e seus respectivos horários.
- Liste os nomes dos instrutores e a data de admissão.

---

### 🔹 5. Seleção com filtros (WHERE)
- Liste os clientes cadastrados após **2024-01-01**.
- Mostre as aulas que acontecem no horário das **18h**.
- Encontre os planos cujo preço mensal seja maior que **100**.
- Liste os instrutores contratados antes de **2023-01-01**.

---

### 🔹 6. Condicionais lógicas (AND, OR, NOT)
- Mostre os clientes cadastrados depois de **2024-01-01** e cujo email termina com **@gmail.com**.
- Liste os planos com preço entre **80** e **200**.
- Mostre as aulas ministradas por instrutores **não** contratados em **2025**.

---

### 🔹 7. Operadores de conjunto e subconsultas
- Liste os clientes que ainda não estão matriculados em nenhuma aula (**NOT IN**).
- Mostre os planos que não foram contratados por nenhum cliente.
- Encontre as aulas que não possuem nenhum aluno matriculado (**NOT EXISTS**).

---

### 🔹 8. Ordenação e Limite de resultados (ORDER BY, LIMIT)
- Liste os clientes em ordem alfabética.
- Mostre os planos do mais caro para o mais barato.
- Exiba as três aulas cadastradas mais recentemente.
- Liste os instrutores do mais antigo ao mais novo.

---

### 🔹 9. Definição e alteração de estrutura (DDL)
- Crie a tabela **Equipamento** (`id`, `nome`, `tipo`, `data_aquisicao`).
- Adicione a coluna **telefone** à tabela **Cliente**.
- Renomeie a coluna **valor_mensal** para **preco_mensal** na tabela **Plano**.
- Remova a tabela **Equipamento**.

---

### 🔹 10. Funções de texto e data
- Mostre apenas o primeiro nome dos clientes.
- Exiba o ano de admissão dos instrutores.
- Liste clientes cujo email não contém **“hotmail”**.
- Liste clientes pela data mais recente de cadastro.
- Mostre os nomes das aulas em letras maiúsculas.

---

## ✅ Resultado Esperado
Ao final do exercício, o aluno deverá ser capaz de:
- Identificar corretamente **entidades e relacionamentos**.
- Criar **tabelas associativas** com integridade referencial.
- Aplicar **SQL básico, intermediário e avançado**.
- Desenvolver uma base sólida em **modelagem de dados relacional**.

---
