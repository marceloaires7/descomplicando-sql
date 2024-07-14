-- Databricks notebook source
DROP TABLE IF EXISTS sandbox.linuxtips.top5_pedido_marcelo;

CREATE TABLE IF NOT EXISTS sandbox.linuxtips.top5_pedido_marcelo
SELECT *
FROM silver.olist.pedido
ORDER BY RAND()
LIMIT 5
;

-- COMMAND ----------

SELECT * FROM sandbox.linuxtips.top5_pedido_marcelo

-- e481f51cbdc54678b7cc49136f2d6af7
-- 22a409aa094a6210e26006088a346124
-- a17bcc333f4e645ec9c31d9b75d1ed89
-- c77e47704d90425196c86d3e237dd9fa
