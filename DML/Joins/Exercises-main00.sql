CREATE TABLE TAB_Cliente
(   CodCliente number(5) NOT NULL,
    NomeCliente varchar2(30) NOT NULL,
    Endereco varchar2(30),
    Cidade varchar2(20),
    CEP varchar2(10),
    UF char(2)
);

CREATE TABLE TAB_Vendedor
(   CodVendedor number(5) NOT NULL,
    NomeVendedor varchar2(30) NOT NULL,
    FaixaComissao number(4,2),
    Salario number(7,2)
);

CREATE TABLE TAB_Produto
(   CodProduto number(5) NOT NULL,
    Descricao varchar(30),
    Unidade char(2),
    ValorUnitario number(6,2)
);

CREATE TABLE TAB_Pedido
(   NumPedido number(5) NOT NULL,
    PrazoEntrega date,
    CodCliente number(5),
    CodVendedor number(5)
);

CREATE TABLE TAB_ItemPedido
(   NumPedido number(5) NOT NULL,
    CodProduto number(5) NOT NULL,
    Quantidade number(5)
);


ALTER TABLE TAB_Cliente ADD PRIMARY KEY(CodCliente);
ALTER TABLE TAB_Produto ADD PRIMARY KEY(CodProduto);
ALTER TABLE TAB_VENDEDOR ADD PRIMARY KEY(CodVendedor);
ALTER TABLE TAB_PEDIDO ADD PRIMARY KEY(NumPedido);
ALTER TABLE TAB_ItemPedido ADD PRIMARY KEY(NumPedido,CodProduto);


ALTER TABLE TAB_Pedido ADD FOREIGN KEY (CodCliente) REFERENCES TAB_Cliente;
ALTER TABLE TAB_Pedido ADD FOREIGN KEY (CodVendedor) REFERENCES TAB_Vendedor;
ALTER TABLE TAB_ItemPedido ADD FOREIGN KEY (NumPedido) REFERENCES TAB_Pedido;
ALTER TABLE TAB_ItemPedido ADD FOREIGN KEY (CodProduto) REFERENCES TAB_Produto;

INSERT INTO TAB_Vendedor VALUES (5,'Antonio Pedro',5.0,400);
INSERT INTO TAB_Vendedor VALUES (15,'Carlos Sola',0.0,400);
INSERT INTO TAB_Vendedor VALUES (25,'Ana Carolina',1.0,200);
INSERT INTO TAB_Vendedor VALUES (35,'Solange Almeida',1.0,300);

INSERT INTO TAB_Cliente VALUES (30, 'João da Silva', 'AV. MATT HOFFMANN, 1100', 'SÃO PAULO', '97056-001', 'SP');
INSERT INTO TAB_Cliente VALUES (31, 'LUCAS ANTUNES', 'RUA TRODANI, 120', 'SOROCABA', '19658-023', 'SP');
INSERT INTO TAB_Cliente VALUES (32, 'LAURA STRAUSS', 'RUA TULIPAS, 650', 'PRIMAVERA', '18556-025', 'SP');

INSERT INTO TAB_Produto VALUES (11, 'Apple Watch', 'UN', 975.99);
INSERT INTO TAB_Produto VALUES (12, 'IPAD', 'UN', 999.70);
INSERT INTO TAB_Produto VALUES (13, 'PÓ PARA TONER', 'KG', 85.60);
INSERT INTO TAB_Produto VALUES (14, 'Mouse', 'UN', 45.60);
INSERT INTO TAB_Produto VALUES (15, 'Caneta digital', 'UN', 100.00);
INSERT INTO TAB_Produto VALUES (40,'Mouse sem fio', 'UN', 68.90);
INSERT INTO TAB_Produto VALUES (42,'FIO HDMI', 'UN', 18.00);
INSERT INTO TAB_Produto VALUES (43,'Pendrive Star Wars', 'UN', 48.00);
INSERT INTO TAB_Produto VALUES (44,'Mouse com fio', 'UN', 28.00);
INSERT INTO TAB_Produto VALUES (45,'Pendrive do Mickey', 'UN', 50.00);

INSERT INTO TAB_PEDIDO VALUES (7, '26/02/2020', 31, 15);
INSERT INTO TAB_PEDIDO VALUES (8, '23/05/2020', 32, 25);
INSERT INTO TAB_PEDIDO VALUES (9, '21/02/2020', 32, 5);
INSERT INTO TAB_PEDIDO VALUES (10, '20/02/2020', 30, 5);

INSERT INTO TAB_ItemPedido VALUES (7,11,1);
INSERT INTO TAB_ItemPedido VALUES (7,40,2);
INSERT INTO TAB_ItemPedido VALUES (7,42,1);
INSERT INTO TAB_ItemPedido VALUES (8,43,5);
INSERT INTO TAB_ItemPedido VALUES (9,12,1);
INSERT INTO TAB_ItemPedido VALUES (10,11,1);
INSERT INTO TAB_ItemPedido VALUES (10,43,1);
INSERT INTO TAB_ItemPedido VALUES (10,13,2);
INSERT INTO TAB_ItemPedido VALUES (8,40,1);

-- Junções - Exercícios.
-- 01. Listar o código e o nome dos vendedores que efetuaram vendas para o cliente com código 30:
SELECT TAB_Vendedor.CodVendedor, TAB_Vendedor.NomeVendedor 
FROM TAB_Vendedor
INNER JOIN TAB_Pedido ON TAB_Vendedor.CodVendedor = TAB_Pedido.CodVendedor
WHERE TAB_Pedido.CodCliente = 30;

-- 02. Listar o número do pedido, prazo de entrega, a quantidade e a descrição do produto com código 11:
SELECT TAB_Pedido.NumPedido, TAB_Pedido.PrazoEntrega, TAB_ItemPedido.Quantidade, TAB_Produto.Descricao 
FROM TAB_ItemPedido
INNER JOIN TAB_Pedido ON TAB_ItemPedido.NumPedido = TAB_Pedido.NumPedido
INNER JOIN TAB_Produto ON TAB_ItemPedido.CodProduto = TAB_Produto.CodProduto
WHERE TAB_ItemPedido.CodProduto = 11;

-- 03. Quais os vendedores (código e nome) fizeram pedidos para o cliente 'João da Silva':
SELECT TAB_Vendedor.CodVendedor, TAB_Vendedor.NomeVendedor 
FROM TAB_Pedido
INNER JOIN TAB_Vendedor ON TAB_Pedido.CodVendedor = TAB_Vendedor.CodVendedor
INNER JOIN TAB_Cliente ON TAB_Pedido.CodCliente = TAB_Cliente.CodCliente
WHERE TAB_Cliente.NomeCliente = 'João da Silva';

-- 04. Listar o número do pedido, o código do produto, a descrição do produto, o código do vendedor, o nome do vendedor , o nome do cliente, para todos os clientes que moram em Sorocaba:
SELECT TAB_Pedido.NumPedido, TAB_Produto.CodProduto, TAB_Produto.Descricao, TAB_Vendedor.CodVendedor, TAB_Vendedor.NomeVendedor, TAB_Cliente.NomeCliente
FROM TAB_Pedido
INNER JOIN TAB_Cliente ON TAB_Pedido.CodCliente = TAB_Cliente.CodCliente
INNER JOIN TAB_Vendedor ON TAB_Pedido.CodVendedor = TAB_Vendedor.CodVendedor
INNER JOIN TAB_ItemPedido ON TAB_Pedido.NumPedido = TAB_ItemPedido.NumPedido
INNER JOIN TAB_Produto ON TAB_ItemPedido.CodProduto = TAB_Produto.CodProduto
WHERE TAB_Cliente.Cidade = 'SOROCABA';

-- 05. Listar o código do produto, a descrição, a quantidade pedida e o prazo de entrega para o pedido número 123:
SELECT TAB_Produto.CodProduto, TAB_Produto.Descricao, TAB_ItemPedido.Quantidade, TAB_Pedido.PrazoEntrega
from TAB_Pedido
INNER JOIN TAB_ItemPedido ON TAB_Pedido.NumPedido = TAB_ItemPedido.NumPedido
INNER JOIN TAB_Produto ON TAB_ItemPedido.CodProduto = TAB_Produto.CodProduto
WHERE TAB_Pedido.NumPedido = 7;

-- 06. Quais os cliente ( nome e endereço) da cidade de Itu ou Sorocaba tiveram seus pedidos tirados com o vendedor de código igual a 10:
SELECT TAB_Cliente.NomeCliente, TAB_Cliente.Endereco 
FROM TAB_Cliente
INNER JOIN TAB_Pedido ON TAB_Cliente.CodCliente = TAB_Pedido.CodCliente
WHERE TAB_Pedido.CodVendedor = 15 AND TAB_Cliente.Cidade ='SOROCABA' OR TAB_Cliente.Cidade='ITU';

-- 07. Listar o código do cliente, nome do cliente e o total de pedidos que cada um realizou:
SELECT TAB_Cliente.CodCliente, TAB_Cliente.NomeCliente, count(TAB_Pedido.CodCliente)
FROM TAB_Pedido
INNER JOIN TAB_Cliente ON TAB_Cliente.CodCliente = TAB_Pedido.CodCliente
GROUP BY TAB_Cliente.CodCliente, TAB_Cliente.NomeCliente;