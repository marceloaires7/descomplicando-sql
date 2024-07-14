-- Databricks notebook source
WITH tb_receita_diaria AS (

  SELECT DATE(dtPedido) AS dataPedido,
         SUM(vlPreco) AS receitaDia

  FROM silver.olist.item_pedido AS t1

  INNER JOIN silver.olist.pedido AS t2
  ON t1.idPedido = t2.idPedido

  GROUP BY dataPedido
  ORDER BY dataPEdido
  
)

SELECT *,
       SUM(receitaDia) OVER (PARTITION BY 1 ORDER BY dataPedido) AS receitaAcum

FROM tb_receita_diaria

-- COMMAND ----------

WITH tb_vendedor_dia AS (

  SELECT DATE(dtPedido) AS dataPedido,
        idVendedor,
        SUM(vlPreco) AS vlReceita

  FROM silver.olist.item_pedido AS t1

  INNER JOIN silver.olist.pedido AS t2
  ON t1.idPedido = t2.idPedido

  GROUP BY dataPedido, idVendedor
  ORDER BY idVendedor, dataPedido

)

SELECT *,
       SUM(vlReceita) OVER (PARTITION BY idVendedor ORDER BY dataPedido) AS receitaAcum

FROM tb_vendedor_dia
