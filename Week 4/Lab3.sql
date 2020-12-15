/*
1. Write a SQL query to display the last name and hire date of all employees 
who were hired before the employee with ID 144 got hired. Sort the result by 
the hire date with the employee that was there the longest going first on list

SELECT last_name, hire_date
FROM employees
WHERE hire_date < (SELECT hire_date
                   FROM employees
                   WHERE employee_id = 144)
ORDER BY hire_date;


2.Write a SQL query to display the last name and salary for those employees 
with the lowest salary. Sort the result by name.


SELECT last_name, salary
FROM employees 
WHERE salary = (SELECT MIN(salary)
                FROM employees)
ORDER BY last_name;


3. Write a SQL query to display the product number, product name, product type 
and sell price of the highest paid product(s) in each product type.  
Sort by product type.


SELECT prod_no, prod_name, prod_type, prod_sell
FROM products
WHERE (prod_type, prod_sell) IN (SELECT prod_type, MAX(prod_sell)
                                 FROM products
                                 GROUP BY prod_type)
ORDER BY prod_type;



4. Write a SQL query to display the product line, and product sell price of the
most expensive (highest sell price) product(s). There may be more than 1 result


SELECT prod_line, prod_sell
FROM products
WHERE prod_sell = (SELECT MAX(prod_sell)
                   FROM products);


5. Write a SQL query to display product name and list price PROD_SELL) for 
products in prod_type  which have the list price less than the lowest 
list price in ANY product type.  
Sort the output by top list prices first and then by the product name


SELECT prod_name, prod_sell
FROM products
WHERE (prod_sell) < ANY (SELECT prod_sell
                         FROM products
                         WHERE (prod_type, prod_sell) IN (SELECT prod_type, 
                                                                 MIN(prod_sell)
                                                          FROM products
                                                          GROUP BY prod_type))
ORDER BY prod_sell DESC, prod_name;



6. Display product number, product name, and product type for products that
are in the same product type as the product with the   lowest price


SELECT prod_no, prod_name, prod_type
FROM products
WHERE prod_type IN (SELECT prod_type
                    FROM products
                    WHERE prod_sell = (SELECT MIN(prod_sell)
                                       FROM products));


7. Write a query to display the tomorrow’s date in the following format:
September 28th of year 2006  <-- this is the format for the date you display.
Your result will depend on the day when you create this query.
     Label the column     Next Day

SELECT TO_CHAR(sysdate + 1,'Month ddth" of year" YYYY') as "NEXT DAY"
FROM dual;


8. Create a query that displays the (a) city names, (b) country codes or ID and
(c) state/province names, but only for those cities that start with a 
lower case S and have at least 8 characters in their name. If city does not 
have a state name assigned, then put State Missing as your output on that row

SELECT city, country_id, NVL(state_province, 'State Missing')
FROM locations
WHERE city LIKE 's%' AND LENGTH(city) > 8;
*/




       