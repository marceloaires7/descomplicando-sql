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

WITH tb_pedido_receita AS (

  SELECT t2.idPedido,
         t2.idVendedor,
         SUM(t2.vlPreco) AS vlReceita

  FROM silver.olist.pedido AS t1

  INNER JOIN silver.olist.item_pedido AS t2
  ON t1.idPedido = t2.idPedido

  WHERE DATE(t1.dtPedido) >= '2017-01-01'
  AND DATE(t1.dtPedido) <= '2017-06-30'

  GROUP BY t2.idPedido, t2.idVendedor

),

-- Tabela temporária do exercício 02
tb_sumario_pedido AS (

  SELECT idVendedor,
        AVG(vlReceita) AS avgValorPedido,
        MIN(vlReceita) AS minValorPedido,
        MAX(vlReceita) AS maxValorPedido

  FROM tb_pedido_receita

  GROUP BY idVendedor

),

-- Tabela temporária do exercício 03
tb_pedido_pagamento AS (

  SELECT t1.idVendedor,
         t2.descTipoPagamento,
         COUNT(DISTINCT t1.idPedido) AS qtdPedido

  FROM tb_pedido_receita AS t1

  LEFT JOIN silver.olist.pagamento_pedido AS t2
  ON t1.idPedido = t2.idPedido

  GROUP BY t1.idVendedor, t2.descTipoPagamento

  ORDER BY t1.idVendedor, t2.descTipoPagamento
),

tb_pagamento_coluna AS (

  SELECT idVendedor,
        SUM(CASE WHEN descTipoPagamento = 'boleto' THEN qtdPedido END) AS qtdBoleto,
        SUM(CASE WHEN descTipoPagamento = 'credit_card' THEN qtdPedido END) AS qtdCredit_card,
        SUM(CASE WHEN descTipoPagamento = 'voucher' THEN qtdPedido END) AS qtdVoucher,
        SUM(CASE WHEN descTipoPagamento = 'debit_card' THEN qtdPedido END) AS qtdDebit_card

  FROM tb_pedido_pagamento

  GROUP BY idVendedor

)

SELECT t1.*,
       qtdBoleto,
       qtdCredit_card,
       qtdVoucher,
       qtdDebit_card

FROM tb_sumario_pedido AS t1

LEFT JOIN tb_pagamento_coluna AS t2
ON t1.idVendedor = t2.idVendedor
