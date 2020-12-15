-- 1.
Display the (1) employee_id,(2) First name Last name (as one name with a space between) and call the column Employee Name, (3) hire_date
Only show employees with hire dates in July 2016 to December of 2016.  You cannot use >= or similar signs
Sort the output by top last hire_date first (December) and then by last name.

SELECT employee_id, first_name||' '||last_name AS "Employee Name", hire_date
FROM employees
WHERE hire_date BETWEEN '16-07-01' AND '16-12-31'
ORDER BY hire_date DESC, last_name;

-- 2.
Write a query to display the tomorrow’s date. The result will depend on the day when you RUN/EXECUTE this query.  Label the column “Next Day”.


SELECT sysdate + 1 AS "Next Day" FROM dual;


-- 3.
Users will often use the name they are accustomed to using. You need to figure out what it is really called for the SQL to work.
Show the following: product ID, product name, list price (means selling price) , and the new list price increased by 2%.
(a) Display a new list price (selling price) as a whole number.
(b) show only product numbers greater than 50000 and less than 60000
(c) product names that start with G or AS


SELECT prod_no, prod_name, prod_sell, round (prod_sell*1.2)
FROM products
WHERE prod_no >= 50000 AND prod_no <= 60000 
      AND prod_name LIKE 'G%' OR prod_name LIKE 'AS%';
      
      
-- 5.
Display the job titles (job_id) and full names of employees whose first name contains an ‘e’ or ‘E’  anywhere, and also contains an 'a' or a 'g' anywhere. The output should look SIMILAR to this sample.

SELECT job_id, first_name||' '||last_name
FROM employees
WHERE first_name LIKE '%e%' OR first_name LIKE '%E%' 
      AND first_name LIKE '%a%' OR first_name LIKE '%g%';
      
-- 6.
For employees whose manager ID is 124, write a query that displays the employee’s Full Name and Job ID in the following format:
SUMMER, PAYNE is a Public Accountant.


SELECT first_name||', '||last_name||' is a '||job_id
FROM employees
WHERE manager_id = 124;


-- 7.
For each employee hired before October 2016, display (a) the employee’s last name, (b) hire date and (c) calculate the number of YEARS between TODAY and the date the employee was hired.
The output for column (c) should be to only 1 decimal place.
Put the output in order by column (c) 


SELECT last_name, hire_date, round((sysdate - hire_date) / 365) "Years Employed"
FROM employees
WHERE hire_date < '16-10-01'
ORDER BY round((sysdate - hire_date) / 365);
*** Corrected: ORDER BY round(((sysdate - hire_date) / 365), 1);

-- 8.
Display each employee’s last name, hire date, and the review date, which is the first Tuesday after a year of service, but only for those hired after 2016. 
•        Label the column REVIEW DAY.
•        Format the dates to appear in the format like:
    TUESDAY, August the Thirty-First of year 2016
Sort by review date


SELECT last_name, hire_date,
       TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 6), 'Tuesday'),'fmDAY, Month " the " Ddspth " of year" YYYY') as "REVIEW DAY"
FROM employees
WHERE hire_date > '16-12-31'
ORDER BY "REVIEW DAY";