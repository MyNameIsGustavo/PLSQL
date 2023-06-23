CREATE TABLE Cliente
(	Codcliente number(6) not null,
	CodEndereco number(6),
	Nome varchar2(40) not null,
	Telefone varchar2(20),
	Datanascimento date,
	CPF varchar2(20)
);

CREATE TABLE Endereco
(	CodEndereco number(6) not null,
	Numero varchar2(5) not null,
	CEP varchar2(20) not null,
	Logradouro varchar2(50) not null,
	Complemento varchar2(50),
	Cidade varchar2(40)
);

CREATE TABLE Cli_End
(	CodCliente number(6) not null,
	CodEndereco number(6) not null
);

CREATE TABLE Pedido
(	CodPedido number(10) not null,
	CodCliente number(6) not null,
	CodPagamento number(10),
	DataPedido date,
	Frete number(7,2),
	Desconto number(2),
	PrecoTotal number(8,2)
);

CREATE TABLE Pagamento
(	CodPagamento number(10) not null,
	DataPagamento date ,
	FormaPagamento char (1) check (FormaPagamento in('B', 'C'))
);

CREATE TABLE Cartao
(	CodPagamento number(10) not null,
	NumeroCartao varchar2(20) not null,
	Parcelas number(2),
	Juros number(4,2),
	Bandeira varchar2(20)
);

CREATE TABLE Boleto
(	CodPagamento number(6) not null,
	Validade date,
	Banco varchar2(20),
	NumCodBarra varchar2(100)
);

CREATE TABLE Item_Ped
(	CodPedido number(10) not null,
	CodLivro number(6) not null,
	Quantidade number(2) not null
);

CREATE TABLE Livro
(	CodLivro number(6) not null,
	CodGenero number(6) not null,
	CodEditora number(6) not null,
	CodAutor number(6) not null,
	Descricao varchar2(250),
	Titulo varchar2(50) not null,
	AnoPubli date,
	Preco number(5,2)
);

CREATE TABLE Liv_Aut
(	CodLivro number(6) not null,
	CodAutor number(6) not null
);

CREATE TABLE Autores
(	CodAutor number(6) not null,
	Nome varchar2(50) not null,
	Nacionalidade varchar2(20),
	QtdeObras number(5),
	DataNascimento date
);

CREATE TABLE Editora
(	CodEditora number(6) not null,
	Endereco varchar2(50),
	Nome varchar2(40) not null,
	CNPJ varchar2(20),
	Contato varchar2(20)
);

CREATE TABLE Genero
(	CodGenero number(5) NOT NULL,
	Nome varchar2(50) NOT NULL
);

--Criação das PKs e constraints.
ALTER TABLE Cliente ADD CONSTRAINT PK_Cliente_CodCliente PRIMARY KEY(CodCliente);
ALTER TABLE Cli_End ADD CONSTRAINT PK_CliEnd_CliEnd PRIMARY KEY(CodCliente, CodEndereco);
ALTER TABLE Endereco  ADD CONSTRAINT PK_Endereco_CodEndereco PRIMARY KEY(CodEndereco);
ALTER TABLE Boleto ADD CONSTRAINT PK_Boleto_CodPagamento PRIMARY KEY (CodPagamento);
ALTER TABLE Pedido ADD CONSTRAINT PK_Pedido_CodPedido PRIMARY KEY(CodPedido);
ALTER TABLE Pagamento ADD CONSTRAINT PK_Pagamento_CodPagamento PRIMARY KEY (CodPagamento);
ALTER TABLE Item_Ped ADD CONSTRAINT PK_ItemPed_CodPedLiv PRIMARY KEY(CodPedido,CodLivro);
ALTER TABLE Livro ADD CONSTRAINT PK_Livro_CodLivro PRIMARY KEY(CodLivro);
ALTER TABLE Autores ADD CONSTRAINT PK_Autores_CodAutor PRIMARY KEY (CodAutor);
ALTER TABLE Genero ADD CONSTRAINT PK_Genero_CodGenero PRIMARY KEY (CodGenero);
ALTER TABLE Editora ADD CONSTRAINT PK_Editora_CodEditora PRIMARY KEY (CodEditora);
ALTER TABLE Liv_Aut ADD CONSTRAINT PK_LivAut_CodLivroAutor PRIMARY KEY (CodLivro, CodAutor);

--Criação das FKs e constraints.
ALTER TABLE Cli_End ADD CONSTRAINT FK_CliEnd_CodCliente FOREIGN KEY(CodCliente) REFERENCES Cliente;
ALTER TABLE Cli_End ADD CONSTRAINT FK_CliEnd_CodEndereco FOREIGN KEY(CodEndereco) REFERENCES Endereco;
ALTER TABLE Liv_Aut ADD CONSTRAINT FK_LivAut_CodAutor FOREIGN KEY (CodAutor) REFERENCES Autores;
ALTER TABLE Boleto ADD CONSTRAINT FK_Boleto_CodPagamento FOREIGN KEY (CodPagamento) REFERENCES Pagamento;
ALTER TABLE Livro ADD CONSTRAINT FK_Livro_CodEditora FOREIGN KEY(CodEditora) REFERENCES Editora;
ALTER TABLE Livro ADD CONSTRAINT FK_Livro_CodGenero FOREIGN KEY(CodGenero) REFERENCES Genero;
ALTER TABLE Livro ADD CONSTRAINT FK_Livro_CodAutor FOREIGN KEY(CodAutor) REFERENCES Autores;
ALTER TABLE  Item_Ped ADD CONSTRAINT FK_ItemPed_CodPedido FOREIGN KEY(CodPedido) REFERENCES Pedido;
ALTER TABLE  Item_Ped ADD CONSTRAINT FK_ItemPed_CodLivro FOREIGN KEY(CodLivro) REFERENCES Livro;
ALTER TABLE  Cartao ADD CONSTRAINT FK_Cartao_CodPagamento FOREIGN KEY(CodPagamento) REFERENCES Pagamento;
ALTER TABLE Pedido ADD CONSTRAINT FK_Pedido_CodPagamento FOREIGN KEY(CodPagamento) REFERENCES Pagamento;
ALTER TABLE Pedido ADD CONSTRAINT FK_Pedido_CodCliente FOREIGN KEY(CodCliente) REFERENCES Cliente;

-- INSERTS NA TABELA CLIENTE.
INSERT INTO Cliente VALUES(001,001, 'Joao da Silva','(15)9919-8786',to_date('16-10-1998','DD-MM-YYYY'),'402.383.869-40');
INSERT INTO Cliente VALUES(002,002, 'Claudio Souza', '(12)9953-8780', to_date('12-10-1995','DD-MM-YYYY'), '418.383.870-30');
INSERT INTO Cliente VALUES(003,003, 'Emanoel Rodrigues', '(12)9920-8780', to_date('11-05-1994','DD-MM-YYYY'), '435.390.870-20');
INSERT INTO Cliente VALUES(004,004, 'Fagner Lemos', '(15)9181-5580', to_date('16-03-1993','DD-MM-YYYY'), '418.383.383-10');
INSERT INTO Cliente VALUES(005,005, 'Roberto Carlos', '(13)9083-8780', to_date('12-03-1999','DD-MM-YYYY'), '408.313.070-75');
INSERT INTO Cliente VALUES(006,006, 'Yuri Alberto', '(11)98818-4950', to_date('01-02-1991','DD-MM-YYYY'), '521.353.900-12');
INSERT INTO Cliente VALUES(007,007, 'Vinicius Jose Junior', '(11)98010-4150', to_date('11-03-1989','DD-MM-YYYY'), '501.303.902-13');

-- INSERTS NA TABELA ENDEREÇO.
INSERT INTO Endereco VALUES(001, '200','18225-698','Rua do brejo','bloco 1','Sorocaba');
INSERT INTO Endereco VALUES(002, '165','19925-137','Wilson de bello','Casa de esquina','Sorocaba');
INSERT INTO Endereco VALUES(003, '123','22215-603','Afonso nunez', 'Proximo ao mercado','Votorantim');
INSERT INTO Endereco VALUES(004, '155','58205-759','Orlando torres','Ao lado do hospital regional','Itu');
INSERT INTO Endereco VALUES(005, '921','20205-072','Veracruz barros','Proximo ao campo de futebol','Ibiuna');
INSERT INTO Endereco VALUES(006, '241','55515-895','Rua juazeiro','bloco 8','Itu');
INSERT INTO Endereco VALUES(007, '199','13025-008','Avenida radial','Proximo ao metro ','Votorantim');

-- INSERTS NA TABELA CLI_END.
INSERT INTO Cli_End VALUES(001,001);
INSERT INTO Cli_End VALUES(002,002);
INSERT INTO Cli_End VALUES(003,003);
INSERT INTO Cli_End VALUES(004,004);
INSERT INTO Cli_End VALUES(005,005);
INSERT INTO Cli_End VALUES(006,006);
INSERT INTO Cli_End VALUES(007,007);

-- INSERTS NA TABELA GENERO.
INSERT INTO Genero VALUES(001,'Romance');
INSERT INTO Genero VALUES(002,'Ficcao Científica');
INSERT INTO Genero VALUES(003,'Humor e comédia');
INSERT INTO Genero VALUES(004,'Biografias');
INSERT INTO Genero VALUES(005,'Tecnologia e ciência');
INSERT INTO Genero VALUES(006,'Desenvolvimento Pessoal');
INSERT INTO Genero VALUES(007,'Quadrinhos');

-- INSERTS NA TABELA AUTORES.
INSERT INTO Autores VALUES(001,'Juliano Augusto','Brasileiro',4,to_date('12-05-1978','DD-MM-YYYY'));
INSERT INTO Autores VALUES(002,'Romero Britto','Brasileiro',10,to_date('10-02-1980','DD-MM-YYYY'));
INSERT INTO Autores VALUES(003,'Mauricio de Souza','Brasileiro',35,to_date('21-03-1970','DD-MM-YYYY'));
INSERT INTO Autores VALUES(004,'Afonso Souza','Espanhol',7,to_date('30-09-1992','DD-MM-YYYY'));
INSERT INTO Autores VALUES(005,'Sergio Ramos','Espanhol',2,to_date('17-12-1995','DD-MM-YYYY'));
INSERT INTO Autores VALUES(006,'Joao Felix','Portugues',55,to_date('04-2-1983','DD-MM-YYYY'));
INSERT INTO Autores VALUES(007,'Bob Buffett','Americano',18,to_date('25-12-1989','DD-MM-YYYY'));

-- INSERTS NA TABELA EDITORA.
INSERT INTO Editora VALUES(001,'Av. Pedro Pedroso','Abril','91.233.795/0001-33','(15)9856-9846');
INSERT INTO Editora VALUES(002,'Av. Faria Lima','Sextante','90.203.705/0111-39','(12)9976-5555');
INSERT INTO Editora VALUES(003,'Rua José Marcondes Alves','Rocco','55.233.888/0211-5','(14)9886-9886');
INSERT INTO Editora VALUES(004,'Rua Altos do ipanema','Alta Books','72.054.795/1010-39','(15)9800-9046');
INSERT INTO Editora VALUES(005,'Av. Campos Sales','Aleph','99.299.095/9999-73','(11)99756-0877');
INSERT INTO Editora VALUES(006,'Rua Alvarenga Pedroso','Ubu','98.283.095/0281-81','(15)9817-4851');
INSERT INTO Editora VALUES(007,'Rua Jose Alves Limeira','Panda Books','41.243.445/0401-65','(11)9919-7731');

-- INSERTS NA TABELA LIVRO.
INSERT INTO Livro VALUES(111,001,001,001,'Game of Thrones','Best seller compre ja',to_date('18-05-2012','DD-MM-YYYY'),78.20);
INSERT INTO Livro VALUES(222,002,001,002,'O Mochileiro  das Galaxias','Classico de ficcao cientifica',to_date('22-11-2018','DD-MM-YYYY'),100.00);
INSERT INTO Livro VALUES(333,001,003,003,'E Assim que Acaba',' segundo livro mais vendido em 2022 no Brasil',to_date('30-01-2021','DD-MM-YYYY'),120.50);
INSERT INTO Livro VALUES(444,006,004,004,'+ Esperto que o Diabo','Inedito no Brasil',to_date('20-07-2017','DD-MM-YYYY'),44.99);
INSERT INTO Livro VALUES(555,004,005,005,'Verity','Distintamente Sinistro',to_date('15-04-2019','DD-MM-YYYY'),55.70);

-- INSERTS NA TABELA LIV_AUT.
INSERT into Liv_Aut VALUES(111,001);
INSERT into Liv_Aut VALUES(222,002);
INSERT into Liv_Aut VALUES(333,003);
INSERT into Liv_Aut VALUES(444,004);
INSERT into Liv_Aut VALUES(555,005);

-- INSERTS NA TABELA PAGAMENTO.
INSERT INTO Pagamento VALUES(001,to_date('20-12-2022','DD-MM-YYYY'),'B');
INSERT INTO Pagamento VALUES(002,to_date('21-12-2022','DD-MM-YYYY'),'C');
INSERT INTO Pagamento VALUES(003,to_date('22-12-2022','DD-MM-YYYY'),'B');
INSERT INTO Pagamento VALUES(004,to_date('23-12-2022','DD-MM-YYYY'),'C');
INSERT INTO Pagamento VALUES(005,to_date('24-12-2022','DD-MM-YYYY'),'B');

-- INSERTS NA TABELA CARTÃO.
INSERT INTO Cartao VALUES(002,'5386 4946 3826 9165',3,5,'VISA');
INSERT INTO Cartao VALUES(004,'5548 4165 7859 7482',1,0,'MASTERCARD');

-- INSERTS NA TABELA BOLETO.
INSERT INTO Boleto VALUES (002,to_date('23-12-2022','DD-MM-YYYY'),'BRADESCO','34191.39001 01043.510047 91020.150008 8 91740026000');
INSERT INTO Boleto VALUES (003,to_date('25-12-2022','DD-MM-YYYY'),'BRADESCO','58191.49001 11043.510047 91020.150008 9 91760026000');
INSERT INTO Boleto VALUES (005,to_date('28-12-2022','DD-MM-YYYY'),'BRADESCO','70191.99001 61043.510047 91020.150008 8 91740026000');

-- INSERTS NA TABELA PEDIDO.
INSERT INTO Pedido VALUES (001,001,001,to_date('19-12-2022','DD-MM-YYYY'),25.26,15,78.99);
INSERT INTO Pedido VALUES (002,002,002,to_date('21-12-2022','DD-MM-YYYY'),30.50,0,99.99);
INSERT INTO Pedido VALUES (003,007,003,to_date('20-12-2022','DD-MM-YYYY'),0,15,245.80);
INSERT INTO Pedido VALUES (004,004,004,to_date('23-12-2022','DD-MM-YYYY'),0,0,125.50);
INSERT INTO Pedido VALUES (005,006,005,to_date('23-12-2022','DD-MM-YYYY'),0,15,45.70);

-- INSERTS NA TABELA ITEM_PEDIDO.
INSERT INTO Item_Ped VALUES(001,111,1);
INSERT INTO Item_Ped VALUES(001,555,1);
INSERT INTO Item_Ped VALUES(002,333,2);
INSERT INTO Item_Ped VALUES(002,111,1);
INSERT INTO Item_Ped VALUES(002,222,3);
INSERT INTO Item_Ped VALUES(003,111,1);
INSERT INTO Item_Ped VALUES(004,333,4);
INSERT INTO Item_Ped VALUES(004,222,1);
INSERT INTO Item_Ped VALUES(005,222,3);

-- Objetivo da questão: Acrescenta a nova coluna ‘data de inclusão’ na tabela cliente.
-- 1- Acrescente uma coluna nova “data de inclusão” no formato date, na primeira tabela criada.
ALTER TABLE Cliente ADD DataInclusao DATE;

-- Objetivo da questão: Alterar o valor da coluna DataInclusao adicionando a data do sistema na primeira tabela criada (Cliente).
-- 2- Altere o valor desta coluna colocando a data do sistema.
UPDATE Cliente SET DataInclusao = SYSDATE;

-- Objetivo da questão: Alterar o tamanho da coluna frete da tabela pedido. 
-- 3- Altere o tamanho de qualquer campo da tabela principal de seu sistema e acrescente a restrição de não permitir valores nulos.
ALTER TABLE Pedido MODIFY Frete NUMBER(8,2) NOT NULL;

-- Objetivo da questão: Excluir a coluna DataInclusao da primeira tabela criada (Cliente);
-- 4- Excluir a coluna acrescentada na questão 1.
ALTER TABLE Cliente DROP COLUMN DataInclusao;

-- Objetivo da questão: Alterar o conteúdo da coluna frete da tabela pedido.
-- 5- Escreva um comando que altere o conteúdo de uma coluna (escolha qq tabela).
UPDATE Pedido
SET Frete = 10.00
WHERE CODPEDIDO = 001;

-- Objetivo da questão: Listar todos os títulos de livros e seus autores que terminam com a palavra ‘Souza’.
-- 6- Escreva um comando Select utilizando a cláusula LIKE.
SELECT L.titulo, A.nome FROM autores A
INNER JOIN liv_aut LA ON A.CODAUTOR = LA.CODAUTOR
INNER JOIN livro L ON LA.CODLIVRO = L.CODLIVRO
WHERE A.NOME LIKE '%Souza';

-- Objetivo da questão: Listar os títulos dos livros e o seu gênero, ordenando o resultado através do gênero do livro. 
-- 7- Escreva um comando Select que utilize a cláusula where com 2 condições, e order by. 
SELECT L.titulo,G.nome FROM Genero G 
INNER JOIN Livro L on G.codgenero = L.codgenero
WHERE G.CodGenero = 2 or G.CodGenero = 5
order by G.nome DESC;

-- Objetivo da questão: Listar todos os bancos e bandeiras usadas em pagamentos sem repetições.
-- 8- Escreva um comando Select utilizando a cláusula distinct.
SELECT DISTINCT  B.Banco FROM Boleto B
INNER JOIN Pagamento PAG on PAG.codpagamento = B.codpagamento
UNION
SELECT DISTINCT C.Bandeira FROM Cartao C
INNER JOIN Pagamento PAG on PAG.codpagamento = C.codpagamento;

-- Objetivo da questão: O boleto tem validade de três dias. Portanto, devem ser listados todos os boletos vencidos.
-- 9- Escreva um comando que utilize uma função de soma de datas dentro da cláusula where.
select NUMCODBARRA, VALIDADE from Boleto
where (Validade+3) < Sysdate;

-- Objetivo da questão: Listar os clientes cadastrados mostrando o dia, mês, ano, hora, minuto e segundo em que a pesquisa foi feita utilizando a data do sistema do banco de dados. 
-- 10- Escreva um comando select para listar a data do sistema mostrando dia, mês, ano, hora, minuto e segundo. 
SELECT to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS') as Clientes_Cadastrados_Nessa_Data from dual
union
select Nome from cliente;

-- Objetivo da questão: Listar o título do livro, o ano de publicação, preço, nome da editora e contato da editora.
-- 11- Escreva um exemplo de junção entre 2 tabelas que retorne várias linhas. 
select L.titulo,L.Datapubli,L.preco,E.Nome,E.contato from LIVRO L
inner join EDITORA E on L.CodEditora=E.CodEditora;

-- Objetivo da questão: Listar o nome do cliente, taxa de desconto e forma de pagamento para todos os pedidos que foram feitos com o pagamento por boleto.
-- 12- Escreva um exemplo de junção entre 3 tabelas. 
SELECT C.Nome, P.Desconto, PG.FormaPagamento FROM Cliente C
INNER JOIN Pedido P ON C.CodCliente = P.CodCliente
INNER JOIN Pagamento PG ON P.CodPagamento = PG.CodPagamento
WHERE PG.FormaPagamento = 'B';

-- Objetivo da questão: Listar o codigo do cliente, nome e quantos pedidos ele já fez.
-- 13- Dê um exemplo de comando DML que utilize a função count(*). 
SELECT C.CodCliente, C.Nome, count(P.CodCliente) FROM Pedido P
INNER JOIN Cliente C ON C.CodCliente = P.CodCliente
GROUP BY C.CodCLiente, C.Nome;

--Objetivo da questão: Somar os valores das vendas e renomear a coluna para “VALOR_TOTAL_DAS_VENDAS”.
--14- Dê um exemplo de comando DML que utilize a função Sum(). 
SELECT SUM(PrecoTotal) as VALOR_TOTAL_DAS_VENDAS from Pedido;

-- Objetivo da questão: Listar o valor total dos pedidos feitos agrupando em cada forma de pagamento.
-- 15- Explique para que serve a cláusula group by e dê 1 exemplo de sua utilização. 
-- Resposta: O group by é usado para agrupar linhas de uma tabela que tem os mesmos valores em todas as colunas da lista.
SELECT PAG.formapagamento, SUM(P.precototal) 
from Pagamento PAG
INNER JOIN Pedido P ON P.codpagamento = PAG.codpagamento
GROUP BY PAG.formapagamento;

-- Objetivo da questão: Listar os livros agrupando o resultado obtido pela editora.
-- 16- Dê um exemplo usando a junção de tabelas com a cláusula Group by. 
SELECT C.nome, SUM(P.precototal) as Total_Gasto from Cliente C 
INNER JOIN Pedido P on P.CodCliente = C.CodCliente
GROUP BY C.nome;

-- Objetivo da questão: Listar o nome dos clientes, valor do pedido para pedidos que tenham valor maior que R $80.00.
-- 17- Explique para que serve a cláusula having e dê 1 exemplo de sua utilização. 
-- A cláusula HAVING filtra os resultados fornecidos a partir de um agrupamento de registros que é feito por um GROUP BY. Funciona como a cláusula WHERE.

SELECT C.nome, SUM(P.precototal) as Total_Gasto from Cliente C 
INNER JOIN Pedido P on P.CodCliente = C.CodCliente
GROUP BY C.nome
HAVING SUM(P.precototal) > 80.00;

-- Objetivo da questão: Para cada pedido feito listar, o código do cliente, nome do cliente, logradouro, número do endereço, CEP, código do pedido, data do pedido, frete e valor do pedido(somando o preço de todos os livros incluídos no pedido).
-- 18- Usando junção de várias tabelas, escreva um comando que liste os campos do documento principal gerado pelo seu sistema. Onde houver chave estrangeira liste a descrição correspondente. Por exemplo=> em “Assinatura de Revista”, deve haver um código de assinante. Neste caso, liste o nome do assinante além do código deste. 
SELECT C.codcliente, C.nome, E.logradouro, E.numero, E.cep, P.codpedido, P.datapedido, P.frete, SUM(L.preco) as VALOR_PEDIDO
FROM Cliente C

INNER JOIN Cli_End CE ON C.codcliente = CE.codcliente
INNER JOIN Endereco E ON CE.codendereco = E.codendereco 
INNER JOIN Pedido P ON C.codcliente = P.codcliente 
INNER JOIN Item_Ped IP ON P.codpedido = IP.codpedido
INNER JOIN Livro L ON IP.codlivro = L.codlivro

GROUP BY C.codcliente, C.nome, E.logradouro, E.numero, E.cep, P.codpedido, P.datapedido, P.frete;

-- Objetivo da questão: Criar uma tabela contendo o código do cliente, nome e código do pedido.
-- 19- Dê um exemplo de como você pode criar uma tabela a partir de outra já existente.
CREATE TABLE ClienteCopia AS
SELECT C.codcliente, C.nome, P.codpedido
FROM Cliente C
INNER JOIN Pedido P on P.codcliente = C.codcliente;

-- Objetivo da questão: Responder o questionamento proposto.
-- 20- Para a criação das tabelas deste exercício foi necessário estabelecer uma ordem? Justifique. 
-- Resposta: Não, devido às instruções de desenvolvimento do projeto, a criação das tabelas foi feita antes da adição das primaries keys(PK’s) e foreigners keys(FK' s). 

-- Objetivo da questão: Listar o nome dos clientes e dos autores em uma única tabela.
-- 21-Dê um exemplo de uma consulta usando a operação de união.
SELECT Nome FROM Cliente
UNION
SELECT Nome FROM Autores
ORDER BY Nome ASC;

-- Objetivo da questão:  Listar os clientes com pedidos registrados.
-- 22-Dê um exemplo de uma consulta usando a operação de interseção. 
SELECT CodCliente from Pedido
INTERSECT
SELECT CodCliente from Cliente;

-- Objetivo da questão: Listar os clientes que não tem compras registradas.
-- 23-Dê um exemplo de uma consulta usando a operação de diferença.
SELECT codcliente from Cliente
MINUS 
SELECT  codcliente from Pedido;