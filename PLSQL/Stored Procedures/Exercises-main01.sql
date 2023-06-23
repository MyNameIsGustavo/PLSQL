-- Exercicio de Stored Procedure.

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

/*	01. Crie uma stored procedure que calcule o percentual de comissão para um vendedor
	cujo código é passado como parâmetro e realize:

	A) - Encontre a somatória do valor de todos os pedidos por vendedor;

	B) - Se a somatória for:
    	 > 0 e < 100.00 atribua a este vendedor um  percentual de comissão de 10%;
         >= 100.00 e <=1.000,00 atribua um percentual de 15%;
         > 1.000,00 atribua um percentual de 20%.

	C) - Se o vendedor não tiver nenhum pedido ( = 0) atribua um percentual de 0% e 
   		 atualizar este percentual na tabela de vendedor.

	Fazer o tratamento de erros.
*/
CREATE OR REPLACE PROCEDURE SP_CalcularComissao(Par_CodigoVendedor IN TAB_Vendedor.CodVendedor%TYPE) IS
    var_Somatoria NUMBER(5);
    var_Percentual TAB_Vendedor.FaixaComissao%TYPE;
    var_pedido NUMBER(2);
BEGIN
    SELECT SUM(ValorUnitario * Unidade)
    INTO var_Somatoria
    FROM TAB_Produto
    INNER JOIN TAB_ItemPedido ON TAB_ItemPedido.CodProduto = TAB_Produto.CodProduto
    INNER JOIN TAB_Pedido ON TAB_Pedido.NumPedido = TAB_ItemPedido.NumPedido
    WHERE TAB_Pedido.CodVendedor = Par_CodigoVendedor;

    SELECT COUNT(*) 
    INTO var_pedido 
    FROM TAB_Pedido 
    WHERE TAB_Pedido.CodVendedor = Par_CodigoVendedor;

	IF var_pedido = 0 THEN
		var_Percentual := 0;
        UPDATE TAB_Vendedor SET FaixaComissao = var_Percentual WHERE CodVendedor = Par_CodigoVendedor;
	END IF;

    IF var_Somatoria >= 0 AND var_Somatoria < 100 THEN
        var_Percentual := 0.10;
    ELSIF var_Somatoria >= 100 AND var_Somatoria <= 1000 THEN
        var_Percentual := 0.15;
    ELSE
        var_Percentual := 0.20;
    END IF;

    UPDATE TAB_Vendedor SET FaixaComissao = var_Percentual WHERE CodVendedor = Par_CodigoVendedor;
    COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO TabErro (DataErro, Mensagem) VALUES (SYSDATE, 'COD. vend nao existe');
END;

EXECUTE SP_CalculaComissao(25);
SELECT * FROM TAB_Vendedor;
SELECT * FROM TabErro;
SELECT * FROM TabLog;

/*	02. Crie um procedimento que receba como parâmetro um código de produto e verifique se existem pedidos para ele.
	Se não existirem pedidos para este produto, excluir o produto da tabela de produto. Antes da exclusão, gravar tabela 
	TabLog  com as informações: data da exclusão, código do produto, descrição do produto, id do usuário que excluiu.

	Utilizar exceptions para controlar erros associados ao select caso o codigo do produto não exista. Em caso de exception, 
	gravar na tabela Tab_erro o código do produto e a mensagem de erro 'Código do produto inexistente'.
*/

CREATE OR REPLACE PROCEDURE SP_VerificaProdutos(Par_CodigoProduto IN TAB_Produto.CodProduto%TYPE) IS
	var_CodigoProduto TAB_Produto.CodProduto%TYPE;
	var_DescricaoProduto TAB_Produto.Descricao%TYPE;
	var_NumPedidos number(5);
	var_ID varchar2(100);
BEGIN

	--Capturando o ID do usuario;
	SELECT username INTO var_ID 
    FROM user_users 
    WHERE user_id = user_id;

	--Capturando as informações do exercicio;
	SELECT COUNT(*) 
    INTO var_NumPedidos
    FROM TAB_ItemPedido 
    INNER JOIN TAB_Produto ON TAB_Produto.CodProduto = TAB_ItemPedido.CodProduto 
    WHERE TAB_Produto.CodProduto = Par_CodigoProduto;

	SELECT TAB_Produto.CodProduto, TAB_Produto.Descricao 
        INTO var_CodigoProduto, var_DescricaoProduto
        FROM TAB_Produto
        WHERE TAB_Produto.CodProduto = Par_CodigoProduto;

	IF var_NumPedidos > 0 THEN
    	DBMS_OUTPUT.PUT_LINE('Produto possui pedidos cadastrados. Não pode ser excluído.');
    ELSE
		INSERT INTO TabLog(datalog, campo1, campo2) VALUES (SYSDATE, var_CodigoProduto, var_DescricaoProduto);
		DELETE FROM TAB_Produto WHERE TAB_Produto.CodProduto = Par_CodigoProduto;
    END IF;
	COMMIT;

	EXCEPTION
        WHEN NO_DATA_FOUND THEN
        	INSERT INTO TabErro(dataerro, mensagem) VALUES (SYSDATE, 'Código do produto inexistente');
END;

EXECUTE SP_VerificaProdutos(11);
EXECUTE SP_VerificaProdutos(14);
EXECUTE SP_VerificaProdutos(46);

SELECT * FROM TabLog;
SELECT * FROM TabErro;