-- Databricks notebook source
SELECT SUM((vlPreco)) / COUNT(vlPreco), -- média aritimética na mão
       AVG(vlPreco), -- média aritimética do preço
       MIN(vlPreco), -- mínimo de um campo do preço
       
       MAX(vlFrete), -- máximo de frete pago do frete
       STD(vlFrete), -- desvio padrão do frete
       percentile(vlFrete, 0.5), -- mediana do frete
       AVG(vlFrete) -- média aritimética do frete

FROM silver.olist.item_pedido


