-- Databricks notebook source
-- DBTITLE 1,Qual a nota (média, mínima e máxima) de cada vendedor que tiveram vendas no ano de 2017? E o percentual de pedidos avaliados com nota 5?
-- 1.  Qual a nota (média, mínima e máxima) de cada vendedor que tiveram vendas no ano de 2017? E o percentual de pedidos avaliados com nota 5?

WITH tb_pedidos AS (

  SELECT DISTINCT
         t1.idPedido,
         t2.idVendedor

  FROM silver.olist.pedido AS t1

  INNER JOIN silver.olist.item_pedido AS t2
  ON t1.idPedido = t2.idPedido

  WHERE YEAR(t1.dtPedido) = 2017

),

tb_avaliacoes AS (

  SELECT *,
         CASE WHEN vlNota = 5 THEN 1 ELSE 0 END AS flNota5
  FROM tb_pedidos AS t1

  INNER JOIN silver.olist.avaliacao_pedido AS t2
  ON t1.idPedido = t2.idPedido

)

SELECT idVendedor,
       AVG(vlNota) AS avgNota,
       MIN(vlNota) AS minNota,
       MAX(vlNota) AS maxNota,
       AVG(flNota5) AS avgNota5

FROM tb_avaliacoes

GROUP BY idVendedor

-- COMMAND ----------

-- DBTITLE 1,Calcule o valor do pedido médio, o valor do pedido mais caro e mais barato de cada vendedor que realizaram vendas entre 2017-01-01 e 2017-06-30.
-- 2. Calcule o valor do pedido médio, o valor do pedido mais caro e mais barato de cada vendedor que realizaram vendas entre 2017-01-01 e 2017-06-30.

WITH tb_pedido_receita AS (

  SELECT t2.idPedido,
         t2.idVendedor,
         SUM(t2.vlPreco) AS vlTotal

  FROM silver.olist.pedido AS t1

  INNER JOIN silver.olist.item_pedido AS t2
  ON t1.idPedido = t2.idPedido

  WHERE DATE(t1.dtPedido) >= '2017-01-01'
  AND DATE(t1.dtPedido) <= '2017-06-30'

  GROUP BY t2.idPedido, t2.idVendedor

),

tb_final AS (

  SELECT idVendedor,
        AVG(vlTotal) AS avgValorPedido,
        MIN(vlTotal) AS minValorPedido,
        MAX(vlTotal) AS maxValorPedido

  FROM tb_pedido_receita

  GROUP BY idVendedor

)

SELECT * FROM tb_final

-- COMMAND ----------

-- DBTITLE 1,Calcule a quantidade de pedidos por meio de pagamento que cada vendedor teve em seus pedidos entre 2017-01-01 e 2017-06-30.
-- 3. Calcule a quantidade de pedidos por meio de pagamento que cada vendedor teve em seus pedidos entre 2017-01-01 e 2017-06-30.

WITH tb_pedido_vendedor AS (

  SELECT DISTINCT
        t2.idPedido,
        t2.idVendedor

  FROM silver.olist.pedido AS t1

  INNER JOIN silver.olist.item_pedido AS t2
  ON t1.idPedido = t2.idPedido

  WHERE DATE(t1.dtPedido) >= '2017-01-01'
  AND DATE(t1.dtPedido) <= '2017-06-30'

),

tb_pedido_pagamento AS (

  SELECT t1.idVendedor,
         t1.idPedido,
         t2.descTipoPagamento

  FROM tb_pedido_vendedor AS t1

  LEFT JOIN silver.olist.pagamento_pedido AS t2
  ON t1.idPedido = t2.idPedido

)

SELECT idVendedor,
       descTipoPagamento,
       COUNT(DISTINCT idPedido) AS qtdPedido

FROM tb_pedido_pagamento

GROUP BY idVendedor, descTipoPagamento

ORDER BY idVendedor, descTipoPagamento

-- COMMAND ----------

-- 4. Combine a query do exercício 2 e 3 de tal forma, que cada linha seja um vendedor, e que haja colunas para cada meio de pagamento (com a quantidade de pedidos) e as colunas das estatísticas do pedido do exercício 2 (média, maior valor e menor valor).

WITH tb_creditcard AS (

  SELECT t1.idVendedor,
         t2.descTipoPagamento AS creditCard,
         COUNT(DISTINCT t1.idPedido) AS qtdCreditCard
  FROM silver.olist.item_pedido AS t1
  LEFT JOIN silver.olist.pagamento_pedido AS t2
  ON t1.idPedido = t2.idPedido
  LEFT JOIN silver.olist.pedido AS t3
  ON t1.idPedido = t3.idPedido
  WHERE t2.descTipoPagamento = 'credit_card'
  AND DATE(t3.dtPedido) >= '2017-01-01'
  AND DATE(t3.dtPedido) <= '2017-06-30'
  GROUP BY t1.idVendedor, t2.descTipoPagamento

),

tb_debitcard AS (

  SELECT t1.idVendedor,
         t2.descTipoPagamento AS debitCard,
         COUNT(DISTINCT t1.idPedido) AS qtdDebitCard
  FROM silver.olist.item_pedido AS t1
  LEFT JOIN silver.olist.pagamento_pedido AS t2
  ON t1.idPedido = t2.idPedido
  LEFT JOIN silver.olist.pedido AS t3
  ON t1.idPedido = t3.idPedido
  WHERE t2.descTipoPagamento = 'debit_card'
  AND DATE(t3.dtPedido) >= '2017-01-01'
  AND DATE(t3.dtPedido) <= '2017-06-30'
  GROUP BY t1.idVendedor, t2.descTipoPagamento

),

tb_boleto AS (

  SELECT t1.idVendedor,
         t2.descTipoPagamento AS boleto,
         COUNT(DISTINCT t1.idPedido) AS qtdBoleto
  FROM silver.olist.item_pedido AS t1
  LEFT JOIN silver.olist.pagamento_pedido AS t2
  ON t1.idPedido = t2.idPedido
  LEFT JOIN silver.olist.pedido AS t3
  ON t1.idPedido = t3.idPedido
  WHERE t2.descTipoPagamento = 'boleto'
  AND DATE(t3.dtPedido) >= '2017-01-01'
  AND DATE(t3.dtPedido) <= '2017-06-30'
  GROUP BY t1.idVendedor, t2.descTipoPagamento

),

tb_voucher AS (

  SELECT t1.idVendedor,
         t2.descTipoPagamento AS voucher,
         COUNT(DISTINCT t1.idPedido) AS qtdVoucher
  FROM silver.olist.item_pedido AS t1
  LEFT JOIN silver.olist.pagamento_pedido AS t2
  ON t1.idPedido = t2.idPedido
  LEFT JOIN silver.olist.pedido AS t3
  ON t1.idPedido = t3.idPedido
  WHERE t2.descTipoPagamento = 'voucher'
  AND DATE(t3.dtPedido) >= '2017-01-01'
  AND DATE(t3.dtPedido) <= '2017-06-30'
  GROUP BY t1.idVendedor, t2.descTipoPagamento

),

tb_valores AS (

  SELECT idVendedor,
         AVG(vlPreco) AS avgPreco,
         MAX(vlPreco) AS maxPreco,
         MIN(vlPreco) AS minPreco,
         COUNT(DISTINCT t1.idPedido) AS qtdPedidos
  FROM silver.olist.item_pedido AS t1
  LEFT JOIN silver.olist.pedido AS t2
  ON t1.idPedido = t2.idPedido
  WHERE DATE(t2.dtPedido) >= '2017-01-01'
  AND DATE(t2.dtPedido) <= '2017-06-30'
  GROUP BY idVendedor

),

tb_final AS (
  SELECT DISTINCT t2.idVendedor,
         t3.creditCard,
         t3.qtdCreditCard,
         t4.debitCard,
         t4.qtdDebitCard,
         t5.boleto,
         t5.qtdBoleto,
         t6.voucher,
         t6.qtdVoucher,
         t7.avgPreco,
         t7.minPreco,
         t7.maxPreco,
         t7.qtdPedidos

  FROM silver.olist.pedido AS t1

  INNER JOIN silver.olist.item_pedido AS t2
  ON t1.idPedido = t2.idPedido

  LEFT JOIN tb_creditcard AS t3
  ON t2.idVendedor = t3.idVendedor

  LEFT JOIN tb_debitcard AS t4
  ON t2.idVendedor = t4.idVendedor

  LEFT JOIN tb_boleto AS t5
  ON t2.idVendedor = t5.idVendedor

  LEFT JOIN tb_voucher AS t6
  ON t2.idVendedor = t6.idVendedor

  LEFT JOIN tb_valores AS t7
  ON t2.idVendedor = t7.idVendedor

  WHERE DATE(t1.dtPedido) >= '2017-01-01'
  AND DATE(t1.dtPedido) <= '2017-06-30' 
)

SELECT *

FROM tb_final

ORDER BY qtdPedidos DESC
