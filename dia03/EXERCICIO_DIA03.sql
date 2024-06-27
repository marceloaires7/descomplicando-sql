-- Databricks notebook source
-- DBTITLE 1,Qual pedido com maior valor de frete? E o menor?
-- 1. Qual pedido com maior valor de frete? E o menor?

SELECT idPedido,
       ROUND(SUM(vlFrete), 2) AS totalFrete

FROM silver.olist.item_pedido

GROUP BY idPedido

ORDER BY totalFrete DESC -- DESC(maior) ou ASC(menor)

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Qual vendedor tem mais pedidos?
-- 2. Qual vendedor tem mais pedidos?

SELECT DISTINCT idVendedor,
       count(DISTINCT idPedido) AS qtPedido

FROM silver.olist.item_pedido

GROUP BY idVendedor

ORDER BY qtPedido DESC

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Qual vendedor tem mais itens vendidos? E o com menos?
-- 3. Qual vendedor tem mais itens vendidos? E o com menos?

SELECT idVendedor,
       COUNT(idProduto) AS maisItensVendidos

FROM silver.olist.item_pedido

GROUP BY idVendedor

ORDER BY maisItensVendidos DESC -- DESC(maior) ou ASC(menor)

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Qual dia tivemos mais pedidos?
-- 4. Qual dia tivemos mais pedidos?

SELECT DATE(dtPedido) AS diaPedido,
       COUNT(DISTINCT idPedido) as qtPedido

FROM silver.olist.pedido

GROUP BY diaPedido

ORDER BY qtPedido DESC

LIMIT 1

-- COMMAND ----------

-- DBTITLE 1,Quantos vendedores são do estado de São Paulo?
-- 5. Quantos vendedores são do estado de São Paulo?

SELECT COUNT(DISTINCT idVendedor) as qtVendedorSP

FROM silver.olist.vendedor

WHERE descUF LIKE 'SP'

-- COMMAND ----------

-- DBTITLE 1,Quantos vendedores são de Presidente Prudente?
-- 6. Quantos vendedores são de Presidente Prudente?

SELECT COUNT(DISTINCT idVendedor) AS qtVendedorPresPrud

FROM silver.olist.vendedor

WHERE descCidade LIKE 'presidente prudente'

-- COMMAND ----------

-- DBTITLE 1,Quantos clientes são do estado do Rio de Janeiro
-- 7. Quantos clientes são do estado do Rio de Janeiro

SELECT COUNT(DISTINCT idClienteUnico) AS qtClienteRJ

FROM silver.olist.cliente

WHERE descUF LIKE 'RJ'

-- COMMAND ----------

-- DBTITLE 1,Quantos produtos são de construção?
-- 8. Quantos produtos são de construção?

SELECT COUNT(DISTINCT idProduto) AS qtProdConstrucao

FROM silver.olist.produto

WHERE descCategoria LIKE '%construcao%'

-- COMMAND ----------

-- DBTITLE 1,Qual o valor médio de um pedido? E do frete?
-- 9. Qual o valor médio de um pedido? E do frete?

SELECT SUM(vlPreco) / COUNT(DISTINCT idPedido) AS vlMedioPedido,
       SUM(vlFrete) / COUNT(DISTINCT idPedido) AS vlMedioFretePedido

FROM silver.olist.item_pedido

-- COMMAND ----------

-- DBTITLE 1,Em médio os pedidos são de quantas parcelas de cartão? E o valor médio por parcela?
-- 10. Em médio os pedidos são de quantas parcelas de cartão? E o valor médio por parcela?

SELECT AVG(nrParcelas) AS mediaParcelas,
       AVG(vlPagamento/nrParcelas) AS mediaVlParcelas

FROM silver.olist.pagamento_pedido

WHERE descTipoPagamento LIKE 'credit_card'

-- COMMAND ----------

-- DBTITLE 1,Quanto em tempo em média demora para um pedido chegar depois de aprovado?
-- 11. Quanto em tempo em média demora para um pedido chegar depois de aprovado?

SELECT AVG(datediff(dtEntregue, dtAprovado)) AS avgQtDias

FROM silver.olist.pedido

WHERE descSituacao LIKE 'delivered'

-- COMMAND ----------

-- DBTITLE 1,Qual estado tem mais vendedores?
-- 12. Qual estado tem mais vendedores?

SELECT descUF,
       COUNT(DISTINCT idVendedor) AS qtVendedor

FROM silver.olist.vendedor

GROUP BY descUF

ORDER BY qtVendedor DESC

LIMIT 5



-- COMMAND ----------

-- DBTITLE 1,Qual cidade tem mais clientes?
-- 13. Qual cidade tem mais clientes?

SELECT descCidade,
       COUNT(DISTINCT idClienteUnico) AS qtCliente

FROM silver.olist.cliente

GROUP BY descCidade

ORDER BY qtCliente DESC

LIMIT 5

-- COMMAND ----------

-- DBTITLE 1,Qual categoria tem mais itens?
-- 14. Qual categoria tem mais itens?

SELECT descCategoria,
       COUNT(DISTINCT idProduto) AS qtProduto

FROM silver.olist.produto

GROUP BY descCategoria

ORDER BY qtProduto DESC

LIMIT 5

-- COMMAND ----------

-- DBTITLE 1,Qual categoria tem maior peso médio de produto?
-- 15. Qual categoria tem maior peso médio de produto?

SELECT descCategoria,
       AVG(vlPesoGramas) AS pesoMedio

FROM silver.olist.produto

GROUP BY descCategoria

ORDER BY pesoMedio DESC

LIMIT 5

-- COMMAND ----------

-- DBTITLE 1,Qual a série histórica de pedidos por dia? E receita?
-- 16. Qual a série histórica de pedidos por dia? E receita?

SELECT DATE(dtPedido) AS diaPedido,
       COUNT(DISTINCT idPedido) as qtPedido

FROM silver.olist.pedido

GROUP BY diaPedido

ORDER BY diaPedido

-- COMMAND ----------

-- DBTITLE 1,Qual produto é o campeão de vendas? Em receita? Em quantidade?
-- 17. Qual produto é o campeão de vendas? Em receita? Em quantidade?

SELECT idProduto,
       COUNT(*) AS qtVendas,
       SUM(vlPreco) AS vlReceita

FROM silver.olist.item_pedido

GROUP BY idProduto

ORDER BY qtVendas DESC

LIMIT 5
