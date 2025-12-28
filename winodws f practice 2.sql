-- Create Database
CREATE DATABASE window_practice;
USE window_practice;

-- Employees Table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    join_date DATE
);

-- Insert Data
INSERT INTO employees VALUES
(1, 'Amit', 'IT', 60000, '2021-01-10'),
(2, 'Neha', 'IT', 75000, '2020-03-15'),
(3, 'Ravi', 'HR', 500,'2022-03-12');

INSERT INTO employees VALUES(4, 'Amit', 'IT', 65000, '2021-01-10'),
(5, 'Neha', 'IT', 78000, '2020-03-15'),
(6, 'Ravi', 'HR', 5000,'2022-03-12');


BASIC

1️⃣ Display each employee’s salary along with their rank based on salary (highest first).
select *,
row_number() over (order by salary desc) as rnk
from employees


2️⃣ Assign a row number to each employee department-wise, ordered by salary descending.
select *,
row_number() over(partition by department order by salary desc) as rnk
from employees


3️⃣ Show employees with their dense rank based on salary.
select *,
dense_rank() over(order by salary desc) as dense_rnk
from employees


INTERMEDIATE

4️⃣ Rank employees within each department based on salary.
select *,
row_number() over(partition by department order by salary desc) as rnk
from employees



5️⃣ Display the highest paid employee in each department using a window function.
with maxsal as(select *,
row_number() over(partition by department order by salary desc) as rnk
from employees) 
select *from maxsal
where rnk<=1;



6️⃣ Display the second highest salary in each department.
with emp_acc as(select *, 
max(salary) over(partition by department order by salary desc) as rnk
from employees)
select * from emp_acc
where rnk>1;




