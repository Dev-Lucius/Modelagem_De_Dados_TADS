# 🗒️ Lista de Exercícios em Postgres

## 📌 Visão Geral
Este repositório contém uma lista de exercícios práticos em PostgreSQL usados
para estudar modelagem de dados e consultas (SELECT, WHERE, operadores lógicos,
LIKE, ORDER BY, etc.). O arquivo principal é [schema.sql](schema.sql), que cria a
base de dados, a tabela `cat`, insere registros de exemplo e traz as consultas
exercício comentadas.

## ✅ Objetivo
- Praticar operações de consulta básicas em PostgreSQL.
- Entender aliases de tabela/coluna, filtragem com `WHERE`, operadores lógicos
	(`AND`, `OR`, `IN`), padrões com `LIKE` e ordenação com `ORDER BY`.

## 🧱 Estrutura do esquema
- Banco: `gatos`
- Tabela: `cat` com colunas:
	- `id` (serial, PK)
	- `nome` (VARCHAR(100), NOT NULL)
	- `cor` (text)
	- `raca` (text)
	- `idade` (integer)
	- `fav_brinquedo` (text)

## 🧪 Dados de exemplo
O arquivo [schema.sql](schema.sql) já contém instruções `INSERT` com amostras de
gatos (Micky, Nine, Carmen, Luna, Bella, Bola de Neve) para testar as consultas.

## 📂 Exercícios / Consultas
As consultas no arquivo exemplificam:
- Selecionar todas as colunas (`SELECT *`).
- Selecionar colunas específicas e renomeá-las com `AS`.
- Filtrar por raça (`WHERE raca = 'Siames'`).
- Filtrar por faixa etária (`WHERE idade < 8`).
- Combinar filtros com `AND` / `OR` e controlar precedência com parênteses.
- Usar `IN` como alternativa ao `OR` múltiplo.
- Buscar textos com `LIKE` (sensível a maiúsculas/minúsculas quando necessário).

## ▶️ Como executar
1. Instale o PostgreSQL (se necessário).
2. No terminal, a partir da pasta do projeto, rode:

```bash
createdb gatos          # cria o banco (opcional se já existir)
psql -d gatos -f schema.sql
```

3. Alternativamente, entre no `psql` e execute:

```sql
\c gatos
\i schema.sql
```

4. Depois, faça consultas diretamente no `psql` ou altere/experimente as queries
	 em [schema.sql](schema.sql).

## Resultados esperados
Ao executar o arquivo, a tabela `cat` será criada com alguns registros de
exemplo; as consultas listadas devem retornar subconjuntos desses registros
conformes às condições especificadas (ex.: gatos siameses, gatos com idade < 8,
buscas por brinquedo contendo "Bola").

## 🔎 Observações Relevantes
- **`GROUP BY` / `ORDER BY`:** `GROUP BY` agrupa linhas para permitir agregações (`COUNT`, `MAX`, `MIN`); `ORDER BY` apenas ordena o resultado final. Agrupe primeiro, depois ordene.
- **`WHERE` vs `HAVING`:** use `WHERE` para filtrar linhas antes de agrupar; use `HAVING` para filtrar grupos após a agregação.
- **`COUNT(*)` vs `COUNT(col)`:** `COUNT(*)` conta todas as linhas (inclui NULL em outras colunas); `COUNT(col)` ignora valores NULL da coluna especificada.
- **Normalização ao agrupar:** para evitar grupos duplicados por diferenças de capitalização/espacos, normalize texto com `TRIM()`, `LOWER()` e use `COALESCE()` para substituir `NULL` por um rótulo padrão.
- **`LIKE` e sensibilidade:** `LIKE` é sensível a maiúsculas em PostgreSQL; use `ILIKE` para busca case-insensitive.
- **Aliases e legibilidade:** use aliases de tabela (ex.: `c`) e `AS` para tornar os resultados mais claros e as queries mais curtas.
- **Nulos e valores vazios:** decida uma política (ex.: tratar `NULL` e `''` como `(desconhecido)`) para análises e agregações consistentes.
- **Boas práticas de teste:** execute o `schema.sql`, teste queries com dados adicionais e, se necessário, crie uma tabela-mestre (`races`) e faça `LEFT JOIN` para listar raças mesmo com zero registros.

## Próximos passos sugeridos
- Adicionar mais dados para cobrir casos de teste (sensibilidade a maiúsculas).
- Criar exercícios que envolvam `JOIN`, `GROUP BY` e agregações (`COUNT`, `AVG`).

## Licença
Conteúdo para fins de estudo. Sinta-se livre para revisar e publicar no GitHub.

