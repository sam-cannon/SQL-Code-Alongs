#---------------------Aggregate Functions (summarizing functions)

#using COUNT (COUNT can be used with both numeric and string data, other agg functions cannot be used with strings)
SELECT COUNT(salary) FROM salaries;

#find distinct dates using COUNT(DISTINCT)
SELECT COUNT(DISTINCT from_date) FROM salaries;

#aggregate functions ignore null values only if you have included a specific column name within the function
#One could use the *, COUNT(*) to return the number of all rows of the table INCLUDING NULL VALUES
SELECT COUNT(*) FROM salaries;
#we have no nulls in this data though

#Exercise, how many departments are there in the 'employees' database?
SELECT COUNT(DISTINCT dept_no) FROM dept_emp;

#using SUM, total amount of salary overall
SELECT SUM(salary) FROM salaries

#Exercise, What is the total amount of money spent on salaries for all contracts starting after the 1 january 1997
SELECT SUM(salary) FROM salaries
WHERE from_date > '1997-01-01';

#using MAX and MIN
SELECT *, MAX(salary) as MAX FROM salaries;

SELECT *, MIN(salary) FROM salaries;

#Exercise, what is the lowest/highest employee number in the database?
SELECT MIN(emp_no) FROM salaries;
SELECT MAX(emp_no) FROM salaries;

#using AVG
#which is the average annual salary the company's employees received?
#use ROUND to round decimals
SELECT ROUND(AVG(salary), 2) FROM salaries;

#Exercise, what is the average annual salary for employees who started after 1 january 1997
SELECT AVG(salary) FROM salaries
WHERE from_date > '1997-01-01';

#using ROUND, really just use it like ROUND(value, # of decimal points to reound to), and thats it!
#you can also not include any decimal points
SELECT ROUND(AVG(salary)) FROM salaries

#using IFNULL
#IFNULL(column, what to say if the column has null values)
#so, you could sat IFNULL(salary, 'no salary provided') if you wanted to see null values as something else

# using COALESCE, basically IFNULL with more than 2 parameters
#COALESCE Will always return a single value of the ones provided in it and the value will be the first non-null value of the list
# reading the values from left to right
#If COALESCE has only 2 arguments then it works the exact same as IFNULL



















