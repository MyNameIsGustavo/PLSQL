CREATE TABLE tb_cliente( 
  	codcliente number(5) NOT NULL,
  	nomecliente varchar2(30) NOT NULL,
  	endereco varchar2(30),
 	cidade varchar2(20),
  	cep varchar2(10),
  	uf char(2)
);

CREATE TABLE tb_vendedor( 
  	codvendedor number(5) NOT NULL,
  	nomevendedor varchar2(30) NOT NULL,
  	faixa_com    number(4,2),
  	salario_fixo number(7,2)
);

CREATE TABLE tb_produto( 
	codproduto   number(5) NOT NULL,
  	descricao varchar(20),
  	unid       char(2),
  	valor_unit number(6,2)
);

CREATE TABLE TB_PEDIDO( 
  	NUMPEDIDO     number(5) NOT NULL,
  	PRAZO_ENTREGA DATE,
  	CODCLIENTE     number(5),
  	CODVENDEDOR   number(5)
);

CREATE TABLE TB_ITEM_PEDIDO(
	NUMPEDIDO   number(5) NOT NULL,
 	CODPRODUTO  number(5) NOT NULL,
 	QTDE        number(5)
);

ALTER TABLE TB_CLIENTE ADD CONSTRAINT PK_CLIENTE_CODCLIENTE PRIMARY KEY(CODCLIENTE);
ALTER TABLE TB_PRODUTO ADD CONSTRAINT PK_PRODUTO_CODPRODUTO PRIMARY KEY(CODPRODUTO);
ALTER TABLE TB_VENDEDOR ADD CONSTRAINT PK_VENDEDOR_CODVENDEDOR PRIMARY KEY(CODVENDEDOR);
ALTER TABLE TB_PEDIDO ADD CONSTRAINT PK_PEDIDO_NUMPEDIDO PRIMARY KEY(NUMPEDIDO);
ALTER TABLE TB_ITEM_PEDIDO ADD CONSTRAint  PK_ITEMPEDIDO_PEDPROD PRIMARY KEY(NUMPEDIDO,CODPRODUTO);

ALTER TABLE TB_PEDIDO ADD CONSTRAINT FK_PEDIDO_CODCLI FOREIGN KEY(CODCLIENTE) REFERENCES TB_CLIENTE;
ALTER TABLE TB_PEDIDO ADD CONSTRAINT FK_PEDIDO_CODVENDEDOR FOREIGN KEY(CODVENDEDOR) REFERENCES TB_VENDEDOR;

ALTER TABLE TB_ITEM_PEDIDO ADD CONSTRAINT FK_ITEMPEDIDO_NUMPEDIDO FOREIGN KEY(NUMPEDIDO) REFERENCES TB_PEDIDO;
ALTER TABLE TB_ITEM_PEDIDO ADD CONSTRAINT FK_ITEMPEDIDO_CODPRODUTO FOREIGN KEY(CODPRODUTO) REFERENCES TB_PRODUTO;

INSERT INTO TB_vendedor VALUES (5,'Antonio Pedro', 5.0, 400);
INSERT INTO TB_vendedor VALUES (15,'Carlos Sola', 0.0, 400);
INSERT INTO tb_vendedor VALUES (25,'Ana Carolina', 1.0, 200);
INSERT INTO TB_vendedor VALUES (35,'Solange Almeida', 1.0, 300);

INSERT INTO TB_CLIENTE VALUES (30, 'João da Silva', 'AV. MATT HOFFMANN, 1100', 'SÃO PAULO', '97056-001', 'SP');
INSERT INTO TB_CLIENTE VALUES (31, 'LUCAS ANTUNES', 'RUA TRODANI, 120', 'SOROCABA', '19658-023', 'SP');
INSERT INTO Tb_CLIENTE VALUES (32, 'LAURA STRAUSS', 'RUA TULIPAS, 650', 'PRIMAVERA', '18556-025', 'SP');

INSERT INTO TB_PRODUTO VALUES (11, 'APPLE DISPLAY', 'UN', 975.99);
INSERT INTO TB_PRODUTO VALUES (12, 'IBM THINK PAD R61', 'UN', 999.70);
INSERT INTO TB_PRODUTO VALUES (13, 'PÓ PARA TONER', 'KG', 85.60);

INSERT INTO TB_PEDIDO VALUES (7, to_date('26-02-2019', 'DD-MM-YYYY'), 31, 15);
INSERT INTO TB_PEDIDO VALUES (8, to_date('23/05/2019', 'DD-MM-YYYY'), 32, 25);
INSERT INTO TB_PEDIDO VALUES (9, to_date('21/02/2019', 'DD-MM-YYYY'), 32, 5);
INSERT INTO TB_PEDIDO VALUES (10, to_date('20/02/2019', 'DD-MM-YYYY'), 30, 5);

INSERT INTO TB_ITEM_PEDIDO VALUES (7, 11, 3);
INSERT INTO TB_ITEM_PEDIDO VALUES (7, 12, 3);

INSERT INTO TB_ITEM_PEDIDO VALUES (8, 13, 3);
INSERT INTO TB_ITEM_PEDIDO VALUES (9, 11, 3);
INSERT INTO TB_ITEM_PEDIDO VALUES (10, 11, 3);
INSERT INTO TB_ITEM_PEDIDO VALUES (10, 12, 3);
INSERT INTO TB_ITEM_PEDIDO VALUES (10, 13, 3);

-- 01. Listar todos os clientes que moram na mesma cidade que 'João da Silva'.
SELECT C.nomecliente FROM TB_Cliente C
WHERE C.nomecliente <> 'João da Silva' AND 
C.cidade = (SELECT  C.cidade FROM TB_Cliente C WHERE C.nomecliente = 'João da Silva');

-- 02.	Qual o nome dos vendedores que  tem o salário fixo  menor  que a média dos salários dos vendedores.
SELECT V.nomevendedor FROM TB_Vendedor V
WHERE V.salario_fixo < (SELECT AVG(V.salario_fixo) FROM TB_Vendedor V);

-- 03.	Quais os nomes dos clientes que só compraram com o vendedor com codigo 05 e com mais nenhum outro vendedor (fidelidade).
SELECT C.codcliente, C.nomecliente FROM TB_Pedido P 
INNER JOIN TB_Cliente C ON P.codcliente = C.codcliente
WHERE P.codvendedor = 5 AND C.codcliente NOT IN 
(SELECT P.codcliente FROM TB_Pedido P WHERE TP.codvendedor <> 5);
	
-- 04. Quais vendedores não fizeram mais de 2 pedidos.
SELECT V.codvendedor, V.nomevendedor FROM TB_Vendedor V
WHERE V.codvendedor NOT IN 
(SELECT P.codvendedor FROM TB_Pedido P GROUP BY P.codvendedor HAVING COUNT(*) > 2);

-- 05. Quais os vendedores não fizeram nenhum pedido no mês de maio/2019
-- USANDO NOT IN
SELECT V.nomevendedor FROM TB_Vendedor V
WHERE V.codvendedor NOT IN (SELECT P.codvendedor FROM TB_Pedido P
   			    WHERE prazo_entrega BETWEEN '01-05-2019' AND '31-05-2019');

-- USANDO NOT EXISTS

SELECT V.nomevendedor FROM TB_Vendedor V
(SELECT 1 FROM TB_Pedido P
WHERE prazo_entrega BETWEEN '01-05-2019' AND '31-05-2019' 
AND P.CodVendedor = V.CodVendedor);

-- 06.	Listar o nome do vendedor que mais fez pedidos.

SELECT P.codvendedor, V.nomevendedor, COUNT(*) FROM TB_pedido P 
INNER JOIN TB_vendedor V ON P.codvendedor = V.codvendedor
GROUP BY P.codvendedor, V.nomevendedor
HAVING COUNT(*) = (SELECT MAX (COUNT(*)) FROM TB_pedido P GROUP BY P.CODVENDEDOR)

-- 07.	Listar o nome dos clientes e o número total de pedidos associados a cada 
cliente em ordem decrescente de vendas, isto é do cliente que mais tem pedidos 
para o que menos tem.

SELECT P.codcliente, C.nomecliente, COUNT(*) AS TOTAL FROM TB_pedido P, TB_cliente C
WHERE P.codcliente = C.codcliente
GROUP BY P.codcliente, C.nomecliente
ORDER BY TOTAL DESC;

-- 08.	Excluir  todos os itens dos pedidos feitos pelo cliente de código = 31.

DELETE tb_item_pedido IP
WHERE IP.numpedido IN(SELECT P.numpedido FROM TB_pedido P WHERE P.codcliente = 31);

rollback;

-- 09.	Alterar o valor unitário de todos os produtos sem vendas no ano de 2020 para menos 20%.
    
UPDATE TB_produto P SET P.valor_unit = P.valor_unit * 0.8
WHERE P.codproduto NOT IN
( SELECT P.codproduto FROM TB_item_pedido IP, TB_pedido PE
WHERE IP.numpedido = PE.numpedido AND PE.prazo_entrega BETWEEN 
'01-01-2020' AND '31-12-2020');