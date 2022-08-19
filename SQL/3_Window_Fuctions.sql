CREATE TABLE employees(
emp_id int(3) NOT NULL PRIMARY KEY,
emp_name varchar(20) NOT NULL,
dept_name varchar(20) NOT NULL,
salary int(8) NOT NULL);

INSERT INTO employees VALUES('101','Mohan','Admin','4000');
INSERT INTO employees VALUES('102','Rajkumar','HR','3000');
INSERT INTO employees VALUES('103','Akbar','IT','4000');
INSERT INTO employees VALUES('104','Dorvin','Finance','6500');
INSERT INTO employees VALUES('105','Rohit','HR','3000');
INSERT INTO employees VALUES('106','Rajesh','Finance','5000');
INSERT INTO employees VALUES('107','Preet','HR','7000');
INSERT INTO employees VALUES('108','Maryam','Admin','4000');
INSERT INTO employees VALUES('109','Sanjay','IT','6500');
INSERT INTO employees VALUES('110','Vasudha','IT','7000');
INSERT INTO employees VALUES('111','Melinda','IT','3000');
INSERT INTO employees VALUES('112','Komal','IT','3000');
INSERT INTO employees VALUES('113','Gautham','Admin','3000');
INSERT INTO employees VALUES('114','Manisha','HR','3000');
INSERT INTO employees VALUES('115','Chandni','IT','4500');
INSERT INTO employees VALUES('116','Satya','Finance','6500');
INSERT INTO employees VALUES('117','Adarsh','HR','3500');
INSERT INTO employees VALUES('118','Tejaswi','Finance','5500');
INSERT INTO employees VALUES('119','Cory','HR','8000');
INSERT INTO employees VALUES('120','Monica','Admin','5000');
INSERT INTO employees VALUES('121','Rosalin','IT','6000');
INSERT INTO employees VALUES('122','Ibrahim','IT','8000');
INSERT INTO employees VALUES('123','Vikram','IT','8000');
INSERT INTO employees VALUES('124','Dhiraj','IT','11000');

SELECT * FROM employees;


SELECT dept_name, max(salary) FROM employees
GROUP BY dept_name;

-- Now we need the same result along with the other details/coulmns
-- So instead of using MAX() as an Aggregate Function  we would use it as a WINDOW FUNCTION/ANALYTICAL FUNCTION. 
-- Along with OVER() clause.

SELECT e.*, MAX(salary) OVER()  AS max_salary
FROM employees e;

-- Here with the OVER() clause the SQL will not treat MAX() as an Aggregate Function but as a WINDOW FUNCTION.
-- Also OVER() aask SQL to create a Window of Records.
-- If we do not specify any column under the OVER(), then SQL will create one window for all the records in the result.

-- Now if we add any column under the OVER() by mentioning PARTITION BY and then the column name. 
-- for extracting max_salary corresponding to each dept_name.
-- For every distinct value present under OVER (PARTITION BY 'column_name') its gonna create one Window
--  and then apply the Aggregate Function to each of those Windows.

SELECT e.*, MAX(salary) 
OVER(PARTITION BY dept_name) AS dept_max_salary
FROM employees e;

# ROW NUMBER : : row_number() : Asssigns the Row Number a Unique value to each record.

SELECT e.*, row_number()
OVER() AS rn
FROM employees e;
-- SQL treats all of the Record as a Whole Window.


SELECT e.*, row_number()
OVER( PARTITION BY dept_name) AS rn
FROM employees e;   -- For each unique values in the column dept_name (under PARTITION BY) a seperate Window gets created 
                    -- And for each Window the row_number() function will be executed.
                    -- And for each record in every Window the row number will be returned.


# Find the first two employees joining each of the dept.
-- Assuming that emp_id of the employees who joined ealier will be lower to the ones who joined later.   

             
SELECT e.*, row_number()
OVER( PARTITION BY dept_name ORDER BY emp_id) AS rn
FROM employees e;                      
-- Data is sorted based on emp_id

-- Now to get only to get first 2 of the employees from each dept
SELECT * FROM(                
SELECT e.*, row_number()
OVER( PARTITION BY dept_name ORDER BY emp_id) AS rn
FROM employees e) x
where x.rn<3;   

# RANK() 
# get the top 3 employees in each dept earning the max salary
-- Rank the employees based on their salaries and then fetch the top 3. Using the Sub Query

SELECT e.*,RANK() 
OVER(PARTITION BY dept_name ORDER BY salary desc) AS rnk
FROM employees e;

-- Over here the RANK assigned here is same for the same values for the column values under the PARTITION BY clause.
-- And then the next rank assigned to the next value is skipped to the next rank number.
-- For every duplicate record its gonna assign the same Rank and then gonna skip the Rank for the very next value.

# get the top 3 employees in each dept earning the max salary
SELECT * FROM(                
SELECT e.*,
RANK() OVER(PARTITION BY dept_name ORDER BY salary desc) AS rnk
FROM employees e) x
where x.rnk<4;   


# DENSE RANK : dense_rank():  Over here it does not skip the Rank for the same/duplicate values.

SELECT * FROM(                
SELECT e.*,
DENSE_RANK() OVER(PARTITION BY dept_name ORDER BY salary desc) AS rnk
FROM employees e) x
where x.rnk<4;   

 -- Showing the RANK(), DENSE_RANK, ROW_NUMBER() together.  
 -- We haven't passed any column_name under  RANK(), DENSE_RANK, ROW_NUMBER() because these are just functions
 -- whch will assign a value for every record which has been detected or identified under the OVER (PARTITION BY.... ORDER BY.....)
SELECT e.*,
RANK() OVER(PARTITION BY dept_name ORDER BY salary desc) AS rnk,
DENSE_RANK() OVER(PARTITION BY dept_name ORDER BY salary desc) AS rnk,
row_number() OVER( PARTITION BY dept_name ORDER BY emp_id) AS rn
FROM employees e;   



# LAG() : Shows the previous values of the column_name mentioned under LAG()
-- LAG(column_name, no_of_prior_rows, default_value)
-- no_of_prior_rows is 1 previous row by default
-- default_value is NULL

SELECT e.*, LAG(salary) 
OVER(PARTITION BY dept_name ORDER BY salary desc) AS previous_salary
FROM employees e;

SELECT e.*, LAG(salary,2,0) 
OVER(PARTITION BY dept_name ORDER BY salary desc) AS previous_salary
FROM employees e;


# LEAD() : Shows the next values of the column_name mentioned under LEAD().....values following the current row.
-- LEAD(column_name, no_of_next_rows, default_value)
-- no_of_next_rows is 1 next row by default
-- default_value is NULL

SELECT e.*, LEAD(salary) 
OVER(PARTITION BY dept_name ORDER BY salary desc) AS next_salary
FROM employees e;


# Get a Query to Display If the Salary of an employee is Higher , Lower or Equal to the Previous employee.

SELECT e.*, 
LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id ) AS prev_emp_salary,
case when e.salary> LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id ) then 'Higher than previous employee'
     when e.salary< LAG(salary) OVER(PARTITION BY dept_name ORDER BY  emp_id) then 'Lower than previous employee'
     when e.salary= LAG(salary) OVER(PARTITION BY dept_name ORDER BY  emp_id) then 'Same as the previous employee'
end sal_range
FROM employees e;
