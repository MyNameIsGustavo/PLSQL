-- Lista 01 de Triggers.

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
    ValorUnitario number(6,2),
    QtdeEstoque number(5)
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
    Quantidade number(5),
    ValorUnitario number(6,2)
);

CREATE TABLE TabLog
( 	datalog DATE,
	campo1 VARCHAR2(100),
	campo2 VARCHAR2(100)
);

CREATE TABLE TabErro
(	dataerro DATE,
	mensagem VARCHAR2(100)
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

INSERT INTO TAB_Produto VALUES (11, 'Apple Watch', 'UN', 975.99, 5);
INSERT INTO TAB_Produto VALUES (12, 'IPAD', 'UN', 999.70, 10);
INSERT INTO TAB_Produto VALUES (13, 'PÓ PARA TONER', 'KG', 85.60, 5);
INSERT INTO TAB_Produto VALUES (14, 'Mouse', 'UN', 45.60, 20);
INSERT INTO TAB_Produto VALUES (15, 'Caneta digital', 'UN', 100.00, 15);
INSERT INTO TAB_Produto VALUES (40,'Mouse sem fio', 'UN', 68.90, 7);
INSERT INTO TAB_Produto VALUES (42,'FIO HDMI', 'UN', 18.00, 9);
INSERT INTO TAB_Produto VALUES (43,'Pendrive Star Wars', 'UN', 48.00, 1);
INSERT INTO TAB_Produto VALUES (44,'Mouse com fio', 'UN', 28.00, 23);
INSERT INTO TAB_Produto VALUES (45,'Pendrive do Mickey', 'UN', 50.00, 33);

INSERT INTO TAB_PEDIDO VALUES (8, to_date('23-05-2020', 'DD-MM-YYYY'), 32, 25);
INSERT INTO TAB_PEDIDO VALUES (9, to_date('21/02/2020', 'DD-MM-YYYY'), 32, 5);
INSERT INTO TAB_PEDIDO VALUES (10, to_date('20/02/2020', 'DD-MM-YYYY'), 30, 5);

INSERT INTO TAB_ItemPedido VALUES (7,11,1,15.00);
INSERT INTO TAB_ItemPedido VALUES (7,40,2,11.00);
INSERT INTO TAB_ItemPedido VALUES (7,42,1,44.00);
INSERT INTO TAB_ItemPedido VALUES (8,43,5,32.00);
INSERT INTO TAB_ItemPedido VALUES (9,12,1,31.00);
INSERT INTO TAB_ItemPedido VALUES (10,11,1,25.00);
INSERT INTO TAB_ItemPedido VALUES (10,43,1,12.00);
INSERT INTO TAB_ItemPedido VALUES (10,13,2,11.00);
INSERT INTO TAB_ItemPedido VALUES (8,40,1,10.00);

/*	01. - Sobre o modelo do item-pedido, escreva um trigger que ao inserir um item do pedido verifique 
	se o cliente já possui mais de 2 pedidos com entrega no mês atual. Se sim, aplicar um desconto 
	de 15% ao preço do item que está sendo cadastrado.
*/
CREATE OR REPLACE TRIGGER TR_InsereItem
BEFORE INSERT ON TAB_ItemPedido
FOR EACH ROW
DECLARE
	vTotal number;
	vCodCliente TAB_Pedido.CodCliente%TYPE;
BEGIN
    -- Descobrindo o codigo do cliente dinamicamente;
	SELECT CodCliente INTO vCodCliente FROM TAB_Pedido
    WHERE NumPedido = :NEW.NumPedido;

	-- Contando os pedidos associados ao cliente;
	SELECT COUNT(*) INTO vTotal
    FROM TAB_Pedido
    WHERE CodCliente = vCodCliente;

	IF(vTotal >= 2) THEN
    	:NEW.ValorUnitario := :NEW.ValorUnitario * 0.85;
    	COMMIT;
    END IF;
END TR_InsereItem;
SELECT * FROM TAB_ItemPedido;
ALTER TRIGGER TR_InsereItem DISABLE;

/*	02. - Crie um trigger que ao ser alterado o campo endereço da tabela de cliente,
	faça a inserção de uma linha na tabela de log com a mensagem:
	"Observar mudança de endereço" <codigo do cliente> <endereço velho> <endereçonovo> 
	Tablog (datalog,campo1,campo2)
*/
CREATE OR REPLACE TRIGGER TR_AlteraEndereco
BEFORE UPDATE ON TAB_Cliente
FOR EACH ROW
BEGIN
	INSERT INTO TabLog VALUES(SYSDATE, 'Obs. Mudancas - CodCliente' || :OLD.CodCliente, 'End. Antigo: ' || :OLD.Endereco || 'Novo: ' || :NEW.Endereco);
END TR_AlteraEndereco;

-- Testando o Trigger;
UPDATE TAB_Cliente SET Endereco = 'Rua X'
WHERE CodCliente = 31;

SELECT * FROM TabLog;
ALTER TRIGGER TR_AlteraEndereco DISABLE;

/*	03. - Escreva um trigger que ao incluir um novo item de pedido, verifique se a quantidade 
	informada no item existe em estoque (comparar com o campo qtde estoque da tabela produto).
	
	Se a quantidade <= quantidade em estoque
		atualizar a quantidade em estoque da tabela (produto) subtraindo a quantidade pedida

	Se quantidade pedida > quantidade estoque
		diminuir a quantidade pedida e zerar a quantidade em estoque

	Se quantidade em estoque = 0 então abortar trigger;
*/
CREATE OR REPLACE TRIGGER TR_VerificaEstoque
BEFORE INSERT ON TAB_ItemPedido
FOR EACH ROW
DECLARE
	vEstoque NUMBER;
BEGIN
    -- Buscando a quantidade do item na tabela de ItemPedido;
	SELECT QtdeEstoque INTO vEstoque FROM TAB_Produto
    WHERE CodProduto = :NEW.CodProduto;

	IF(vEstoque = 0)THEN
		RAISE_APPLICATION_ERROR(-20001, 'Sem produtos no estoque');
	ELSE
        IF(:NEW.Quantidade <= vEstoque) THEN
        	UPDATE TAB_Produto SET QtdeEstoque = (QtdeEstoque - :NEW.Quantidade)
        	WHERE CodProduto = :NEW.CodProduto;
		ELSE
            	:NEW.Quantidade := vEstoque;
				UPDATE TAB_Produto SET QtdeEstoque = 0 WHERE CodProduto = :NEW.CodProduto;
		END IF;
    END IF;
END TR_VerificaEstoque;
ALTER TRIGGER TR_VerificaEstoque DISABLE;

/*	04. - Escreva um trigger que ao incluir um pedido ou alterar o prazo de entrega de um pedido, 
	só permita inserir prazo de entrega superior a 5 dias da data atual. Caso isso não ocorra mudar
	o prazo para mais 5 dias automaticamente.
*/
CREATE OR REPLACE TRIGGER TR_AlteraData
BEFORE INSERT OR UPDATE ON TAB_Pedido
FOR EACH ROW
BEGIN
	IF :NEW.PrazoEntrega < SYSDATE + 5 THEN
    	:NEW.PrazoEntrega := SYSDATE + 5;
	END IF;
END TR_AlteraData;