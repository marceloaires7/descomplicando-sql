-- Databricks notebook source
-- DBTITLE 1,Qual categoria tem mais produtos vendidos?
-- 1. Qual categoria tem mais produtos vendidos?

SELECT t2.descCategoria,
       COUNT(*) AS qtdCategoria,
       COUNT(DISTINCT t1.idPedido) AS qtdPedidos

FROM silver.olist.item_pedido AS t1

LEFT JOIN silver.olist.produto AS t2
ON t1.idProduto = t2.idProduto

GROUP BY t2.descCategoria

ORDER BY qtdCategoria DESC

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Qual categoria tem produtos mais caros, em média? E Mediana?
-- 2. Qual categoria tem produtos mais caros, em média? E Mediana?

SELECT t2.descCategoria,
       AVG(t1.vlPreco) AS avgPreco,
       PERCENTILE(t1.vlPreco, .5) AS medianPreco

FROM silver.olist.item_pedido AS t1

LEFT JOIN silver.olist.produto AS t2
ON t1.idProduto = t2.idProduto

GROUP BY t2.descCategoria

ORDER BY avgPreco DESC

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Qual categoria tem maiores fretes, em média?
-- 3. Qual categoria tem maiores fretes, em média?

SELECT t2.descCategoria,
       AVG(t1.vlFrete) AS avgFrete

FROM silver.olist.item_pedido AS t1

INNER JOIN silver.olist.produto AS t2
ON t1.idProduto = t2.idProduto

GROUP BY t2.descCategoria

ORDER BY avgFrete DESC

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Os clientes de qual estado pagam mais frete, em média?
-- 4. Os clientes de qual estado pagam mais frete, em média?

SELECT t3.descUF,
       SUM(t1.vlFrete) / COUNT(DISTINCT t1.idPedido) AS avgFrete,
       AVG(t1.vlFrete) AS avgFreteItem,
       SUM(t1.vlFrete) / COUNT(DISTINCT t2.idCliente) AS avgFreteCliente

FROM silver.olist.item_pedido AS t1

INNER JOIN silver.olist.pedido AS t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.cliente AS t3
ON t2.idCliente = t3.idCliente

GROUP BY t3.descUF

ORDER BY avgFrete DESC

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Clientes de quais estados avaliam melhor, em média? Proporção de 5?
-- 5. Clientes de quais estados avaliam melhor, em média? Proporção de 5?

SELECT t3.descUF,
       AVG(t1.vlNota) AS avgNota,
       AVG(CASE WHEN t1.vlNota = 5 THEN 1 ELSE 0 END) AS prop5

FROM silver.olist.avaliacao_pedido AS t1

INNER JOIN silver.olist.pedido AS t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.cliente AS t3
ON t2.idCliente = t3.idCliente

GROUP BY t3.descUF

ORDER BY prop5 DESC

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Vendedores de quais estados têm as piores reputações?
-- 6. Vendedores de quais estados têm as piores reputações?

SELECT t3.descUF,
       AVG(t1.vlNota) AS avgNota

FROM silver.olist.avaliacao_pedido AS t1

INNER JOIN silver.olist.item_pedido AS t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.vendedor AS t3
ON t2.idVendedor = t3.idVendedor

GROUP BY t3.descUF

ORDER BY avgNota ASC

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Quais estados de clientes levam mais tempo para a mercadoria chegar?
-- 7. Quais estados de clientes levam mais tempo para a mercadoria chegar?

SELECT t2.descUF,
       AVG(datediff(t1.dtEntregue, t1.dtPedido)) AS avgTempoEntrega

FROM silver.olist.pedido AS t1

LEFT JOIN silver.olist.cliente AS t2
ON t1.idCliente = t2.idCliente

WHERE t1.dtEntregue IS NOT NULL

GROUP BY t2.descUF

ORDER BY avgTempoEntrega DESC

-- COMMAND ----------

-- DBTITLE 1,Qual meio de pagamento é mais utilizado por clientes do RJ?
-- 8. Qual meio de pagamento é mais utilizado por clientes do RJ?

SELECT t3.descUF,
       t1.descTipoPagamento,
       COUNT(DISTINCT t1.idPedido) as qtdTipoPagamento

FROM silver.olist.pagamento_pedido AS t1

INNER JOIN silver.olist.pedido AS t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.cliente AS t3
ON t2.idCliente = t3.idCliente

WHERE t3.descUF IN ('RJ')

GROUP BY t1.descTipoPagamento, t3.descUF

ORDER BY qtdTipoPagamento DESC

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Qual estado sai mais ferramentas?
-- 9. Qual estado sai mais ferramentas?

SELECT t3.descUF,
       COUNT(*) AS qtdProdutoVendido

FROM silver.olist.item_pedido AS t1

LEFT JOIN silver.olist.produto AS t2
ON t1.idProduto = t2.idProduto

LEFT JOIN silver.olist.vendedor AS t3
ON t1.idVendedor = t3.idVendedor

WHERE t2.descCategoria LIKE '%ferramenta%'

GROUP BY t3.descUF

ORDER BY qtdProdutoVendido DESC

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Qual estado tem mais compras por cliente?
-- 10. Qual estado tem mais compras por cliente?

SELECT t2.descUF,
       COUNT(DISTINCT t1.idPedido) as qtdPedido,
       COUNT(DISTINCT t2.idClienteUnico) as qtdCliente,
       qtdPedido / qtdCliente as avgPedidoCliente

FROM silver.olist.pedido as t1

INNER JOIN silver.olist.cliente as t2
ON t1.idCliente = t2.idCliente

GROUP BY t2.descUF

ORDER BY avgPedidoCliente DESC

-- COMMAND ----------

SELECT t1.idVendedor,
       COUNT(t1.idVendedor)

FROM silver.olist.item_pedido as t1

INNER JOIN silver.olist.produto as t2
ON t1.idProduto = t2.idProduto

LEFT JOIN silver.olist.vendedor as t3
ON t1.idVendedor = t3.idVendedor

WHERE t2.descCategoria = 'pcs'

GROUP BY t1.idVendedor
