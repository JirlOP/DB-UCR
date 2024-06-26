USE AdventureWorks2017

-- 6
SELECT * INTO dbo.SalesOrderHeader FROM Sales.SalesOrderHeader;
SELECT * INTO dbo.SalesOrderDetail FROM Sales.SalesOrderDetail;
SELECT * INTO dbo.SalesPerson FROM Sales.SalesPerson;

-- Ejercicio 1
-- a
SELECT ProductID
FROM Sales.SalesOrderDetail;
SELECT ProductID
FROM dbo.SalesOrderDetail;

-- e
-- Cree indice sobre 'dbo.SalesOrderDetail'
-- para mejorar el rendimiento de la consulta:
SELECT ProductID
FROM dbo.SalesOrderDetail;
CREATE INDEX IndexProductID ON dbo.SalesOrderDetail(ProductID);

-- f
SELECT ProductID
FROM Sales.SalesOrderDetail;
SELECT ProductID
FROM dbo.SalesOrderDetail;

-- g
-- Eliminar indice creado en 'e'

-- Ejercicio 2
-- a
SELECT *
FROM dbo.SalesOrderHeader
WHERE TotalDue BETWEEN 500 AND 40000;

-- d
-- crear indice sobre 'TotalDue' de la tabla 'dbo.SalesOrderHeader'
-- para mejorar el rendimiento de la consulta
CREATE INDEX IndexTotalDue ON dbo.SalesOrderHeader(TotalDue);


-- e
SELECT *
FROM dbo.SalesOrderHeader
WHERE TotalDue BETWEEN 500 AND 40000;

-- f
SELECT TotalDue
FROM dbo.SalesOrderHeader
WHERE TotalDue BETWEEN 500 AND 40000;

-- h 
SELECT SalesOrderID, TotalDue
FROM dbo.SalesOrderHeader
WHERE TotalDue BETWEEN 500 AND 40000;

-- j
-- Elimine indice creado en 'd'
-- Cree uno nuevo segun recomendacion de SQL Server
-- para mejorar el rendimiento de la consulta 'f'
CREATE INDEX TotalDueSalesOrderIDInxex ON dbo.SalesOrderHeader(TotalDue) 
	INCLUDE(SalesOrderID)

-- k
SELECT TotalDue
FROM dbo.SalesOrderHeader
WHERE TotalDue BETWEEN 500 AND 40000;

-- l
SELECT SalesOrderID, TotalDue
FROM dbo.SalesOrderHeader
WHERE ABS(TotalDue) BETWEEN 500 AND 40000;

-- n
SELECT SalesOrderID, TotalDue
FROM dbo.SalesOrderHeader
WHERE TotalDue BETWEEN 500 AND 40000;

SELECT SalesOrderID, TotalDue
FROM dbo.SalesOrderHeader
WHERE ABS(TotalDue) BETWEEN 500 AND 40000;

-- p
-- elimine indice creado en 'j'

-- Ejercicio 3
-- a
SELECT h.SalesOrderID, d.SalesOrderDetailID, h.SalesPersonID
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d
ON d.SalesOrderID = h.SalesOrderID
JOIN Sales.SalesPerson p
ON p.BusinessEntityID = h.SalesPersonID;

SELECT h.SalesOrderID, d.SalesOrderDetailID, h.SalesPersonID
FROM dbo.SalesOrderHeader h
JOIN dbo.SalesOrderDetail d
ON d.SalesOrderID = h.SalesOrderID
JOIN dbo.SalesPerson p
ON p.BusinessEntityID = h.SalesPersonID;

-- e
-- mejorar segunda consulta de 'a' creando indices
CREATE INDEX SalesOrderHeaderIndex ON dbo.SalesOrderHeader(SalesPersonID) -- h
	INCLUDE(SalesOrderID)
CREATE INDEX SalesOrderDetailIndex ON dbo.SalesOrderDetail(SalesOrderID,SalesOrderDetailID) -- d
CREATE INDEX SalesPersonIndex ON dbo.SalesPerson(BusinessEntityID) -- p


-- f
SELECT h.SalesOrderID, d.SalesOrderDetailID, h.SalesPersonID
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d
ON d.SalesOrderID = h.SalesOrderID
JOIN Sales.SalesPerson p
ON p.BusinessEntityID = h.SalesPersonID;

SELECT h.SalesOrderID, d.SalesOrderDetailID, h.SalesPersonID
FROM dbo.SalesOrderHeader h
JOIN dbo.SalesOrderDetail d
ON d.SalesOrderID = h.SalesOrderID
JOIN dbo.SalesPerson p
ON p.BusinessEntityID = h.SalesPersonID;

-- g
-- eliminar indices creados en 'e'

-- Ejercicio 4
-- a
SELECT SalesOrderID, SalesPersonID, ShipDate
FROM dbo.SalesOrderHeader WHERE
SalesPersonID IN
	(SELECT BusinessEntityID
	FROM dbo.SalesPerson
	WHERE TerritoryID > 5)
AND ShipDate > '2014-01-01'

-- c
-- reescribir 'a' para no tener consulta anidada

-- e
-- cree indices para mejorar la consulta de 'c'

-- f
-- vuelva a ejecutar 'c'
