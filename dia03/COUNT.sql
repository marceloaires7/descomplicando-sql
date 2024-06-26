-- Databricks notebook source
-- DBTITLE 1,Contagem de linhas da tabela
SELECT COUNT(*),
       COUNT(1)

FROM silver.olist.pedido

-- COMMAND ----------

SELECT COUNT(descSituacao), -- linhas não nulas deste campo (descSituacao)
       COUNT(DISTINCT descSituacao)

FROM silver.olist.pedido

-- COMMAND ----------

SELECT COUNT(idPedido), -- linhas não nulas para idPedido
       COUNT(DISTINCT idPedido), -- linhas distintas para idPedido
       COUNT(*), -- linhas totais da tabela
       COUNT(1) -- linhas totais da tabela
FROM silver.olist.pedido
