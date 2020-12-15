/*******************************
-- Name: Amirhossein Sabagh    *
-- Email: asabagh@myseneca.ca  *
-- ID: 152956199               *
-- Date: 2020-11-12            *
-- Lab 05 DBS311               *
*******************************/

-- SET SERVEROUTPUT ON 

-- 1.
/* Write a stored procedure that get an integer number and prints
The number is even.
If a number is divisible by 2.
Otherwise, it prints 
The number is odd. */

-- Q1 SOLUTION:  
CREATE OR REPLACE PROCEDURE even_or_odd (num IN NUMBER) AS 
BEGIN 
IF mod(num, 2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE('The number is even');
  ELSE
    DBMS_OUTPUT.PUT_LINE('The number is odd');
END IF;
EXCEPTION
WHEN OTHERS
  THEN 
      DBMS_OUTPUT.PUT_LINE ('Error!');
END even_or_odd;
/

EXECUTE even_or_odd(&value);


-- 2.
/* Create a stored procedure named find_employee. This procedure gets an 
employee number and prints the following employee information:
First name 
Last name 
Email
Phone 	
Hire date 
Job title
The procedure gets a value as the employee ID of type NUMBER. */

-- Q2 SOLUTION:
CREATE OR REPLACE PROCEDURE 
find_employee (p_empID IN employees.employee_id%TYPE) AS 
p_firstName employees.first_name%TYPE;
p_lastName employees.last_name%TYPE;
p_email employees.email%TYPE;
p_phone employees.phone_number%TYPE;
p_hireDate employees.hire_date%TYPE;
p_jobTitle employees.job_id%TYPE;
BEGIN
SELECT first_name, last_name, email, 
       phone_number, hire_date, job_id
INTO   p_firstName, p_lastName, p_email, 
       p_phone, p_hireDate, p_jobTitle
FROM employees
WHERE employee_id = p_empID;
DBMS_OUTPUT.PUT_LINE ('First name: ' || p_firstName);
DBMS_OUTPUT.PUT_LINE ('Last name: ' || p_lastName);
DBMS_OUTPUT.PUT_LINE ('Email: ' || p_email);
DBMS_OUTPUT.PUT_LINE ('Phone: ' || p_phone);
DBMS_OUTPUT.PUT_LINE ('Hire date: ' || p_hireDate);
DBMS_OUTPUT.PUT_LINE ('Job title: ' || p_jobTitle);
EXCEPTION
WHEN TOO_MANY_ROWS THEN 
  DBMS_OUTPUT.PUT_LINE ('Too Many Employees Returned!');
WHEN NO_DATA_FOUND THEN 
  DBMS_OUTPUT.PUT_LINE ('No Employee Found!');
WHEN OTHERS THEN 
  DBMS_OUTPUT.PUT_LINE ('Error!');
END find_employee;
/

EXECUTE find_employee(&id);

-- 3.
/* Every year, the company increases the price of all products in one product 
type. For example, the company wants to increase the selling price of products 
in type Tents by $5. Write a procedure named update_price_tents to update the 
price of all products in a given type and the given amount to be added to the 
current selling price if the price is greater than 0. 
The procedure shows the number of updated rows if the update is successful.
The procedure gets two parameters:
-	Prod_type IN VARCHAR2
-	amount 	NUMBER(9,2) */

-- Q3 SOLUTION:
CREATE OR REPLACE PROCEDURE 
update_price_tents(p_prodType IN copy_products.prod_type%TYPE, 
                   p_amount IN copy_products.prod_sell%TYPE) AS
rows_updated NUMBER;
prod_sell copy_products.prod_sell%TYPE;
BEGIN
UPDATE copy_products
SET prod_sell = prod_sell + p_amount
WHERE LOWER(prod_type) = LOWER(p_prodType);
IF (prod_sell - p_amount) <= 0 THEN
  ROLLBACK;
END IF;
-- i first put the if statement at top and declared it as if the prod sell is 
-- greater than 0, update; but it made the code longer and repititive. So, i 
-- applied reverse engineering.
rows_updated := SQL%ROWCOUNT;
DBMS_OUTPUT.PUT_LINE ('Number of Rows Updated: ' || rows_updated);
EXCEPTION
WHEN TOO_MANY_ROWS THEN 
  DBMS_OUTPUT.PUT_LINE ('Too Many Employees Returned!');
WHEN NO_DATA_FOUND THEN 
  DBMS_OUTPUT.PUT_LINE ('No Employee Found!');
WHEN OTHERS THEN 
  DBMS_OUTPUT.PUT_LINE ('Error!');
END update_price_tents;
/
ROLLBACK;

EXECUTE update_price_tents('Tents', 5);


-- 4.
/* Every year, the company increases the price of products by 1 or 2% 
(Example of 2% -- prod_sell * 1.02) based on if the selling price (prod_sell) 
is less than the average price of all products. 
Write a stored procedure named update_low_prices_123456789 where 123456789 is 
replace by your student number. This procedure does not have any parameters. 
You need to find the average sell price of all products and store it into a 
variable of the same data type. If the average price is less than or equal to 
$1000, then update the products selling price by 2% if that products sell price 
is less than the calculated average. If the average price is greater than $1000,
then update products selling price by 1% if the price of the products selling 
price is less than the calculated average. The query displays an error message
if any error occurs. Otherwise, it displays the number of updated rows. */

-- Q4 SOLUTION:
CREATE OR REPLACE PROCEDURE update_low_prices_152956199 AS
u_avg copy_products.prod_sell%TYPE;
rows_updated NUMBER;
BEGIN
SELECT ROUND(AVG(prod_sell), 3) INTO u_avg
FROM copy_products;
IF u_avg <= 1000 THEN
  UPDATE copy_products
  SET prod_sell = prod_sell * 1.02
  WHERE prod_sell < u_avg;
  
  rows_updated := SQL%ROWCOUNT;
  display_update_low_prices(u_avg);
  DBMS_OUTPUT.PUT_LINE ('Number of Updates: ' || rows_updated);
  DBMS_OUTPUT.PUT_LINE ('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
ELSE
  UPDATE copy_products
  SET prod_sell = prod_sell * 1.01
  WHERE prod_sell < u_avg;
  
  rows_updated := SQL%ROWCOUNT;
  display_update_low_prices(u_avg);
  DBMS_OUTPUT.PUT_LINE ('Number of Updates: ' || rows_updated);
  DBMS_OUTPUT.PUT_LINE ('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
END IF;
EXCEPTION
WHEN OTHERS
  THEN 
      DBMS_OUTPUT.PUT_LINE ('Error!');
END update_low_prices_152956199;
/
CREATE OR REPLACE PROCEDURE display_update_low_prices(d_avg IN copy_products.prod_sell%TYPE) AS
BEGIN
IF d_avg <= 1000 THEN
  DBMS_OUTPUT.PUT_LINE ('*** OUTPUT OF update_low_prices_123456789  ***');
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE (
  'Prices of products with average below $1000 got increased by 2%');
ELSE
  DBMS_OUTPUT.PUT_LINE ('*** OUTPUT OF update_low_prices_123456789  ***');
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE (
  'Prices of products with average over $1000 got increased by 1%');
END IF;
END display_update_low_prices;
/
ROLLBACK;

EXECUTE update_low_prices_152956199;


-- 5.
/* The company needs a report that shows three categories of products based 
their prices. The company needs to know if the product price is cheap, fair, or 
expensive. Let us assume that
- If the list price is less than the (average sell price – minimum sell price) 
divided by 2 -> The product’s price is LOW.
- If the list price is greater than the maximum less the average divided by 2
	-> The product’ price is HIGH.
- If the list price is between 
o	(average price – minimum price) / 2 AND (maximum price – average price) / 2 INCLUSIVE
	-> The product’s price is fair.
Write a procedure named price_report_123456789  to show the number of products 
in each price category
 */

-- Q5 SOLUTION:
CREATE OR REPLACE PROCEDURE price_report_152956199 AS
avg_price copy_products.prod_sell%TYPE;
max_price copy_products.prod_sell%TYPE;
min_price copy_products.prod_sell%TYPE;
low_count NUMBER := 0;
fair_count NUMBER := 0;
high_count NUMBER := 0;

BEGIN
SELECT ROUND(AVG(prod_sell), 3), MAX(prod_sell), MIN(prod_sell) 
INTO avg_price, max_price, min_price
FROM copy_products;

SELECT COUNT(*) INTO low_count
FROM copy_products
WHERE prod_sell < ((avg_price - min_price) / 2);
SELECT COUNT(*) INTO fair_count
FROM copy_products
WHERE prod_sell BETWEEN ((avg_price - min_price) / 2) AND 
                        ((max_price - avg_price) / 2);
SELECT COUNT(*) INTO high_count
FROM copy_products
WHERE prod_sell > ((max_price - avg_price) / 2);

DBMS_OUTPUT.PUT_LINE ('Low: ' || low_count);
DBMS_OUTPUT.PUT_LINE ('Fair: ' || fair_count);
DBMS_OUTPUT.PUT_LINE ('High: ' || high_count);

EXCEPTION
WHEN NO_DATA_FOUND THEN 
  DBMS_OUTPUT.PUT_LINE ('No Price Found!');
WHEN OTHERS THEN 
  DBMS_OUTPUT.PUT_LINE ('Error!');
END price_report_152956199;
/
ROLLBACK;

EXECUTE price_report_152956199;


/*
DROP table copy_products;
CREATE TABLE copy_products AS (select * from products);
*/