CREATE TABLE TB_Funcionario
(   CodFunc number(5) PRIMARY KEY,
    NomeFunc varchar2(30),
    Sexo char(1),
    DataAdmissao date,
    Salario number(7,2)
)

CREATE TABLE TB_Projeto
(   CodProjeto number(3) PRIMARY KEY,
    Descricao varchar2(30)
)

CREATE TABLE TB_FuncProj
(   CodFunc number(5) REFERENCES TB_Funcionario,
    CodProjeto number(3) REFERENCES TB_Projeto,
    TempoAlocacao number(2),
    BonusSalario number(7,2),
    PRIMARY KEY(CodFunc, CodProjeto)
)

INSERT INTO TB_Funcionario VALUES(1, 'Roger Guedes', 'M', to_date('01-01-2023', 'DD-MM-YYYY'), 1500);
INSERT INTO TB_Funcionario VALUES(2, 'Yuri Alberto', 'M', to_date('01-03-2023', 'DD-MM-YYYY'), 1500);
INSERT INTO TB_Funcionario VALUES(3, 'Renato Augusto', 'M', to_date('01-05-2023', 'DD-MM-YYYY'), 1500);
SELECT * FROM TB_Funcionario;

INSERT INTO TB_Projeto VALUES(1, 'APP CARONA');
INSERT INTO TB_Projeto VALUES(2, 'VAMO REPROVAR EM LBD');
INSERT INTO TB_Projeto VALUES(3, 'RESPONDA MEU EMAIL');
INSERT INTO TB_Projeto VALUES(4, 'PQ CHORAS ROCHA');
SELECT * FROM TB_Projeto;

INSERT INTO TB_FuncProj VALUES(1, 1, 5, 10);
INSERT INTO TB_FuncProj VALUES(2, 2, 9, 11);
INSERT INTO TB_FuncProj VALUES(3, 3, 7, 12);
INSERT INTO TB_FuncProj VALUES(3, 1, 7, 12);
INSERT INTO TB_FuncProj VALUES(3, 2, 7, 12);
SELECT * FROM TB_FuncProj;

-- 01. Listar o código do funcionario, nome do funcionario e a quantidade de projetos que ele está alocado, 
-- mas só para os funcionarios alocados em mais de 2 projetos.
SELECT  F.NomeFunc, F.CodFunc, COUNT(FP.CodFunc) AS Projetos FROM TB_Funcionario F
INNER JOIN TB_FuncProj FP ON F.CodFunc = FP.CodFunc
GROUP BY F.CodFunc, F.NomeFunc HAVING COUNT(FP.CodFunc) > 2;

-- 02. Alterar o campo BonusSalario para 200,00 para todos os funcionarios que trabalham no projeto de descrição = 'APP CARONA';
UPDATE TB_FuncProj FP SET BonusSalario = 200 WHERE FP.CodProjeto IN
(	SELECT P.CodProjeto AS Codigo_Func FROM TB_Projeto P
    INNER JOIN TB_FuncProj FP ON P.CodProjeto = FP.CodProjeto
    WHERE P.Descricao LIKE '%APP CARONA%'
);

-- 03. Listar o código do projeto que não tem funcionarios alocados criando comandos nas 3 formas:
-- 03[A]: Usando o operador NOT IN.
SELECT P.CodProjeto FROM TB_Projeto P
WHERE P.CodProjeto NOT IN (SELECT FP.CodProjeto FROM TB_FuncProj FP);

-- 03[B]: Usando o operador NOT EXISTS.
SELECT P.CodProjeto FROM TB_Projeto P
WHERE NOT EXISTS(SELECT FP.CodProjeto FROM TB_FuncProj FP WHERE FP.CodProjeto = P.CodProjeto);

--03[C]: Usando o operador MINUS(ou except).
SELECT P.CodProjeto FROM TB_projeto P
MINUS
SELECT FP.CodProjeto FROM TB_FuncProj FP;

-- 03[D]: Usando o operador EXISTS.
SELECT F.CodFunc,  F.NomeFunc, P.CodProjeto FROM TB_Projeto P
INNER JOIN TB_FuncProj FP ON FP.CodProjeto = P.CodProjeto
INNER JOIN TB_Funcionario F ON FP.CodFunc = F.CodFunc
WHERE F.CodFunc = 3 AND F.CodFunc 
NOT IN (SELECT F.CodFunc FROM TB_Funcionario F WHERE F.CodFunc <> 3);

	--- Exercicios Extras ---

-- Retornar apenas os códigos dos projetos que tem funcionarios.
SELECT P.CodProjeto from TB_Projeto P
WHERE EXISTS(SELECT 'a' FROM TB_FuncProj FP WHERE P.CodProjeto = FP.CodProjeto);

-- Retornar os funcionarios que mais estão em projetos.
SELECT FP.CodFunc, F.NomeFunc, COUNT(*) AS QTDE_Projeto FROM TB_Funcionario F
INNER JOIN TB_FuncProj FP ON FP.CodFunc = F.CodFunc
GROUP BY FP.CodFunc, F.NomeFunc 
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM TB_FuncProj FP GROUP BY FP.CodFunc);