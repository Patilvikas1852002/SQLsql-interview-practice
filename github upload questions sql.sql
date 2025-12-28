-- Create Database
CREATE DATABASE mnc_sql_practice;
USE mnc_sql_practice;

-- Employees Table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    manager_id INT,
    salary INT,
    join_date DATE
);

INSERT INTO employees VALUES
(1,'Amit','IT',3,70000,'2021-01-10'),
(2,'Riya','HR',5,45000,'2022-03-15'),
(3,'Suresh','IT',NULL,90000,'2019-06-20'),
(4,'Neha','Finance',6,60000,'2020-09-12'),
(5,'Priya','HR',NULL,80000,'2018-11-01'),
(6,'Raj','Finance',NULL,95000,'2017-04-25'),
(7,'Karan','IT',3,50000,'2023-07-01'),
(8,'Pooja','Finance',6,75000,'2022-12-05'),
(9,'Vikas','IT',3,90000,'2020-02-10'),
(10,'Anjali','HR',5,40000,'2023-08-18');

-- Projects Table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    emp_id INT,
    project_name VARCHAR(50),
    budget INT
);

INSERT INTO projects VALUES
(101,1,'ERP',200000),
(102,3,'CRM',300000),
(103,4,'Audit',150000),
(104,7,'Cloud',250000),
(105,9,'AI',500000);

-- Sales Table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_amount INT,
    sale_date DATE
);

INSERT INTO sales VALUES
(1,1,50000,'2024-01-10'),
(2,1,30000,'2024-02-15'),
(3,7,20000,'2024-01-20'),
(4,9,70000,'2024-03-05'),
(5,9,30000,'2024-03-15');
----------------------------------------------------------------------------------
 INTERMEDIATE SQL REAL LIFE SCENARIO QUESTIONS (PROJECT)
-----------------------------------------------------------------------------------
🔹 Q1 Find employees whose salary is greater than the average salary of their department.
------------------------------------------------------------------------------------
SELECT e.emp_name, e.salary, e.department
FROM employees e
WHERE e.salary >
(
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e.department
);
-----------------------------------------------------------------------------------
🔹 Q2 Display department-wise total salary but only those departments whose total salary > 150000.
  ----------------------------------------------------------------------------------
select department, sum(salary) as total_salary from employees
group by department
having sum(salary)>150000

-----------------------------------------------------------------------------------------------
🔹 Q3 Find employees who do not have any project assigned.
 ---------------------------------------------------------------------------------------------
 select emp_id,emp_name from employees
 where emp_id not in(select emp_id from projects)
 


----------------------------------------------------------------------------------------------------
🔹 Q4 Display employee name and manager name (self join).
---------------------------------------------------------------------------------------------------
select e.emp_name as employee_name,m.emp_name as manager_name from employees  e
 join employees m on m.manager_id=e.emp_id

-- another query

SELECT 
    t1.emp_name as employee_name,
    t2.emp_name as manager_name
FROM employees AS t1
JOIN employees AS t2
ON t1.emp_id = t2.manager_id;


------------------------------------------------------------------------------------------------------
🔹 Q5 Find the second highest salary in the company without using LIMIT.
----------------------------------------------------------------------------------------------------
select max(salary) as second_highest_salary  from employees
where salary <(select max(salary) from employees)

---------------------------------------------------------------------------------------------------------
🔹 Q6 Find Duplicate Salaries from employees table
--------------------------------------------------------------------------------------------------------
SELECT emp_name, salary
FROM employees
WHERE salary IN (
    SELECT salary
    FROM employees
    GROUP BY salary
    HAVING COUNT(*) > 1
)
ORDER BY salary, emp_name;
-------------------------------------------------------------------------------------------------------------
🔹 Q7 Find employees who joined in the last 2 years.
-------------------------------------------------------------------------------------------------------------
select emp_name,join_date from employees
where join_date>=curdate() - interval 2 YEAR



-------------------------------------------------------------------------------------------------------------
🔹 Q8 Find total sales amount by each employee
👉 Include employees who made no sales.
---------------------------------------------------------------------------------------------------------------
select e.emp_name,sum(s.sale_amount) as total_sales from  employees e
left join sales s  on e.emp_id=s.emp_id
group by emp_name



---------------------------------------------------------------------------------------------------------------
🔹 Q9 Rank employees by salary within each department.
---------------------------------------------------------------------------------------------------------------
select *,
rank() over(partition by department order by salary desc) as rnk
from employees
------------------------------------------------------------------------------------------------------------
🔹 Q10 Find employees earning more than their manager.
----------------------------------------------------------------------------------------------------------

SELECT 
    e.employee_id,
    e.name AS employee_name,
    e.salary AS employee_salary,
    m.employee_id AS manager_id,
    m.name AS manager_name,
    m.salary AS manager_salary
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;
----------------------------------------------------------------------------------------------------------------------------------------------------
