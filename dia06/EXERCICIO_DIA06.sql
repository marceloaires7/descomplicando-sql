-- Databricks notebook source
-- DBTITLE 1,Quais são os Top 5 vendedores campeões de vendas de cada UF?
-- 1. Quais são os Top 5 vendedores campeões de vendas de cada UF?

WITH tb_venda AS (

  SELECT
        t1.idVendedor,
        descUF,
        SUM(t1.vlPreco) AS receitaVendedor,
        COUNT(*) AS qtdVendaItens,
        COUNT(DISTINCT t1.idPedido) AS qtdVendaPedido

  FROM silver.olist.item_pedido AS t1

  INNER JOIN silver.olist.vendedor AS t2
  ON t1.idVendedor = t2.idVendedor

  GROUP BY t1.idVendedor, descUF
  
)

SELECT 
       row_number() OVER (PARTITION BY descUF ORDER BY qtdVendaItens DESC) as rnItens,
       *,
       row_number() OVER (PARTITION BY descUF ORDER BY receitaVendedor DESC) as rnReceita,
       row_number() OVER (PARTITION BY descUF ORDER BY qtdVendaPedido DESC) as rnPedidosUnico

FROM tb_venda

QUALIFY rnItens <= 5

ORDER BY descUF DESC, rnItens

-- COMMAND ----------

-- DBTITLE 1,Quais são os Top 5 vendedores campeões de vendas em cada categoria?
-- 2. Quais são os Top 5 vendedores campeões de vendas em cada categoria?

WITH tb_pedidos_vendedor AS (

  SELECT
        idVendedor,
        descCategoria,
        SUM(vlPreco) AS receitaVendedor,
        COUNT(*) AS qtdVendaItens,
        COUNT(DISTINCT idPedido) AS qtdVendaPedido

  FROM silver.olist.item_pedido AS t1

  INNER JOIN silver.olist.produto AS t2
  ON t1.idProduto = t2.idProduto

  WHERE t2.descCategoria IS NOT NULL

  GROUP BY t1.idVendedor, t2.descCategoria
  
)

SELECT 
       row_number() OVER (PARTITION BY descCategoria ORDER BY qtdVendaItens DESC) as rnPedidos,
       *

FROM tb_pedidos_vendedor

QUALIFY rnPedidos <= 5

ORDER BY descCategoria

-- COMMAND ----------

-- DBTITLE 1,Qual é a Top 1 categoria de cada vendedor
-- 3. Qual é a Top 1 categoria de cada vendedor

WITH tb_pedidos_vendedor AS (

  SELECT
        t1.idVendedor,
        t2.descCategoria,
        SUM(vlPreco) AS receitaVendedor,
        COUNT(*) AS qtdVendaItens,
        COUNT(DISTINCT idPedido) AS qtdVendaPedido

  FROM silver.olist.item_pedido AS t1

  INNER JOIN silver.olist.produto AS t2
  ON t1.idProduto = t2.idProduto

  WHERE t2.descCategoria IS NOT NULL

  GROUP BY t1.idVendedor, t2.descCategoria
  
)

SELECT 
       row_number() OVER (PARTITION BY idVendedor ORDER BY qtdVendaItens DESC) as rnPedidos,
       *

FROM tb_pedidos_vendedor

QUALIFY rnPedidos = 1

ORDER BY qtdVendaItens DESC

-- COMMAND ----------

-- DBTITLE 1,Quais são as Top 2 categorias que mais vendem para clientes de cada estado?
-- 4. Quais são as Top 2 categorias que mais vendem para clientes de cada estado?

WITH tb_pedidos AS (

  SELECT t3.descUF,
         t4.descCategoria,
         SUM(vlPreco) AS receitaVendedor,
         COUNT(*) AS qtdVendaItens,
         COUNT(DISTINCT t1.idPedido) AS qtdVendaPedido

  FROM silver.olist.item_pedido AS t1

  INNER JOIN silver.olist.pedido AS t2
  ON t1.idPedido = t2.idPedido

  LEFT JOIN silver.olist.cliente AS t3
  ON t2.idCliente = t3.idCliente

  LEFT JOIN silver.olist.produto AS t4
  ON t1.idProduto = t4.idProduto

  WHERE t4.descCategoria IS NOT NULL

  GROUP BY t3.descUF, t4.descCategoria

)

SELECT 
       row_number() OVER (PARTITION BY descUF ORDER BY qtdVendaItens DESC) AS rnPedidos,
       *

FROM tb_pedidos

QUALIFY rnPedidos <= 2

ORDER BY descUF DESC

-- COMMAND ----------

-- DBTITLE 1,Quantidade acumulada de itens vendidos por categoria ao longo do tempo.
-- 5. Quantidade acumulada de itens vendidos por categoria ao longo do tempo.

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

-- DBTITLE 1,Receita acumulada por categoria ao longo do tempo
-- 6. Receita acumulada por categoria ao longo do tempo

WITH tb_receita_diaria AS (

  SELECT DATE(dtPedido) AS dataPedido,
         descCategoria,
         SUM(vlPreco) AS receitaVendedor,
         COUNT(*) AS qtdVendaItens,
         COUNT(DISTINCT t1.idPedido) AS qtdVendaPedido

  FROM silver.olist.item_pedido AS t1

  INNER JOIN silver.olist.pedido AS t2
  ON t1.idPedido = t2.idPedido

  LEFT JOIN silver.olist.produto AS t3
  ON t1.idProduto = t3.idProduto

  WHERE t3.descCategoria IS NOT NULL

  GROUP BY descCategoria, dataPedido
  ORDER BY descCategoria, dataPEdido
  
)

SELECT *,
       SUM(receitaVendedor) OVER (PARTITION BY descCategoria ORDER BY dataPedido) AS receitaAcum

FROM tb_receita_diaria

-- COMMAND ----------

-- DBTITLE 1,PLUS: Selecione um dia de venda aleatório de cada vendedor
-- 7. PLUS: Selecione um dia de venda aleatório de cada vendedor

WITH tb_dia_vendedor AS (

  SELECT DISTINCT t1.idVendedor,
         DATE(t2.dtPedido) AS dataPedido

  FROM silver.olist.item_pedido AS t1

  INNER JOIN silver.olist.pedido AS t2
  ON t1.idPedido = t2.idPedido
  
)

SELECT *,
       row_number() OVER (PARTITION BY idVendedor ORDER BY RAND()) AS rnVendedor

FROM tb_dia_vendedor

QUALIFY rnVendedor <= 2
