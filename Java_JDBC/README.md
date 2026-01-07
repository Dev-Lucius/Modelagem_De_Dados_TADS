# 📘 JDBC com PostgreSQL — Material Completo de Estudo (Java + Maven)

Este material foi criado para servir como um **guia completo de estudo sobre JDBC**, abordando desde os **conceitos fundamentais** até a **execução prática de SQL via Java**, utilizando **PostgreSQL**, **Maven** e **VS Code**.

O foco é ensinar **como o JDBC funciona**, **por que cada etapa existe** e **como evitar erros comuns** enfrentados por iniciantes.

---

## 📌 Sumário

1. O que é JDBC
2. Como o JDBC funciona internamente
3. Arquitetura de uma aplicação JDBC
4. Preparando o ambiente
5. Criando um projeto Maven no VS Code
6. Entendendo o `pom.xml`
7. Driver JDBC do PostgreSQL
8. Criando a classe de conexão
9. Testando a conexão
10. Executando um `schema.sql` via Java
11. Executando SQL diretamente no Java
12. PreparedStatement (conceito essencial)
13. CRUD completo com JDBC
14. Tratamento de erros
15. Boas práticas profissionais
16. Erros comuns e como resolver

---

## 1️⃣ O que é JDBC?

**JDBC (Java Database Connectivity)** é a API padrão do Java que permite que aplicações Java se comuniquem com bancos de dados relacionais.

Em outras palavras:

> JDBC é a ponte entre o **Java** e o **Banco de Dados**.

Sem JDBC, o Java **não sabe** como:
- Enviar comandos SQL
- Receber resultados
- Criar conexões com bancos de dados

---

## 2️⃣ Como o JDBC funciona internamente?

O JDBC funciona em **camadas**:

```text
Java Application
       ↓
   JDBC API
       ↓
 JDBC Driver
       ↓
 Banco de Dados
```

### Componentes principais:
    - Driver JDBC → biblioteca específica do banco
    - Connection → conexão com o banco
    - Statement / PreparedStatement → envio de SQL
    - ResultSet → retorno de dados

## 3️⃣ Arquitetura básica de uma aplicação JDBC

```
┌──────────────┐
│  Java Code   │
└──────┬───────┘
       ↓
┌──────────────┐
│  JDBC API    │
└──────┬───────┘
       ↓
┌──────────────┐
│ JDBC Driver  │
└──────┬───────┘
       ↓
┌──────────────┐
│ PostgreSQL   │
└──────────────┘
```

### 📌 Regra importante:
- **Cada banco possui seu próprio driver JDBC.**

---

## 4️⃣ Preparando o ambiente

### Requisitos:

- Java instalado (java -version)
- Maven instalado (mvn -version)
- PostgreSQL rodando (ou o banco de dados de sua escolha)
- VS Code com extensões Java

---

## 5️⃣ Criando um Projeto Maven no VS Code

No VS Code:

- ``` Ctrl + Shift + P ```
- **Maven: Create Maven Projec**
- Escolha ``` maven-archetype-quickstart ```
- Versão 1.4
- Defina: 
    * GroupId → br.com.lucas
    * ArtifactId → jdbc-schema-runner

## Entendo o ``` pom.xml ```

Em linhas Gerais, trata-se do coração do **Maven**

Ele Define Propriedades como:

- Dependências
- Versão do Java
- Plugins
- Configuração de Build

Exemplo Mínimo Funcional:

```xml
<properties>
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
</properties>
```

**A versão do Java no Maven precisa bater com a do JDK instalado.**

---

## 7️⃣ Driver JDBC do PostgreSQL

Sem o Driver, Ocorre o Erro

```
No suitable driver found
```

Depedência Correta

```
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.7.3</version>
</dependency>
```

---

## 8️⃣ Criando a classe de conexão

Responsável **Exclusivamente** Por conectar o Arquivo Java ao **banco de dados**

### Exemplo Básico

```java
public class Conexao {

    private static final String URL =
        "jdbc:postgresql://localhost:5432/seu_banco";
    private static final String USER = "postgres";
    private static final String PASSWORD = "postgres";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

- 📌 ```Class.forName() ```não é mais obrigatório em drivers modernos.

---

## 9️⃣ Testando a conexão

```java
public class TesteConexao {

    public static void main(String[] args) {
        try (Connection conn = Conexao.getConnection()) {
            System.out.println("Conectado com sucesso!");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

---

## 🔟 Executando um ```schema.sql``` via Java

### Porque Executar um *```schema.sql```* Via Java

- Automazia Criação de Tabelas
- Evitar Rodar SQL Manualmente
- Facilta Deploy e Testes

📂 Estrutura:

```text
src/main/resources/schema.sql
```

### Lendo o Arquivo no Java

```java
InputStream is = getClass()
    .getClassLoader()
    .getResourceAsStream("schema.sql");
```

- 📌 O Java lê o arquivo como **recurso interno**.

---

## 1️⃣1️⃣ Executando SQL diretamente no Java

- ***INSERT***

```java
String sql = "INSERT INTO cliente (nome, email) VALUES (?, ?)";

PreparedStatement ps = conn.prepareStatement(sql);
ps.setString(1, "Lucas");
ps.setString(2, "lucas@email.com");
ps.executeUpdate();
```

- ***SELECT***

```java
String sql = "SELECT id, nome FROM cliente";

ResultSet rs = ps.executeQuery();
while (rs.next()) {
    System.out.println(
        rs.getInt("id") + " - " + rs.getString("nome")
    );
}
```

---

## 1️⃣2️⃣ PreparedStatement (conceito essencial)

Porque Usar?

- Evita SQL Injection
- Melhora o Desempenho
- Código Mais Limpo

### ❌ ERRADO:

```java
"SELECT * FROM usuario WHERE nome = '" + nome + "'"
```

### ✅ CORRETO:

```java
"SELECT * FROM usuario WHERE nome = ?"
```

---

## 1️⃣3️⃣ CRUD completo com JDBC

| Operação | Método |
| -------- | ------ |
| Create   | INSERT |
| Read     | SELECT |
| Update   | UPDATE |
| Delete   | DELETE |

---

## 1️⃣4️⃣ Tratamento de erros

Sempre Trate:

- ```SQLException```
- Erros de Conexão
- Erros de Sintaxe SQL

Uma boa prática é usar:

```java
catch (SQLException e) {
    System.err.println("Erro SQL: " + e.getMessage());
}
```

## 1️⃣5️⃣ Boas práticas profissionais

- ✅ Use ```PreparedStatement```
- ✅ Use ```try-with-resources```
- ✅ Centralize a conexão
- ✅ Separe responsabilidades
- ❌ Nunca concatene SQL

---

## 1️⃣6️⃣ Erros comuns e soluções

```invalid target release```
- Versão do Java incompatível com Maven

```ClassNotFoundException```
- Classe Fora do Package ou Simplesmente no caminho errado

```No suitable driver```
- Driver do JDBC Ausente 