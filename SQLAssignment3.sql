--Chunxi Wang SQL Assignment 3
--1. In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?
--Since JOIN clause has better performance, we should use JOIN instead of subquery.

--2. What is CTE and when to use it?
--CTE is Common table expression; When we need to have temporary result set, we can use CTE. 

--3. What are Table Variables? What is their scope and where are they created in SQL Server?
--Table variable is scoped to the stored procedure, batch, or user-defined function.

--4. What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
--DELETE is a DML command, Truncate is a DDL command; 
--Delete command is useful to delete all or specific rows from a table specified using a Where clause;
--Truncate command removes all rows of a table. We cannot use a Where clause in this;
--Delete removes rows one at a time; Truncate removes all rows in a table by deallocating the pages that are used to store the table data;
--Delete command retains the object statistics and allocated space;
--Truncate deallocates all data pages of a table. Therefore, it removes all statistics and allocated space as well;
--Delete command can activate a trigger as well. Delete works on individual rows and delete the data. Therefore, it activates a trigger;
--The truncate command cannot activate a trigger. The trigger is activated if any row modification takes place;
--So Truncate has a better performance than delete.

--5. What is Identity column? How does DELETE and TRUNCATE affect it?
--Identity column is a column whose value increases automatically. 
--TRUNCATE TABLE removes all rows from a table, but the table structure and its columns, constraints, indexes, and so on remain. 
--If the table contains an identity column, the counter for that column is reset to the seed value defined for the column. 
--If no seed was defined, the default value 1 is used. To retain the identity counter, use DELETE instead.

--6. What is difference between “delete from table_name” and “truncate table table_name”?
--Delete can be used to remove all rows or only a subset of rows. Truncate removes all rows.

USE Northwind
GO

--Problem1
SELECT c.City FROM Customers c
INTERSECT
SELECT e.City FROM Employees e;

--Problem2
SELECT DISTINCT c.City FROM Customers c
WHERE NOT c.City IN (SELECT DISTINCT e.City FROM Employees e);

SELECT c.City FROM Customers c
EXCEPT
SELECT e.City FROM Employees e;

--Problem3
SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantities
FROM Orders o Inner JOIN [Order Details] od
ON o.OrderID=od.OrderID Inner JOIN Products p
ON od.ProductID=p.ProductID
GROUP BY p.ProductName;

--Problem4
SELECT c.City, SUM(od.Quantity) AS TotalQuantities
FROM Customers c Inner JOIN Orders o
ON c.CustomerID=o.CustomerID Inner JOIN [Order Details] od
ON o.OrderID=od.OrderID
GROUP BY c.City;

--Problem5
SELECT a.City
FROM
	(SELECT City, CustomerID FROM Customers
	UNION 
	SELECT City, CustomerID FROM Customers) as a
group by a.City
having count(CustomerID) >= 2

SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID)>1;

--Problem6
SELECT c.City, COUNT(p.ProductID) AS ProductCount
FROM Customers c 
JOIN Orders o ON c.CustomerID=o.CustomerID
JOIN [Order Details]od ON o.OrderID=od.OrderID 
JOIN Products p ON p.ProductID=od.ProductID
GROUP BY c.City
HAVING COUNT(p.ProductID)>1;

--Problem7
SELECT c.CustomerID, c.ContactName
FROM Customers AS c
JOIN Orders AS o
ON c.CustomerID=o.CustomerID
WHERE c.City != o.ShipCity;

--Problem8
SELECT TOP 5 COUNT(o.OrderID) AS OrderCount, p.ProductName, SUM(od.Quantity) AS TotalQuantity, od.UnitPrice, c.City 
FROM Customers c
JOIN Orders o ON c.CustomerID=o.CustomerID
JOIN [Order Details] od ON o.OrderID=od.OrderID
JOIN Products p ON p.ProductID=od.ProductID
GROUP BY p.ProductName, od.UnitPrice, c.City 
ORDER BY TotalQuantity DESC;

--Problem9
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City NOT IN 
(SELECT DISTINCT c.City
FROM Orders o 
JOIN Customers c ON o.CustomerID=c.CustomerID);

SELECT DISTINCT e.City
FROM Employees e LEFT JOIN Customers c
ON e.City=c.City
FULL OUTER JOIN Orders o
ON o.CustomerID=c.CustomerID
WHERE o.OrderID is null;

--Problem10
SELECT TOP 1 e.City AS CityWithMostOrders
FROM Employees e
INNER JOIN Orders o
ON e.EmployeeID=o.EmployeeID
GROUP BY e.City
ORDER BY COUNT(o.OrderID) DESC
SELECT TOP 1 e.City AS CityMostProductOrderFrom
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID=o.EmployeeID
JOIN [Order Details] as od ON o.OrderID=od.OrderID
GROUP BY e.City
ORDER BY count(od.Quantity);

--Problem11
--Use key word "DISTINCT";

--Problem12
--SELECT DISTINCT a.empid 
--FROM Employee as e
--LEFT JOIN Emplyee as e1 
--ON e.mgrid=e1.empid
--WHERE e.empid id is null

--Problem13
--SELECT d.deptname, COUNT(e.empid) AS CountOfEmployees
--FROM Dept d INNER JOIN Employee e
--ON d.deptid=e.deptid
--GROUP BY d.deptid, d.deptname
--HAVING COUNT(e.empid)=
--		(SELECT TOP 1 count(empid)
--		 FROM Employee 
--		 GROUP BY deptid)
--ORDER BY d.deptname

--Problem14
--SELECT d.deptname, e.empid, count(e.salary) AS Salary
--RANK() over
--	(PARTITION BY d.deptid
--	 ORDER BY d.deptname DESC,
--	 COUNT(e.salary) desc) as rank
--FROM Dept as d JOIN Employee as e
--ON d.deptid=e.deptid
--GROUP BY d.deptname, e.empid
--WHERE rank < 4
