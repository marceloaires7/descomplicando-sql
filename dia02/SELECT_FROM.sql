-- Databricks notebook source
-- DBTITLE 1,Consultando Tabelas
SELECT *
FROM silver.olist.pedido
LIMIT 10

-- COMMAND ----------

SELECT *,
       vlPreco + vlFrete AS vlTotal
FROM silver.olist.item_pedido

-- COMMAND ----------

SELECT idPedido,
       idProduto,
       vlPreco,
       vlFrete,
       vlPreco + vlFrete AS vlTotal
       
FROM silver.olist.item_pedido
