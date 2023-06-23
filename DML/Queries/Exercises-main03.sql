CREATE TABLE TAB_Cliente
(   CodCliente number(5) not null,
    NomeCliente varchar2(30) not null,
    Endereco varchar2(30),
    Cidade varchar2(20),
    CEP varchar2(10),
    UF char(2)
);

CREATE TABLE TAB_Vendedor
(   CodVendedor number(5) not null,
    NomeVendedor varchar2(30) not null,
    FaixaComissao number(4,2),
    Salario number(7,2)
);

CREATE TABLE TAB_Produto
(   CodProduto number(5) not null,
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

ALTER TABLE TAB_Cliente ADD CONSTRAINT PK_Cliente_CodCliente PRIMARY KEY(CodCliente);
ALTER TABLE TAB_Produto ADD CONSTRAINT PK_Produto_CodProduto PRIMARY KEY(CodProduto);
ALTER TABLE TAB_VENDEDOR ADD CONSTRAINT PK_Vendedor_CodVendedor PRIMARY KEY(CodVendedor);
ALTER TABLE TAB_PEDIDO ADD CONSTRAINT PK_Pedido_NumPedido PRIMARY KEY(NumPedido);
ALTER TABLE TAB_ItemPedido ADD CONSTRAINT  PK_ItemPedido_PedidoProd PRIMARY KEY(NumPedido,CodProduto);
select * from user_constraints order by table_name;

ALTER TABLE TAB_Pedido ADD CONSTRAINT FK_Pedido_CodCliente FOREIGN KEY (CodCliente) REFERENCES TAB_Cliente;
ALTER TABLE TAB_Pedido ADD CONSTRAINT FK_Pedido_CodVendedor FOREIGN KEY (CodVendedor) REFERENCES TAB_Vendedor;
ALTER TABLE TAB_ItemPedido ADD CONSTRAINT FK_ItemPedido_NumPedido FOREIGN KEY (NumPedido) REFERENCES TAB_Pedido;
ALTER TABLE TAB_ItemPedido ADD CONSTRAINT FK_ItemPedido_CodProduto FOREIGN KEY (CodProduto) REFERENCES TAB_Produto;
SELECT * FROM user_constraints

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

SELECT * FROM TAB_Cliente;
SELECT * FROM TAB_Vendedor;
SELECT * FROM TAB_Produto;
SELECT * FROM TAB_Pedido;
SELECT * FROM TAB_ITEMPedido;


ALTER TABLE TAB_Vendedor ADD DATANASC DATE;

ALTER TABLE TAB_Cliente ADD REGIAO varchar2(20);
ALTER TABLE TAB_Cliente MODIFY NOMECLIENTE varchar2(50);
ALTER TABLE TAB_Cliente DROP COLUMN REGIAO;

INSERT INTO TAB_Cliente VALUES (33, 'ANA MARIA ANTUNES', 'RUA TRODANI, 120', 'SOROCABA', '18035-400', 'SP', 'SP');

UPDATE TAB_Cliente 
SET CEP = '18035-400' 
WHERE CIDADE = 'Sorocaba';

UPDATE TAB_Produto 
SET ValorUnitario = ValorUnitario * 1.1
WHERE = 'KG';

DELETE TAB_Produto 
WHERE Unidade = 'LT' and ValorUnitario > 50.00;

SELECT NomeVendedor "NOME" FROM TAB_Vendedor;

SELECT Descricao, ValorUnitario, ValorUnitario * 1.1 FROM TAB_Produto;

SELECT NomeCliente FROM TAB_Cliente
WHERE Cidade = 'SOROCABA' AND NomeCliente LIKE '%SILVA';

SELECT NumPedido, PrazoEntrega FROM TAB_Pedido
WHERE PrazoEntrega BETWEEN '01/03/2021' AND '31/03/2021';

SELECT NumPedido, PrazoEntrega FROM TAB_Pedido
WHERE TO_CHAR PrazoEntrega(PrazoEntrega, 'YYYY') = '2020';

SELECT * FROM TAB_Produto
WHERE ValorUnitario > 100.00 AND ValorUnitario < 200.00;