--ChunxiWang SQL Assignment4

--1.What is View? What are the benefits of using views?
--View is the result set of a stored query on the data, which the database users can query just as they would in a persistent database collection object.

--2.Can data be modified through views?
--A view can be used in a query that updates data, subject to a few restrictions.

--3.What is stored procedure and what are the benefits of using it?
--A stored procedure is a prepared SQL code that you can save, so the code can be reused over and over again;
--By grouping SQL statements, a stored procedure allows them to be executed with a single call.

--4.What is the difference between view and stored procedure?
--View is simple showcasing data stored in the database tables whereas a stored procedure is a group of statements that can be executed.

--5.What is the difference between stored procedure and functions?
--The function must return a value but in Stored Procedure it is optional.

--6.Can stored procedure return multiple result sets?
--Yes, It can. Most stored procedures return multiple result sets. 

--7.Can stored procedure be executed as part of SELECT Statement? Why?
--Stored procedures are typically executed with an EXEC statement. 
--However, you can execute a stored procedure implicitly from within a SELECT statement, provided that the stored procedure returns a result set.

--8.What is Trigger? WhatS types of Triggers are there?
--A trigger is a special type of stored procedures that is automatically executed when an event occurs in a specific database server. 
--There are two types of triggers: the DML Triggers and the DDL triggers.

--9.What are the scenarios to use Triggers?
--We can have a trigger activate before each row that is inserted into a table or after each row that is updated.

--10.What is the difference between Trigger and Stored Procedure?S
--Trigger and Procedure both perform a specified task on their execution. 
--Trigger executes automatically on occurrences of an event whereas, the Procedure is executed when it is explicitly invoked.

USE Northwind
GO

--Problem1
SELECT * FROM Region
INSERT INTO Region(RegionID, RegionDescription) VALUES(5, 'Middle Earth')

SELECT * FROM Territories
INSERT INTO Territories(TerritoryID, TerritoryDescription, RegionID) VALUES(98200, 'Gondor', 5)

SELECT * FROM Employees
SET IDENTITY_INSERT Employees ON
INSERT INTO Employees(EmployeeID, LastName, FirstName) VALUES(10, 'Aragorn', 'King')
SELECT * FROM EmployeeTerritories
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES(10, 98200)

--Problem2
UPDATE Territories
SET TerritoryDescription='Arnor'
WHERE TerritoryID=98200;

--Problem3
DELETE FROM EmployeeTerritories
WHERE TerritoryID=98200
DELETE FROM Territories
WHERE RegionID=5
DELETE FROM Region
WHERE RegionID=5;

--Problem4
CREATE VIEW view_product_order_chunxiwang AS
SELECT Products.ProductName, SUM([Order Details].Quantity) AS TotalAmount
FROM Products inner JOIN [Order Details] 
ON Products.ProductID=[Order Details].ProductID
inner JOIN Orders
ON [Order Details].OrderID=Orders.OrderID
GROUP BY Products.ProductName;

--Problem5
CREATE PROC sp_product_order_quantity_chunxiwang @Productid int
AS
(SELECT DISTINCT p.ProductName
FROM Products p inner JOIN [Order Details] od
ON p.ProductID=od.ProductID
inner JOIN Orders o
ON od.OrderID=o.OrderID
WHERE p.ProductID=@Productid)

EXEC sp_product_order_quantity_chunxiwang @Productid = 17

--Problem6
CREATE PROC sp_product_order_city_chunxiwang @Productname varchar(40)
AS
(SELECT TOP 5 c.City, COUNT(o.OrderID) AS TotalAmount
FROM Products p inner JOIN [Order Details] od
ON p.ProductID=od.ProductID
inner JOIN Orders o
ON od.OrderID=o.OrderID
inner JOIN Customers c
ON c.CustomerID=o.CustomerID
WHERE p.ProductName=@Productname
GROUP BY c.City
)

EXEC sp_product_order_city_chunxiwang @Productname='Chai'

--Problem7
CREATE PROC sp_move_employees_chunxiwang
AS
DECLARE @tid int
IF 
(SELECT t.TerritoryID AS tid
FROM Territories t INNER JOIN EmployeeTerritories et
ON t.TerritoryID=et.TerritoryID
WHERE t.TerritoryDescription='Troy') IS NOT NULL
	INSERT INTO Territories(TerritoryID, TerritoryDescription, RegionID) VALUES(98320, 'Stevens Point', 3)
	UPDATE Territories
	SET TerritoryDescription='Stevens Point'
	WHERE TerritoryID = @tid

EXEC sp_move_employees_chunxiwang

--Problem8
CREATE TRIGGER t_moveback ON Employees
AS BEGIN
	Declare @count INT;
	SELECT @count=COUNT(Employees.EmployeeID) FROM Employees 
	INNER JOIN EmployeeTerritories ON Employees.EmployeeID=EmployeeTerritories.EmployeeID
	INNER JOIN Territories ON Territories.TerritoryID=EmployeeTerritories.TerritoryID
	WHERE Territories.TerritoryDescription='Stevens Point'
	IF @count>=100
		UPDATE Territories
		SET TerritoryDescription='Troy'
		WHERE TerritoryDescription = 'Stevens Point';
END;

--Problem9
CREATE TABLE city_chunxiwang (id int NOT NULL, City varchar(20), PRIMARY KEY(id))
CREATE TABLE people_chunxiwang (id int NOT NULL, Name varchar(20), Cityid int, PRIMARY KEY(id), FOREIGN KEY (Cityid) REFERENCES city_chunxiwang(id))
INSERT INTO city_chunxiwang (id, City) VALUES(1, 'Seattle')
INSERT INTO city_chunxiwang (id, City) VALUES(2, 'Green Bay')
INSERT INTO people_chunxiwang (id, Name, Cityid) VALUES(1, 'Aaron Rodgers', 2)
INSERT INTO people_chunxiwang (id, Name, Cityid) VALUES(2, 'Russell Wilson', 1)
INSERT INTO people_chunxiwang (id, Name, Cityid) VALUES(3, 'Jody Nelson', 2)
SELECT * FROM city_chunxiwang
SELECT * FROM people_chunxiwang

INSERT INTO city_chunxiwang (id, City) VALUES(3, 'Madison')
UPDATE people_chunxiwang
SET Cityid=3
WHERE Cityid=2

ALTER TABLE people_chunxiwang DROP CONSTRAINT FK__people_ch__Cityi__7C4F7684
DELETE FROM city_chunxiwang
WHERE city_chunxiwang.City='Seattle'

DROP TABLE people_chunxiwang
DROP TABLE city_chunxiwang

--Problem10
CREATE PROC sp_birthday_employees_chunxiwang
AS
(CREATE TABLE birthday_employees_wang(EmployeeName varchar(40), Birthday datetime) 
INSERT INTO birthday_employees_wang
SELECT Employees.FirstName+' '+Employees.LastName AS EmployeeName, Employees.BirthDate
FROM Employees
WHERE MONTH(Employees.BirthDate)=2;
)

DROP TABLE birthday_employees_wang

--Problem11
CREATE PROC sp_wang_1
AS 
(
SELECT c.City
FROM Customers c 
WHERE c.CustomerID=(
	SELECT o.CustomerID
	FROM Orders o JOIN [Order Details] od
	ON o.OrderID=od.OrderID
	GROUP BY o.OrderID, o.CustomerID
	HAVING COUNT(od.ProductID)<2
))

CREATE PROC sp_wang_2
AS
(SELECT c.City
FROM Customers c inner JOIN Orders o
ON c.CustomerID=o.CustomerID
inner JOIN [Order Details] od
ON od.OrderID=o.OrderID
GROUP BY c.CustomerID, c.City
HAVING COUNT(od.ProductID)<2 and COUNT(o.CustomerID)>1
)

--Problem12
--"CHECKSUM TABLE" command can compare two tables directlty;

--Problem14
--IF(SELECT t.[Middle Name] FROM t) is not null
--	SELECT t.[Last Name]+ ' '+t.[Middle Name]+'. '+t.[Last Name] As [Full Name]
--  FROM t;
--ELSE
--	SELECT t.[Last Name]+ ' '+t.[Last Name] As [Full Name]
--  FROM t;

--Problem15
--IF (SELECT t.Sex FROM t)='F'
--	SELECT TOP 1 t.Marks
--	FROM t
--	GROUP BY t.Mark
--	HAVING t.Sex='F'
--	Order BY Marks

--Problem16
--SELECT t.Student, t.Marks, t.sex
--FROM t
--ORDER BY t.marks, t.sex DESC

