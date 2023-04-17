select * from employee;
select * from department;
select * from manager;
select * from projects;


# INNER JOIN / JOIN: Will fetch only those records that are present in both the common columns of the two tables.
-- based on the column (dept_id) that we have mentioned in the Join condition and is present in both the tables.
--  matching the values that are present in the columns mentioned in the Join condition. Not every column.

# Fetch the employee name and department name they belong to.
SELECT * FROM employee;    -- D01,D02,D03,D04,D10
SELECT * FROM department;  -- D01,D02,D03,D04

SELECT e.emp_name, d.dept_name
FROM employee e JOIN department d 
ON e.dept_id=d.dept_id;


# LEFT JOIN = INNER JOIN + any additional record in the LEFT TABLE which were not returned(left out) from the LEFT Table
--                 D01,D02,D03,D04 + (D10)  is not matching the condition but is in the LEFT Table column (dept_id)

# employee    -- D01,D02,D03,D04,D10
# department  -- D01,D02,D03,D04

SELECT e.emp_name, d.dept_name
FROM employee e LEFT JOIN department d 
ON e.dept_id=d.dept_id;

-- if your SELECT Clause has any column(dept_name) fetched from the Right Table which is not satisfying the JOIN condition
-- for those Records the column (d.dept_id) will return  as NUll. 
-- over here, in this example For D10 the values returned in the dept_name column is NULL.


# RIGHT JOIN == INNER JOIN + any additional record in the RIGHT TABLE which were not returned(left out) from the RIGHT Table
--                   D1,D2 + D3,D4  is not matching the condition but is in the RIGHT Table column (dept_id)

# employee    -- D01,D02,D03,D04,D10
# department  -- D01,D02,D03,D04

SELECT e.emp_name, d.dept_name
FROM employee e RIGHT JOIN department d 
ON e.dept_id=d.dept_id;

-- depending upon the placement of the tables in the Join Condition (around 'JOIN') we can get the same o/p result. 

SELECT e.emp_name, d.dept_name
FROM  department d LEFT JOIN employee e
ON d.dept_id=e.dept_id;
 
 -- FETCHES ONLY THE MATCHING RECORD
 -- IN LEFT JOIN LEFT TABLE GETS THE PRIORITY
 -- IN RIGHT JOIN RIGHT TABLE GETS THE PRIORITY


# Q. Fetch details of all employees, their manager, their department and the projects they work on.
--   We need to join all the 4 Tables. 
--   And also be aware of the fact that which table is to be considered as the main table (here employee)


SELECT e.emp_name, d.dept_name, m.manager_name, p.project_name
FROM employee e LEFT JOIN department d 
ON e.dept_id = d.dept_iD
LEFT JOIN manager m ON m.manager_id = e.manager_id
LEFT JOIN projects p ON p.team_member_id = e.emp_id;

-- The result of the statement from the 'FROM' clause till the  Left of the the 'LEFT JOIN projects p' 
-- is considered entirely as the LEFT Table ( Result table) and the RIGHT Table is the projects Table.
-- Its not the manager table to be only considered as the LEFT Table here.
-- A cumulatiove result table from the 'FROM' till before the last 'LEFT JOIN' is to be considered as the LEFT Table.

# FULL OUTER JOIN = INNER JOIN + any additional record in the LEFT TABLE which were not returned(left out) from the LEFT Table
-- 						       + any additional record in the RIGHT TABLE which were not returned(left out) from the RIGHT Table

-- MySQL doesn't offer syntax for a FULL OUTER join, but you can implement one using the 'UNION' of a LEFT and a RIGHT join.
--  Oracle, PostgreSQL and MS-SQL Server do support the full-outer join.

SELECT e.emp_name, d.dept_name
FROM employee e LEFT JOIN department d 
ON e.dept_id = d.dept_id
UNION
SELECT e.emp_name, d.dept_name
FROM employee e RIGHT JOIN department d 
ON e.dept_id=d.dept_id;


# CROSS JOIN  (Cartesian Product) We match every record from the Left Table with every record from the Right Table.
-- CROSS JOIN does not require any JOIN condition.

SELECT e.emp_name, d.dept_name
FROM employee e CROSS JOIN department d;

-- Here every record in employee table was returned together with every record in the department table
-- employee (6) and department (4).   i.e. 6 x 4 =24 total records generated.alter

CREATE TABLE company(
company_id varchar(20) NOT NULL PRIMARY KEY,
company_name varchar(20) NOT NULL,
location varchar(20) NOT NULL);

INSERT INTO company VALUES('C001','techTFQ Solutions','Mumbai');
SELECT * FROM company;

# Q. Write a Query to fetch the employee name and their corresponding department name.
#    Also make sure to display the company name and the company location corresponding to each employee.

SELECT e.emp_name, d.dept_name, c.company_name, c.location
FROM employee e JOIN department d 
ON e.dept_id=d.dept_id
CROSS JOIN company c;

-- Whenever we have 2 Tables that cannot be Joined based on any common feilds (columns) and still need to get joined record together.
-- Then Cross Join is the best Option.

# NATURAL JOIN  SQL will decide what type of join should be used and based on what column conditions, not by the User.
-- Similar to CROSS, NATURAL JOIN does not have any condition under 'ON' Clause.
-- As SQL will decide based on which coulmn JOIN should happen and this depends upon the Column name (sharing the same name)
-- Basically its an INNER JOIN executing without any condition.

SELECT e.emp_name, d.dept_name
FROM employee e NATURAL JOIN department d;  -- dept_id (same name column with same stored Values)

-- If the values stored are completely different in the columns with the same name , there the NATURAL JOIN won't be applicable.
-- If the two tables do not have any common column name then the the JOIN performed is the CROSS JOIN b/w the Tables (cartesian Product)
-- So the JOIN selection and execution is done by the SQL itself , not by the USER. Hence it is not recommended to use such type of JOIN.


# SELF JOIN Joning a Table with itself.

SELECT * FROM family;

-- Over here we don't have separate tables (Parent and Child) to perform Joins for Parent-Child relationships..
-- We need to match one record of the table with another record of the sme table 
-- And be careful when writting the Syntax.

# Q. Write a query to fetch the child name and their age corresponding to their parent name and paret age.

SELECT child.name AS child_name, child.age AS child_age,
parent.name AS parent_name, parent.age AS parent_age
FROM family as child
JOIN family as parent 
ON child.parent_id = parent.member_id;

-- If instead of SELF join we use LEFT Join, then the result will include the child name and age with their parent name and age values shown as NULL.
