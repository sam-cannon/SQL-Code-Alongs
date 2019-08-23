#-------------------------Advanced JOIN
#INNER JOIN 20 row output
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup AS m
JOIN departments_dup AS d
ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

#Entries that match each other to create inner joins are called 'connection points'

#NOTE: the old JOIN syntax uses WHERE clauses to connect tables, the output is the same but its not how things are done now!
#more complex examples would show that using WHERE is inefficient and slower, don't use it!

#using JOIN and WHERE together, get all salaries greater than $145,000
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees AS e
JOIN salaries AS s
ON e.emp_no = s.emp_no
WHERE s.salary > 145000
ORDER BY s.salary;

#Exercise, Select the first and last name, the hire date, and the job title of all employees 
#whose first name is “Margareta” and have the last name “Markovitch”.
SELECT e.first_name, e.last_name, e.hire_date, t.title
FROM employees AS e
JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE first_name = 'Margareta' AND last_name = 'Markovitch';
#interesting, we can see that she was promoted!

#-----------CROSS JOIN
#using CROSS JOIN will take all the values from a certain table and connect them with all the values from the table we want to JOIN with
# This differs from INNER JOIN in that it doesn't only connect matching values 
# CROSS JOIN connects ALL values, it creates a cartesian product of the tables, table 1(n rows) x table 2(m rows) = nxm table,a lot of rows
#CROSS JOIN is really only useful when the tables in a database are not well connected, so the 'employees' database isn't the best 
#place to use this, but.. hey

#CROSS JOIN
SELECT dm.*, d.* FROM dept_manager AS dm
CROSS JOIN departments AS d
ORDER BY dm.emp_no, d.dept_no;

#display all departments EXCEPT the one that the manager is currently head of (e.g. no matching dept_no's)
SELECT dm.*, d.* FROM dept_manager AS dm
CROSS JOIN departments AS d
WHERE dm.dept_no != d.dept_no
ORDER BY dm.emp_no, d.dept_no;
#now the manager's own department is not included in the result set, also the difference in length between this code's output and 
# the previous code's output will be the exact number of managers in the dept_managers table!

#CROSS JOIN more than 2 tables, be careful about the size of the table

#use CROSS JOIN and JOIN together
SELECT e.*, d.* 
FROM departments AS d
CROSS JOIN dept_manager AS dm
JOIN employees AS e ON dm.emp_no = e.emp_no
WHERE d.dept_no != dm.dept_no
ORDER BY dm.emp_no, d.dept_no;

#Exercise, Use a CROSS JOIN to return a list with all possible 
#combinations between managers from the dept_manager table and department number 9.
SELECT dm.*, d.*
FROM dept_manager AS dm
CROSS JOIN departments AS d
WHERE d.dept_no = 'd009';

#Exercise, Return a list with the first 10 employees with all the departments they can be assigned to
SELECT e.*, d.*
FROM employees AS e
CROSS JOIN departments AS d
WHERE e.emp_no < 10011
ORDER BY e.emp_no, d.dept_name;

#Exercise, find the average salaries of  men and women in the company
SELECT AVG(s.salary) AS average_salary, e.gender
FROM salaries AS s
JOIN employees AS e
ON s.emp_no = e.emp_no
GROUP BY gender;
#REMEMBER, you should group by the field of interest when using aggregate functions

#------------JOIN multiple tables

SELECT e.first_name, e.last_name, e.hire_date, m.from_date, d.dept_name
FROM employees AS e
JOIN dept_manager AS m
ON e.emp_no = m.emp_no
JOIN departments AS d
ON m.dept_no = d.dept_no
ORDER BY e.last_name;
#be sure to link the columns correctly!

#Exercise, Select all managers’ first and last name, hire date, job title, start date, and department name.
SELECT e.emp_no, e.first_name, e.last_name, e.hire_date, t.title, m.from_date, d.dept_name
FROM employees e
JOIN titles t
ON e.emp_no = t.emp_no
JOIN dept_manager m
ON t.emp_no = m.emp_no
JOIN departments d
ON m.dept_no = d.dept_no
GROUP BY e.first_name
ORDER BY e.emp_no;

#Get the average salary for each department, trick here is joining multiple tables to get desired result
SELECT d.dept_name, AVG(s.salary) AS avg_salary
FROM departments d
JOIN dept_manager m
ON d.dept_no = m.dept_no
JOIN salaries s
ON m.emp_no = s.emp_no
GROUP BY d.dept_name;

#Exercise, How many male and how many female managers do we have in the ‘employees’ database?
SELECT COUNT(m.emp_no) AS count, gender
FROM dept_manager m
JOIN employees e
ON m.emp_no = e.emp_no
GROUP BY e.gender;

#----------------UNION vs UNION ALL
#create employees duplicate
DROP TABLE IF EXISTS employees_dup;

CREATE TABLE employees_dup
(emp_no INT(11), birth_date date, first_name VARCHAR(14), last_name VARCHAR(16), gender ENUM('M', 'F'), hire_date date);

#fill new table with first 20 rows of employees table
INSERT INTO employees_dup
SELECT * FROM employees
LIMIT 20;
#check
SELECT * FROM employees_dup;

#now insert a duplicate of the first row
INSERT INTO employees_dup
VALUES ('10001', '1953-09-02', 'Georgi', 'Facello',  'M', '1986-06-26');
#check to see if it worked
SELECT * FROM employees_dup
ORDER BY first_name;

# UNION ALL is used to unify tables 
SELECT 
	e.emp_no, 
    e.first_name, 
    e.last_name, 
    NULL AS dept_no,
    NULL AS from_date
FROM 
	employees_dup e
WHERE 
	e.emp_no = 10001
UNION ALL SELECT 
	NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM 
	dept_manager m;
#a lot to unpack here, we basically unioned the two tables through adding in the missing columns between the two tables as NULL values
# we created the missing columns so that the tables could be unioned, which is why theres a bunch of NULL values
    
#now lets use UNION instead of UNION ALL
SELECT 
	e.emp_no, 
    e.first_name, 
    e.last_name, 
    NULL AS dept_no,
    NULL AS from_date
FROM 
	employees_dup e
WHERE 
	e.emp_no = 10001
UNION SELECT 
	NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM 
	dept_manager m;
#this returned 1 less row, and it was the row that was duplicated in the UNION ALL statement 

#When uniting two identically organized tables, UNION retrieves distinct values while UNION ALL gets all the duplicates as well


















