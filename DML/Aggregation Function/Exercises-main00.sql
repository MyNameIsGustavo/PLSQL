CREATE TABLE AGREGACAO
(   NF Number(3),
    Produto Varchar2(100),
    Cliente Varchar2(100),
    Quantidade Number(3),
    Valor Number(7,2),
    Dia Number(2)
);

INSERT INTO AGREGACAO VALUES (1,'P001','C1', 8, 160, 5);
INSERT INTO AGREGACAO VALUES (1,'P002','C2', 2, 34, 5);
INSERT INTO AGREGACAO VALUES (1,'P003','C1', 1, 58, 5);
INSERT INTO AGREGACAO VALUES (2,'P002','C3', 20, 340, 7);
INSERT INTO AGREGACAO VALUES (3,'P002','C2', 5, 85, 8);
INSERT INTO AGREGACAO VALUES (3,'P002','C2', 5, 85, 8);
INSERT INTO AGREGACAO VALUES (4,'P001','C1', 2, 40, 10);
INSERT INTO AGREGACAO VALUES (5,'P003','C3', 4, 232, 15);

-- Somar todos os valores;
SELECT SUM(Valor) FROM AGREGACAO;

-- Somar todos os valores do cliente C1;
SELECT SUM(Valor) FROM AGREGACAO
WHERE Cliente = 'C1';

-- Contar a quantidade de itens(inserts);
SELECT COUNT(*) FROM AGREGACAO;

-- Contar todos os valores do cliente C2;
SELECT COUNT(*) FROM AGREGACAO 
WHERE Cliente = 'C2';

-- Calcular o valor médio de todos os itens com precisão de 1 casa decimal;
SELECT ROUND(AVG(Valor), 1) AS Valor_Media_Itens FROM AGREGACAO;

-- Calcular o valor médio do cliente C1 nenhuma precisão de casas decimais;
SELECT ROUND(AVG(Valor), 0) AS Valor_Medio_C1 FROM AGREGACAO
WHERE Cliente = 'C1';

-- Calcular o menor valor e o maior valor de todos os itens;
SELECT MIN(Valor) AS Menor_Valor, MAX(Valor) AS Maior_Valor FROM AGREGACAO;

-- Calcular o menor valor e o maior valor do cliente C1;
SELECT MIN(Valor) AS Menor_Valor, MAX(Valor) AS Maior_Valor FROM AGREGACAO
WHERE Cliente = 'C1';

-- Realizar a soma de cada um dos clientes separadamente;
SELECT Cliente, SUM(Valor) AS Soma_Valores FROM AGREGACAO
GROUP BY Cliente;

-- Realizar a soma dos valores do cliente C2 separadamente;
SELECT Cliente, SUM(Valor) AS Soma_Valores FROM AGREGACAO
WHERE Cliente = 'C2'
GROUP BY Cliente;

-- Contar a quantidade total de itens por NF;
SELECT NF, COUNT(*) FROM AGREGACAO
GROUP BY NF;

-- Calcular o valor médio por NF;
SELECT NF, AVG(Valor) AS Valor_Medio FROM AGREGACAO 
GROUP BY NF;

-- Obter o menor e o maior valor por NF;
SELECT NF, MIN(Valor), MAX(Valor) FROM AGREGACAO
GROUP BY NF;

-- Realizar a soma de cada um dos clientes separadamente e contar a quantidade de itens e ordernar o valor;
SELECT Cliente, COUNT(*) FROM AGREGACAO
GROUP BY Cliente
ORDER BY SUM(Valor) DESC;

-- Obter todos os clientes onde a soma dos valores seja superior a 300;
SELECT Cliente, SUM(Valor), COUNT(*) AS REGISTROS FROM AGREGACAO
GROUP BY Cliente
HAVING(SUM(Valor) > 300);

-- Obter todos os clientes que possuem mais de 2 registros;
SELECT Cliente, COUNT(*) AS REGISTROS FROM AGREGACAO
GROUP BY Cliente
HAVING(COUNT(*) > 2);