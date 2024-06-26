-- Databricks notebook source
-- DBTITLE 1,Ordenação do preço e frete
SELECT *

FROM silver.olist.item_pedido

ORDER BY vlPreco DESC, vlFrete DESC

LIMIT 3

-- COMMAND ----------

-- DBTITLE 1,Top 5 categoria 'perfumaria' com maior nome
SELECT *

FROM silver.olist.produto

WHERE descCategoria = 'perfumaria'

ORDER BY nrTamanhoNome DESC

LIMIT 5

-- COMMAND ----------

-- DBTITLE 1,Top 5 categoria 'perfumaria' com maior volume
SELECT *,
       (vlComprimentoCm * vlAlturaCm * vlLarguraCm) AS volumeCm

FROM silver.olist.produto

WHERE descCategoria = 'perfumaria'

ORDER BY (vlComprimentoCm * vlAlturaCm * vlLarguraCm) DESC

LIMIT 5
