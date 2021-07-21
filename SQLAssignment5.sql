--Chunxi Wang Assignment5
--1.What is an object in SQL?
--SQL objects are schemas, journals, catalogs, tables, aliases, views, indexes, constraints, 
--	triggers, masks, permissions, sequences, stored procedures, user-defined functions, user-defined types, 
--	global variables, and SQL packages. 
--SQL creates and maintains these objects as system objects.

--2.What is Index? What are the advantages and disadvantages of using Indexes?
--An index is an on-disk structure associated with a table or view that speeds retrieval of rows from the table or view. 
--Advantages:
--Speed up SELECT query;
--Helps to make a row unique or without duplicates(primary,unique);
--If index is set to fill-text index, then we can search against large string values.
--Disadvantages
--Indexes take additional disk space;
--indexes slow down INSERT,UPDATE and DELETE, but will speed up UPDATE if the WHERE condition has an indexed field.  
--INSERT, UPDATE and DELETE becomes slower because on each operation the indexes must also be updated. 

--3.What are the types of Indexes?
--

--4.Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
--

--5.Can a table have multiple clustered index? Why?
--

--6.Can an index be created on multiple columns? Is yes, is the order of columns matter?
--

--7.Can indexes be created on views?
--

--8.What is normalization? What are the steps (normal forms) to achieve normalization?
--

--9.What is denormalization and under which scenarios can it be preferable?
--

--10.How do you achieve Data Integrity in SQL Server?
--We can apply Entity integrity to the Table by specifying a primary key, unique key, and not null. 

--11.What are the different kinds of constraint do SQL Server have?
--UNIQUE constraints and CHECK constraints;

--12.What is the difference between Primary Key and Unique Key?
--Primary key is the unique identifier for rows of a table; Cannot be NULL;
--Unique key is the Unique identifier for rows of a table when primary key is not present; Can be NULL;

--13.What is foreign key?
--A FOREIGN KEY is a field (or collection of fields) in one table, refers to the PRIMARY KEY in another table.

--14.Can a table have multiple foreign keys?
--Yes, it can!

--15.Does a foreign key have to be unique? Can it be null?
--Foreign key does not to be unique and it can be NULL;

--16.Can we create indexes on Table Variables or Temporary Tables?
--

--17.What is Transaction? What types of transaction levels are there in SQL Server?
--A transaction is a logical unit of work that contains one or more SQL statements. A transaction is an atomic unit. 
--Read Uncommitted; Read Committed; Repeatable Read; Serializable;


--Problem1
 Create table customer(cust_id int,  iname varchar (50));
 create table order(order_id int,cust_id int,amount money,order_date smalldatetime)

 --SELECT c.iname, SUM(o.amount) AS SunOfOrder
 --FROM customer c INNER JOIN order o
 --ON c.cust_id=o.cust_id
 --GROUP BY c.cust_id
 --HAVING YEAR(o.order_date)=2002;

--Problem2
 Create table person (id int, firstname varchar(100), lastname varchar(100)) 

 --SELECT* 
 --FROM person
 --WHERE person.lastname LIKE 'A%';

--Problem3
 Create table person(person_id int primary key, manager_id int null, name varchar(100)not null) 
 --DECLARE @id int
 --SELECT person.name, COUNT(person_id) AS ManagePeople
 --FROM person
 --WHERE managed_id =
 --(SELECT person.person_id
 --FROM person
 --WHERE managed_id is null)


--Problem4
--1. DML statements (INSERT, UPDATE, DELETE) on a particular table or view, issued by any user

--2. DDL statements (CREATE or ALTER primarily) issued either by a particular schema/user or by any schema/user in the database

--3. Database events, such as logon/logoff, errors, or startup/shutdown, also issued either by a particular schema/user or by any schema/user in the database

--Problem5

