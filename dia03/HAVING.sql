-- Databricks notebook source
SELECT descCategoria,
       COUNT(DISTINCT idProduto) AS qtProduto,
       ROUND(AVG(vlPesoGramas) / 1000, 2) AS avgPesoKG

FROM silver.olist.produto

WHERE descCategoria IN ('bebes', 'perfumaria')
OR descCategoria LIKE '%moveis%'

GROUP BY descCategoria

HAVING qtProduto > 100
AND avgPesoKG > 1

ORDER BY avgPesoKG DESC
