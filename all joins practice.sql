
CREATE DATABASE sql_joins_practice;
USE sql_joins_practice;

-- Employees
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    manager_id INT,
    salary INT
);

-- Departments
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Projects
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT
);

-- Employee Projects (Many-to-Many)
CREATE TABLE employee_projects (
    emp_id INT,
    project_id INT
);

-- Insert Departments
INSERT INTO departments VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Marketing');

-- Insert Employees
INSERT INTO employees VALUES
(1, 'Alice', 1, NULL, 80000),
(2, 'Bob', 2, 1, 90000),
(3, 'Charlie', 2, 1, 70000),
(4, 'Diana', 3, 2, 85000),
(5, 'Eve', NULL, 2, 60000),
(6, 'Frank', 4, NULL, 75000);

-- Insert Projects
INSERT INTO projects VALUES
(101, 'Recruitment System', 1),
(102, 'Website Revamp', 2),
(103, 'Budget Analysis', 3),
(104, 'Ad Campaign', 4),
(105, 'Internal Tool', NULL);

-- Insert Employee-Project Mapping
INSERT INTO employee_projects VALUES
(1, 101),
(2, 102),
(3, 102),
(4, 103),
(2, 105);


#INNER JOIN — Practice Questions

-- List employee names along with their department names.

select e.emp_name,d.dept_name from employees  e
inner join departments d on e.dept_id=d.dept_id;


-- List employees working on projects.
select p.project_name, e.emp_name
from projects p
inner join employee_projects ep on p.project_id = ep.project_id
inner join employees e on ep.emp_id = e.emp_id;


-- Show project names and employee names assigned to each project.
select p.project_name, e.emp_name
from projects p
inner join employee_projects ep on p.project_id = ep.project_id
inner join employees e on ep.emp_id = e.emp_id;


-- Find employees who belong to the IT department.
select e.emp_name,d.dept_name from employees e
inner join departments d on e.dept_id=d.dept_id
where d.dept_name='IT'

-- Count number of employees in each department.
select count(e.emp_name),dept_name from employees e
inner join departments d on d.dept_id=e.dept_id
group by dept_name;

 #LEFT JOIN — Practice Questions

#List all employees, including those without departments.
select e.emp_name,d.dept_name from employees e
left join departments d on e.dept_id=d.dept_id



-- Show all departments and the employees in them (include empty departments).
select d.dept_name, e.emp_name
from departments d
left join employees e on d.dept_id = e.dept_id;



-- List all projects and assigned employees (include projects with no employees).
select p.project_name, e.emp_name
from projects p
left join employee_projects ep on p.project_id = ep.project_id
left join employees e on ep.emp_id = e.emp_id;



-- Find employees who are not assigned to any project.
select e.emp_name
from employees e
left join employee_projects ep on e.emp_id = ep.emp_id
where ep.project_id is null;



-- Find departments that have no employees.
select d.dept_name,e.emp_name from departments d
left join employees e on d.dept_id=e.dept_id
where emp_name is null;

