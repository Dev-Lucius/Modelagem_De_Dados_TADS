CREATE DATABASE gatos;

\c gatos;

CREATE TABLE cat(
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cor text,
    raca text,
    idade INTEGER,
    fav_brinquedo text
);
INSERT INTO cat (nome, raca, cor, idade, fav_brinquedo) VALUES
('Micky', 'Maine Coon', 'Cinza', 3, 'bola vermelha'),
('Nine', 'Ragamuffin', 'Branca', 2, 'Bola Verde'),
('Carmen', 'Persa', 'Marrom', 2, 'rato de borracha'), 
('Luna', 'Abyssinian', 'Preto', 12, 'laser'),
('Bella', 'Siames', 'Vermelho', 15, 'laser');
('Bola de Neve', 'Siames', 'Cinza', 9, 'pena');

-- Consultas

-- 1) Obtenha todas as informações da tabela cat.
/*
    Select é usado para recuperar registros de uma determinada Tabela
    Nesse caso, a Tabela 'cat'.

    Além disso, o Asterisco é usado para Pegar todas as colunas da Tabela em questão
*/
SELECT * FROM cat;

-- 2) Selecione somente as colunas name e idade da tabela cat
SELECT c.nome AS nome_gato, c.idade AS idade_gato
FROM cat c;

-- 3) Obter todas as informações da tabela cat sobre gatos siameses.
SELECT c.nome AS nome_gato, c.raca AS raca_gato FROM cat c WHERE c.raca = 'Siames';

-- 4) Obtenha as linhas da tabela cat que correspondam a indivíduos com menos de 8 anos de idade.
SELECT c.nome AS nome_gato, c.idade AS idade_gato FROM cat c WHERE c.idade < 8 ORDER BY c.idade ASC;

-- 5) Obter linhas que correspondam a gatos siameses com menos de 8 anos de idade.
SELECT c.nome AS nome_gato, c.raca AS raca_gato, c.idade AS idade_gato FROM cat c WHERE c.raca = 'Siames' AND c.idade < 8;

-- 6) Obtenha uma lista de gatos persas ou siameses na tabela cat tabela.
SELECT c.nome AS nome_gato, c.raca AS raca_gato, c.idade AS idade_gato FROM cat c WHERE c.raca = 'Siames' OR c.raca = 'Persa' ORDER BY c.idade ASC;

-- 7) Obtenha uma lista de gatos siameses ou persas da tabela cat que tenham menos de 5 anos de idade ou mais de 10 anos de idade.
/*
    Deve-se tomar cuidado quando os operadores OR e AND são colocados na mesma cláusula WHERE
    O Psql irá combinar as condições lógicas na ordem em que elas aparecem , a menos que parênteses sejam utilizados.
    Assim, deve-se utilizar parênteses para controlar o que seŕa avaliado primeiro
*/
SELECT c.nome AS nome_gato, c.raca AS raca_gato, c.idade AS idade_gato FROM cat c WHERE (c.raca = 'Siames' OR c.raca = 'Persa') AND (c.idade < 5 OR c.idade > 10);

-- 8) Obter uma lista de gatos Persas, Siameses ou Ragdoll sem usar o operador OR.
SELECT c.nome AS nome_gato, c.raca AS raca_gato FROM cat c WHERE c.raca IN ('Persa', 'Siames', 'Radgoll');

-- 9) Obter todas as linhas da tabela cat correspondentes aos gatos cujo brinquedo favorito é uma bola de qualquer cor.
SELECT c.nome AS nome_gato, c.fav_brinquedo AS brinquedo FROM cat c WHERE c.fav_brinquedo LIKE '%Bola%' OR c.fav_brinquedo LIKE '%bola%';

-- 10) Obtenha todas as linhas da tabela cat correspondentes aos gatos que não têm um brinquedo favorito.
SELECT c.nome AS nome_gato, c.fav_brinquedo AS brinquedo FROM cat c WHERE c.fav_brinquedo IS NULL;

-- 11) Obtenha todas as linhas da tabela cat correspondentes aos gatos que têm um brinquedo favorito.
SELECT c.nome AS nome_gato, c.fav_brinquedo AS brinquedo FROM cat c WHERE c.fav_brinquedo IS NOT NULL;

-- 12)  Selecione o nome e a idade na tabela cat certificando-se de que os resultados sejam ordenados por idade.
SELECT c.nome AS nome_gato, c.idade AS idade_gato FROM cat c ORDER BY c.idade ASC; -- => Ascendente
SELECT c.nome AS nome_gato, c.idade AS idade_gato FROM cat c ORDER BY c.idade DESC; -- => Descendente 

-- 13) Selecione a raça, o nome e a idade de todas as linhas da tabela cate obter os resultados ordenados primeiro por raça e depois por idade
SELECT c.raca AS raca_gato, c.nome AS nome_gato, c.idade AS idade_gato FROM cat c ORDER BY c.idade ASC;

-- 14) Selecione a raça, o nome e a idade de todos os gatos e, em seguida, classifique os resultados primeiro por raça em ordem alfabética e, 
--     depois, por idade, do mais velho ao mais novo.
SELECT c.raca AS raca_gato, c.nome AS nome_gato, c.idade AS idade_gato FROM cat c ORDER BY c.raca ASC;
SELECT c.raca AS raca_gato, c.nome AS nome_gato, c.idade AS idade_gato FROM cat c ORDER BY c.idade DESC;

-- 15) Selecione as raças de gatos da tabela cat e o número de gatos de cada raça.
SELECT c.raca AS raca_gato, COUNT(*) AS total_por_raca FROM cat c GROUP BY c.raca ORDER BY total_por_raca DESC;

-- 16) Selecione uma lista das raças de gatos da tabela cat juntamente com a idade máxima e mínima de cada raça.
-- Group By ==> resume/agrupa dados, é útil quando se usa Funções Agregadas
-- Order By ==> apenas ordena o resultado (não resume). Pode ser usando com qualquer Função
-- Ordem de execução lógica: o agrupamento acontece antes da ordenação — você normalmente calcula agregados (com GROUP BY) e depois ordena (com ORDER BY).
SELECT c.raca AS raca_gato, MAX(c.idade) AS idade_max, MIN(c.idade) AS idade_min FROM cat c GROUP BY c.raca;

-- 17) Selecione uma lista de raças de gatos e diferentes colorações na tabela cat tabela, contando o número de gatos de cada combinação de raça e coloração.
SELECT c.raca AS raca_gato, c.cor AS cor_gato, COUNT(*) AS total_por_cor FROM cat c GROUP BY c.cor, c.raca ORDER BY total_por_cor;

-- 18) Obtenha uma lista das raças que são representadas por mais de um registro na tabela cat tabela.
-- Having ==> cláusula que filtra grupos produzidos por GROUP BY; 
--            aplicada após as agregações (ex.: COUNT, SUM, MAX, MIN, AVG).
SELECT c.raca AS raca_gato, COUNT(*) FROM cat c GROUP BY c.raca HAVING COUNT(*) > 1;


