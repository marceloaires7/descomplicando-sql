-- Databricks notebook source
-- DBTITLE 1,Crie uma tabela em sandbox.linuxtips com o seu nome.
-- 1. Crie uma tabela em sandbox.linuxtips com o seu nome.

DROP TABLE IF EXISTS sandbox.linuxtips.marcelo;

CREATE TABLE IF NOT EXISTS sandbox.linuxtips.marcelo (
  id INT,
  nome STRING,
  dt_nascimento DATE,
  profissao STRING,
  renda FLOAT,
  uf STRING,
  nacionalidade STRING
);

SELECT * FROM sandbox.linuxtips.marcelo;

-- COMMAND ----------

-- DBTITLE 1,Insira nesta tabela criada os seguintes registros utilizando a cláusula INSERT INTO
-- 2. Insira nesta tabela criada os seguintes registros utilizando a cláusula INSERT INTO

INSERT INTO sandbox.linuxtips.marcelo (id, nome, dt_nascimento, profissao, renda, uf, nacionalidade)
VALUES (1, 'Maria', DATE('1989-01-18'), 'Artesã', 1450.90, 'MG', 'Brasileira' ),
       (2, 'José', DATE('1987-06-25'), 'Mecânico', 2756.87, 'SP', 'Brasileira' ),
       (3, 'Manoel', DATE('1995-09-13'), 'Operador de máquinas pesadas', 3245.53, 'SP', 'Brasileira' ),
       (4, 'Antônia', DATE('1991-02-28'), 'Tratorista', 3135.47, 'SC', 'Brasileira' ),
       (5, 'Maria Eduarda', DATE('1985-12-28'), 'Serviço gerais', 1649.21, 'BA', 'Brasileira'),
       (6, 'João de Deus', DATE('1999-03-14'), 'Manobrista', 2375.78, 'PE', 'Brasileira'),
       (7, 'Eduardo', DATE('2003-05-04'), 'Atendente', 3157.06, 'AM', 'Haitiano'),
       (8, 'Mônica', DATE('2006-10-09'), 'Estudante', 550.00, 'SP', 'Brasileira'),
       (9, 'Bruno', DATE('1998-02-26'), 'Encanador', 1459.98, 'MG', 'Brasileira'),
       (10, 'Letícia', DATE('1982-04-01'), 'Marceneira', 1698.74, 'SP', 'Angolana'),
       (11, 'Tomé', DATE('1971-07-31'), 'Porteiro', 2670.32, 'SP', 'Brasileira')
;

SELECT * FROM sandbox.linuxtips.marcelo;

-- COMMAND ----------

-- DBTITLE 1,O atendente Eduardo, id=7, ganhou um aumento de 15% em seu salário. Precisamos atualizar seus dados. Pode fazer isso?
-- 3. O atendente Eduardo, id=7, ganhou um aumento de 15% em seu salário. Precisamos atualizar seus dados. Pode fazer isso?

UPDATE sandbox.linuxtips.marcelo SET renda = ROUND(renda * 1.15) WHERE id = 7;

SELECT * FROM sandbox.linuxtips.marcelo;

-- COMMAND ----------

-- DBTITLE 1,Maria Eduarda, id=5 foi promovida à copeira e seu novo salário será de R$2150,00. Vamos atualizar seus dados?
-- 4. Maria Eduarda, id=5 foi promovida à copeira e seu novo salário será de R$2150,00. Vamos atualizar seus dados?

UPDATE sandbox.linuxtips.marcelo SET profissao = 'Copeira', renda = 2150 WHERE id = 5;

SELECT * FROM sandbox.linuxtips.marcelo;

-- COMMAND ----------

-- DBTITLE 1,Manoel, id=3, saiu da empresa e solicitou a exclusão de seus dados. Como podemos fazer essa operação?
-- 5. Manoel, id=3, saiu da empresa e solicitou a exclusão de seus dados. Como podemos fazer essa operação?

DELETE FROM sandbox.linuxtips.marcelo WHERE id = 3;

SELECT * FROM sandbox.linuxtips.marcelo;

-- COMMAND ----------

-- DBTITLE 1,O salário mínimo nacional aumentou 5%, como podemos atualizar todos os salários da tabela?
-- 6. O salário mínimo nacional aumentou 5%, como podemos atualizar todos os salários da tabela?

UPDATE sandbox.linuxtips.marcelo SET renda = ROUND(renda * 1.05, 2);

SELECT * FROM sandbox.linuxtips.marcelo;

-- COMMAND ----------

-- DBTITLE 1,O governo brasileiro está dando incentivo para empresas que valorizam a mão de obra imigrante. Portanto, todas as pessoas não brasileiras receberam um aumento de 2,5% em seus respectivos salários.
-- 7. O governo brasileiro está dando incentivo para empresas que valorizam a mão de obra imigrante. Portanto, todas as pessoas não brasileiras receberam um aumento de 2,5% em seus respectivos salários.

UPDATE sandbox.linuxtips.marcelo SET renda = ROUND(renda * 1.025, 2) WHERE nacionalidade != 'Brasileira';

SELECT * FROM sandbox.linuxtips.marcelo;
