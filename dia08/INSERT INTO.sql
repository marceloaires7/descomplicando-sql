-- Databricks notebook source
CREATE TABLE sandbox.linuxtips.usuarios_marcelo (
  id INT,
  nome STRING,
  idade INT
);

-- COMMAND ----------

INSERT INTO sandbox.linuxtips.usuarios_marcelo (id, nome, idade) VALUES (1, "Marcelo", 31)

-- COMMAND ----------

INSERT INTO sandbox.linuxtips.usuarios_marcelo (id, nome, idade)
VALUES (2, "Lari", 33), (3, "Ana", 1)

-- COMMAND ----------

INSERT INTO sandbox.linuxtips.usuarios_marcelo
VALUES (4, "José")

-- COMMAND ----------

INSERT INTO sandbox.linuxtips.usuarios_marcelo
VALUES (5, "João", 21)

-- COMMAND ----------

SELECT * FROM sandbox.linuxtips.usuarios_marcelo

-- COMMAND ----------

SELECT * FROM silver.olist.cliente LIMIT 10

-- COMMAND ----------

CREATE TABLE sandbox.linuxtips.cliente_olist_marcelo (
  id STRING,
  estado STRING
)

-- COMMAND ----------

INSERT INTO sandbox.linuxtips.cliente_olist_marcelo

SELECT idCliente AS id,
       descUF AS estado

FROM silver.olist.cliente LIMIT 10

-- COMMAND ----------

WITH tb_rj AS (
  SELECT * FROM silver.olist.cliente
  WHERE descUF = 'RJ'
)

INSERT INTO sandbox.linuxtips.cliente_olist_marcelo

SELECT idCliente AS id,
       descUF AS estado
FROM tb_rj
LIMIT 10

-- COMMAND ----------

SELECT * FROM sandbox.linuxtips.cliente_olist_marcelo
