CREATE TABLE Autor
(   CodAutor Number(5) PRIMARY KEY, 
    Nomeautor Varchar2(20),
    datanascimento Date,
    CidadeNasc Varchar2(20),
    sexo Char(1) 
);

CREATE TABLE Livro 
(   CodigoLivro Number(5) PRIMARY KEY,
    Titulo Varchar2(30),
    Editora	Varchar2(20),
    Cidade Varchar2(30), 
    DataEdicao Date, 
    Versao Number(3),
    CodAssunto Number(5),
    Preco Number(5,2),
    DataCadastro Date,
    lancamento Char(1)
);

CREATE TABLE AutorLivro
(   codigoLivro Number(5) NOT NULL,
    codAutor Number(5) NOT NULL
); 

CREATE TABLE Assunto
(   CodAssunto Number(5) PRIMARY KEY,
    descricao Varchar2(40),
    descontopromocao Number(4,2)
);

ALTER TABLE AutorLivro ADD CONSTRAINT PK_AUTORLIVRO_CODLIAUTOR PRIMARY KEY(CodigoLivro,CodAutor);
ALTER TABLE AutorLivro ADD CONSTRAINT FK_AUTORLIVRO_CODIGOLIVRO FOREIGN KEY (CodigoLivro) REFERENCES Livro;
ALTER TABLE AutorLivro ADD CONSTRAINT FK_AUTORLIVRO_CODAUTOR FOREIGN KEY (CodAutor) REFERENCES Autor;

ALTER TABLE Livro ADD CONSTRAINT FK_LIVRO_CODASSUNTO FOREIGN KEY (CodAssunto) REFERENCES Assunto;

-- 3- Adicionar uma nova coluna de nome Nacionalidade na tabela Autor.

ALTER TABLE Autor ADD Nacionalidade VARCHAR2(25);

INSERT INTO Assunto VALUES (10,'LITERATURA',2.5);
INSERT INTO Assunto VALUES (20,'PROGRAMACAO',5);
INSERT INTO Assunto VALUES (30,'Estudos Contabilidade', 2.99);
INSERT INTO Assunto VALUES (40,'Ficção Científica', 10.99);

INSERT INTO Autor VALUES (111,'CLARISSE LISPECTOR', TO_DATE('10/09/1920', 'DD/MM/YYYY'), 'CHECHELNYK','F','Ucraniana');
INSERT INTO Autor VALUES (222,'JOEL GRUS',TO_DATE('31/12/1970', 'DD/MM/YYYY'),'SEATTLE','M', 'Americano');
INSERT INTO Autor VALUES (333, 'Marina Souza', TO_DATE('20/01/20 00:16:30', 'DD/MM/YYYY hh24:mi:ss'),'Sorocaba', 'F', 'Brasileira');

INSERT INTO Livro VALUES (888,'A HORA DA ESTRELA','ROCCO','RIO DE JANEIRO', TO_DATE('04/08/1998', 'DD/MM/YYYY'),'3',10,11.9, TO_DATE('21/08/2020', 'DD/MM/YYYY'),'L');
INSERT INTO Livro VALUES (999,'DATA SCIENCE DO ZERO','ALTA BOOKS','RIO DE JANEIRO', TO_DATE('27/06/2016', 'DD/MM/YYYY'),'1',20,43.4, TO_DATE('21/08/2020', 'DD/MM/YYYY'),'L');
INSERT INTO Livro VALUES (555,'A HORA DA ESTRELA','ROCCO','RIO DE JANEIRO', TO_DATE('04/08/1998', 'DD/MM/YYYY'),'3',10,11.9, TO_DATE('21/08/2020', 'DD/MM/YYYY'),'L');
INSERT INTO Livro VALUES (777,'Contabilidade para ADS', 'Editora OK','Sorocaba', TO_DATE('20/01/2011', 'DD/MM/YYYY'), 1, 30,25.99, TO_DATE('15/08/2018', 'DD/MM/YYYY'), 'N');
INSERT INTO Livro VALUES (1010,'Contabilidade ADS - Parte II ', 'Editora OK','Sorocaba', TO_DATE('20/01/2011', 'DD/MM/YYYY'), 1, 30,25.99, TO_DATE('15/08/2018', 'DD/MM/YYYY'), 'N');
INSERT INTO Livro VALUES(750,'Inferno','Editora Arqueiro','São Paulo',TO_DATE('01/01/2013', 'DD/MM/YYYY'), 1, NULL, 67.00, SYSDATE,'N');

INSERT INTO AutorLivro VALUES(888,111);
INSERT INTO AutorLivro VALUES(999,222);
INSERT INTO AutorLivro VALUES(777, 333);
INSERT INTO AutorLivro VALUES(1010, 333);

-- Exibe os livros com seus respectivos assuntos e descrição;
SELECT L.CodigoLivro, L.Titulo, A.Descricao, A.CodAssunto FROM Livro L

INNER JOIN ASSUNTO A ON L.CodAssunto = A.CodAssunto
ORDER BY L.CodigoLivro DESC;

-- Exibe todos os livros que tem o código do assunto informado e os que não tem;
SELECT L.CodigoLivro, L.Titulo, L.CodAssunto AS Livro_CodAssunto, A.CodAssunto, A.Descricao FROM Livro L

LEFT JOIN Assunto A ON L.CodAssunto = A.CodAssunto;

-- Exibe todos os livros que tem o código do assunto informado e os dados dos assuntos que não tem livros cadastrados;
SELECT L.CodigoLivro, L.Titulo, L.CodAssunto AS Livro_CodAssunto, A.CodAssunto, A.Descricao FROM Livro L

RIGHT JOIN Assunto A ON L.CodAssunto = A.CodAssunto;

-- Combinação do LEFT JOIN e o RIGHT JOIN;
SELECT L.CodigoLivro, L.Titulo, L.CodAssunto AS Livro_CodAssunto, A.CodAssunto, A.Descricao FROM Livro L

FULL OUTER JOIN Assunto A ON L.CodAssunto = A.CodAssunto;

-- Executa o LEFT JOIN e depois seleciona só as linhas onde a chave da direita é nula;
-- LEFT EXCLUDING JOIN
SELECT L.CodigoLivro, L.Titulo, L.CodAssunto AS Livro_CodAssunto, A.CodAssunto, A.Descricao FROM Livro L

LEFT JOIN Assunto A ON L.CodAssunto = A.CodAssunto

WHERE A.CodAssunto IS NULL;

-- Executa o RIGHT JOIN e depois seleciona só as linhas onde a chave da esqueda é nula;
-- RIGHT EXCLUDING JOIN
SELECT L.CodigoLivro, L.Titulo, L.CodAssunto AS Livro_CodAssunto, A.CodAssunto, A.Descricao FROM Livro L

RIGHT JOIN Assunto A ON L.CodAssunto = A.CodAssunto

WHERE A.CodAssunto IS NULL;

-- Executa o RIGHT JOIN e o LEFT JOIN e depois seleciona só as linhas onde a chave da esqueda é nula;
-- OUTER EXCLUDING JOIN
SELECT L.CodigoLivro, L.Titulo, L.CodAssunto AS Livro_CodAssunto, A.CodAssunto, A.Descricao FROM Livro L

FULL OUTER JOIN Assunto A ON L.CodAssunto = A.CodAssunto

WHERE A.CodAssunto IS NULL OR A.CodAssunto IS NULL;