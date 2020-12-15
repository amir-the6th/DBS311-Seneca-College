/*-----------------------------------------------------------------*/
/*-- Amirhossein Sabagh | #152956199 | Assignment 2 | 2020-12-06 --*/
/*-----------------------------------------------------------------*/

SET SERVEROUTPUT ON; 

-- find_customer
CREATE OR REPLACE PROCEDURE 
find_customer(customer_id  IN NUMBER, found OUT NUMBER) AS
BEGIN
    SELECT COUNT(*)
    INTO found
    FROM customers
    WHERE cust_no = customer_id ;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        found := 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error!');
END find_customer;
/

-- find_product
CREATE OR REPLACE PROCEDURE 
find_product (product_id IN NUMBER, price OUT products.prod_sell%TYPE) AS
BEGIN
    SELECT  prod_sell
    INTO    price
    FROM    products
    WHERE   prod_no = product_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        price := 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error!');
END find_product;
/

-- add_order
CREATE OR REPLACE PROCEDURE 
add_order(customer_id IN NUMBER, new_order_id OUT NUMBER) AS
orderDT orders.order_dt%TYPE;
BEGIN
    SELECT  MAX(order_no) + 1
    INTO    new_order_id
    FROM    orders;
    
    SELECT
        TO_CHAR(SYSDATE, 'DD-Mon-YYYY') INTO orderDT
    FROM dual;
    
    INSERT INTO orders
    (order_no, cust_no, status, rep_no, order_dt)
    VALUES
    (new_order_id, customer_id , 'C', 56, orderDT);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        new_order_id := 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error!');
END add_order;
/

-- add_orderline
CREATE OR REPLACE PROCEDURE 
add_orderline (orderId IN orderlines.order_no%TYPE,
               itemId IN orderlines.line_no%TYPE, 
               productId IN orderlines.prod_no%TYPE, 
               quantity IN orderlines.qty%TYPE,
               price IN orderlines.price%TYPE) AS  
BEGIN
    INSERT INTO orderlines
    (order_no, line_no, prod_no, qty, price)
    VALUES
    (orderId, itemId, productId, quantity, price);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error!');
END add_orderline;
/

SELECT * 
FROM orders
WHERE order_dt LIKE '%2020';
