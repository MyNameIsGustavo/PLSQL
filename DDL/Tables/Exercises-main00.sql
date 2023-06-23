CREATE TABLE Paciente
(   CodPaciente number(4) Primary  Key,
    NomePaciente varchar2(30) not null,
    DataNasc date,
    Sexo char( 1 ) check (sexo in ( 'F',  'M' )),	
    Endereco varchar2(25) 
);

CREATE TABLE Medico
(   CodMedico number(4) primary key,
    NomeMedico varchar2(50)
);

CREATE TABLE Consulta
(   CodConsulta number(4) Primary Key,
    DataConsulta date,
    TipoCons char(01) check (tipocons in ('P','C')),
    CodPaciente number(4) Not Null References Paciente,                   
    CodMedico number(4) Not Null References Medico ,
    ValConsulta number(7,2) Not Null 
);

ALTER TABLE  Paciente ADD (Cidade varchar2(15));
ALTER TABLE  Paciente MODIFY (Cidade varchar2(20) Not Null);
ALTER TABLE  Paciente ADD (Desconto char(01)check(Desconto in ('S','N' )));

INSERT INTO Medico VALUES (1,'DR. Yuri');
INSERT INTO Medico VALUES (2,'DR. Roger');
INSERT INTO Medico VALUES (3,'DR. Gil');

INSERT INTO Paciente VALUES (10,'Alberto','01/05/2005','M','Jardim Helena','Sorocaba','S');
INSERT INTO Paciente VALUES (11,'Martinelli','09/01/2000','M','Campolim','Votorantim','N');
INSERT INTO Paciente VALUES (12,'Gabriel','05/03/2002','M','Santa Rosalia','Ibiuna','S');

INSERT INTO Consulta VALUES (15,'15/03/2022','P',10, 1,500);
INSERT INTO Consulta VALUES (16,'16/03/2022','C',11, 2,969);
INSERT INTO Consulta VALUES (17,'17/02/2023','C',12, 3,300);
INSERT INTO Consulta VALUES (18,'18/02/2023','P',10, 1,500);
INSERT INTO Consulta VALUES (19,'19/05/2024','P',11, 2,969);
INSERT INTO Consulta VALUES (20,'20/05/2024','P',12, 3,300);