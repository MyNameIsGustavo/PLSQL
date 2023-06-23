/*	01. - Escreva uma função que receba como parâmetro um código de Paciente (modelo Paciente-consulta) 
	e devolva “IDOSO” se o paciente tiver mais de 65 anos. Caso contrário devolva “NÃO IDOSO”.
*/

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION FN_verificaIdade(PAR_codigoPaciente IN NUMBER) RETURN NUMBER
AS
    varIdade NUMBER;
BEGIN
	SELECT TRUNC((SYSDATE - Datanasc) / 365.25)
    INTO varIdade
    FROM Paciente
    WHERE Codpaciente = Par_codigoPaciente;

	IF varIdade > 65 THEN
		DBMS_OUTPUT.PUT_LINE('Paciente idoso. Idade: ' || varIdade);
	ELSE
		DBMS_OUTPUT.PUT_LINE('Paciente nao idoso. Idade: ' || varIdade);
    END IF;

	RETURN varIdade;
END;

SELECT FN_verificaIdade(007) AS IDADE FROM DUAL;

/*	02. - Crie uma função chamada FN_ConsultaEstoque que retorna a qtde corrente em estoque de determinado produto.
	A -	Passe para a função o código do produto;
	B -	Crie o campo QTDE_estoque na tabela de produto;
	C -	Crie uma forma de executar a função criada;
*/

ALTER TABLE TAB_Produto ADD QTDE_estoque NUMBER(4);
INSERT INTO TAB_Produto VALUES(50, 'Camisa de time', 'UN', 250.00, 10);

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION FN_ConsultaEstoque(PAR_CodigoProduto IN  NUMBER) RETURN NUMBER
AS
	varQtdeCorrente NUMBER;
BEGIN
	SELECT QTDE_estoque
	INTO varQtdeCorrente
    FROM TAB_Produto
    WHERE CodProduto = PAR_CodigoProduto;

	DBMS_OUTPUT.PUT_LINE('Quantidade corrente atual: ' || varQtdeCorrente);
	RETURN varQtdeCorrente;
END;

SELECT FN_ConsultaEstoque(50) AS CODIGO FROM DUAL;

/*	03. - Escreva uma função que receba como parâmetro um número de telefone não formatado(só números) 
	e exiba este número no formato: (xx)xxxx-xxxx
*/
ALTER TABLE TAB_Cliente ADD telefone VARCHAR2(14);
INSERT INTO TAB_Cliente VALUES (35, 'Roger Guedes', 'Arena Corinthians, 1100', 'SÃO PAULO', '97056-001', 'SP', '0012345678');

CREATE OR REPLACE FUNCTION FN_FormataTelefone(PAR_Telefone IN VARCHAR2) RETURN VARCHAR2
AS
	varTelefoneFormatado VARCHAR2(14);
BEGIN
    SELECT telefone
    INTO varTelefoneFormatado
    FROM TAB_Cliente
    WHERE telefone = PAR_Telefone;

	varTelefoneFormatado := '(' || SUBSTR(varTelefoneFormatado, 1, 2) || ')' || SUBSTR(varTelefoneFormatado, 3, 4) || '-'
                  				|| SUBSTR(varTelefoneFormatado, 7, 4);

	return varTelefoneFormatado;
END;

SELECT FN_FormataTelefone('0012345678') FROM DUAL;