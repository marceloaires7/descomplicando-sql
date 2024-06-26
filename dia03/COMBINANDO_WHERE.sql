-- Databricks notebook source
SELECT COUNT(idVendedor),
       COUNT(DISTINCT idVendedor)

FROM silver.olist.vendedor

WHERE descUF = 'RJ'

-- COMMAND ----------

SELECT COUNT(idCliente), -- clientes não únicos
       COUNT(DISTINCT idClienteUnico), -- clientes únicos
       COUNT(DISTINCT descCidade) -- cidades distintas
FROM silver.olist.cliente

WHERE descUF = 'AC'

-- COMMAND ----------

SELECT COUNT(*),
       AVG(vlPesoGramas),
       PERCENTILE(vlPesoGramas, .5),
       STD(vlPesoGramas),
       MIN(vlPesoGramas),
       MAX(vlPesoGramas),
       MAX(vlPesoGramas) - MIN(vlPesoGramas)

FROM silver.olist.produto

WHERE descCategoria = 'perfumaria'
