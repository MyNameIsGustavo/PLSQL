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

CREATE TABLE TabLog
( 	datalog DATE,
	campo1 VARCHAR2(60),
	campo2 VARCHAR2(60)
);

CREATE TABLE TabErro
(	dataerro DATE,
	mensagem VARCHAR2(50)
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

INSERT INTO TAB_PEDIDO VALUES (8, to_date('23-05-2020', 'DD-MM-YYYY'), 32, 25);
INSERT INTO TAB_PEDIDO VALUES (9, to_date('21/02/2020', 'DD-MM-YYYY'), 32, 5);
INSERT INTO TAB_PEDIDO VALUES (10, to_date('20/02/2020', 'DD-MM-YYYY'), 30, 5);

INSERT INTO TAB_ItemPedido VALUES (7,11,1);
INSERT INTO TAB_ItemPedido VALUES (7,40,2);
INSERT INTO TAB_ItemPedido VALUES (7,42,1);
INSERT INTO TAB_ItemPedido VALUES (8,43,5);
INSERT INTO TAB_ItemPedido VALUES (9,12,1);
INSERT INTO TAB_ItemPedido VALUES (10,11,1);
INSERT INTO TAB_ItemPedido VALUES (10,43,1);
INSERT INTO TAB_ItemPedido VALUES (10,13,2);
INSERT INTO TAB_ItemPedido VALUES (8,40,1);

/* 	03. - Usando exceções pré-definidas pelo usuário. 
	Crie um procedimento que receba como parâmetro um código de produto e verifique se existem pedidos para ele.
	Se não existirem pedidos, excluir o produto da tabela de produto. Antes da exclusão, gravar uma linha na 
	tabela Tab_erro com as informações: data da exclusão, código do produto, descrição do produto.

	Tratar as exceções da forma:
	Criar uma exceção para tratar o erro em caso solicitação de exclusão de produtos que tenham pedido. 
	Neste caso, emitir mensagem “Erro, produto com pedidos associados” concatenado com o código do produto
	e encerrar o procedimento. Em caso de Produto inexistente, gravar na tabela Tab_Erro a mensagem de erro
	'Código	do produto inexistente' e o código do produto.
*/
CREATE OR REPLACE PROCEDURE SP_Pedidos(Pcodprod number) IS
	E_associados exception;
	vped number;
	vdesc tab_produto.descricao%type;
BEGIN

	SELECT descricao 
    INTO vdesc 
    FROM tab_produto WHERE codproduto = pcodprod; 
    
    --verificando se produto tem pedidos
	SELECT COUNT(*) 
    INTO vped 
    FROM tab_itempedido WHERE codproduto = pcodprod;

	IF vped = 0 THEN
    	INSERT INTO tablog VALUES(sysdate, pcodprod, vdesc);

	DELETE FROM tab_produto WHERE codproduto = pcodprod;

	ELSE 
    	raise E_associados;
	END IF;

	EXCEPTION
	WHEN no_data_found THEN 
    	INSERT INTO taberro VALUES (sysdate, 'Codigo do produto inexistente: ' || pcodprod);
	WHEN E_associados THEN
		raise_application_error(-20999, 'Erro, produto com pedidos associados ' || pcodprod);
END;

EXECUTE SP_comissao(99);
SELECT * FROM tab_erro;
SELECT * FROM tb_vendedor;

/*	04. - Escreva uma Stored Procedure que receba como parâmetro a unidade de venda de um produto (KG por exemplo)
	e altere em mais 10% o preço de todos os produtos com a unidade igual à passada como parâmetro.

	Gravar na tabela de log as informações: 
	Datalog: colocar sysdate Campo 1: a mensagem ‘PRODUTOS com preço modificado= ‘
	Campo2: o número de linhas que sofreram update
*/
CREATE OR REPLACE PROCEDURE SP_Unidade (Prod_Unidade tab_produto.unidade%type) IS 
  vnumlupdate number; 
BEGIN
	UPDATE tab_produto 
	SET valorunitario = valorunitario * 1.1
	WHERE unidade = Prod_Unidade;

	vnumlupdate := SQL%ROWCOUNT;

	INSERT INTO tablog VALUES(sysdate, 'Os produtos com preço alterado = ', vnumlupdate);
END;

EXECUTE SP_Unidade('KG');
SELECT * FROM tablog;
SELECT * FROM tab_produto WHERE unidade = 'KG';