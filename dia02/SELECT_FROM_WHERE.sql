-- Databricks notebook source
-- DBTITLE 1,Filtros para produtos mais caros ou iguas a R$ 500
SELECT *

FROM silver.olist.item_pedido

WHERE vlPreco >= 500

-- COMMAND ----------

-- DBTITLE 1,Comparando valor frete e valor produto
SELECT *

FROM silver.olist.item_pedido

WHERE vlFrete > vlPreco

-- COMMAND ----------

-- DBTITLE 1,Preço maior que 100 e frete maior que preço
SELECT *

FROM silver.olist.item_pedido

WHERE vlPreco >= 100
AND vlFrete > vlPreco

-- COMMAND ----------

-- DBTITLE 1,Filtrando produtos de pte_shop, telefonias e bebes
SELECT *

FROM silver.olist.produto

WHERE descCategoria = 'pet_shop'
OR descCategoria = 'telefonia'
OR descCategoria = 'bebes'

-- COMMAND ----------

-- DBTITLE 1,Filtrando produtos de pte_shop, telefonias e bebes
SELECT *

FROM silver.olist.produto

WHERE descCategoria IN ('pet_shop', 'telefonia', 'bebes')

-- COMMAND ----------

-- DBTITLE 1,Pedidos de jan/2017
SELECT idPedido,
       idCliente,
       descSituacao,
       dtPedido

FROM silver.olist.pedido

WHERE date(dtPedido) >= '2017-01-01'
AND date(dtPedido) <= '2017-01-31'

-- COMMAND ----------

-- DBTITLE 1,Pedidos de jan/2017
SELECT *

FROM silver.olist.pedido

WHERE year(dtPedido) = 2017
AND month(dtPedido) = 1

-- COMMAND ----------

-- DBTITLE 1,Pedidos de jan/2017 ou jun/2017
SELECT *

FROM silver.olist.pedido

WHERE year(dtPedido) = 2017
AND (month(dtPedido) = 1
OR month(dtPedido) = 6)

-- COMMAND ----------

-- DBTITLE 1,Operações matemáticas e suas ordens
SELECT 10 * (100 + 2)

-- COMMAND ----------

-- DBTITLE 1,Pedidos de jan/2017 ou jun/2017
SELECT *

FROM silver.olist.pedido

WHERE year(dtPedido) = 2017
AND month(dtPedido) IN (1, 6)
