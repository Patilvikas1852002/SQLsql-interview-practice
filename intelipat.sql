create database intelipat_question 
use intelipat_question
CREATE TABLE sales (
sale_id INT PRIMARY KEY,
sale_date DATE,
amount DECIMAL(10, 2)
);

INSERT INTO sales (sale_id, sale_date, amount) VALUES
(1, '2023-01-15', 100.50),
(2, '2023-01-20', 150.25),
(3, '2023-10-05', 200.00),
(4, '2023-12-10', 150.00),
(5, '2024-02-01', 75.00),
(6, '2023-01-25', 25.00);


For Q1: Finding total sales for each month of the year 2023

select month(sale_date) as month, sum(amount) as total_sales from sales
where year(sale_date)=2023
group by month(sale_date);


For Q2: Finding customers who placed orders after 1st January 2023

sql
CREATE TABLE customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(255),
city VARCHAR(255)
);

CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE,
order_amount DECIMAL(10, 2),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, customer_name, city) VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Johnson', 'Los Angeles'),
(3, 'Charlie Davis', 'Chicago'),
(4, 'Robin Smith', 'New York'),
(5, 'Tom Brown', 'Houston');

INSERT INTO orders (order_id, customer_id, order_date, order_amount) VALUES
(1, 1, '2023-01-01', 500.00),
(2, 2, '2024-02-10', 1200.00),
(3, 1, '2023-03-20', 300.00),
(4, 4, '2023-10-15', 750.00),
(5, 3, '2022-11-25', 200.00),
(6, 5, '2024-01-05', 900.00);

Q2: Finding customers who placed orders after 1st January 2023

select c.customer_name,o.order_date from customers c 
join orders o on c.customer_id=o.customer_id
where   o.order_date>'2023-01-01'


---------------------------------------------------------------------

CREATE TABLE employees (
employee_id INT PRIMARY KEY,
department_id INT,
salary DECIMAL(10, 2)
);

INSERT INTO employees (employee_id, department_id, salary) VALUES
(101, 101, 550.00),
(102, 102, 750.00),
(103, 101, 480.00),
(104, 102, 800.00),
(105, 103, 600.00),
(106, 101, 510.00);

For Q3: Second Highest Salary for Department 101
select max(salary) as highest_salary from employees
where salary<(select max(salary) as highest_salary from employees where department_id=101)
-------------------------------------------------------------------------------------------------

For Q4: Finding products that have never been sold

sql
CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR(255),
price DECIMAL(10, 2)
);

CREATE TABLE sales_q4 (
sale_id INT PRIMARY KEY,
product_id INT,
quantity INT,
FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Laptop', 1200.00),
(2, 'Mouse', 25.00),
(3, 'Tablet', 400.00),
(4, 'Keyboard', 75.00),
(5, 'Smartwatch', 300.00);

INSERT INTO sales_q4 (sale_id, product_id, quantity) VALUES
(1, 1, 2),
(2, 2, 5),
(3, 1, 1),
(4, 4, 3),
(5, 1, 1);

or Q4: Finding products that have never been sold

select product_name from products
where product_id not in(select distinct product_id from sales_q4);

--------------------------------------------------------------------------------------
For Q5: Finding customers whose order amount exceeds 1000

sql
CREATE TABLE orders_q5 (
order_id INT PRIMARY KEY,
customer_id INT,
order_amount DECIMAL(10, 2)
);

INSERT INTO orders_q5 (order_id, customer_id, order_amount) VALUES
(1, 101, 500.00),
(2, 102, 1200.00),
(3, 101, 600.00),
(4, 103, 700.00),
(5, 102, 300.00),
(6, 101, 800.00), 
(7, 103, 1000.00);

(17:28)

For Q6: Finding the total quantity for each product from stores in LA during 2023

CREATE TABLE products_q6 (
product_id INT PRIMARY KEY,
product_name VARCHAR(255),
category_id INT
);

CREATE TABLE stores (
store_id INT PRIMARY KEY,
store_name VARCHAR(255),
city VARCHAR(255)
);

CREATE TABLE sales_q6 (
sale_id INT PRIMARY KEY,
product_id INT,
store_id INT,
quantity INT,
sale_date DATE,
FOREIGN KEY (product_id) REFERENCES products_q6(product_id),
FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

INSERT INTO products_q6 (product_id, product_name, category_id) VALUES
(1, 'Laptop', 1),
(2, 'Tablet', 1),
(3, 'Smartphone', 2),
(4, 'Desktop', 1);
INSERT INTO stores (store_id, store_name, city) VALUES
(1, 'Tech Zone LA', 'Los Angeles'),
(2, 'Gadget Hub NY', 'New York'),
(3, 'Electro World LA', 'Los Angeles');
INSERT INTO sales_q6 (sale_id, product_id, store_id, quantity, sale_date) VALUES
(1, 1, 1, 2, '2023-05-10'),
(2, 3, 2, 1, '2023-01-20'),
(3, 1, 3, 3, '2023-07-01'),
(4, 2, 1, 1, '2022-11-15'),
(5, 4, 3, 2, '2024-03-01');

For Q6: Finding the total quantity for each product from stores in LA during 2023

select  p.product_name,sum(s.quantity) as total_quantity  from  products_q6 p
join sales_q6 s on p.product_id=s.product_id
join stores sa on sa.store_id=s.store_id
where sa.city='LA' and year(s.sale_date)='2023'
group by p.product_name;
--------------------------------------------------------------------------------------------- 
 

sql
CREATE TABLE employees_q7 (
employee_id INT PRIMARY KEY,
employee_name VARCHAR(255),
manager_id INT
);

INSERT INTO employees_q7 (employee_id, employee_name, manager_id) VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Carol', 1),
(4, 'David', 2),
(5, 'Emma', 2),
(6, 'Frank', 3),
(7, 'Grace', 3);

select * from employees_q7
For Q7: Finding names of employees along with their direct managers
select e.employee_name,m.employee_name as Manager_name from employees_q7 e
left join employees_q7  m on e.employee_id=m.manager_id
