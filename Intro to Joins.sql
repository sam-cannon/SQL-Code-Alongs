#--------------------------------------JOINS
#create departments_dup table
CREATE TABLE departments_dup 
(
	dept_no CHAR(4),
    dept_name VARCHAR(40)
);

#insert copy of info from departments table
INSERT INTO departments_dup
(
	dept_no,
    dept_name
)
(
	SELECT * FROM departments
);

#create a Public Relations department record
INSERT INTO departments_dup
(
	dept_name
)
VALUES
(
	'Public Relations'
);

#removing records from database using DELETE (NOTE: YOU must go the Edit -> Preferences -> SQL Editor -> uncheck the 'Safe Updates' Box
# you MUST restart your SQL session for the 'Safe Updates' option to be confirmed, be careful here, I suggest googling Safe Updates and 
# determining for yourself the best way to check/uncheck it in the future, we are unchecking it here so that we can delete observations in the 
#database, but if you forget it is unchecked you can lose a lot of data!!!!
USE employees;

#use DELETE to remove the row
DELETE FROM departments_dup
WHERE dept_no = 'd002';

#insert two new records
INSERT INTO departments_dup
(
	dept_no
)
VALUES
('d010'), ('d011');

SELECT * FROM departments_dup;

#Create dept_manager_dup table 
DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (

  emp_no int(11) NOT NULL,

  dept_no char(4) NULL,

  from_date date NOT NULL,

  to_date date NULL

  );

 

INSERT INTO dept_manager_dup

select * from dept_manager;

 

INSERT INTO dept_manager_dup (emp_no, from_date)

VALUES                (999904, '2017-01-01'),

                                (999905, '2017-01-01'),

                               (999906, '2017-01-01'),

                               (999907, '2017-01-01');

 

DELETE FROM dept_manager_dup

WHERE

    dept_no = 'd001';

INSERT INTO departments_dup (dept_name)

VALUES                ('Public Relations');

 

DELETE FROM departments_dup

WHERE

    dept_no = 'd002'; 

#look at the manager table
SELECT * FROM dept_manager_dup
ORDER BY dept_no;

#look at the department table
SELECT * FROM departments_dup
ORDER BY dept_no;

#join the tables with an INNER JOIN
SELECT * FROM departments_dup as dd
JOIN dept_manager_dup as dm
ON dd.dept_no = dm.dept_no;

#select specific columns
SELECT m.dept_no, m.emp_no, d.dept_name
FROM departments_dup as d
JOIN dept_manager_dup as m
ON d.dept_no = m.dept_no
ORDER BY m.dept_no;

#INNER JOIN matches records from both tables, NA values will not be displayed, you also do not have to type out INNER
#JOIN will return an INNER JOIN by default
#Another note with JOIN in general, matching column = linking column, these are the same, whichever column links the tables



#Exercise, Extract a list containing information about all managers’ employee number, first and last name, 
# department number, and hire date. 
SELECT d.emp_no, e.first_name, e.last_name, d.dept_no, e.hire_date
FROM dept_manager as d
JOIN employees as e
ON d.emp_no = e.emp_no
ORDER BY emp_no;

#You can add any number of columns into your output as long as the records match they will appear

# ----------------------------Duplicate Records
#insert duplicate row
INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');

#create another duplicate row in departments_dup
INSERT INTO departments_dup
VALUES ('d009',  'Customer Service'); #remember, if the entries match columns then we don't have to specify columns in INSERT 

#check
SELECT * FROM dept_manager_dup
ORDER BY dept_no;

#check
SELECT * FROM departments_dup
ORDER BY dept_name;

#Now join them and see what happens
SELECT m.dept_no, m.emp_no, d.dept_name
FROM departments_dup as d
JOIN dept_manager_dup as m
ON d.dept_no = m.dept_no
ORDER BY dept_no;
#we get 25 rows back now, notice the Customer Service results at the bottom are all duplicates of each other 

#so , how do we deal with duplicates if they aren't supposed to be there?
#We simply add a GROUP BY statement that will return distinct values, group joins by the field that differs most among records!
SELECT m.dept_no, m.emp_no, d.dept_name
FROM departments_dup as d
JOIN dept_manager_dup as m
ON d.dept_no = m.dept_no
GROUP BY m.emp_no
ORDER BY dept_no;

#----------------------------------------LEFT JOIN
#remove duplicated rows that were created from the last section
DELETE FROM dept_manager_dup
WHERE emp_no = '110228';

DELETE FROM departments_dup
WHERE dept_no = 'd009';

#Now add back in the information that was originally in the table, since our last code deleted the originals as well
INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');

INSERT INTO departments_dup
VALUES ('d009', 'Customer Service');


#Now LEFT JOIN
#LEFT JOIN will return all rows from the first table that do not match the rows from the other table
#In addition, it will return the rows that do match, just like an INNER JOIN would
#The order that you JOIN tables matters!
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup as m
LEFT JOIN departments_dup as d
ON d.dept_no = m.dept_no
ORDER BY dept_no;

#switch order of tables, retrieve the first column from the first table!
#BTW, you could also use LEFT OUTER JOIN, they are interchangeable, but you shouldn't type OUTER, its always OUTER with LEFT or RIGHT
SELECT d.dept_no, m.emp_no, d.dept_name
FROM departments_dup as d
LEFT JOIN dept_manager_dup as m
ON d.dept_no = m.dept_no
ORDER BY dept_no;
#examine the differences yourself

#retrieve the records that contain Nulls after the JOIN using a WHERE IS NULL clause
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup as m
LEFT JOIN departments_dup as d
ON d.dept_no = m.dept_no
WHERE dept_name IS NULL
ORDER BY dept_no;

#Exercise, Join the 'employees' and the 'dept_manager' tables to return a subset of all the employees whose last name is Markovitch. 
#See if the output contains a manager with that name. 
SELECT e.first_name, e.last_name, d.from_date, d.dept_no, d.emp_no 
FROM employees as e
JOIN dept_manager as d
ON e.emp_no = d.emp_no
WHERE e.last_name = 'Markovitch'
ORDER BY dept_no, emp_no;

#RIGHT JOIN, the same exact funcitonality as LEFT JOIN but the process is inverted
#again, RIGHT OUTER JOIN is the same thing
#NOTICE, if we substitute 'm' and 'd' out in the first column being selected (i.e. d.dept_no) we get a different output
#each time, why is this? its becuase we are using the dept_no from the departments_dup table instead of the one from 
#dept_manager
SELECT d.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup as m
RIGHT JOIN departments_dup as d
ON d.dept_no = m.dept_no
ORDER BY dept_no;

#NOTE: RIGHT JOINS ARE RARELY APPLIED IN PRACTICE! This is due to the fact that you can simply invert the joined tables 
#in a LEFT JOIN and the outpute would be exactly the same!






