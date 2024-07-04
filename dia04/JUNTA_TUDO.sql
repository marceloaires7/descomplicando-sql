-- Databricks notebook source
-- DBTITLE 1,Quais são os vendedores de cada estado que tem +R$1000,00 em vendas durante o ano de 2017?
-- Quais são os vendedores de cada estado que tem +R$1000,00 em vendas durante o ano de 2017?

SELECT t2.idVendedor,
       t3.descUF,
       SUM(t2.vlPreco) AS totalVendido

FROM silver.olist.pedido AS t1

INNER JOIN silver.olist.item_pedido AS t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.vendedor AS t3
ON t2.idVendedor = t3.idVendedor

WHERE YEAR(dtPedido) = 2017

GROUP BY t2.idVendedor, t3.descUF

HAVING totalVendido >= 1000

ORDER BY t3.descUF, totalVendido DESC
