CREATE DATABASE SQL_PROJECT_SK
USE SQL_PROJECT_SK

-- AdventureWorks2012.bak is download and restored in server -- 


-- Perform the following with help of the above database:
-- a. Get all the details from the person table including email ID, phone number and phone number type

SELECT
    p.FirstName,
    p.LastName,
    e.EmailAddress,
    PH.PhoneNumber,
    PHT.Name
FROM
    Person.Person AS p
INNER JOIN
    Person.EmailAddress AS e ON p.BusinessEntityID = e.BusinessEntityID
INNER JOIN
    Person.PersonPhone AS PH ON p.BusinessEntityID = PH.BusinessEntityID
INNER JOIN
    Person.PhoneNumberType AS PHT ON PH.PhoneNumberTypeID = PHT.PhoneNumberTypeID;




-- b. Get the details of the sales header order made in May 2011

SELECT *
FROM Sales.SalesOrderDetail AS SD
INNER JOIN Sales.SalesOrderHeader AS SH ON SD.SalesOrderID = SH.SalesOrderID
WHERE SH.OrderDate >= '2011-05-01' AND SH.OrderDate < '2011-06-01';



-- c. Get the details of the sales details order made in the month of May 2011
SELECT *
FROM Sales.SalesOrderDetail AS sod
INNER JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate >= '2011-05-01' AND soh.OrderDate < '2011-06-01';


-- d. Get the total sales made in May 2011
SELECT
    SUM(sod.LineTotal) AS TotalSales,
    MONTH(soh.OrderDate) AS SaleMonth
FROM
    Sales.SalesOrderDetail AS sod
INNER JOIN
    Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE
    soh.OrderDate >= '2011-05-01' AND soh.OrderDate < '2011-06-01'
GROUP BY
    MONTH(soh.OrderDate);


-- e. Get the total sales made in the year 2011 by month order by increasing sales
SELECT
    SUM(sd.LineTotal) AS TotalSales,
    MONTH(soh.OrderDate) AS SaleMonth
FROM
    Sales.SalesOrderDetail AS sd
INNER JOIN
    Sales.SalesOrderHeader AS soh ON sd.SalesOrderID = soh.SalesOrderID
GROUP BY
    MONTH(soh.OrderDate)
ORDER BY
    TotalSales;


-- f. Get the total sales made to the customer with FirstName='Gustavo' and LastName ='Achong'
SELECT sp.*, p.FirstName
FROM sales.salesperson AS sp
INNER JOIN person.person AS p ON sp.businessentityid = p.businessentityid
WHERE p.FirstName = 'Gustavo' AND p.LastName = 'Achong';
