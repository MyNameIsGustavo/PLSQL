CREATE TABLE Paciente
(   CodPaciente number(4) PRIMARY KEY,
    NomePaciente varchar2(30) NOT NULL,
    DataNasc date,
    Sexo char( 1 ) check (sexo in ( 'F',  'M' )),	
    Endereco varchar2(25) 
);

CREATE TABLE Medico
(   CodMedico number(4) PRIMARY KEY,
    NomeMedico varchar2(50)
);

CREATE TABLE Consulta
(   CodConsulta number(4) PRIMARY KEY,
    DataConsulta date,
    TipoCons char(01) check (tipocons in ('P','C')),
    CodPaciente number(4) NOT NULL REFERENCES PACIENTE,                   
    CodMedico number(4) NOT NULL REFERENCES MEDICO,
    ValConsulta number(7,2) NOT NULL
);

ALTER TABLE Paciente ADD (Cidade varchar2(15));
ALTER TABLE Paciente MODIFY (Cidade varchar2(20) Not Null);
ALTER TABLE Paciente ADD (Desconto char(01)check(Desconto in ('S','N' )));

INSERT INTO Medico VALUES (1,'DR. Yuri');
INSERT INTO Medico VALUES (2,'DR. Roger');
INSERT INTO Medico VALUES (3,'DR. Gil');

INSERT INTO Paciente VALUES (10,'Alberto',TO_DATE('01/05/2005', 'DD/MM//YYYY'),'M','Jardim Helena','Sorocaba','S');
INSERT INTO Paciente VALUES (11,'Martinelli',TO_DATE('09/01/2000','DD/MM//YYYY'),'M','Campolim','Votorantim','N');
INSERT INTO Paciente VALUES (12,'Gabriel',TO_DATE('05/03/2002','DD/MM//YYYY'),'M','Santa Rosalia','Ibiuna','S');

INSERT INTO Consulta VALUES (15,TO_DATE('15/03/2022','DD/MM//YYYY'),'P',10, 1,500);
INSERT INTO Consulta VALUES (16,TO_DATE('16/03/2022','DD/MM//YYYY'),'C',11, 2,969);
INSERT INTO Consulta VALUES (17,TO_DATE('17/02/2023','DD/MM//YYYY'),'C',12, 3,300);
INSERT INTO Consulta VALUES (18,TO_DATE('18/02/2023','DD/MM//YYYY'),'P',10, 1,500);
INSERT INTO Consulta VALUES (19,TO_DATE('19/05/2024','DD/MM//YYYY'),'P',11, 2,969);
INSERT INTO Consulta VALUES (20,TO_DATE('20/05/2024','DD/MM//YYYY'),'P',12, 3,300);

-- Listar o código do paciente, nome do paciente, código da consulta e data da consulta para todos 
-- os pacientes que tem consultas realizas;
SELECT P.CodPaciente, P.NomePaciente, C.TipoCons AS Consultas, C.CodConsulta, C.DataConsulta FROM Paciente P 
INNER JOIN Consulta C ON C.CodPaciente = P.CodPaciente;

-- Listar o código do paciente, nome do paciente, código da consulta e data da consulta para todos
-- os pacientes que tem consultas realizadas e para os que não tem;
SELECT P.CodPaciente, P.NomePaciente, C.TipoCons AS Consultas, C.CodConsulta, C.DataConsulta FROM Paciente PConsulta C
LEFT JOIN Consulta C ON C.CodPaciente = P.CodPaciente;

-- Listar somente os códigos e nomes dos pacientes que não tem consultas;
SELECT P.CodPaciente, P.NomePaciente FROM Paciente P
LEFT JOIN Consulta C ON P.CodPaciente = C.CodPaciente
WHERE C.CodConsulta IS NULL;

-- Listar o código das consultas, data consulta e o nome do médico para todos os médicos que tem 
-- consultas que para os que não tem;
SELECT C.CodConsulta, C.DataConsulta, M.NomeMedico FROM Consulta C
LEFT JOIN Medico M ON M.CodMedico = C.CodMedico;