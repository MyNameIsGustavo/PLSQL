CREATE TABLE MyTable
(   ID_Cliente number(5)primary key,
    Nome_Cliente varchar2(40) not null,
    CPF_Cliente varchar2(11) not null,
    DataNasc_Cliente date,
    Sexo_Cliente char(1)
);

INSERT INTO MyTable VALUES(1,'Gustavo Rocha','12345678912','12/03/2003','M');
ALTER TABLE MyTable MODIFY CPF_cliente varchar2(14);
INSERT INTO MyTable VALUES(2,'@Gu_Rocha','123.456.789/12','13/03/2003','M');

SELECT * FROM MyTable;

SELECT ID_Cliente, Nome_Cliente FROM MyTable WHERE Sexo_Cliente = 'M'; 