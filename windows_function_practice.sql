-- Create database
CREATE DATABASE window_function_practice;
USE window_function_practice;

-- Employee table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    joining_date DATE
);

-- Sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_date DATE,
    amount INT
);

-- Insert employees
INSERT INTO employees VALUES
(1, 'Amit', 'IT', 60000, '2021-01-10'),
(2, 'Neha', 'IT', 50000, '2022-03-15'),
(3, 'Rahul', 'IT', 50000, '2023-02-20'),
(4, 'Priya', 'HR', 45000, '2021-05-25'),
(5, 'Sneha', 'HR', 40000, '2022-08-10'),
(6, 'Rohit', 'Finance', 70000, '2020-11-01'),
(7, 'Kiran', 'Finance', 65000, '2022-01-12');

-- Insert sales
INSERT INTO sales VALUES
(101, 1, '2024-01-01', 10000),
(102, 1, '2024-01-05', 15000),
(103, 2, '2024-01-03', 12000),
(104, 3, '2024-01-07', 12000),
(105, 4, '2024-01-02', 8000),
(106, 5, '2024-01-06', 7000),
(107, 6, '2024-01-04', 20000),
(108, 7, '2024-01-08', 18000);


select * from employees;
select * from sales;


🪟 REAL INTERVIEW WINDOW FUNCTION QUESTIONS
🟢 BASIC (Asked in Fresher Interviews)

1️⃣ Rank employees by salary
 select *, 
 rank() over(order by salary ) as rank_salary from employees

2️⃣ Assign row numbers to employees by joining date
select emp_name,
department,
salary,
row_number() over(order by joining_date asc ) as row_no
from employees

3️⃣ Find duplicate salaries using DENSE_RANK
 with ranked_salary as(select *,
 dense_rank() over(order by salary )as ranked_salary
 from employees
 COUNT(*) OVER (PARTITION BY salary) AS salary_count) 
 SELECT DISTINCT salary
FROM ranked_salary
WHERE salary_count > 1;
 
 WITH ranked_salary AS (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary) AS dense_rnk,
           COUNT(*) OVER (PARTITION BY salary) AS salary_count
    FROM employees
)
SELECT DISTINCT salary
FROM ranked_salary
WHERE salary_count > 1;


4️⃣ Show employee salary along with department average salary

SELECT 
    emp_id,
    emp_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees;


🟡 INTERMEDIATE (Most Common)

5️⃣ Rank employees by salary within each department

with ranked as(select *,
rank() over(partition by department order by salary desc) as emp_rank from employees)
select * from ranked
where emp_rank<=2;


6️⃣ Find top 2 highest paid employees in each department
select *,
rank() over(partition by department order by salary desc ) as emp_rank
from employees 
where emp_rank<2
use 
7️⃣ Find employees earning the same salary in the same department
with emp_ass as(select emp_name, salary,
 over(partition by department)
from employees)
select * from  emp_ass

8️⃣ Calculate running total of sales amount by sale date
 select*,
 sum(amount) over(order by amount desc) sum_over
 from sales


