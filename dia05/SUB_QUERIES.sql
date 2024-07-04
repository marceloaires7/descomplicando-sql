-- Databricks notebook source
-- DBTITLE 1,Identificando o mês
-- 1. Quais são os TOP 10 vendedores que mais venderam (em quantidade) no mês com maior número de vendas no Olist

SELECT DATE(date_trunc('MONTH', dtPedido)) AS dtMonth

FROM silver.olist.pedido

GROUP BY dtMonth

ORDER BY COUNT(DISTINCT idPedido) DESC

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Identificando os vendedores (hard coded)
SELECT t2.idVendedor,
       COUNT(*) AS qtdItens

FROM silver.olist.pedido AS t1

INNER JOIN silver.olist.item_pedido AS t2
ON t1.idPedido = t2.idPedido

WHERE date_trunc('MONTH', t1.dtPedido) = '2017-11-01'

GROUP BY t2.idVendedor

ORDER BY qtdItens DESC

LIMIT 10

-- COMMAND ----------

-- DBTITLE 1,Identificando os vendedores (subquery)
SELECT t2.idVendedor,
       COUNT(*) AS qtdItens

FROM silver.olist.pedido AS t1

INNER JOIN silver.olist.item_pedido AS t2
ON t1.idPedido = t2.idPedido

WHERE date_trunc('MONTH', t1.dtPedido) = (
  
  -- IDENTIFICA MES COM MAIS VENDAS
  SELECT DATE(date_trunc('MONTH', dtPedido)) AS dtMonth
  FROM silver.olist.pedido
  GROUP BY dtMonth
  ORDER BY COUNT(DISTINCT idPedido) DESC
  LIMIT 1 

  )

GROUP BY t2.idVendedor

ORDER BY qtdItens DESC

LIMIT 10

-- COMMAND ----------

-- DBTITLE 1,Exemplo SubQuery FROM
SELECT *

FROM (

  SELECT DATE(date_trunc('MONTH', dtPedido)) AS dtMonth,
         COUNT(DISTINCT idPedido) AS qtdPedido
  FROM silver.olist.pedido
  GROUP BY dtMonth
  ORDER BY qtdPedido DESC

  )

WHERE dtMonth >= '2018-01-01'

-- COMMAND ----------

-- Total de vendas históricas (independente da categoria) dos vendedores que venderam ao menos um produto da categoria bebes na blackfriday de 2017-11-01



-- COMMAND ----------

-- DBTITLE 1,Identifica vendedores BlackFriday e categoria Bebes
SELECT DISTINCT t2.idVendedor

FROM silver.olist.pedido as t1

INNER JOIN silver.olist.item_pedido as t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.produto as t3
ON t2.idProduto = t3.idProduto

WHERE DATE(DATE_TRUNC('MONTH', dtPedido)) = '2017-11-01'
AND t3.descCategoria = 'bebes'

-- COMMAND ----------

-- DBTITLE 1,Histórico de vendas completo dos vendedores
SELECT idVendedor,
       COUNT(DISTINCT idPedido) AS qtdPedido

FROM silver.olist.item_pedido

WHERE idVendedor in (

  SELECT DISTINCT t2.idVendedor

  FROM silver.olist.pedido as t1

  INNER JOIN silver.olist.item_pedido as t2
  ON t1.idPedido = t2.idPedido

  LEFT JOIN silver.olist.produto as t3
  ON t2.idProduto = t3.idProduto

  WHERE DATE(DATE_TRUNC('MONTH', dtPedido)) = '2017-11-01'
  AND t3.descCategoria = 'bebes'

)

GROUP BY idVendedor

ORDER BY qtdPedido DESC

-- COMMAND ----------

-- DBTITLE 1,Retrieve Baby Product Orders for November 2017


SELECT t1.idVendedor,
       COUNT(DISTINCT t2.idPedido) as qtdPedido

FROM (

  SELECT DISTINCT t2.idVendedor
  FROM silver.olist.pedido as t1
  INNER JOIN silver.olist.item_pedido as t2
  ON t1.idPedido = t2.idPedido
  LEFT JOIN silver.olist.produto as t3
  ON t2.idProduto = t3.idProduto
  WHERE DATE(DATE_TRUNC('MONTH', t1.dtPedido)) = '2017-11-01'
  AND t3.descCategoria = 'bebes'

) AS t1

LEFT JOIN silver.olist.item_pedido AS t2
ON t1.idVendedor = t2.idVendedor

GROUP BY t1.idVendedor

ORDER BY qtdPedido DESC
