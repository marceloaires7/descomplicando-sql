-- Databricks notebook source
SELECT descUF,
       COUNT(DISTINCT idVendedor) as qtdVendedor

FROM silver.olist.vendedor

GROUP BY descUF

ORDER BY 2 DESC

-- COMMAND ----------

SELECT descUF,
       COUNT(DISTINCT idVendedor)

FROM silver.olist.vendedor

GROUP BY descUF

ORDER BY COUNT(idVendedor) DESC

-- COMMAND ----------

SELECT descUF,
       COUNT(DISTINCT idVendedor) as qtVendedor

FROM silver.olist.vendedor

GROUP BY descUF

ORDER BY qtVendedor DESC

-- COMMAND ----------

SELECT descCategoria,
       COUNT(idProduto) AS qtProduto,
       AVG(vlPesoGramas) AS avgPeso,
       PERCENTILE(vlPesoGramas, 0.5) AS medianaPeso,

       AVG(vlComprimentoCm * vlAlturaCm * vlLarguraCm) AS avgVolume,
       PERCENTILE(vlComprimentoCm * vlAlturaCm * vlLarguraCm, .5) AS medianaVolume

FROM silver.olist.produto

GROUP BY descCategoria

ORDER BY medianaPeso DESC

-- COMMAND ----------

SELECT year(dtPedido) || '-' || MONTH(dtPedido) AS anoMes,
       COUNT(idPedido)

FROM silver.olist.pedido

GROUP BY anoMes

ORDER BY anoMes

-- COMMAND ----------

SELECT DATE(DATE_TRUNC('month', dtPedido)) AS anoMes,
       COUNT(idPedido)

FROM silver.olist.pedido

GROUP BY anoMes

ORDER BY anoMes
