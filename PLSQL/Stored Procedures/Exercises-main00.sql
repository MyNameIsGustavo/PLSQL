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

-- 01. - Crie um procedimento de nome SP_Atraso que receba como parâmetro o número de um pedido. 
-- Obter o prazo de entrega deste pedido. Se o prazo de entrega for anterior a data atual(SYSDATE), 
-- obter o nome do vendedor deste pedido e gravar uma linha na TabLog com:

	-- Em datalog gravar o Prazo de entrega;
	-- Em campo 1 gravar o Nome do vendedor;
	-- Em campo 2 gravar a mensagem “Pedido em atraso. O vendedor deve avisar ao cliente”.

-- Utilizar exception para controlar erros associados ao select. 
-- Em caso de erro gravar na tabela TabErro o número do pedido concatenado com a 
-- mensagem de erro 'Número do Pedido inexistente'.

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE SP_Atraso(NumeroPedido IN TAB_Pedido.NumPedido%TYPE) IS	
--Definindo as variaveis locais com seus respectivos tipos;
	prazoEntrega TAB_Pedido.PrazoEntrega%type;
	nomeVendedor TAB_Vendedor.NomeVendedor%type;
BEGIN
	SELECT TAB_Pedido.PrazoEntrega, TAB_Vendedor.NomeVendedor
	INTO prazoEntrega, nomeVendedor
    
    FROM TAB_Pedido 
    INNER JOIN TAB_Vendedor ON TAB_Pedido.CodVendedor = TAB_Vendedor.CodVendedor
    WHERE TAB_Pedido.NumPedido = NumeroPedido;

	IF prazoEntrega < SYSDATE THEN
    -- Inserindo uma linha na tabela TABLOG com os dados necessários;
    	INSERT INTO TabLog(datalog, campo1, campo2) VALUES(prazoEntrega, nomeVendedor, 'Pedido em atraso. O vendedor deve avisar ao cliente!');
	
	END IF;
	COMMIT;

	EXCEPTION
        WHEN NO_DATA_FOUND THEN
        INSERT INTO TabErro(dataerro, mensagem)VALUES(SYSDATE, 'Numero de pedido: ' || NumeroPedido || ' [inexistente]');
END;

EXECUTE SP_Atraso(10);
    
SELECT * FROM TabLog;
SELECT * FROM TabErro;

-- 02. - Escreva uma Stored Procedure de nome "SP_ClientePremium" que receba como parâmetro o código de um cliente.
-- Se este possuir mais que 2 pedidos com prazo de entrega nos próximos 2 meses.
-- Gravar na tabela TABLOG:
	-- Em datalog gravar a data do sistema.
	-- Em campo1 gravar a mensagem 'Cliente especial - enviar brinde'.
	-- Em campo2 gravar o código do cliente concatenado com o nome do cliente.
	-- Fazer o tratamento de exceções.

--Inserindo o cliente para base de testes do exercicio 02;
INSERT INTO TAB_Pedido VALUES(15, ADD_MONTHS(SYSDATE, 1), 30, 5);
INSERT INTO TAB_Pedido VALUES(16, ADD_MONTHS(SYSDATE, 1), 30, 5);
INSERT INTO TAB_Pedido VALUES(17, ADD_MONTHS(SYSDATE, 1), 30, 5);
SELECT * FROM TAB_Pedido;

CREATE OR REPLACE PROCEDURE SP_ClientePremium(P_CodCliente IN TAB_Cliente.CodCliente%TYPE) IS
	var_Acumulador TAB_Pedido.NumPedido%TYPE;
    var_codigoCliente TAB_Cliente.CodCliente%TYPE;
	var_nomeCliente TAB_Cliente.nomeCliente%TYPE;
BEGIN
	SELECT COUNT(*), TAB_Cliente.CodCliente, TAB_Cliente.nomeCliente
    INTO var_Acumulador, var_codigoCliente, var_nomeCliente
	FROM TAB_Cliente
    INNER JOIN TAB_Pedido ON TAB_Pedido.CodCliente = TAB_Cliente.CodCliente
    WHERE TAB_Pedido.CodCliente = P_CodCliente AND TAB_Pedido.PrazoEntrega BETWEEN SYSDATE AND ADD_MONTHS(SYSDATE, 2)
    GROUP BY var_Acumulador, TAB_Cliente.CodCliente, TAB_Cliente.nomeCliente;

	IF var_Acumulador > 2 THEN
		INSERT INTO TabLog(datalog, campo1, campo2)VALUES(sysdate, 'Cliente especial - Enviar brinde.', 'Nome: '|| var_nomeCliente || ' - ' || 'Codigo: ' || var_CodigoCliente);
	END IF;
    COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        	INSERT INTO TabErro(dataerro, mensagem)VALUES(sysdate, 'Cliente não cadastrado!');
END;

EXECUTE SP_ClientePremium(30);
SELECT * FROM TabLog;
SELECT * FROM TabErro;