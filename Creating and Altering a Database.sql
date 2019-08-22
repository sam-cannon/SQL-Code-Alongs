#creating a database (couldve used create schema too)
CREATE DATABASE IF NOT EXISTS sales;

#activates the database that you want to use
 USE sales;


#creating a table to go into the database
CREATE TABLE sales 
(
	pruchase_number INT NOT NULL PRIMARY KEY AUTO_INCREMENT,  #auto increment automatically makes unique identifiers for these values
    date_of_purchase DATE NOT NULL,  #this field cannot be null, needs to be date type
    customer_id INT,  #this field can be null, may not know the customerid
    item_code VARCHAR(10) NOT NULL, #this field cannot be null, can be no longer than 10 characters
FOREIGN KEY(customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE #if values are deleted in the customers table then these 
# values will be deleted in the sales table as well, this is directionally dependent, not the same for the child to parent table relationship
    );
    
#we can also alter tables so that we dont have to drop the table frequently
ALTER TABLE sales 
DROP FOREIGN KEY sales_ibfk_1;  #ibfk_1 is the name given to the foreign key constraint found in the ddl tab

#you can also mess with keys by right clicking on the table and using the 'alter table' functionality

#create a customer table
CREATE TABLE customers
(
	customer_id INT, 
    first_name VARCHAR(255), 
    last_name VARCHAR(255), 
    email_address VARCHAR(255), 
    number_of_complaints INT
);

#we dropped the original customers table and are re-creating it
DROP TABLE customers;

#creating a new customers 
CREATE TABLE customers
(
	customer_id INT, 
    first_name VARCHAR(255), 
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    number_of_complaints INT,
PRIMARY KEY(customer_id)
);

#now create items table
CREATE TABLE items
(
	item_id VARCHAR(255) PRIMARY KEY,
    item VARCHAR(255),
    unit_price NUMERIC(10, 2), #remember 10 here is precision and 2 is scale or decimal points
    company_id VARCHAR(255)
);

#create companies table
CREATE TABLE companies
(
	company_id VARCHAR(255) PRIMARY KEY,
    company_name VARCHAR(255),
    headquarters_phone_number INT(12) #this means that no matter what we want the column to show at most 11 digits here
);

#drop the tables
DROP TABLE sales;

DROP TABLE customers;

DROP TABLE items;

DROP TABLE companies;

#create the customer table again
CREATE TABLE customers
(
	customer_id INT, 
    first_name VARCHAR(255), 
    last_name VARCHAR(255), 
    email_address VARCHAR(255), 
    number_of_complaints INT
);

#alter the table to create a unique key constraint for email address
ALTER TABLE customers 
ADD UNIQUE KEY(email_address);

#drop unique keys through drop index statement
ALTER TABLE customers
DROP INDEX email_address;

#drop the customers table and recreate it
DROP TABLE customers;

CREATE TABLE customers
(
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    number_of_complaints INT
);

#now add gender column and values 
ALTER TABLE customers
ADD COLUMN gender ENUM('M', 'F') AFTER last_name;

INSERT INTO customers(first_name, last_name, gender, email_address, number_of_complaints)
VALUES('John', 'Mackinley', 'M', 'john@365careers.com', 0);

#alter the customers table to have a default number of complaints as 0
ALTER TABLE customers
CHANGE COLUMN number_of_complaints number_of_complaints INT DEFAULT 0;

#create a check record to see if the default was changed
INSERT INTO customers(first_name, last_name, gender)
VALUES('sam', 'smith', 'M')

#see if it worked, and it did, can always check the ddl tab
SELECT * FROM sales.customers

#and as always we can drop this with alter table
ALTER TABLE customers
ALTER COLUMN number_of_complaints DROP DEFAULT;

#now drop the companies table and recreate it with new values with a unique key and default values
CREATE TABLE companies
(
	company_id VARCHAR(255),
    company_name VARCHAR(255) DEFAULT 'X',
    headquarters_phone_number VARCHAR(255) UNIQUE KEY
);

DROP TABLE companies;

CREATE TABLE companies
(
	company_id VARCHAR(255),
    company_name VARCHAR(255) NOT NULL, #placing the not null constraint on the column
    headquarters_phone_number VARCHAR(255) UNIQUE KEY
);

#removing the NOT NULL constraint with MODIFY
ALTER TABLE companies
MODIFY company_name VARCHAR(255) NULL;

#placing back again
ALTER TABLE companies
CHANGE COLUMN company_name company_name VARCHAR(255) NOT NULL;














