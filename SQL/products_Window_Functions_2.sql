CREATE TABLE product(
product_category varchar(20) NOT NULL,
brand varchar(20) NOT NULL,
product_name varchar(20) NOT NULL,
price_$ int(8) NOT NULL);


INSERT INTO product VALUES('Phone','Apple','iPhone 12 Pro Max','1300');
INSERT INTO product VALUES('Phone','Apple','iPhone 12 Pro','1100');
INSERT INTO product VALUES('Phone','Apple','iPhone 12 ','1000');
INSERT INTO product VALUES('Phone','Samsung','Galaxy Z Fold 3','1800');
INSERT INTO product VALUES('Phone','Samsung','Galaxy Z Flip 3','1000');
INSERT INTO product VALUES('Phone','Samsung','Galaxy Note 20','1200');
INSERT INTO product VALUES('Phone','Samsung','Galaxy S21','1000');
INSERT INTO product VALUES('Phone','OnePlus','OnePlus Nord','300');
INSERT INTO product VALUES('Phone','OnePlus','OnePlus 9','800');
INSERT INTO product VALUES('Phone','Google','Pixel 5','600');
INSERT INTO product VALUES('Laptop','Apple','MacBook Pro 13','2000');
INSERT INTO product VALUES('Laptop','Apple','MacBook Air','1200');
INSERT INTO product VALUES('Laptop','Microsoft','Surface Laptop 4','2100');
INSERT INTO product VALUES('Laptop','Dell','XPS 13','2000');
INSERT INTO product VALUES('Laptop','Dell','XPS 15','2300');
INSERT INTO product VALUES('Laptop','Dell','XPS 17','2500');
INSERT INTO product VALUES('Earphones','Apple','Airpods Pro','280');
INSERT INTO product VALUES('Earphones','Samsung','Galaxy Buds Pro','220');
INSERT INTO product VALUES('Earphones','Samsung','Galaxy Buds Live','170');
INSERT INTO product VALUES('Earphones','Sony','WF-1000XM4','250');
INSERT INTO product VALUES('Headphone','Sony','WH-1000XM4','400');
INSERT INTO product VALUES('Headphone','Apple','Airpods Max','550');
INSERT INTO product VALUES('Headphone','Microsoft','Surface Headphones 2','250');
INSERT INTO product VALUES('Smartwatch','Apple','Apple Watch Series 6','1000');
INSERT INTO product VALUES('Smartwatch','Apple','Apple Watch SE','400');
INSERT INTO product VALUES('Smartwatch','Samsung','Galaxy Watch 4','600');
INSERT INTO product VALUES('Smartwatch','OnePlus','OnePlus Watch','220');

SELECT * FROM product;

# FIRST_VALUE : first_value(): To extract a column Value from the very first record within a partition.

# Write a query to display the most expensive product under each category (corresponding to each record)

SELECT *,
first_value(product_name) 
OVER (PARTITION BY product_category ORDER BY price_$ DESC) AS most_expensive_product
FROM product;

-- First it basically groups the records based on the product_category and then by price in desc order.
-- Then it selects the very first value of the each window created based on the OVER clause.
-- And then Dispalys the value for the column_name mentioned in the first_value() clause in a new seperate column.



# LAST_VALUE : last_value(): To extract a column Value from the very last record within a partition.

# Write a query to display the least expensive product under each category (corresponding to each record)

SELECT *,
last_value(product_name) OVER (PARTITION BY product_category ORDER BY price_$ DESC) AS least_expensive_product
FROM  product;

-- We are not getting the desired result because of the default FRAME clause that SQL is using.

-- FRAME : Its basically the subset of the records created in a Window by the Partition using the Window Functions

-- last_value(), Its not going to use all the records in the Window at once.
-- Its going to use all the records which are within its Frame.
-- FRAME by FRAME 

SELECT *,
last_value(product_name) 
OVER (PARTITION BY product_category ORDER BY price_$ DESC
      range between unbounded preceding and current row) AS least_expensive_product
FROM product;

-- by default the frame clause statement is : 'range between unbounded preceding and current row'
-- range : range of records that the last_value window function needs to consider
-- unbounded preceding:  Rows preceding to the current row from the very first row  of the partition.
-- The default Frame clause generally impacts the last_value(), nth_value and also most of the Aggregate Functions.


-- To get the desired result, from the last_value we just need to make the change with 'current row' to 'unbounded following'.
-- 'unbounded following' This will point to the last value of the partition.
SELECT *,
last_value(product_name) 
OVER (PARTITION BY product_category ORDER BY price_$ DESC
      range between unbounded preceding and unbounded following) AS least_expensive_product
FROM product;



SELECT *,
first_value(product_name) 
OVER (PARTITION BY product_category ORDER BY price_$ DESC) AS most_expensive_product,
last_value(product_name) 
OVER (PARTITION BY product_category ORDER BY price_$ DESC
      range between unbounded preceding and unbounded following) AS least_expensive_product
FROM product;

-- when specifying the frame clause, we can also specify the 'range' to 'rows' also.
-- The difference b/w the two arises when there are the duplicate values.

SELECT *,
last_value(product_name) 
OVER (PARTITION BY product_category ORDER BY price_$ DESC
      rows between unbounded preceding and current row) AS least_expensive_product,
last_value(product_name) 
OVER (PARTITION BY product_category ORDER BY price_$ DESC
      range between unbounded preceding and current row) AS least_expensive_product
FROM product
WHERE product_category='Phone';

-- 'rows between unbounded preceding and current row' it will consider the exact current row.
-- 'range between unbounded preceding and current row' if the particular row has any duplicate value 
-- here '1000' is repeated in 3 differet rows, the 'range' will only consider only the last row with that price
-- which is the 'Galaxy S21'.

-- So, basically when we have duplicate data the 'range' will consider everything 
-- all the duplicate datas will also be considered until the last row of the frame.
-- and when using 'rows', it will stick only to that current row.

SELECT *,
first_value(product_name) 
OVER (PARTITION BY product_category ORDER BY price_$ DESC
      rows between 2 preceding and 2 following) AS most_expensive_product,
last_value(product_name) 
OVER (PARTITION BY product_category ORDER BY price_$ DESC
      rows between 2 preceding and 2 following) AS least_expensive_product
FROM product
WHERE product_category='Phone';  
-- Considering 2 prior (previous) rows and 2 following (after) rows for the frame in the window


# ALTERNATE WAY OF WRITTING THE QUERY FOR THE WINDOW FUNCTION

SELECT *,
first_value(product_name) OVER w AS most_expensive_product,
last_value(product_name) OVER w AS least_expensive_product
FROM product
WINDOW w AS (PARTITION BY product_category ORDER BY price_$ DESC
      rows between unbounded preceding and unbounded following);
      
      
# Nth_VALUE : nth_value(): Can fetch the value from any specified position

# Extract the 2nd most expensive product from each Category
-- nth_value(column_name, position) and if the positioned value is missing then it will return the NULL Value.

SELECT *,
first_value(product_name) OVER w AS most_expensive_product,
last_value(product_name) OVER w AS least_expensive_product,
nth_value(product_name,2) OVER w AS second_most_expensive_product
FROM product
WINDOW w AS (PARTITION BY product_category ORDER BY price_$ DESC
      rows between unbounded preceding and unbounded following);
      
-- For the deafult 'range between unbounded preceding and current row' 
-- While processing upto the n-1 records of the frame, it has access to upto only n-1 rows 
-- so till then no nth value is to be considered in the result column
-- and in that case it will show the corresponding result values as NULL.
SELECT *,
nth_value(product_name,3) OVER w AS second_most_expensive_product
FROM product
WINDOW w AS (PARTITION BY product_category ORDER BY price_$ DESC );   



# So when using the 'last_value' and 'nth_value'  Window function, make sure to use the proper Frame .


# NTILE : ntile(): Basically be used to group together a set of Data within your partition and then palce it under certain buckets,
-- And SQL will try its best that each bucket that is created within a partition will have almost the equal no. of records as much as possible. 
-- ntile(no. of buckets to be created)


# Write a query to segregate all the expensive phones, mid range phones and the cheaper phones.
SELECT *,
ntile(3) OVER (ORDER BY price_$) as buckets -- no need to specify the PARTITION BY
FROM product
WHERE product_category = 'Phone';

-- SQL wil try to equally split the records b/w the 3 buckets.
-- and try giving precedence/ priority to 1st Bucket seeing the range of the Prices in the record.

SELECT product_name,
CASE WHEN x.buckets =1 THEN 'expensive Phones'
	 WHEN x.buckets =2 THEN 'mid range Phones'
     WHEN x.buckets =3 THEN 'cheaper Phones' END phone_category
FROM( SELECT *,
ntile(3) OVER (ORDER BY price_$) as buckets -- no need to specify the PARTITION BY
FROM product
WHERE product_category = 'Phone') x;    


# CUME_DIST : cume_dist(): CUMULATIVE DISTRIBUTION
-- the value -->  0 < cume_dist() <= 1.
-- FORMULA = Current Row No (or Row No with value same as current Row)/ Total No of Rows.

# Query to fetch all products which are constituting the first 30 % of Data in product table based on 'price'.

SELECT *
FROM product; 

-- out of the total products what are the products that are constituting the first 30 % of the Data.

SELECT *,
cume_dist() OVER( ORDER BY price_$ desc) as cumulative_distribution,
round(cume_dist() OVER( ORDER BY price_$ desc) * 100,2) as cumulative_distribution_percent
FROM product; 

SELECT product_name, cumulative_distribution_percent
FROM(
SELECT *,
round(cume_dist() OVER( ORDER BY price_$ desc)  * 100,2) as cumulative_distribution_percent
FROM product)x
WHERE x.cumulative_distribution_percent <= 30; 

-- For the two or more same values in different rows , the cume_dist() value for the Higher row no is considered
-- and then assigned to all the corresponding duplicate records.

# PERCENT_RANK : percent_rank() : It provides each row with percentage rank in form of percentage.
-- the value -->  0 < percent_rank() <= 1.
-- FORMULA = Current Row No -1 /Total No of Rows -1

# How much percentage more expensive is "Galaxy Z Fold 3" when compared to all the products. 

SELECT *,
percent_rank() OVER( ORDER BY price_$) as percentage_rank,
round(percent_rank() OVER( ORDER BY price_$) * 100,2) as per_rank
FROM product; 


SELECT product_name, per_rank
FROM(SELECT *,
percent_rank() OVER( ORDER BY price_$) as percentage_rank,
round(percent_rank() OVER( ORDER BY price_$) * 100,2) as per_rank
FROM product) x
WHERE x.product_name = 'Galaxy Z Fold 3';
