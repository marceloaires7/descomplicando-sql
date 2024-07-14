-- Databricks notebook source
CREATE TABLE IF NOT EXISTS sandbox.linuxtips.top50_pedido_marcelo AS 

  SELECT idPedido FROM silver.olist.pedido
  ORDER BY RAND()
  LIMIT 50

-- COMMAND ----------

SELECT *

FROM sandbox.linuxtips.top50_pedido_marcelo

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS sandbox.linuxtips.nova_table_vazia_marcelo (
  descNome STRING,
  vlIdade INT,
  vlSalario FLOAT
)

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS sandbox.linuxtips.ex07_dia06_marcelo

WITH tb_receita_diaria AS (

  SELECT DATE(dtPedido) AS dataPedido,
         t3.descCategoria,
         SUM(vlPreco) AS receitaVendedor,
         COUNT(*) AS qtdVendaItens,
         COUNT(DISTINCT t1.idPedido) AS qtdVendaPedido

  FROM silver.olist.item_pedido AS t1

  INNER JOIN silver.olist.pedido AS t2
  ON t1.idPedido = t2.idPedido

  LEFT JOIN silver.olist.produto AS t3
  ON t1.idProduto = t3.idProduto

  WHERE descCategoria IS NOT NULL

  GROUP BY descCategoria, dataPedido
  ORDER BY descCategoria, dataPedido

)

SELECT *,
       SUM(qtdVendaItens) OVER (PARTITION BY descCategoria ORDER BY dataPedido ASC) AS qtdAcum

FROM tb_receita_diaria

-- COMMAND ----------

SELECT * FROM sandbox.linuxtips.ex07_dia06_marcelo
