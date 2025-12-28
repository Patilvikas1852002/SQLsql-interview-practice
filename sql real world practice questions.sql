/* ---------------------------------------
CREATE DATABASE & USE
--------------------------------------- */
CREATE DATABASE sql_db;
USE sql_db;


/* ---------------------------------------
CREATE TABLE
--------------------------------------- */
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    join_date DATE
);


/* ---------------------------------------
INSERT DATA
--------------------------------------- */
INSERT INTO employees (emp_id, emp_name, department, salary, join_date) VALUES
(1, 'Amit', 'IT', 50000, '2022-01-10'),
(2, 'Neha', 'HR', 45000, '2021-03-15'),
(3, 'Rahul', 'IT', 60000, '2020-07-20'),
(4, 'Sneha', 'Finance', 55000, '2019-11-25'),
(5, 'Vikas', 'IT', 50000, '2022-01-10'),
(6, 'Pooja', 'HR', 40000, '2023-06-01'),
(7, 'Ankit', 'Finance', 70000, '2018-05-05'),
(8, 'Rohit', 'IT', 60000, '2020-07-20');

-- STEP 2: PRACTICE QUESTIONS (MASTER LEVEL)
🔹 WHERE / AND / OR
select * from employees
1️⃣ Display employees from IT department earning more than 55000
select * from employees
where department='IT' and salary>55000

2️⃣ Display employees from HR OR Finance department
select * from employees
where department='HR' or department='Finance'
🔹 DISTINCT

3️⃣ Display distinct departments
select distinct department from employees

🔹 BETWEEN

4️⃣ Display employees whose salary is between 45000 and 60000
select * from employees
where salary between 45000 and 60000
🔹 TOP (LIMIT in MySQL)

5️⃣ Display top 3 highest paid employees
 select salary from employees
 order by salary desc 
🔹 HAVING

6️⃣ Display departments having total salary greater than 100000
select department,sum(salary) as total_salary from employees 
group by department
having total_salary>100000
🔹 UPDATE

7️⃣ Increase salary by 5000 for employees in IT department
update employees set salary=salary+5000
where department='IT'
🔹 DELETE

8️⃣ Delete employees who joined before 2020
delete from employees 
where year(join_date)<'2020'
🔹 TRUNCATE

9️⃣ Remove all records from employees table (structure remains)
truncate  employees
🔹 DROP

🔟 Completely remove the employees table
drop employees

🔹 ALTER

1️⃣1️⃣ Add a new column email VARCHAR(50) to employees table
alter table employees add column email varchar(50)

1️⃣2️⃣ Change salary column datatype from INT to BIGINT
alter table employees modify column salary BIGINT
🔹 RENAME

1️⃣3️⃣ Rename table employees to employee_master
 rename table employees to employee_master
