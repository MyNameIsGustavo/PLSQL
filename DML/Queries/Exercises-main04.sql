CREATE TABLE TipoMulta
(   codtipoMulta  number(3) primary key,
    descricaoTipo Varchar2(20)
);

CREATE TABLE Veiculo
(   placaVeiculo char(7) primary key,
    modelo varchar2(20),
    anoveiculo date,
    cor varchar2(15)
);

CREATE TABLE Motorista 
(   CNH number(6) primary key, 
    NomeMotorista  varchar2(40), 
    Sexo Char(1) check (sexo in ('F', 'M')), 
    CidadeNasc varchar2(25), 
    DataNasc date,
    Email varchar2 (30),
    Situacao Char(1)
);

CREATE TABLE Multa
(   NumMulta number(6), 
    DataMulta date,
    CNH number(6),
    PlacaVeiculo  char(7), 
    Pontuacao number(2),  
    codTipoMulta number(2),
    ValorMulta number(5,2)
);

INSERT INTO VEICULO VALUES ('GEE2345','HB20 HATCH','01/01/2017', 'Branco');
INSERT INTO VEICULO VALUES ('FTZ8809','HB20','01/01/2019', 'Azul');
INSERT INTO VEICULO VALUES ('GHT','GOLF','01/01/2021', 'Prata');

INSERT INTO TIPOMULTA VALUES (100,'GRAVE');
INSERT INTO TIPOMULTA VALUES (120,'GRAVÍSSIMA');
INSERT INTO TIPOMULTA VALUES (130,'LEVE');

INSERT INTO MOTORISTA VALUES (11111, 'Henrique Silva', 'M', 'Sorocaba', '09/05/2000', 'henriquesilva@gmail.com', 'S');
INSERT INTO MOTORISTA VALUES (22222, 'Ricardo Silva Santos', 'M', 'Votorantim', '02/07/1997', 'ricardoss@gmail.com', 'N');
INSERT INTO MOTORISTA VALUES (33333, 'Larissa Santos Oliveira', 'F', 'Sorocaba', '15/04/1995', 'larissasolive@uol.com', 'N');
INSERT INTO MOTORISTA VALUES (44444, 'Carla Augusta', 'F', 'Votorantim', '05/04/2002', 'Carla@uol.com', 'N');
INSERT INTO MOTORISTA VALUES (55555, 'Carlos Oliveira Santos', 'M', 'Votorantim', '05/04/2003', 'Carlao@uol.com', 'N');
			
-- A tabela Multa possui 1 chave primária e 3 chaves estrangeiras, porém estas não estão no script apresentado. Usando o comando Alter table, crie estas chaves dando nome às constraints.
ALTER TABLE Multa ADD CONSTRAINT PK_Multa_NumMulta PRIMARY KEY (NumMulta);

ALTER TABLE Multa ADD CONSTRAINT FK_Multa_TipoMulta FOREIGN KEY (codtipoMulta) REFERENCES TipoMulta;
ALTER TABLE Multa ADD CONSTRAINT FK_Multa_Veiculo FOREIGN KEY (placaVeiculo) REFERENCES Veiculo;
ALTER TABLE Multa ADD CONSTRAINT FK_Multa_Motorista FOREIGN KEY (CNH) REFERENCES Motorista;

--Inserir 4 linhas na tabela de Multas.  Pelo menos 2 multas devem ter o codtipomulta com o valor 120.
ALTER TABLE Multa MODIFY codTipoMulta Number(3);

INSERT INTO MULTA VALUES(123456, '01/01/2001', 11111, 'GEE2345', 1, 120, 100);
INSERT INTO MULTA VALUES(123455, '02/01/2001', 22222, 'FTZ8809', 2, 120, 110);
INSERT INTO MULTA VALUES(123454, '03/01/2001', 33333, 'GHT', 3, 100, 120);
INSERT INTO MULTA VALUES(123453, '04/01/2001', 44444, 'FTZ8809', 4, 130, 130);

--Eliminar o campo email na tabela de Motorista. 
ALTER TABLE Motorista DROP COLUMN Email;

--Alterar o campo ValorMulta da tabela de Multa para aceitar 5  inteiros e 2 decimais.
ALTER TABLE Multa MODIFY ValorMulta Number(7,2); 

--Adicionar o campo DataCNH na tabela de motorista.
ALTER TABLE Motorista ADD DataCNH DATE;

--Excluir as multas que possuam o valor da multa nulo.
DELETE Multa 
WHERE ValorMulta is NULL;

--Atualizar o atributo cor da tabela de veiculo para ‘Vermelho’ e Modelo = ‘Creta’ para o veiculo de placa = 'GEE2345';
UPDATE Veiculo 
SET cor='Vermelho' 
WHERE modelo ='Creta' and placaVeiculo = 'GEE2345';

-- Exibir todos os atributos dos motoristas que possuem  ‘Santos’ no final do nome. 
SELECT * FROM Motorista 
WHERE NomeMotorista LIKE '%Santos';

-- Exibir o nome  de todos os motoristas do sexo masculino e que moram na cidade de Votorantim.  Mostrar o resultado ordenado pelo nome do motorista.
SELECT NomeMotorista FROM Motorista
WHERE Sexo = 'M' and CidadeNasc = 'Votorantim'
ORDER BY NomeMotorista;

-- Exibir a CNH, Nome do motorista e data de nascimento para todos os motoristas com menos de 25 anos (não fixar a data, usar Sysdate).
SELECT CNH, NomeMotorista, DataNasc FROM Motorista 
WHERE ((sysdate - DataNasc)) / 365.25 < 25;

-- Listar  o valor das Multas aumentado em 10% para as tuplas em que o campo CodTipoMulta = 120 e o campo Pontuação estiver entre 4 e 8 pontos. Colocar um cabeçalho para a coluna derivada.
SELECT ValorMulta * 1.1 "NovoValor" FROM Multa
WHERE CodTipoMulta = 120 and Pontuacao BETWEEN 4 AND 8;