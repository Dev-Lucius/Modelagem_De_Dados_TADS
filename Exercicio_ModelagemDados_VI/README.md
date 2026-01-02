# 🐾 Sistema de Gestão de Clínica Veterinária — Desafio Completo de Modelagem de Dados

## 📌 Visão Geral
Este projeto consiste em um **desafio completo de Modelagem de Dados**, abrangendo desde o **levantamento de requisitos** até a **criação de consultas SQL avançadas**, com foco em **bancos de dados relacionais (PostgreSQL)**.

O objetivo é desenvolver uma modelagem **conceitual, lógica e física** sólida, respeitando as **formas normais**, boas práticas de modelagem e integridade referencial, simulando um **cenário real de uma clínica veterinária**.

---

## 🎯 Objetivos de Aprendizado
Ao concluir este desafio, você será capaz de:

- Identificar e modelar **entidades**, **atributos** e **relacionamentos**
- Trabalhar corretamente com:
  - Entidades associativas
  - Atributos multivalorados
  - Relacionamentos N:N
- Aplicar **normalização (1FN, 2FN e 3FN)**
- Converter MER → Modelo Lógico → Modelo Físico (SQL)
- Criar **consultas SQL reais**, incluindo agregações e subconsultas
- Justificar decisões de modelagem de forma técnica

---

## 🧩 Contexto do Sistema
Uma **Clínica Veterinária** deseja informatizar completamente seu sistema de atendimento, mantendo **histórico completo** de clientes, animais, consultas e procedimentos médicos.

O sistema deve gerenciar:
- Clientes e seus animais
- Consultas veterinárias
- Exames, medicamentos, vacinas e procedimentos
- Especialidades dos veterinários
- Histórico clínico completo dos animais

---

## 🧱 Requisitos Funcionais

### 🧑 Cliente
- id
- nome
- cpf
- data de nascimento
- múltiplos telefones
- múltiplos e-mails
- pode possuir **0 ou mais animais**

---

### 🐾 Animal
- id
- nome
- espécie
- raça
- data de nascimento
- pertence a **um único cliente**
- pode realizar **várias consultas**
- pode receber **várias vacinas**

---

### 👨‍⚕️ Veterinário
- id
- nome
- cfmv
- possui **uma ou mais especialidades**
- realiza **várias consultas**

---

### 📅 Consulta
- id
- data e hora
- anotação
- status
- associada a:
  - um animal
  - um veterinário
- pode conter:
  - exames
  - medicamentos
  - procedimentos

---

### 🧪 Exame
- id
- nome
- tipo
- pode ser solicitado em várias consultas
- por consulta deve registrar:
  - resultado
  - data de realização
  - observações

---

### 💊 Medicamento
- id
- nome
- princípio ativo
- pode ser prescrito em várias consultas
- registrar:
  - dose
  - frequência
  - duração

---

### 💉 Vacina
- id
- nome
- um animal pode receber a mesma vacina várias vezes
- registrar:
  - data da aplicação
  - dose
  - observação

---

### ⚙️ Procedimento
- id
- nome
- custo base
- pode ocorrer em várias consultas

---

## 🧠 Desafios de Modelagem
Durante o desenvolvimento, o aluno deverá:

- Identificar atributos **multivalorados**
- Identificar relacionamentos **N:N**
- Criar **entidades associativas** quando necessário
- Decidir entre:
  - chave primária composta
  - chave artificial (id)
- Definir regras de integridade referencial
- Garantir normalização até a **3ª Forma Normal (3FN)**

---

## 🗺️ Etapas do Projeto

### 1️⃣ Modelo Conceitual (MER)
- Entidades
- Atributos
- Relacionamentos
- Cardinalidades
- Participação total/parcial

---

### 2️⃣ Modelo Lógico (Relacional)
- Tabelas
- Chaves primárias
- Chaves estrangeiras
- Constraints (`NOT NULL`, `UNIQUE`)
- Tabelas associativas

---

### 3️⃣ Modelo Físico (PostgreSQL)
- Criação das tabelas em SQL
- Tipos corretos (`DATE`, `TIMESTAMP`, etc.)
- Índices
- Regras `ON DELETE`
- Constraints de integridade

---

## 🔍 Consultas SQL Obrigatórias

### 📌 Consultas Básicas
1. Listar todos os clientes e seus animais  
2. Listar veterinários e suas especialidades  
3. Listar consultas realizadas em um período  

---

### 📌 Consultas Intermediárias
4. Consultas com nome do animal, cliente e veterinário  
5. Exames solicitados em uma consulta específica  
6. Medicamentos prescritos para um animal  
7. Vacinas aplicadas em um animal  

---

### 📌 Consultas Avançadas
8. Veterinário que mais realizou consultas  
9. Animais que nunca passaram por consulta  
10. Clientes com mais de 3 animais  
11. Exames nunca solicitados  
12. Custo total de uma consulta  
13. Histórico completo de um animal  
14. Animais com vacinas atrasadas  
15. Relatório mensal de consultas por veterinário  

---

## 🏁 Critérios de Conclusão
O desafio é considerado concluído quando o participante:

- Consegue justificar cada tabela e relacionamento
- Demonstra normalização correta
- Implementa o modelo em PostgreSQL
- Resolve todas as consultas propostas
- Consegue explicar o sistema como um todo

---

## 🚀 Tecnologias Utilizadas
- PostgreSQL
- SQL padrão ANSI
- Ferramenta de modelagem (brModelo, Draw.io, Lucidchart, etc.)

---

## 📚 Observações Finais
Este projeto é ideal para:
- Estudo acadêmico
- Treinamento avançado em modelagem
- Portfólio técnico
- Preparação para entrevistas técnicas

---

## ✍️ Autor
Projeto desenvolvido como exercício avançado de Modelagem de Dados.

