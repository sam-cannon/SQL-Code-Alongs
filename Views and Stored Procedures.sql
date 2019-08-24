#---------------------------Using SQL Views
#views are a virtual table whose contents are obtained from existing tables or 'base tables'

#visualize only the period encompassing the last contract of each employee
CREATE OR REPLACE VIEW v_dept_emp_latest_date AS
SELECT emp_no, MAX(from_date) as from_date, MAX(to_date) as to_date
FROM dept_emp
GROUP BY emp_no;
#our view is stored in 'views' under our table in the navigator
#creating a view could be helpful if you want to organize information that you want to go back to over time
#you could allow each person that is using this database to see this table as well
#views are dynamic, which means they update as the underlying base tables update
#you cannot insert or update info that is in them though

#Exercise, Create a view that will extract the average salary of all managers registered in the database. 
#Round this value to the nearest cent.
#If you have worked correctly, after executing the view from the “Schemas” section in Workbench, you should obtain the value of 66924.27.
CREATE OR REPLACE VIEW v_avg_salary_managers AS 
SELECT ROUND(AVG(s.salary), 2) AS average_salary
FROM salaries s
WHERE s.emp_no IN (SELECT m.emp_no FROM dept_manager m);
#If you go down to the views tab on the navigator and allow your cursor to hover over the view, the third from the left icon will execute
#the SELECT statement contained within the view, which will return your result set!

#another solution to the same problem
CREATE OR REPLACE VIEW v_manager_avg_salary AS

    SELECT

        ROUND(AVG(salary), 2)

    FROM

        salaries s

            JOIN

        dept_manager m ON s.emp_no = m.emp_no;
        
#----------------------------Stored Routines
#stored routines are statements that are stored on the server, prevents people from having to run the same code over and over again
# if they are repeatedly needing that query
# indicated by CALL, REFERENCE, or INVOKE
#two types of stored routines, procedures and functions

#create a procedure that will return the first 1000 from the employees table (general structure of a stored procedure)

USE employees; #call the database you want the procedure to be in 

DROP PROCEDURE IF EXISTS select_employees; #drop if it already exists
#always set $$ before starting, always use () after the name, then always reset the delimiter to ; when you are finished!
DELIMITER $$ 
CREATE PROCEDURE select_employees() 
BEGIN
	SELECT * FROM employees
    LIMIT 1000;
END$$
DELIMITER ;
#now we can see it in our 'stored procedures' in the navigator

#using stored procedures
CALL employees.select_employees();
#CALL brings up all the data in that routine

#we can also just directly call it since we are already in the databse
CALL select_employees();

#we can also use the procedure directly by clicking the lightning button while hovering over the stored procedure in the navigator
#we can ALSO create a stored procedure by right clicking on stored procedures and clicking 'create stored procedure'

#Stored procedures with an input parameter, similar to creating functions in Python
#return info for a specific emp_no
DROP PROCEDURE IF EXISTS salary;
DELIMITER $$
CREATE PROCEDURE salary(IN p_emp_no INTEGER)
BEGIN
SELECT 
	e.first_name, e.last_name, s.salary, s.from_date, s.to_date
FROM 
	employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.emp_no = p_emp_no;
END$$

DELIMITER ;

#we can then click on the lightning button again and type in any employee number to see their salary!
#you can also use aggreagate functions within stored procedures as well
DELIMITER $$
CREATE PROCEDURE av_salary(IN p_emp_no INTEGER)
BEGIN
SELECT 
	e.first_name, e.last_name, AVG(s.salary)
FROM 
	employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.emp_no = p_emp_no;
END$$

DELIMITER ;

#now we can call it locally
CALL av_salary(11300);

#stored procedures with output parameters
DROP PROCEDURE IF EXISTS av_salary_out;
DELIMITER $$
CREATE PROCEDURE av_salary_out(IN p_emp_no INTEGER, out p_avg_salary DECIMAL(10, 2))
BEGIN
	SELECT AVG(s.salary) 
    INTO p_avg_salary
	FROM 
	employees e
	JOIN salaries s ON e.emp_no = s.emp_no
	WHERE e.emp_no = p_emp_no;
END$$

DELIMITER ;
#we can use this using the lightning key again

#-------------------------Variables
#working with variables
#SO, we created a variable using the @ symbol, populated it with 0, which is standard practice, filled it using a stored procedure, and then
# we basically called the variable out after populating it with an employee number for the average salary calculation
SET @v_avg_salary = 0;
CALL employees.av_salary_out(11300, @v_avg_salary);
SELECT @v_avg_salary;




















