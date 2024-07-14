-- Databricks notebook source
WITH tb_dia_receita AS (

  SELECT DATE(t2.dtPEdido) AS dtPedido,
  SUM(t1.vlPreco) AS receitaDia

  FROM silver.olist.item_pedido AS t1

  INNER JOIN silver.olist.pedido AS t2
  ON t1.idPedido = t2.idPedido

  WHERE descSituacao = 'delivered'

  GROUP BY 1
  ORDER BY 1

),

tb_lag AS (

  SELECT *,
        LAG(receitaDia) OVER (PARTITION BY 1 ORDER BY dtPedido) AS lag1Receita,
        LAG(receitaDia, 2) OVER (PARTITION BY 1 ORDER BY dtPedido) AS lag2Receita,

        LEAD(receitaDia) OVER (PARTITION BY 1 ORDER BY dtPedido) AS lead1Receita,
        LAG(receitaDia, -1) OVER (PARTITION BY 1 ORDER BY dtPedido) AS lag_1Receita

  FROM tb_dia_receita
  
)

SELECT *,
       receitaDia - lag1Receita AS diffLag1

FROM tb_lag

-- COMMAND ----------

WITH tb_vendedor AS (

  SELECT 
        DISTINCT
        t1.idVendedor,
        DATE(t2.dtPedido) AS dtPedido

  FROM silver.olist.item_pedido AS t1

  INNER JOIN silver.olist.pedido AS t2
  ON t1.idPedido = t2.idPedido

  ORDER BY idVendedor, dtPedido
  
),
tb_lag AS (

  SELECT *,
        LAG(dtPedido) OVER (PARTITION BY idVendedor ORDER BY dtPedido) AS lag1Data

  FROM tb_vendedor
  
),

tb_diff AS (

  SELECT *,
        datediff(dtPedido, lag1Data) AS diffData

  FROM tb_lag

)

SELECT idVendedor,
       AVG(diffData) AS mediaIntervaloVendas,
       PERCENTILE(diffData, 0.5) AS medianIntervaloVendas,
       COUNT(*) AS qtdVendas

FROM tb_diff

GROUP BY idVendedor

HAVING COUNT(*) >= 2

ORDER BY qtdVendas DESC
