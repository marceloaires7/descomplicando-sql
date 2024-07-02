-- Databricks notebook source
-- DBTITLE 1,Qual categoria tem mais produtos vendidos?
-- 1. Qual categoria tem mais produtos vendidos?

SELECT t2.descCategoria,
       SUM(t1.idPedidoItem) AS quantProdutosVendidos

FROM silver.olist.item_pedido AS t1

INNER JOIN silver.olist.produto AS t2
ON t1.idProduto = t2.idProduto

GROUP BY t2.descCategoria

ORDER BY quantProdutosVendidos DESC

-- COMMAND ----------

-- DBTITLE 1,Qual categoria tem produtos mais caros, em média? E Mediana?
-- 2. Qual categoria tem produtos mais caros, em média? E Mediana?

SELECT t2.descCategoria,
       AVG(t1.vlPreco) AS mediaPreco,
       PERCENTILE(t1.vlPreco, .5) AS medianaPreco

FROM silver.olist.item_pedido AS t1

INNER JOIN silver.olist.produto AS t2
ON t1.idProduto = t2.idProduto

GROUP BY t2.descCategoria

ORDER BY medianaPreco DESC

-- COMMAND ----------

-- DBTITLE 1,Qual categoria tem maiores fretes, em média?
-- 3. Qual categoria tem maiores fretes, em média?

SELECT t2.descCategoria,
       AVG(t1.vlFrete) AS mediaFrete

FROM silver.olist.item_pedido AS t1

INNER JOIN silver.olist.produto AS t2
ON t1.idProduto = t2.idProduto

GROUP BY t2.descCategoria

ORDER BY mediaFrete DESC

-- COMMAND ----------

-- DBTITLE 1,Os clientes de qual estado pagam mais frete, em média?
-- 4. Os clientes de qual estado pagam mais frete, em média?

SELECT t3.descUF,
       AVG(t1.vlFrete) AS mediaFrete

FROM silver.olist.item_pedido AS t1

INNER JOIN silver.olist.pedido AS t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.cliente AS t3
ON t2.idCliente = t3.idCliente

GROUP BY t3.descUF

ORDER BY mediaFrete DESC

-- COMMAND ----------

-- DBTITLE 1,Clientes de quais estados avaliam melhor, em média? Proporção de 5?
-- 5. Clientes de quais estados avaliam melhor, em média? Proporção de 5?

SELECT t3.descUF,
       AVG(t1.vlNota) AS mediaNota

FROM silver.olist.avaliacao_pedido AS t1

LEFT JOIN silver.olist.pedido AS t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.cliente AS t3
ON t2.idCliente = t3.idCliente

GROUP BY t3.descUF

ORDER BY mediaNota DESC

-- COMMAND ----------

-- DBTITLE 1,Vendedores de quais estados têm as piores reputações?
-- 6. Vendedores de quais estados têm as piores reputações?

SELECT t3.descUF,
       AVG(t2.vlNota) AS mediaNota

FROM silver.olist.item_pedido AS t1

INNER JOIN silver.olist.avaliacao_pedido AS t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.vendedor AS t3
ON t1.idVendedor = t3.idVendedor

GROUP BY t3.descUF

ORDER BY mediaNota ASC

-- COMMAND ----------

-- DBTITLE 1,Quais estados de clientes levam mais tempo para a mercadoria chegar?
-- 7. Quais estados de clientes levam mais tempo para a mercadoria chegar?

SELECT t2.descUF,
       AVG(datediff(t1.dtEntregue, t1.dtEnvio)) AS mediaTempoEntrega

FROM silver.olist.pedido AS t1

INNER JOIN silver.olist.cliente AS t2
ON t1.idCliente = t2.idCliente

GROUP BY t2.descUF

ORDER BY mediaTempoEntrega DESC

-- COMMAND ----------

-- DBTITLE 1,Qual meio de pagamento é mais utilizado por clientes do RJ?
-- 8. Qual meio de pagamento é mais utilizado por clientes do RJ?

SELECT t3.descUF,
       t2.descTipoPagamento,
       COUNT(t2.descTipoPagamento) as qtdTipoPagamento

FROM silver.olist.pedido AS t1

INNER JOIN silver.olist.pagamento_pedido AS t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.cliente AS t3
ON t1.idCliente = t3.idCliente

WHERE t3.descUF IN ('RJ')

GROUP BY t2.descTipoPagamento, t3.descUF

ORDER BY qtdTipoPagamento DESC

-- COMMAND ----------

-- DBTITLE 1,Qual estado sai mais ferramentas?
-- 9. Qual estado sai mais ferramentas?

SELECT t3.descUF,
       COUNT(t3.descUF) AS qtdFerramentas

FROM silver.olist.item_pedido AS t1

INNER JOIN silver.olist.produto AS t2
ON t1.idProduto = t2.idProduto

LEFT JOIN silver.olist.vendedor AS t3
ON t1.idVendedor = t3.idVendedor

WHERE t2.descCategoria LIKE '%ferramenta%'

GROUP BY t3.descUF

ORDER BY qtdFerramentas DESC

-- COMMAND ----------

-- DBTITLE 1,Qual estado tem mais compras por cliente?
-- 10. Qual estado tem mais compras por cliente?

SELECT *

FROM silver.olist.cliente
