USE employees

SELECT * FROM employees;

#the code below for a few lines has been 'cleaned' or tidyed with the broom button in MySQL workbench, I wanted to do this to 
#show examples of how the code can be organized differently depending on the aesthetics you need, I am going to reverty
#to single spacing later for the sake of space
#using WHERE
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Denis';

#using the AND clause, get names and gender of men named Denis
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Denis' AND gender = 'M';

#using the OR clause, OR will retrieve data that meets one of the conditions not BOTH like with AND
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Denis'
        OR first_name = 'Elvis';

#using AND and OR together, have to use () for it to work right, logical order precedence takes AND first 
SELECT 
    *
FROM
    employees
WHERE
    last_name = 'Denis'
        AND (gender = 'M' OR gender = 'F');

#using IN and NOT IN, returns data that is in the table according to the provided conditions
SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Cathie' , 'Mark', 'Nathan')

#using LIKE or NOT LIKE, pattern matching with strings
SELECT * FROM employees
WHERE first_name LIKE('Mar%');

#get names ending in ar
SELECT * FROM employees
WHERE first_name LIKE('%ar');

#find ar in the individuals first name
SELECT * FROM employees
WHERE first_name LIKE('%ar%');
    
#search for names with only one letter after the pattern with _
SELECT * FROM employees
WHERE first_name LIKE('Mar_');

#use NOT LIKE to see records not matching this sequence
SELECT * FROM employees
WHERE first_name NOT LIKE('%Mar%');

SELECT * FROM employees
WHERE emp_no LIKE('1000_')

#use BETWEEN and AND, gotta use both together, records are inclusive with the conditions
SELECT * FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '2000-01-01'
ORDER BY hire_date;

#when using NOT BETWEEN, the records specified will NOT be included 
SELECT * FROM employees
WHERE hire_date NOT BETWEEN '1990-01-01' AND '2000-01-01'
ORDER BY hire_date;

#between can also be applied to strings and numbers
SELECT * FROM salaries
WHERE salary BETWEEN 66000 AND 70000;

SELECT * FROM departments
WHERE dept_no BETWEEN 'd003' AND 'd006';

SELECT * FROM employees
WHERE emp_no NOT BETWEEN '10004' AND '10012';

#use IS NOT NULL
SELECT * FROM employees
WHERE first_name IS NOT NULL;

#now we can see that there is no missing data in first_name
SELECT * FROM employees
WHERE first_name IS NULL;

#using <> or !=, they are the same
SELECT * FROM employees
WHERE first_name <> 'Mark';

#using < or >
SELECT * FROM employees
WHERE hire_date > '2000-01-01';

#using <= or >=
SELECT * FROM employees
WHERE hire_date >= '2000-01-01';

SELECT * FROM employees
WHERE hire_date < '1985-02-01';

#all female employees hired in 2000 or after 
SELECT * FROM employees
WHERE hire_date >= '2000-01-01' AND gender = 'F';

#get list of salaries higher than 150,000
SELECT * FROM salaries 
WHERE salary > '150000';

#use DISTINCT, returns unique values
SELECT DISTINCT
    gender
FROM
    employees;

#get list of all different hire dates
SELECT DISTINCT hire_date FROM employees;

--  -----------------------Introduction to Aggregate Functions, NOTE: aggregate functions ignore NAs unless told not to
#using COUNT, this is often used in combo with DISTINCT
SELECT COUNT(hire_date) FROM employees;

SELECT COUNT(DISTINCT hire_date) FROM employees;

#how many employees are there?
SELECT COUNT(DISTINCT emp_no) FROM employees;

#make sure the number of employees was right
SELECT COUNT(first_name) FROM employees;

#see the number of distinct names
SELECT COUNT(DISTINCT first_name) FROM employees;

#EXERCISES
#how many annual contracts with a value higher than or equal to $100,000 are in the salaries table?
SELECT COUNT(*) from salaries
WHERE salary >= 100000;

#How many managers do we have in the employees database?
SELECT COUNT(*) FROM dept_manager;

#Uing ORDER BY clause to order data queries
SELECT * FROM employees
ORDER BY first_name ASC; #SQL defaults to ASC

SELECT * FROM employees
ORDER BY first_name DESC; #starts from the last result when DESC is specified

#ORDER BY works for numeric columns as well
SELECT * FROM employees
ORDER BY emp_no DESC;

#you can order by multiple fields
SELECT * FROM employees
ORDER BY first_name, last_name;

#using GROUP BY (VERY IMPORTANT FOR MORE COMPLEX QUERIES)
#it must be placed immediately after the WHERE clause if one is present and immediately prior to ORDER BY
# when using aggregate functions, you will almost always need a GROUP BY statement as well

#get the count of first names 
SELECT COUNT(first_name) FROM employees
GROUP BY first_name
ORDER BY first_name;

#BUT we also need to ALWAYS include the field we are grouping by in our SELECT statement! this is so we know what we are looking at
SELECT first_name, COUNT(first_name) FROM employees
GROUP BY first_name
ORDER BY first_name;

#using aliases, we can name our aggregated column 
SELECT first_name, COUNT(first_name) AS number_of_names FROM employees
GROUP BY first_name
ORDER BY first_name;

#Exercise, write a query that contains 2 columns, the first has salaries higher than $80,000
# and the second shows the # of employees having that salary, alias this column and sort everything by the first column
SELECT salary, COUNT(emp_no) as num_employees_with_this_salary FROM salaries
WHERE salary > 80000
GROUP BY salary
ORDER BY salary;

#using the HAVING clause, needs to be inserted between the ORDER BY and GROUP BY clauses
#HAVING is like WHERE but applied to the GROUP BY clause

#after HAVING you can have a condition with an aggregate function, while WHERE cannot use aggregate functions within its conditions
SELECT first_name, COUNT(first_name) AS names_count
FROM employees
WHERE COUNT(first_name) > 250 
GROUP BY first_name
ORDER BY first_name;

#this query returns an error, invalid use of group function!

#what about using HAVING? remember we have to place the code between GROUP BY and ORDER BY 
SELECT first_name, COUNT(first_name) AS names_count
FROM employees
GROUP BY first_name
HAVING COUNT(first_name) > 250 #cannot use alias here
ORDER BY first_name;
#Now it works!

#use HAVING when you are using aggregate functions!

#Exercise, select all employees who have an average salary higher than $120,000 
SELECT *, AVG(salary) AS average_salary FROM salaries
GROUP BY emp_no #remember GROUP BY returns the distinct values
HAVING AVG(salary) > 120000;

#what about a query with both HAVING and WHERE?
#get a list of names that are encountered less than 200 times. Let the data refer to people hired after 1 january 1999
SELECT first_name, hire_date, COUNT(first_name) AS names_count FROM employees
WHERE hire_date > '1999-01-01'
GROUP BY first_name
HAVING COUNT(first_name) < 200
ORDER BY hire_date;
#see how the two clauses interact? HAVING must be used with a specific aggregate function whil WHERE is used on a general condition
#Weird quirk to point out with HAVING, you cannot have an aggregate function and a non aggregated statement together with one clause

#Exercise, select the employee numbers of all individuals who have signed more than 1 contract after 1 january 2000
SELECT emp_no FROM dept_emp
WHERE from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no;


#LIMIT statement, just limits the amount of data output
SELECT * FROM employees
LIMIT 10;






















    
    
    