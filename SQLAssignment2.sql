--Chunxi Wang Assignment2
--1.	What is a result set?
--			The set of rows return from specific queries; 

--2.	What is the difference between Union and Union All?
--			Union All will combine the result set of two or more SELECT statements and allow duplicate values;
--			However, Union will only selects distinct values;

--3.	What are the other Set Operators SQL Server has?
--			EXCLUDE; UNION; UNION ALL; INTERSECT, MINUS;

--4.	What is the difference between Union and Join?
--			Join will combine columns, union will combine rows; 

--5.	What is the difference between INNER JOIN and FULL JOIN?
--			Inner join will only return records that matches values in both table; 
--			Full join will return all the records that matches in both table;

--6.	What is difference between left join and outer join
--			Left join will return all the records that matches in the left table and records that matches values in the right table;
--			Outer join contains left join, right join and full join. 

--7.	What is cross join?
--			Cross join returns the Cartesian product of the sets of records from the two joined tables;

--8.	What is the difference between WHERE clause and HAVING clause?
--			WHERE clause can be used alone, HAVING clause should used with GROUP BY clause;
--			WHERE clause cannot use with aggregate functions but HAVING can;

--9.	Can there be multiple group by columns?
--			Yes, it can. That will create a unique combination of multiple columns. 

USE AdventureWorks2019
GO
--Problem1
SELECT COUNT ([ProductID]) AS NumberOfProduct
FROM Production.Product;

--Problem2
SELECT COUNT ([ProductID]) AS NumberOfProduct
FROM Production.Product
WHERE ProductSubcategoryID is not null;

--Problem3
SELECT DISTINCT ProductSubcategoryID, Count (ProductSubcategoryID) AS CountedProducts
FROM Production.Product
GROUP BY ProductSubcategoryID
HAVING ProductSubcategoryID is not null;

--Problem4
SELECT COUNT ([ProductID]) AS NumberOfProduct
FROM Production.Product
WHERE ProductSubcategoryID is null;

--Problem5
SELECT p.ProductID, SUM (p.Quantity) AS TotalAmount
FROM Production.ProductInventory p
GROUP BY p.ProductID;

--Problem6
SELECT p.ProductID, SUM (p.Quantity) AS TheSum
FROM Production.ProductInventory p
WHERE p.LocationID=40
GROUP BY p.ProductID
HAVING SUM(p.Quantity)<100;

--Problem7
SELECT p.Shelf, p.ProductID, SUM (p.Quantity) AS TheSum
FROM Production.ProductInventory p
WHERE p.LocationID=40
GROUP BY p.ProductID, p.Shelf
HAVING SUM(p.Quantity)<100;

--Problem8
SELECT p.ProductID, AVG(p.Quantity) AS Average
FROM Production.ProductInventory p
WHERE p.LocationID=10
GROUP BY p.ProductID;

--Problem9
SELECT p.ProductID, p.Shelf, AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
GROUP BY p.ProductID, p.Shelf;

--Problem10
SELECT p.ProductID, p.Shelf, AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
WHERE p.Shelf != 'N/A'
GROUP BY p.ProductID, p.Shelf;

--Problem11
SELECT p.Color, p.Class, COUNT(*) AS TheCount, AVG(p.ListPrice) AS AvgPrice
FROM Production.Product p
WHERE (p.Color is not null) OR (p.Class is not null)
GROUP BY p.Color, p.Class;

--Problem12
SELECT C.CountryRegionCode AS Country, S.StateProvinceCode AS Province
FROM Person.CountryRegion C inner JOIN Person.StateProvince S
ON C.Name = S.Name;

--Problem13
SELECT C.CountryRegionCode AS Country, S.StateProvinceCode AS Province
FROM Person.CountryRegion C inner JOIN Person.StateProvince S
ON C.CountryRegionCode = S.CountryRegionCode
WHERE C.CountryRegionCode='CA' OR C.CountryRegionCode='DE';

USE Northwind
GO
--Problem14
SELECT p.ProductName, o.OrderDate
FROM Orders o Inner JOIN [Order Details] d 
ON o.OrderID=d.OrderID
JOIN Products p
ON d.ProductID=p.ProductID
WHERE DATEDIFF(year, o.OrderDate,GETDATE())>=25 and o.OrderID is not null;

--Problem15
SELECT top 5 c.postalcode
FROM customers c inner join 
(SELECT o.CustomerID,od.ProductID,od.Quantity
	FROM orders o 
	inner join[Order Details] od ON o.orderid=od.orderid) M 
ON c.CustomerID=M.customerid
WHERE PostalCode is not null
GROUP BY c.postalcode
ORDER BY SUM (Quantity) DESC;

--Problem16
SELECT top 5 c.postalcode
FROM customers c inner join 
(SELECT o.CustomerID,od.ProductID,od.Quantity, o.OrderDate
	FROM orders o 
	inner join[Order Details] od ON o.orderid=od.orderid) M 
ON c.CustomerID=M.customerid
WHERE DATEDIFF(year, M.OrderDate,GETDATE())<=20
	AND PostalCode is not null
GROUP BY c.postalcode
ORDER BY SUM (Quantity) DESC;

--Problem17
SELECT c.City, COUNT(c.CustomerID) AS CustomerNumber
FROM Customers c
GROUP BY c.CustomerID, c.City;

--Problem18
SELECT c.City, COUNT(c.CustomerID) AS CustomerNumber
FROM Customers c
GROUP BY c.CustomerID, c.City
HAVING COUNT(c.CustomerID)>10;

--Problem19
SELECT c.ContactName, o.OrderDate
FROM Customers c inner join Orders o
ON c.CustomerID=o.CustomerID
WHERE DATEDIFF(day, '1998-1-1', o.OrderDate)>0 and o.OrderID is not null;

--Problem20
SELECT top 1 c.ContactName
FROM Customers c inner join Orders o
ON c.CustomerID=o.CustomerID
ORDER BY o.OrderDate DESC;

--Problem21
SELECT c.ContactName, SUM(od.Quantity) AS CountOfProducts
FROM Customers c inner join Orders o
ON c.CustomerID=o.CustomerID
inner join [Order Details] od 
ON o.OrderID=od.OrderID
GROUP BY C.ContactName;

--Problem22
SELECT c.ContactName, SUM(od.Quantity) AS CountOfProducts
FROM Customers c inner join Orders o
ON c.CustomerID=o.CustomerID
inner join [Order Details] od 
ON o.OrderID=od.OrderID
GROUP BY C.ContactName
HAVING SUM(od.Quantity)>100;

--Problem23
SELECT su.CompanyName AS [Supplier Company Name], sh.CompanyName AS [Shipping Company Name]
FROM Suppliers su inner join Shippers sh 
ON su.SupplierID=sh.ShipperID;

--Problem24
SELECT o.OrderDate, p.ProductName
FROM Orders o
inner join [Order Details] od 
ON o.OrderID=od.OrderID
inner join Products p
ON od.ProductID=p.ProductID
GROUP BY o.OrderDate, p.ProductName;

--Problem25
SELECT e1.FirstName +  ' ' + e1.LastName AS EmployeeName1, 
	e2.FirstName +  ' ' + e2.LastName AS EmployeeName2
FROM Employees e1, Employees e2
WHERE e1.Title=e2.Title;

--Problem26
SELECT FirstName +  ' ' + LastName AS ManagerName
FROM Employees
WHERE ReportsTo>=2;

--Problem27
DECLARE @type AS VARCHAR(10)='Customer'
DECLARE @type1 AS VARCHAR(10)='Supplier'
SELECT c.City, c.CompanyName AS Name, c.ContactName, @type AS Type
FROM Customers c 
UNION all
SELECT s.City, s.CompanyName AS Name, s.ContactName, @type1 AS type
FROM Suppliers s

--Problem28
--SELECT *
--FROM T1 inner join T2
--ON T1's coloum number = T2's row number

--The result will be [2, 3]

--Problem29
--SELECT *
--FROM T1 left join T2
--ON T1's coloum number = T2's row number

--The result will be [1, 2, 3]
