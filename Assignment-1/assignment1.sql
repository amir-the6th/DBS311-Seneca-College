/*
1. 
Name					Student#		    Oracle id
-----------------   	--------------     --------------
Amirhossein Sabagh	     152569199		    dbs311_203e30

Hung Truong 			147779193     	    dbs311_203g31

Truong Giang Nguyen      121265193          dbs311_203e27

Anas Zakariyah Bemat	165239187		    dbs311_203e03

Thanh Cong Van 		136708195		    dbs311_203e37

Tuan Thanh Tan 		102183191 	    dbs311_203e35

Lara Fahmi		     109742197 	    dbs311_203g07

Yonghwan Song 			135458198 	    dbs311_203g27

--------------------------------------------------------------------------------

2. Display the (1) customer number, (2) customer name and (3) country code 
for all the customers that are in the Germany. 
Look up th country code for Germany. Table used is CUSTOMERS

SELECT cust_no, cname, country_cd
FROM customers
WHERE country_cd LIKE 'DE';

--------------------------------------------------------------------------------

3. For any customers with customer names that include 'Outlet' provide
(1) customer number, (2) customer name and (3) order number but only if they 
ordered any of these products 40301, 40303, 40300, 40310, 40306 
Put result in order number order.


SELECT c.cust_no, c.cname, o.order_no
FROM orders o
RIGHT JOIN customers c ON o.cust_no = c.cust_no 
INNER JOIN orderlines ol ON o.order_no = ol.order_no 
WHERE c.cname LIKE '%Outlet%' AND (ol.prod_no = 40301 OR ol.prod_no = 40303 OR
ol.prod_no = 40300 OR ol.prod_no = 40310 OR ol.prod_no = 40306)
ORDER BY o.order_no;

--------------------------------------------------------------------------------

4. Display all orders for United Kingdom. 
The COUNTRY_NAME can be either hard coded or accepted from the user 
-- your choice.BUT-- You need to have United Kingdom and not UK.  
Show only cities that start with L. 
Display the (1) customer number, (2) customer name, (3) order number, 
(4) product name,?(5) the total dollars for that line on the order.  
Give that last column the name of Line Sales
Put the output into?customer?number?order from highest to lowest. 
Display only customer numbers less than 1000 


SELECT ord.cust_no, cname, ordl.order_no, prod_name, sum(price* qty) LineSales
FROM customers cs
JOIN orders ord
        on  cs.cust_no = ord.cust_no
JOIN orderlines ordl
        on ordl.order_no = ord.order_no
JOIN products pd
        on ordl.prod_no = pd.prod_no  
JOIN countries ct
        on cs.country_cd = ct.country_id
WHERE country_name like 'United Kingdom'   
AND cs.city like 'L%'
AND cs.cust_no < 1000
GROUP BY cname, ord.cust_no, ordl.order_no, prod_name
ORDER BY 1;

--------------------------------------------------------------------------------

5. Mr. King, the top person in the company, would like to see 
all orders in 2014 from Germany and United Kingdom  
Show the (1) customer number, (2)customer name and (3)country name

SELECT c.cust_no, c.cname, cou.country_name
FROM customers c
JOIN orders o ON o.cust_no = c.cust_no
JOIN countries cou ON c.country_cd = cou.country_id
WHERE o.order_dt LIKE '%2014' 
AND (cou.country_id = 'UK' OR cou.country_id = 'DE');

--------------------------------------------------------------------------------

6. Find the total dollar value for all orders from London customers.
Each row will show (1) customer name, (2) order number 
and (3) total dollars for that order.  
Sort by highest total first

SELECT c.cname, ol.order_no, SUM(ol.price * ol.qty)
FROM orders o
INNER JOIN customers c ON o.cust_no = c.cust_no 
INNER JOIN orderlines ol ON o.order_no = ol.order_no
WHERE c.city = 'London'
GROUP BY (c.cname, ol.order_no)
ORDER BY SUM(ol.price * ol.qty) DESC;

--------------------------------------------------------------------------------

7. For all orders in the orders table supply order date 
and count of the number of orders on that date.
Only include those dates in 2015 and 2016
also only show those with more than 1 order

SELECT order_dt, COUNT(order_no) 
FROM orders
GROUP BY order_dt 
HAVING (order_dt LIKE '%2015' OR order_dt LIKE '%2016') AND COUNT(order_no) > 1;

--------------------------------------------------------------------------------

8. Display (1) Department_id, (2) Job_id and the (3) Lowest salary for this
combination but only if that Lowest Pay falls in the range $6000 - $18000.
Exclude people who
(a) work as some kind of Representative (REP)job from this query and
(b) departments IT and SALES
Sort the output according to the Department_id and then by Job_id.
You MUST NOT use the Subquery method.

SELECT department_id, job_id, MIN(salary)
FROM employees 
GROUP BY department_id, job_id
HAVING (MIN(salary) BETWEEN 6000 AND 18000) AND job_id NOT LIKE '%REP' 
       AND department_id != 60 AND department_id != 80
ORDER BY department_id, job_id;

--------------------------------------------------------------------------------

9. The President wants to know out of the 150 to 155 customers that are on file,
how many customers have not placed an order?

SELECT COUNT(c.cust_no)
FROM customers c
LEFT OUTER JOIN orders o ON c.cust_no = o.cust_no
WHERE o.cust_no IS NULL;

--------------------------------------------------------------------------------

10. Show what customers (1) number and (2) name along with the (3) country name 
for all customers that are in the same countries as customers starting with the
letters Supra. Limit the list to any customer names that
starts with the letters A to E. 


SELECT c.cust_no, c.cname, co.country_name 
FROM customers c 
JOIN countries co ON c.country_cd = co.country_id 
WHERE c.cname BETWEEN 'A%' AND 'F%' 
      AND c.country_cd IN  (SELECT country_cd 
                            FROM customers 
                            WHERE cname LIKE 'Supra%'); 

--------------------------------------------------------------------------------

11. List the (1) employee number, (2) last name (3) job id and (4) the modified 
or not modified salary for all employees.  
Show only employees -- If the salary without the increase is 
outside the range $6,000 – $11,000? 
- and who are employed as a Vice Presidents or Managers (President is not counted here).? 
- You should use Wild Card characters for this.?? 
- the modified salary for a VP will be 30% higher?? 
- and managers a 20% salary increase.? 
- Sort the output by the top salaries (before this increase).? 
The output lines should look "like" this sample line:? 
205 Higgins              15400  

/*
SELECT employee_id, last_name, job_id, (salary * 1.3)
FROM employees
WHERE (job_id LIKE '%VP') AND (salary NOT BETWEEN 6000 AND 11000)
UNION
SELECT employee_id, last_name, job_id, (salary * 1.2)
FROM employees
WHERE (job_id LIKE '%MAN' OR job_id LIKE '%MGR') AND (salary NOT BETWEEN 6000 AND 11000)
--ORDER BY salary;
*/

SELECT employee_id, last_name, job_id, 
CASE    
    WHEN job_id LIKE '%VP' THEN (salary*1.3) 
    WHEN job_id LIKE '%MAN' OR job_id LIKE '%MGR' THEN (salary*1.2) 
    ELSE salary 
END AS newSalary 
FROM employees 
WHERE  (job_id LIKE '%VP' OR job_id LIKE '%MAN' OR job_id LIKE '%MGR')
       AND salary NOT BETWEEN 6000 AND 11000 
ORDER BY salary DESC; 


--------------------------------------------------------------------------------

12. Display (1) last_name, (2) salary and (3) job for all employees who earn 
more than all lowest paid employees in departments outside the US locations.
Exclude President and Vice Presidents from this query.? This question may be 
interpreted as ALL employees in the table that are lower, OR comparing those in
the US to the lowest outside the US. Choose whichever you want.
Sort the output by job title ascending.
You need to use a Subquery and Joining with the NEWER method. (USING/JOIN or ON)


SELECT e.last_name, e.salary, e.job_id 
FROM employees e 
WHERE (e.job_id NOT LIKE '%PRES') AND (e.job_id NOT LIKE '%VP')
       AND e.salary > ALL (SELECT MIN(e.salary)
                      FROM employees e
                      JOIN
                      departments d ON e.department_id = d.department_id
                      JOIN locations l ON d.location_id = l.location_id
                      WHERE (l.country_id != 'US'))
ORDER BY e.job_id;
                                      
--------------------------------------------------------------------------------

13. List the manager's last name and the
employees last name that works for that manager

SELECT m.last_name, e.last_name
FROM employees m
INNER JOIN employees e ON e.manager_id = m.employee_id
ORDER BY m.last_name;

*/
