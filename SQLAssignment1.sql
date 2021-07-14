--ChunxiWang Assignment Day1 
USE AdventureWorks2019
GO
--Problem1
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product;

--Problem2
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice='0';

--Problem3
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NULL;

--Problem4
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL;

--Problem5
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL AND ListPrice>0;

--Problem6
SELECT Name+', '+Color AS NameAndColor
FROM Production.Product
WHERE Color IS NOT NULL;

--Problem7
SELECT 'NAME: '+Name+' -- COLOR: '+Color AS NameAndColor
FROM Production.Product
WHERE Color IS NOT NULL;

--Problem8
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID between 400 and 500;

--Problem9
SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color='black' or Color='blue'

--Problem10
SELECT *
FROM Production.Product
WHERE Name like 'S%';

--Problem11
SELECT Name, ListPrice
FROM Production.Product
WHERE Name like 'S%'
ORDER BY Name;

--Problem12
SELECT Name, ListPrice
FROM Production.Product
WHERE Name like 'S%' or Name like 'A%'
ORDER BY Name ASC;

--Problem13
SELECT Name
FROM Production.Product
WHERE Name like 'SPO%' AND Name NOT like 'SPOK%'
ORDER BY Name;

--Problem14
SELECT Color
FROM Production.Product
WHERE Color is not null
GROUP BY Color
ORDER BY Color DESC;

--Problem15
SELECT ProductSubcategoryID, Color
FROM Production.Product
WHERE Color is not null and ProductSubcategoryID is not null
GROUP BY ProductSubcategoryID, Color

--Problem16
SELECT ProductSubCategoryID, LEFT([Name],35) AS [Name], Color, ListPrice 
FROM Production.Product
WHERE Color IN ('Red','Black') 
      AND ListPrice BETWEEN 1000 AND 2000 
      AND ProductSubCategoryID = 1
ORDER BY ProductID;

--Problem17
SELECT DISTINCT p.ProductSubcategoryID, p.Name, p.Color, p.ListPrice
FROM Production.Product p
WHERE (p.ProductSubcategoryID<=14) and (P.Name like '%, %') and(p.ProductSubcategoryID is not null and p.Color is not null)
ORDER BY ProductSubcategoryID DESC;
