-- Databricks notebook source
-- QUERY SP
(SELECT t2.idVendedor,
       t3.descUF,
       COUNT(t1.idPedido) AS contagem,
       SUM(t2.vlPreco) AS somaPreco

FROM silver.olist.pedido AS t1

INNER JOIN silver.olist.item_pedido AS t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.vendedor AS t3
ON t2.idVendedor = t3.idVendedor

WHERE YEAR(t1.dtPedido) = 2017
AND t3.descUF IN ('SP')

GROUP BY t2.idVendedor, t3.descUF

ORDER BY contagem DESC

LIMIT 5)

UNION ALL

-- QUERY RJ
(SELECT t2.idVendedor,
       t3.descUF,
       COUNT(t1.idPedido) AS contagem,
       SUM(t2.vlPreco) AS somaPreco

FROM silver.olist.pedido AS t1

INNER JOIN silver.olist.item_pedido AS t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.vendedor AS t3
ON t2.idVendedor = t3.idVendedor

WHERE YEAR(t1.dtPedido) = 2017
AND t3.descUF IN ('RJ')

GROUP BY t2.idVendedor, t3.descUF

ORDER BY contagem DESC

LIMIT 5)
