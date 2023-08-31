Create database IITM

USE IITM

--Problem Statement: 

--You have successfully cleared the first semester. 
--In your second semester you will learn how to create tables,
--work with WHERE clause and basicoperators. 

--Tasks To Be Performed: 

--1. Create a customer table which comprises of these columns: 
--�customer_id�, �first_name�, �last_name�, �email�, �address�, �city�,�state�,�zip� 


create table CUSTOMERS (CUSTOMER_ID INT,
FIRST_NAME VARCHAR(50),
LAST_NAME VARCHAR(50),
EMAIL VARCHAR(50),
ADDRESS VARCHAR(50),
CITY VARCHAR(50),
STATE VARCHAR(50),
ZIP INT
)

--2. Insert 5 new records into the table


INSERT INTO CUSTOMERS VALUES
	  (10,'JEMMI','JORDAN','JEM@GMAIL.COM','2ND FLOOR GANDHI NAGAR','SANJOSE','KARNATAKA','33222'),
	  (20,'GAGANA','AVANTHIKA','GAGANA@GMAIL.COM','3ND FLOOR JAYA NAGAR','SHANTI NAGAR','KASHMIR','22222'),
	  (30,'JESSICA','VANYA','VANYA@GMAIL.COM','19TH BLOCK BOMMARI','ALLEPPY','TAMIL NADU','33333'),
	  (40,'JERUSHA','JERU','JERU@GMAIL.COM','4TH FLOOR','OOTY','DELHI','44444'),
	  (50,'GRACE','ZIPPORA','GRACE@GMAIL.COM','5TH FLOOR','SAN JOSE','UTTAR PRADESH','55555');


	  SELECT * FROM CUSTOMERS;

--3. Select only the �first_name� and �last_name� columns from the customer table 


select FIRST_NAME,LAST_NAME From CUSTOMERS


--4. Select those records where �first_name� starts with �G� and city is �San Jose�.

SELECT * FROM CUSTOMERS
WHERE FIRST_NAME LIKE 'G%' AND CITY= 'SAN JOSE'

--5. Select those records where Email has only �gmail�.

SELECT * from CUSTOMERS
where email LIKE '%gmail%'


--6. Select those records where the �last_name� doesn't end with �A�.

SELECT * FROM CUSTOMERS
where LAST_NAME not like '%A'

--ASSINGMENT 02

--Problem Statement:

--You have successfully cleared the second semester.
--In your third semester you will work with joins and update statements. 

--Tasks To Be Performed: 

--1. Create an �Orders� table which comprises of these columns:
--�order_id�, �order_date�, �amount�, �customer_id�.

CREATE TABLE ORDERS (
ORDER_ID  INT,
ORDER_DATE DATE,
AMOUNT INT,
CUSTOMER_ID INT
)


--2. Insert 5 new records.

INSERT INTO ORDERS VALUES(100,'2020-10-01',9000,20),
						(110,'2020-10-01',9000,10),
						(111,'2020-10-02',8000,2),
						(112,'2020-10-03',7000,30),
						(113,'2020-10-04',6000,3),
						(114,'2020-10-05',5000,5);

SELECT * FROM ORDERS


--3. Make an inner join on �Customer� and �Orders� tables on the �customer_id� column.

SELECT * FROM CUSTOMERS
JOIN
ORDERS on
CUSTOMERS.CUSTOMER_ID=ORDERS.CUSTOMER_ID

SELECT * FROM CUSTOMERS
SELECT * FROM ORDERS

--4. Make left and right joins on �Customer� and �Orders� tables on the �customer_id� column. 
SELECT * FROM CUSTOMERS
LEFT JOIN
ORDERS on
CUSTOMERS.CUSTOMER_ID=ORDERS.CUSTOMER_ID

SELECT * FROM CUSTOMERS
RIGHT JOIN
ORDERS on
CUSTOMERS.CUSTOMER_ID=ORDERS.CUSTOMER_ID


--5. Make a full outer join on �Customer� and �Orders� table on the �customer_id� column. 
--(LEFT JOIN +RIGHT JOIN)
SELECT * FROM CUSTOMERS
FULL JOIN
ORDERS on
CUSTOMERS.CUSTOMER_ID=ORDERS.CUSTOMER_ID

--6. Update the �Orders� table and set the amount to be 100 where �customer_id� is 3.

update Orders set amount=100 where customer_id = 3

select * from Orders


--ASSINGMENT 4


----Problem Statement:

--You have successfully cleared your third semester.
--In the fourth semester you will work with inbuilt functions and user-defined functions. 

--Tasks To Be Performed: 

--1. Use the inbuilt functions and find the minimum, maximum and average amount from the orders table

SELECT MAX(AMOUNT) AS MAX_AMOUNT,
MIN(AMOUNT) AS MIN_AMOUNT,
AVG(AMOUNT) AS AVG_AMOUNT 
FROM ORDERS

--2. Create a user-defined function which will multiply the given number with 10 


CREATE FUNCTION MULTIPLY(@NUM INT)
RETURNS INT
AS 
BEGIN
RETURN(@NUM * 10)
END

SELECT DBO.MULTIPLY(10)

--CREATE A FUNTION WHICH WILL MULTIPLY YOUR NUMBER BY 100

CREATE FUNCTION MULTIPLY1(@NUM INT)
	RETURNS INT
	AS 
	BEGIN
	RETURN(@NUM * 100)
	END

	
--CHEKH -- 
SELECT DBO.MULTIPLY1(20)


--3. Use the case statement to check if 100 is less than 200, greater than 200 or equal to 200 and print the corresponding value.

SELECT 
CASE
WHEN 100<200 THEN 'SMALLER'
WHEN 100>200 THEN ' GREATER'
ELSE 'EQUAL'
END

--3. Use the case statement to check if 1000 is less than 2000, greater than 2000
--or equal to 2000 and print the corresponding value.

SELECT 
CASE
WHEN 1000<2000 THEN 'SMALLER'
WHEN 1000>2000 THEN 'GREATER'
ELSE 'EQUAL'
END



--4. Using a case statement, find the status of the amount.
--Set the status of the amount as high amount, 
--low amount or medium amount based upon the condition. 

SELECT CASE
WHEN AMOUNT>5000 THEN 'HIGH AMOUNT'
WHEN AMOUNT<5000 THEN 'LOW AMOUNT'
ELSE 'MEDIUM'
END AS AMOUNT_CAT
FROM ORDERS

SELECT * FROM ORDERS

--5. Create a user-defined function, to fetch the amount 
--greater than then given input.(TABLE)

CREATE FUNCTION AMT_GREATER_THAN_IP(@NUM1 INT)
RETURNS TABLE
AS
RETURN SELECT AMOUNT FROM ORDERS WHERE AMOUNT>@NUM1

SELECT * FROM AMT_GREATER_THAN_IP(5000)

CREATE FUNCTION GETORDERGREATERTHEN(@INPUTAMT INT)
RETURNS TABLE
AS
RETURN
(
SELECT * FROM ORDERS WHERE AMOUNT>@INPUTAMT
);

SELECT * FROM GETORDERGREATERTHEN(7000)

----ASSINGMENT 05.
--Problem Statement: 

--You have successfully cleared your fourth semester. 
--In the fifth semester you will work with GROUP BY, having BY clauses and SET operators.

--Tasks To Be Performed:

--1. Arrange the �Orders� dataset in decreasing order of amount 

SELECT * FROM ORDERS 
ORDER BY AMOUNT DESC

--2. Create a table with the name �Employee_details1� consisting of these columns: 
--�Emp_id�, �Emp_name�, �Emp_salary�. Create another table with the name �Employee_details2�
--consisting of the same columns as the first table. 


create table employee_details1
(
emp_id int,
emp_name varchar(20),
emp_salary int)

 insert into employee_details1  values
 (1,'Faran',50000),
 (2,'Nadim',60000),
 (3,'Raja',45000),
 (4,'Rohit',70000),
 (5,'Sunil',80000)

create table Employee_details2
(
emp_id int,
emp_name varchar(20),
emp_salary int)
 
 insert into Employee_details2 values
 (1,'Aditya',45000),
 (2,'Anil',86000),
 (3,'Ishika',48600),
 (4,'Swetha',97000),
 (5,'Sunil',80000),
 (6,'Faran',50000)

 select * from employee_details1
 select * from Employee_details2

--3. Apply the UNION operator on these two tables 

 select * from employee_details1
 UNION
 select * from Employee_details2


 select * from employee_details1
 UNION ALL
 select * from Employee_details2


--4. Apply the INTERSECT operator on these two tables

 select * from employee_details1
 INTERSECT
 select * from Employee_details2

--5. Apply the EXCEPT operator on these two tables.//A-B

 select * from employee_details1
 EXCEPT
 select * from Employee_details2

 --ASSINGMENT 06
--Problem Statement:
--You have successfully cleared your fifth semester. In the final semester youwill
--work with views, transactions and exception handling. Tasks To Be Performed:


--1. Create a view named �customer_san_jose� which comprises of onlythosecustomers who are from San Jose

CREATE VIEW customer_san_jose
AS
SELECT * FROM CUSTOMERS
WHERE CITY = 'san jose';

--2. Inside a transaction, update the first name of the customer to Francis where the last name is Jordan:

BEGIN TRANSACTION;

UPDATE CUSTOMERS
SET FIRST_NAME='FRANCIES'
WHERE LAST_NAME='JORDAN'


SELECT * FROM CUSTOMERS
--a. Rollback the transaction

BEGIN TRANSACTION;

UPDATE CUSTOMERS
SET FIRST_NAME='FRANCIES'
WHERE LAST_NAME='JORDAN'

ROLLBACK;

SELECT * FROM CUSTOMERS



--b. Set the first name of customer to Alex, where the last name is Jordan

UPDATE CUSTOMERS SET FIRST_NAME='Francis' 
WHERE LAST_NAME='Jordan'

SELECT * FROM CUSTOMERS
--OR
BEGIN TRANSACTION;

UPDATE CUSTOMERS 
SET FIRST_NAME='ALEX'
WHERE LAST_NAME='JORDAN'

COMMIT;


--3. Inside a TRY... CATCH block, divide 100 with 0, print the default error
--message.

begin 
try 
print 100/0
end try
begin catch
print error_message()
end catch

--4. Create a transaction to insert a new record to Orders table and save
--it.

BEGIN TRANSACTION;

-- Insert a new record into the 'Orders' table
INSERT INTO Orders (order_id, order_date, amount, customer_id)
VALUES (115, '2020-10-06', 3000, 10);

-- Commit the transaction to save the changes
COMMIT;
