-- Databricks notebook source
WITH tb_pedidos_sem_atraso AS (

  SELECT *
  FROM silver.olist.pedido
  WHERE descSituacao = 'delivered'
  AND dtEntregue <= dtEstimativaEntrega

),

tb_produto_bebes AS (

  SELECT *
  FROM silver.olist.produto
  WHERE descCategoria = 'bebes'

),

tb_final AS (

  SELECT *

  FROM tb_pedidos_sem_atraso AS t1

  INNER JOIN silver.olist.item_pedido AS t2
  ON t1.idPedido = t2.idPedido

  INNER JOIN tb_produto_bebes AS t3
  ON t2.idProduto = t3.idProduto

)

SELECT *
FROM tb_final

-- COMMAND ----------

-- 1. Quais são os TOP 10 vendedores que mais venderam (em quantidade) no mês com maior número de vendas no Olist

WITH tb_mes AS (

  -- IDENTIFICA MES COM MAIS VENDAS
  SELECT DATE(date_trunc('MONTH', dtPedido)) AS dtMonth
  FROM silver.olist.pedido
  GROUP BY dtMonth
  ORDER BY COUNT(DISTINCT idPedido) DESC
  LIMIT 1 

)

SELECT t2.idVendedor,
       COUNT(*) AS qtdItens

FROM silver.olist.pedido AS t1

INNER JOIN silver.olist.item_pedido AS t2
ON t1.idPedido = t2.idPedido

WHERE date_trunc('MONTH', t1.dtPedido) = (SELECT * FROM tb_mes)

GROUP BY t2.idVendedor

ORDER BY qtdItens DESC

LIMIT 10





-- COMMAND ----------

-- Total de vendas históricas (independente da categoria) dos vendedores que venderam ao menos um produto da categoria bebes na blackfriday de 2017-11-01

WITH tb_vendedores AS (

  -- VENDEDORES QUE VENDERAM CAT BEBES NA BF (2017)
  SELECT DISTINCT t2.idVendedor
  FROM silver.olist.pedido as t1
  
  INNER JOIN silver.olist.item_pedido as t2
  ON t1.idPedido = t2.idPedido
  
  LEFT JOIN silver.olist.produto as t3
  ON t2.idProduto = t3.idProduto
  
  WHERE DATE(DATE_TRUNC('MONTH', dtPedido)) = '2017-11-01'
  AND t3.descCategoria = 'bebes'

)

SELECT idVendedor,
       COUNT(DISTINCT idPedido) AS qtdPedido

FROM silver.olist.item_pedido

WHERE idVendedor in (SELECT * FROM tb_vendedores)

GROUP BY idVendedor

ORDER BY qtdPedido DESC

-- COMMAND ----------

WITH tb_vendedores_bf_bebes AS (

  SELECT DISTINCT t2.idVendedor
  FROM silver.olist.pedido as t1
  INNER JOIN silver.olist.item_pedido as t2
  ON t1.idPedido = t2.idPedido
  LEFT JOIN silver.olist.produto as t3
  ON t2.idProduto = t3.idProduto
  WHERE DATE(DATE_TRUNC('MONTH', dtPedido)) = '2017-11-01'
  AND t3.descCategoria = 'bebes'

)

SELECT t1.idVendedor,
       COUNT(DISTINCT t1.idPedido) AS qtdPedido

FROM silver.olist.item_pedido AS t1

INNER JOIN tb_vendedores_bf_bebes AS t2
ON t1.idVendedor = t2.idVendedor

GROUP BY t1.idVendedor

ORDER BY qtdPedido DESC
