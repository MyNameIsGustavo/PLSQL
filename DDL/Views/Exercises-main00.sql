CREATE TABLE Paciente
(   Codpaciente number(4,0) not null,
    Nompaciente varchar2(30) not null,
    Datanasc date,
    Sexo char( 1 ) check (sexo in ( 'F',  'M' )),
    Endereco varchar2(25),
    constraint pk_codpaciente Primary Key (codpaciente)
);

CREATE TABLE Medico
(   Codmedico number(4,0) not null,
    nommedico varchar2(30) not null,
    constraint pk_codmedico Primary Key (codmedico)
);

CREATE TABLE Consulta
(   Codconsulta number(3,0) not null,
    Dataconsulta date,
    Codpaciente number(4,0) Not Null,                   
    Codmedico number(4,0) Not Null,
    Valconsulta number(5,0) Not Null,
    constraint pk_codconsulta Primary Key (codconsulta)
);

ALTER TABLE Consulta ADD (constraint fk_codpaciente Foreign Key (codpaciente) references Paciente (codpaciente) on delete cascade);
ALTER TABLE Consulta ADD (constraint fk_codmedico Foreign Key (codmedico) references Medico (codmedico) on delete cascade);

ALTER TABLE  Paciente  ADD (cidpaciente varchar2(15)   Not   Null );
ALTER TABLE  Paciente  MODIFY (cidpaciente varchar2(20));
ALTER TABLE  Paciente  ADD (desconto varchar2(01) check (desconto in ('S','N' )));
ALTER TABLE  Consulta  ADD (Tipoconsulta char (1) check (tipoconsulta in ('C', 'P')));
ALTER TABLE  Consulta  MODIFY (Valconsulta number(7,2));
 
INSERT INTO Paciente VALUES (001, 'Joao da Silva', TO_DATE('01-09-1957', 'DD-MM-YYYY'),'M','Rua das Flores, 301', 'Sorocaba','S');
INSERT INTO Paciente VALUES (002, 'Henrique Matias',TO_DATE('25-01-1960', 'DD-MM-YYYY'),'M','Av. das Margaridas, 112', 'Sorocaba','S');
INSERT INTO Paciente VALUES (003, 'Clara das Neves',TO_DATE('20-01-1978', 'DD-MM-YYYY'),'F','Rua Manoel Bandeira, 1100', 'Itu','S');
INSERT INTO Paciente VALUES (004, 'Joao Pessoa',TO_DATE('15-10-1945', 'DD-MM-YYYY'),'M','Rua Maria Machado, 800', 'Salto','N');
INSERT INTO Paciente VALUES (005, 'Karla da Cruz',TO_DATE('29-12-1939', 'DD-MM-YYYY'),'F','Av. Brasil, 701', 'Avare','S');
INSERT INTO Paciente VALUES (006, 'Jandira Gomes',TO_DATE('18-02-1940', 'DD-MM-YYYY'),'F','Rua Jardim Florido, 1152', 'Sorocaba','N');
INSERT INTO Paciente VALUES (007, 'Ana Maria Faracco',TO_DATE('13-08-1980', 'DD-MM-YYYY'),'F','Rua Jose Vieira, 65', 'Sorocaba','S');
INSERT INTO Paciente VALUES (008, 'Roberto Faracco',TO_DATE('01-01-1978', 'DD-MM-YYYY'),'M','Rua Jose Vieira, 65', 'Sorocaba','S');
INSERT INTO Paciente VALUES (009, 'Barbara Moreira',TO_DATE('30-09-1969', 'DD-MM-YYYY'),'F','Rua das Pedras, 127', 'Sao Paulo','N');
INSERT INTO Paciente VALUES (010, 'Norberto Almeida',TO_DATE('27-11-1937', 'DD-MM-YYYY'),'M','Rua Capitao Pereira, 170', 'Itapetininga','S');

INSERT INTO Medico VALUES (001, 'Ronaldo Bueno');
INSERT INTO Medico VALUES (002, 'Helena Silva');
INSERT INTO Medico VALUES (003, 'Paulo Cesar Oliveira');
INSERT INTO Medico VALUES (004, 'Roberto Silva');

INSERT INTO Consulta VALUES (001,'20-JAN-2022',001,003,80.00,'C');
INSERT INTO Consulta VALUES (002,'22-FEB-2022',001,003,80.00,'C');
INSERT INTO Consulta VALUES (003,'15-OCT-2021',002,001,75.50,'P');
INSERT INTO Consulta VALUES (004,'07-DEC-2021',003,002,60.75,'P');
INSERT INTO Consulta VALUES (005,'18-NOV-2021',004,004,57.80,'C');
INSERT INTO Consulta VALUES (006,'27-JUN-2021',005,001,60.00,'C');
INSERT INTO Consulta VALUES (007,'30-JUL-2020',005,001,60.00,'C');
INSERT INTO Consulta VALUES (008,'15-AUG-2022',006,003,75.20,'P');

--01. Crie uma visão que possua: Código do medico, código do paciente e a data da consulta acrescentada em 30 dias (retorno).
CREATE VIEW agendamentoConsulta AS 
SELECT M.Codmedico, C.Codpaciente, C.Dataconsulta FROM Medico M
INNER JOIN Consulta C ON M.Codmedico = C.Codmedico;

SELECT Dataconsulta+30 FROM agendamentoConsulta;
--02. Crie uma visão que possua: nome do medico,código da consulta e  dataconsulta.
CREATE VIEW dadosConsulta AS
SELECT M.nommedico, C.Codconsulta, C.Dataconsulta FROM Medico M
INNER JOIN Consulta C ON M.Codmedico = C.Codmedico;

SELECT * FROM dadosConsulta;
--03. Crie uma visão que exiba o código do medico e o valor total de suas consultas.
CREATE VIEW valorTotalConsulta AS
SELECT Codmedico, valConsulta FROM Consulta;

SELECT Codmedico, SUM(valConsulta) FROM valorTotalConsulta
GROUP BY Codmedico;
--04. Crie uma visão que exiba o código do medico, o nome do medico  e o valor médio de suas consultas.
CREATE VIEW valorMedioConsulta AS
SELECT M.Codmedico, M.nommedico, C.Valconsulta FROM Medico M
INNER JOIN Consulta C ON M.Codmedico = C.Codmedico;

SELECT Codmedico AS Codigo_Medico, nommedico AS Nome_Medico, ROUND(AVG(Valconsulta), 1) AS Valor_Medio_Consulta FROM valorMedioConsulta
GROUP BY Codmedico, nommedico;

--05. Listar o nome de todas as visões que tem a string “SOR’ no nome.
-- Exercicio alterado por causa dos nomes das visoes.
SELECT view_name AS NOME_VISOES FROM all_views
WHERE view_name LIKE '%CONSULTA%';
-- OU --
SELECT view_name AS NOME_VISOES FROM all_views
WHERE view_name LIKE '%SOR%';