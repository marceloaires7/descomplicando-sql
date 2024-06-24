-- Databricks notebook source
-- DBTITLE 1,Somando dias
SELECT date_add('2023-01-01', 61) -- ano-mes-dia

-- COMMAND ----------

-- DBTITLE 1,Subtraindo dias
SELECT date_add('2023-01-01', -15)

-- COMMAND ----------

-- DBTITLE 1,Subtraindo dias
SELECT date_sub('2023-01-01', 15)

-- COMMAND ----------

-- DBTITLE 1,Navegando em meses
SELECT add_months('2023-01-01', -1)

-- COMMAND ----------

-- DBTITLE 1,Extraindo o ano
SELECT year('2023-01-01')

-- COMMAND ----------

-- DBTITLE 1,Extraindo o mês
SELECT month('2023-01-01')

-- COMMAND ----------

-- DBTITLE 1,Extraindo o dia
SELECT day('2023-01-01')

-- COMMAND ----------

-- DBTITLE 1,Extraindo o dia da semana
SELECT dayofweek('2023-01-01')

-- COMMAND ----------

-- DBTITLE 1,Diferença em dias
SELECT date_diff('2023-06-01', '2023-01-01')

-- COMMAND ----------

-- DBTITLE 1,Diferença em meses
SELECT months_between('2023-06-01', '2023-01-01')

-- COMMAND ----------

SELECT idPedido,
       idCliente,
       dtPedido,
       dtEntregue,
       datediff(dtEntregue, dtPedido) AS diasEntreEntregaPedido
FROM silver.olist.pedido
