/*
1.
SELECT job_id "Sabagh", COUNT(*) --COUNT(employee_id)
FROM employees
GROUP BY job_id
ORDER BY job_id;

2.
SELECT MAX(salary), MIN(salary), round(AVG(salary), 0),
       MAX(salary) - MIN(salary)
FROM employees;

--3.
SELECT c.cname, SUM(ol.price * ol.qty)
FROM ((orders o
JOIN orderlines ol ON o.order_no = ol.order_no)
JOIN customers c ON o.cust_no = c.cust_no)
GROUP BY c.cname
HAVING SUM(ol.price * ol.qty) > 50000;


4.
SELECT prod_type, SUM(sales_2016), SUM(sales_2015)
FROM products
GROUP BY prod_type
ORDER BY prod_type;

5.
SELECT c.cname, count (distinct o.order_no)
FROM customers c
LEFT JOIN orders o
ON c.cust_no = o.cust_no
GROUP BY c.cname, c.cust_no
HAVING c.cname LIKE 'G%' OR c.cname LIKE 'A%'
ORDER BY c.cname;


--6.
SELECT c.cust_no, c.cname, SUM(ol.price * ol.qty), 
       count(distinct o.order_no)
FROM ((orders o
JOIN orderlines ol ON o.order_no = ol.order_no)
JOIN customers c ON o.cust_no = c.cust_no)
GROUP BY c.cname, c.cust_no
ORDER BY count(distinct o.order_no);


7.
SELECT c.cust_no, c.cname, SUM(ol.price * ol.qty), 
       count(distinct o.order_no)
FROM ((orders o
JOIN orderlines ol ON o.order_no = ol.order_no)
RIGHT JOIN customers c ON o.cust_no = c.cust_no)
GROUP BY c.cname, c.cust_no
HAVING c.cname LIKE 'A%'
ORDER BY count(distinct o.order_no); 
*/



