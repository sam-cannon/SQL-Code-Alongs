#------------------Subqueries
#subqueries = inner queries = nested queries
#employed in the WHERE clause of a SELECT statement
#part of 'outer query'

#Select the first and last name from the employees table for the employee numbers found in the managers table
SELECT e.first_name, e.last_name
FROM employees e
WHERE e.emp_no IN (SELECT m.emp_no FROM dept_manager m);
#subqueries are always placed in perenthesis

#Exercise, Extract the information about all department managers who were hired between the 1st of January 1990 and the 1st of January 1995.
SELECT m.* FROM dept_manager m
WHERE m.emp_no IN (SELECT e.emp_no FROM employees e WHERE e.hire_date BETWEEN '1990-01-01' AND '1995-01-01'); 

#EXISTS and NOT EXISTS
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS(SELECT * FROM dept_manager dm WHERE dm.emp_no = e.emp_no);

#EXISTS and IN are similar, but EXISTS is quicker with larger datasets while IN is faster with smaller datasets

#using ORDER BY with subqueries,  you should always place ORDER BY within the outer query, not the subquery, more professional
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS(SELECT * FROM dept_manager dm WHERE dm.emp_no = e.emp_no)
ORDER BY emp_no;

#Exercise, Select the entire information for all employees whose job title is “Assistant Engineer”.
SELECT e.* FROM employees e
WHERE e.emp_no IN (SELECT t.emp_no FROM titles t WHERE title = 'Assistant Engineer')
ORDER BY emp_no;

#another solution, though I am not sure why you would write this since it is longer, I could be missing something though?
SELECT

    *

FROM

    employees e

WHERE

    EXISTS( SELECT

            *

        FROM

            titles t

        WHERE

            t.emp_no = e.emp_no

                AND title = 'Assistant Engineer');

#------------------Subqueries nested in SELECT and FROM 
#Get the data for employee number 110022 as a manager to all employees from 10001 to 10020, and employee number 110039 as a manager to 
# all employees from 10021 to 10040
SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_id,
            MIN(dp.dept_no) AS department_code, #using MIN ensures that we get only 1 value per employee, some employees may be in multiple departments, couldve used MAX too
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_id
    FROM
        employees e
    JOIN dept_emp dp ON e.emp_no = dp.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A
UNION
SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_id,
            MIN(dp.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_id
    FROM
        employees e
    JOIN dept_emp dp ON e.emp_no = dp.emp_no
    WHERE
        e.emp_no >= 10021 AND e.emp_no <= 10040
    GROUP BY e.emp_no
    ORDER BY e.emp_no LIMIT 20) AS B;

#I know this is a ton to unpack, this is a discussion and a google session for sure, stop here and figure out exactly what is going on in the above query

#Exercise, Starting your code with “DROP TABLE”, create a table called “emp_manager” 
# (emp_no – integer of 11, not null; dept_no – CHAR of 4, null; manager_no – integer of 11, not null).
DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager (

   emp_no INT(11) NOT NULL,

   dept_no CHAR(4) NULL,

   manager_no INT(11) NOT NULL

);

#Exercise continued, Fill emp_manager with data about employees, the number of the department they are working in, and their managers.
#Your query skeleton must be:

-- Insert INTO emp_manager SELECT

-- U.*

-- FROM

--                  (A)

-- UNION (B) UNION (C) UNION (D) AS U;

#A and B should be the same subsets used in the last lecture (SQL Subqueries Nested in SELECT and FROM). 
#In other words, assign employee number 110022 as a manager to all employees from 10001 to 10020 (this must be subset A), 
#and employee number 110039 as a manager to all employees from 10021 to 10040 (this must be subset B).

#Use the structure of subset A to create subset C, where you must assign employee number 110039 as a manager to employee 110022.

#Following the same logic, create subset D. Here you must do the opposite - assign employee 110022 as a manager to employee 110039.

#Your output must contain 42 rows.
Insert INTO emp_manager SELECT
    U.*
FROM
    (SELECT 
        A.*
    FROM
        (SELECT 
        e.emp_no AS employee_id,
            MIN(dp.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_id
    FROM
        employees e
    JOIN dept_emp dp ON e.emp_no = dp.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A UNION SELECT 
        B.*
    FROM
        (SELECT 
        e.emp_no AS employee_id,
            MIN(dp.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_id
    FROM
        employees e
    JOIN dept_emp dp ON e.emp_no = dp.emp_no
    WHERE
        e.emp_no >= 10021 AND e.emp_no <= 10040
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B UNION SELECT 
        C.*
    FROM
        (SELECT 
        e.emp_no AS employee_id,
            MIN(dp.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_id
    FROM
        employees e
    JOIN dept_emp dp ON e.emp_no = dp.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS C UNION SELECT 
        D.*
    FROM
        (SELECT 
        e.emp_no AS employee_id,
            MIN(dp.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_id
    FROM
        employees e
    JOIN dept_emp dp ON e.emp_no = dp.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS D) AS U;

#SWEET we got it right!

#------------------------------Self Join
#joining rows from the same table
#you MUST USE ALIASES, these allow you to use different blocks of one table

#OK, so lets see this in action
#From the emp_manager table, extract the record data only of those employees who are managers as well
SELECT * FROM emp_manager
ORDER BY emp_manager.emp_no;

#now the self join
SELECT e1.* 
FROM emp_manager e1
JOIN emp_manager e2
ON e1.emp_no = e2.manager_no
GROUP BY emp_no; #using GROUP BY gives distinct values

#google up on self-joins, they are interesting





















