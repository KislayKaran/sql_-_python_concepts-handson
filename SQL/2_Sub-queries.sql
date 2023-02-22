
CREATE TABLE departments(
dept_id int(1) NOT NULL PRIMARY KEY,
dept_name varchar(20) NOT NULL,
location varchar(20) NOT NULL);

INSERT INTO departments VALUES('1','Admin','Bangalore');
INSERT INTO departments VALUES('2','HR','Bangalore');
INSERT INTO departments VALUES('3','IT','Bangalore');
INSERT INTO departments VALUES('4','Finance','Mumbai');
INSERT INTO departments VALUES('5','Marketing','Bangalore');
INSERT INTO departments VALUES('6','Sales','Mumbai');


-- Sub Queries also called as an Inner Query or Nested Query within another SQL Query
-- and embedded within 'WHERE' Clause.

-- A Sub-Query is used to return the data that will be used in the main query 
-- as a condition to further restrict the dta to be retrieved.


-- RULES:
-- Can be used with SELECT, INSERT, UPDATE & DELETE statements
-- along with the operators like =,<,>,>=,<=,IN .

-- (1) A Subquery can have only 1 Column in the SELECT Claue, unless multiple Columns are in the main Query
--     for the Subquery to compare its selected Columns.
-- (2) An ORDER BY cannot be used in a subquery ,
--        GROUP BY can be used to perform the same role as ORDER BY in a Subquery.
--     Although the  Main Query can be use an ORDER BY.
-- (3) The BETWEEN operator cannot be used with a Subquery (Main Query)
--     However it can be used within the Sub Query.
-- (4) Subqueries that return more than one row can only be used with multiple value operators
--     such as the IN, EXISTS, NOT IN, ANY/SOME, ALL Operators.
    
    
SELECT * FROM employees;
SELECT * FROM departments; 

describe departments;

-- Q. Find the Employees whose Salary is more than the avg. salary earned by all employees
-- Break into two Parts:

-- (a) Find the Avg. Salary.
-- (b) Filter the employees based on the (a) result.

SELECT avg(salary) from employees;
-- 5333.3333

-- SELECT * FROM employees WHERE salary>5333.3333 ;     Not the Correct Way.
-- Instead

SELECT * FROM employees 
WHERE salary > (SELECT avg(salary) from employees); 

-- OUTER Query is using the INNER Query to fetch the record and filter it and
--  then get the final reseult using and the OUTER Query.

-- INNER Query can be executed on its own ,
-- does not have any dependencies on the OUTER Query.

-- OUTPUT from the INNER Query will be processed by OUTER Query.

-- 

-- TYPES OF SUB_QUERY
-- (1) Scalar Subqueries
-- (2) Multiple Subquerie
-- (3) Correlated Subqueries

-- (1) Scalar Subqueries : returns only one Row and only One Column.
-- The simplest subquery returns exactly one column and exactly one row.
--  It can be used with comparison operators =, <, <=, >, or >=.

-- This query finds emp_name with the same salary as Mohan:
SELECT emp_name FROM employees
WHERE salary = (
SELECT salary
FROM employees
WHERE emp_name = 'Mohan'
);

SELECT * FROM employees e
JOIN (SELECT avg(salary) as avg_sal from employees) avg_sal; 

-- Here SQL treats the result returned from the Subquery as a Seperate table by itself.
-- i.e. Sal Column with avg_sal gets added to the final result.

-- But with e.* ----> that extra 'avg_sal' column will not be added.
-- Table will be represented in its original form and set of columns.

SELECT e.* FROM employees e
JOIN (SELECT avg(salary) as avg_sal from employees) avg_sal;


-- (2) Multiple Row Subqueries: Returns the Multiple Rows
-- These are of two types: (a) Multiple Columns and Multiple Rows
--                         (b) Single Column Multiple Rows

-- A subquery can also return multiple columns or multiple rows. 
-- Such subqueries can be used with operators IN, NOT IN,  EXISTS, ALL, or ANY/SOME.

-- Q. Find the employees which aearn the highest salary in each dept. (GROUP BY)
-- (1) Find the highest Salary in each Dept.
-- (2) Compare the Result of (1st) o/p with the entire employee table.alter

SELECT dept_name, max(salary)
FROM employees
GROUP BY dept_name;

SELECT * FROM employees
WHERE (dept_name,salary)
IN (SELECT dept_name, max(salary)
	FROM employees
    GROUP BY dept_name);
    
-- Q. Which are the departments (dept_name) with no employees 
-- i.e. dept with no emp_names in the employee table.alter

SELECT distinct(dept_name) 
FROM employees;   -- as an INNER query returns only 1 column.

SELECT * FROM departments
WHERE dept_name NOT IN (SELECT distinct(dept_name) 
	                    FROM employees); 
                        
                        -- To compare the values 'dept_name NOT IN'
                        
-- Showing the dept columns from the dept_table by which the dept_names are missing from the employees table.

-- Values of dept_name  from departments table which are not present as the dept_name values in the 
-- employees table ( missing from the employees table )      



-- (3) Corelated Subquerries: Sub Query related to the OUTER Query. 
--                             Processing of the Sub-Query depends upon the values returned from the  OUTER Query.
--                             Cannot execute itself.

-- Q. Find the emploees in each department who earn more than the avg. salary in that department.

-- We need to find the avg. salary in each dept. 
-- And then compare the salary of the employees with the avg. salary of their dept. from the employee table.


-- Finding the avg. salary of each dept.
SELECT dept_name,avg(salary)
FROM employees
GROUP BY dept_name;

-- Comparing the salary of the employees with the avg. salary of their dept.
SELECT emp_name,dept_name,salary
FROM employees e1 
WHERE salary > (SELECT avg(salary) as avg_sal
                FROM employees e2
                WHERE e2.dept_name = e1.dept_name
                GROUP BY dept_name) ;
-- Reffereing a column in a sub-query which is coming from Outer-query
-- the Sub-query will be dependent on every single value that will be returned from the Outer Query.

-- This Subquery is dependent on 
-- Every Single record processed from the Outer-Query it will execute the Inner-Query.

-- First the Outer Query Execution followed up by the Inner-Query.
               
-- For each row value of employees e1 the dept_name will get returned over here.
-- Then the Inner-Query will get executed for getting the avg. salary for the e1.dept_name.
-- For every single employee record from e1 Outer-Query , the SQL will process the Sub_Query once.

-- Based on no of records processed by the Outer-Query that many no of times the Subquery(corelated) will get executed.

-- Corelated Sub-Query will have some join Condition based on some column that is used from the Outer-Query.

-- Q. Find the department who do not have employees (solving it using Corelated Sub-Queries)

SELECT * FROM departments d
WHERE NOT EXISTS ( SELECT * FROM employees e
                   WHERE e.dept_name = d.dept_name);
               
-- Comparing the Datas b/w the two different tables.
-- For every Record from the Outer-Query we can check for the correspondingrecord in the Sub-Query.



-- Difference b/w Corelated Sub-Queries and other Sub-Queries

-- Other Subqueries:
    --  SQL will straight away execute subquery it will hold that o/p and then use that o/p
    --  from the Sub-Queries to process that Outer-Query.
    
-- Corelated Subqueries:
	-- SQL will not be able to execute the Sub-Query as a whole so for the every single record that is 
    -- processed from the OUter-Query the Inner Corelated (dependent) Sub-Query will be executed.
    
    
-- NESTED SUBQUERIES 

CREATE TABLE sales(
store_id int(3) NOT NULL,
store_name varchar(20) NOT NULL,
product_name varchar(20) NOT NULL,
quantity int(2) NOT NULL,
price int(6) NOT NULL);   



INSERT INTO sales VALUES ('1','Apple Store 1', 'iPhone 13 Pro', '1','1000');
INSERT INTO sales VALUES ('1','Apple Store 1', 'MacBook Pro 14', '3','6000');
INSERT INTO sales VALUES ('1','Apple Store 1', 'AirPods Pro', '2','500');
INSERT INTO sales VALUES ('2','Apple Store 2', 'iPhone 13 Pro', '2','2000');
INSERT INTO sales VALUES ('3','Apple Store 3', 'iPhone 12 Pro', '1','750');
INSERT INTO sales VALUES ('3','Apple Store 3', 'MacBook Pro 14', '1','2000');
INSERT INTO sales VALUES ('3','Apple Store 3', 'MacBook Air', '4','4400');
INSERT INTO sales VALUES ('3','Apple Store 3', 'iPhone 13', '2','1800');
INSERT INTO sales VALUES ('3','Apple Store 3', 'AirPods Pro', '3','750');
INSERT INTO sales VALUES ('4','Apple Store 4', 'iPhone 12 Pro', '2','1500');
INSERT INTO sales VALUES ('4','Apple Store 4', 'MacBook Pro 16', '1','3500');

SELECT * FROM sales;


-- Q. Find thr Stores whose Sales were better than the avg. Sales across all the Stores.

-- (1) Total Sales for each Store
-- (2) Avg Sales for all the Stores .....( Not for the entire sales data, Store wise)
-- (3) Compare (1) & (2).alter

-- (1)
		SELECT store_name, sum(price) as total_sales FROM sales 
		GROUP BY store_name;

-- (2)
		SELECT avg(total_sales)
        FROM (SELECT store_name, sum(price) as total_sales FROM sales 
		     GROUP BY store_name) average;
             
-- (1) + (2)  
-- Joining (1) & (2)......Join sales_x & avg_sales
		SELECT *
        FROM (SELECT store_name, sum(price) as total_sales 
              FROM sales 
		      GROUP BY store_name) sales_x
        JOIN (SELECT avg(total_sales) as sales
              FROM (SELECT store_name, sum(price) as total_sales
                    FROM sales 
		            GROUP BY store_name) y) avg_sales
              ON sales_x.total_sales> avg_sales.sales;               
           

-- To reduce the code length , we need to do an initialization of the sales_x (query)  using with clause 
-- replacing a Subquery with clause instead of using it multiple times.

WITH sales_x AS
(SELECT store_name, sum(price) as total_sales 
 FROM sales 
 GROUP BY store_name)
 SELECT * FROM  sales_x
        JOIN (SELECT avg(total_sales) as sales
              FROM sales_x y) avg_sales
              ON sales_x.total_sales> avg_sales.sales;  
              


-- SubQuery with SELECT Clause :            

-- Here in the example below the SubQuery should be of a Scalar Subquery
-- i.e. it should return only one result with 1 row and 1 column 

SELECT *, 
      ( CASE WHEN salary > ( SELECT avg(salary) FROM employees)
			 THEN 'Higher than average'
             ELSE null
        END) AS Remarks
 FROM employees;       
 
 
 -- Try Avoiding the above Query .....Instead use the modified version.
 -- The below Query Shows both the Average Salary and the Remarks column.
SELECT *, 
      ( CASE WHEN salary > ( SELECT avg(salary) FROM employees)
			 THEN 'Higher than average'
             ELSE null
        END) AS Remarks
 FROM employees
 CROSS JOIN ( SELECT avg(salary) avg_sales FROM employees) avg_sal;
 

-- SubQuery with HAVING Clause : 

-- Q. Find the stores that have sold more units than the average units sold by all the stores.
-- (1) 
SELECT store_name, sum(quantity)
FROM sales 
GROUP BY store_name;

-- (2)
SELECT avg(quantity) FROM sales;

-- (1)+(2)
SELECT store_name, sum(quantity)
FROM sales 
GROUP BY store_name
HAVING sum(quantity) >(SELECT avg(quantity) FROM sales);


-- SubQuery with INSERT Clause : 

-- Q. Insert Data to emp_bkp table make sure not to insert the duplicate records

CREATE TABLE emp_bkp(
emp_id int(1) NOT NULL PRIMARY KEY,
emp_name varchar(20) NOT NULL,
dept_name varchar(20) NOT NULL,
salary int(8) NOT NULL,
location varchar(20) NOT NULL);


INSERT INTO emp_bkp
SELECT e.emp_id, e.emp_name, d.dept_name, e.salary, d.location
FROM employees e JOIN departments d
ON d.dept_name = e.dept_name
WHERE NOT EXISTS ( SELECT 1 FROM emp_bkp eb        
                   WHERE eb.emp_id = e.emp_id);             -- For eliminating the Duplicate Values.
 
 -- On 1st Query execution-- 24 row(s) affected Records: 24  Duplicates: 0  Warnings: 0
 -- On 2nd Query execution-- 0 row(s) affected Records: 0  Duplicates: 0  Warnings: 0

--                    
SELECT * FROM emp_bkp;


-- SubQuery with UPDATE Clause :  

-- Q. Give 10% increment to all employees in Mumbai Location, based on the Max. Salary earned by an employee in each dept.
-- Only Consider employees in emp_bkp table.

UPDATE employees e
SET salary=( SELECT max(salary) + (max(salary)*0.1) 
			 FROM emp_bkp eb
             WHERE eb.dept_name = e.dept_name
             GROUP BY eb.dept_name)
WHERE e.dept_name IN ( SELECT dept_name
                       FROM departments 
                       WHERE location='Mumbai')
AND e.emp_id IN (SELECT emp_id FROM emp_bkp);                       

-- 4 row(s) affected Rows matched: 4  Changed: 4  Warnings: 0

-- SubQuery with DELETE Clause :

-- Q. Delete all departments who do not have any employees

DELETE FROM departments
WHERE dept_name IN ( SELECT dept_name
                    FROM ddepartments department 
                    WHERE NOT EXISTS (SELECT * FROM employees e
									  WHERE e.dept-name=d.dept_name)
                    );                  
