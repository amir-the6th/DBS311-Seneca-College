/*******************************
-- Name: Amirhossein Sabagh    *
-- Email: asabagh@myseneca.ca  *
-- ID: 152956199               *
-- Date: 2020-11-19            *
-- Lab 06 DBS311               *
*******************************/

-- SET SERVEROUTPUT ON 
-- 1.
/* The company wants to calculate what the employees’ annual salary would be:
Assume that the starting salary or sometimes called base salary was $10,000.
Every year of employment after that, the salary increases by 5%.
Write a stored procedure named calculate_salary which gets an employee ID from
the user and for that employee, calculates the salary based on the number of 
years the employee has been working in the company.  
 */

-- Q1 SOLUTION:  
CREATE OR REPLACE PROCEDURE 
calculate_salary(c_empID IN employees.employee_id%TYPE) AS
  c_lastName employees.last_name%TYPE;
  c_firstName employees.first_name%TYPE;
  c_salary employees.salary%TYPE;
  CURSOR employee_cursor
  IS
    SELECT first_name, last_name, ROUND(POWER(1.05, (TO_CHAR(sysdate, 'YYYY') -
           TO_CHAR(hire_date, 'YYYY'))) * 10000, 2)
    FROM employees
    WHERE c_empID = employee_id;
BEGIN
OPEN employee_cursor;
  LOOP
    FETCH employee_cursor INTO c_lastName, c_firstName, c_salary;
      EXIT WHEN employee_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE ('First name: ' || c_firstName);
    DBMS_OUTPUT.PUT_LINE ('Last name: ' || c_lastName);
    DBMS_OUTPUT.PUT_LINE ('Salary: $' || c_salary);
  END LOOP;
  IF employee_cursor%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE ('There is no employee with this employeed id');
  END IF;
  --IF employee_cursor%ISOPEN THEN
CLOSE employee_cursor;
  --END IF;
EXCEPTION
WHEN OTHERS THEN 
  DBMS_OUTPUT.PUT_LINE ('Error!');
END calculate_salary;
/
EXECUTE calculate_salary(&id);


-- 2.
/* Write a stored procedure named employee_works_here to print the employee_id,
employee Last name and department name.
If the value of the department name is null or does not exist, display “no department”.
The value of employee ID ranges from your Oracle id's last 2 digits 
(ex: dbs311_203g37 would use 37) to employee 105.
(NOTE: Check manually and not in the procedure, to see if your number is in the 
employee table. If not pick the first employee number higher that does exist) */

-- Q2 Solution:
CREATE OR REPLACE PROCEDURE employee_works_here AS
  e_empID employees.employee_id%TYPE;
  e_lastName employees.last_name%TYPE;
  d_name departments.department_name%TYPE;
  rows_displayed NUMBER := 0;
BEGIN
DBMS_OUTPUT.PUT_LINE (RPAD('Employee #', 15) || RPAD('Last Name', 15) ||
                      RPAD('Department Name', 10));
FOR i_id IN 30..105
  LOOP
  BEGIN
    SELECT employee_id, last_name INTO e_empID, e_lastName
    FROM employees
    WHERE i_id = employee_id;
    
    SELECT e.employee_id, e.last_name, d.department_name INTO 
           e_empID, e_lastName, d_name
    FROM employees e, departments d
    WHERE i_id = employee_id AND e.department_id = d.department_id;
    
    DBMS_OUTPUT.PUT_LINE 
    (RPAD(e_empID,14) || ' ' || RPAD(e_lastName, 14) || ' ' || d_name);
    
    rows_displayed := rows_displayed + 1;
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN NULL;
  END;
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE 
  (RPAD('***', 10) || 'Number of Rows: ' || RPAD(rows_displayed, 10) || '***');
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE ('No department for this employee');
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE ('Error!');
END employee_works_here;
/
EXECUTE employee_works_here();



