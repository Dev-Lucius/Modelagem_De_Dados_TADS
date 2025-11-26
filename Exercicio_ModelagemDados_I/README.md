
# Guia Rápido: Comandos Essenciais do PostgreSQL (psql)

Este README.md apresenta um guia simples, organizado e claro com os principais comandos utilizados para trabalhar com **PostgreSQL via terminal no Linux usando psql**.

---

## 🎲 1. Como acessar o psql

### Entrar como usuário postgres:
```
psql -U postgres
``` 

### 📌 2. Entrar Diretamente em um Banco
```
psql -U postgres -d clinica
```

### 📌 3. Entrar sem senha:
```
sudo -u postgres psql
```

---

## 🎲 2. Meta-Comandos do PSQL

### Listar Bancos
```
\l
```

### Conectar em um Banco
```
\c nome_banco
```

### Listar Tabelas
```
\dt
```

### Listar Usuários
```
\du
```

### Ajuda
```
\?
```

### Limpar Tela
```
\! clear
```

### Ajuda SQL
```
\h
\h create table
```

### Sair
```
\q
```

---

## 🎲 3. Executar Arquivos SQL

```
\i /home/usuario/script.sql
```

---

## 🎲 4. Exportar / Importar CSV
```
\copy cliente TO 'clientes.csv' CSV HEADER;
\copy cliente FROM 'clientes.csv' CSV HEADER;
```

### **Feito por Lucas Oliveira** 🐧🗃️