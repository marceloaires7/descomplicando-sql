-- Databricks notebook source
DROP TABLE IF EXISTS sandbox.linuxtips.usuarios_marcelo;

CREATE TABLE IF NOT EXISTS sandbox.linuxtips.usuarios_marcelo (
  id INT,
  nome STRING,
  idade INT,
  profissao STRING
);

INSERT INTO sandbox.linuxtips.usuarios_marcelo
VALUES (1, 'Téo', 31, 'Streamer'),
       (2, 'Nah', 32, 'Artesã'),
       (3, 'Mah', 17, 'Estudante'),
       (4, 'Ana', 27, 'Dev'),
       (5, 'João', 45, 'Dev'),
       (6, 'Marcelo', 12, 'Eng. Mecânico'),
       (7, 'Zé', 41, 'Streamer'),
       (8, 'Diná', 33, 'Eng. Mecânico'),
       (9, 'Carlos', 51, 'Analista Financeiro'),
       (10, 'Jeff', 23, 'Cientista de Dados'),
       (11, 'Alex', 18, 'Analista de Dados')
;

SELECT * FROM sandbox.linuxtips.usuarios_marcelo

-- COMMAND ----------

-- DBTITLE 1,UPDATE SEM WHERE
UPDATE sandbox.linuxtips.usuarios_marcelo SET idade = 31

-- COMMAND ----------

-- DBTITLE 1,UPDATE COM WHERE
UPDATE sandbox.linuxtips.usuarios_marcelo SET idade = 31 WHERE id = 6

-- COMMAND ----------

SELECT * FROM sandbox.linuxtips.usuarios_marcelo
