/* =========================
   DATABASE SCHEMA
   ========================= */
create database advance45;
use advance45;
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT,
    dept_id INT,
    salary INT,
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    start_date DATE,
    end_date DATE
);

CREATE TABLE employee_projects (
    emp_id INT,
    project_id INT,
    allocation_percent INT,
    PRIMARY KEY (emp_id, project_id)
);

CREATE TABLE salaries_history (
    emp_id INT,
    salary INT,
    effective_date DATE
);

/* =========================
   INSERT DATA
   ========================= */

INSERT INTO departments VALUES
(1, 'Engineering'),
(2, 'HR'),
(3, 'Sales'),
(4, 'Finance');

INSERT INTO employees VALUES
(1, 'Alice', NULL, 1, 90000, '2018-01-10'),
(2, 'Bob', 1, 1, 70000, '2019-03-15'),
(3, 'Charlie', 1, 1, 70000, '2019-03-15'),
(4, 'David', 2, 2, 60000, '2020-06-01'),
(5, 'Eva', 1, 3, 80000, '2017-11-20'),
(6, 'Frank', 5, 3, 50000, '2021-01-05'),
(7, 'Grace', 5, 3, 50000, '2021-01-05'),
(8, 'Hannah', NULL, 4, 95000, '2016-09-17');

INSERT INTO projects VALUES
(101, 'Alpha', 1, '2020-01-01', '2020-12-31'),
(102, 'Beta', 1, '2021-01-01', NULL),
(103, 'Gamma', 3, '2019-06-01', '2020-06-01'),
(104, 'Delta', 4, '2022-01-01', NULL);

INSERT INTO employee_projects VALUES
(1, 101, 50),
(2, 101, 100),
(3, 102, 100),
(5, 103, 70),
(6, 103, 30),
(7, 103, 30),
(8, 104, 100);

INSERT INTO salaries_history VALUES
(1, 85000, '2018-01-10'),
(1, 90000, '2020-01-01'),
(2, 65000, '2019-03-15'),
(2, 70000, '2021-04-01'),
(3, 70000, '2019-03-15'),
(5, 75000, '2017-11-20'),
(5, 80000, '2019-07-01'),
(8, 90000, '2016-09-17'),
(8, 95000, '2020-02-01');

/* =========================
   ADVANCED SQL PRACTICE QUESTIONS
   (DO NOT WRITE ANSWERS HERE)
   ========================= */

-- 1. Find the second highest salary in each department.
WITH cte AS (
    SELECT
        e.emp_id,
        e.emp_name,
        d.dept_name,
        e.salary,
        DENSE_RANK() OVER (
            PARTITION BY e.dept_id
            ORDER BY e.salary DESC
        ) AS salary_rank
    FROM employees e
    JOIN departments d
        ON e.dept_id = d.dept_id
)
SELECT
    dept_name,
    salary
FROM cte
WHERE salary_rank = 2;



-- 2. Find employees who have the same salary and hire_date.
SELECT *
FROM employees
WHERE (salary, hire_date) IN (
    SELECT salary, hire_date
    FROM employees
    GROUP BY salary, hire_date
    HAVING COUNT(*) > 1
);





-- 3. List managers who have more than 2 direct reportees.

SELECT
    e2.emp_id   AS manager_id,
    e2.emp_name AS manager_name,
    COUNT(e1.emp_id) AS reportee_count
FROM employees e1
JOIN employees e2
  ON e1.manager_id = e2.emp_id
GROUP BY e2.emp_id, e2.emp_name
HAVING COUNT(e1.emp_id) > 2;


-- 4. Find employees whose salary is greater than their manager’s salary.
SELECT
    e.emp_id   AS employee_id,
    e.emp_name AS employee_name,
    m.emp_id   AS manager_id,
    m.emp_name AS manager_name,
    e.salary   AS employee_salary,
    m.salary   AS manager_salary
FROM employees e
JOIN employees m
  ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;

-- 5. Find departments where the total salary expense is above the company average.
SELECT
    d.dept_id,
    d.dept_name,
    SUM(e.salary) AS dept_total_salary
FROM employees e
JOIN departments d
  ON e.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING SUM(e.salary) >
       (
           SELECT AVG(dept_salary)
           FROM (
               SELECT SUM(salary) AS dept_salary
               FROM employees
               GROUP BY dept_id
           ) x
       );


-- 6. Find employees who are not assigned to any project.
select e.emp_name from employees e
left join employee_projects ep
on e.emp_id=ep.emp_id
where project_id is null;

-- 7. Find projects where more than 1 employee is allocated but total allocation exceeds 100%.
SELECT
    p.project_id,
    p.project_name,
    COUNT(ep.emp_id) AS employee_count,
    SUM(ep.allocation_percent) AS total_allocation
FROM projects p
JOIN employee_projects ep
  ON p.project_id = ep.project_id
GROUP BY p.project_id, p.project_name
HAVING COUNT(ep.emp_id) > 1
   AND SUM(ep.allocation_percent) > 100;



-- 8. Find the latest salary of each employee using salary history.
SELECT
    emp_id,
    salary AS latest_salary,
    effective_date
FROM (
    SELECT
        emp_id,
        salary,
        effective_date,
        ROW_NUMBER() OVER (
            PARTITION BY emp_id
            ORDER BY effective_date DESC
        ) AS rn
    FROM salaries_history
) x
WHERE rn = 1;

-- 9. Find employees whose salary never changed.
SELECT
    emp_id,
    MAX(salary) AS salary
FROM salaries_history
GROUP BY emp_id
HAVING COUNT(DISTINCT salary) = 1;


-- 10. Rank employees by salary within each department (handle ties).
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.salary,
    DENSE_RANK() OVER (
        PARTITION BY e.dept_id
        ORDER BY e.salary DESC
    ) AS salary_rank
FROM employees e
JOIN departments d
  ON e.dept_id = d.dept_id;

-- 11. Find employees working in departments that have no active projects.
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM employees e
JOIN departments d
  ON e.dept_id = d.dept_id
WHERE e.dept_id NOT IN (
    SELECT DISTINCT dept_id
    FROM projects
    WHERE end_date IS NULL
);


-- 12. Find employees who joined on the same day as someone else.
SELECT
    e.emp_id,
    e.emp_name,
    e.hire_date
FROM employees e
WHERE e.hire_date IN (
    SELECT hire_date
    FROM employees
    GROUP BY hire_date
    HAVING COUNT(*) > 1
)
ORDER BY hire_date;

-- 13. Find the longest running project.
SELECT
    project_id,
    project_name,
    start_date,
    end_date,
    (COALESCE(end_date, CURRENT_DATE) - start_date) AS duration_days
FROM projects
ORDER BY duration_days DESC


-- 14. Find employees who worked on more than one project.
SELECT
    e.emp_id,
    e.emp_name,
    COUNT(ep.project_id) AS project_count
FROM employees e
JOIN employee_projects ep
  ON e.emp_id = ep.emp_id
GROUP BY e.emp_id, e.emp_name
HAVING COUNT(ep.project_id) > 1;

-- 15. Find the department with the highest average salary.
SELECT
    d.dept_id,
    d.dept_name,
    AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d
  ON e.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY AVG(e.salary) DESC
limit 1;


-- 16. Find employees who earn more than the average salary of their department.
-- 17. Find gaps in salary history dates per employee.
-- 18. Find the top 2 highest paid employees per department.
-- 19. Find employees w hose manager belongs to a different department.
-- 20. Write a query to detect circular manager relationships (if any).

/* =========================
   END
   ========================= */
ADVANCED SQL INTERVIEW QUESTIONS (HARD)
🧠 Window Functions & Analytics

Find the salary difference between each employee and the next higher-paid employee within the same department.

Identify employees who are paid the same as the department average salary.

For each department, find employees whose salary is in the top 25%.

Assign a dense rank to employees by salary across the entire company.

Find employees whose salary increased by more than 10% compared to their previous salary.

Find employees who have never been the highest paid in their department.

🔁 Self Joins & Hierarchies

Find all employees who indirectly report to a top-level manager.

Find managers who have reportees earning more than them.

Find the maximum depth of management hierarchy.

Identify managers who have only one direct report.

Find employees whose manager was hired after them.

📊 Aggregations & Grouping (Tricky)

Find departments where minimum salary = maximum salary.

Find employees contributing more than 50% of total department salary.

Find departments where average salary is higher than overall company average.

Find employees who earn exactly the median salary of their department.

Find departments with at least one employee earning below company average.

📈 Projects & Allocation Logic

Find employees who are allocated to projects belonging to other departments.

Find projects where all assigned employees belong to the same department.

Find employees whose total project allocation is less than 100%.

Find projects where some employees are over-allocated.

Find employees who worked on projects that never ended.

Find departments with projects but no employees assigned.

🧮 Salary History (Advanced)

Find the largest salary jump per employee.

Find employees whose salary decreased at any point.

Find employees whose salary changed exactly once.

Find employees whose salary change gap exceeds 1 year.

Identify employees who had a salary change before completing 1 year of service.

🧩 Subqueries & Correlated Queries

Find employees earning more than all employees in HR.

Find employees who earn more than the average salary of managers.

Find departments where every employee earns above company median salary.

Find employees who earn more than the highest paid employee in Sales.

Find employees whose salary is higher than at least one manager.

🔄 CTEs & Recursive Thinking

Using recursive logic, find all subordinates of a given manager.

Find the management chain for each employee.

Find managers who control more than 50% of department salary.

Find employees who are leaf nodes in the organization tree.

Detect orphan employees (manager does not exist).

🚨 Edge-Case & Trap Questions

Find employees who are assigned to projects but do not exist in employees table.

Find employees with NULL managers but not department heads.

Find departments where total project allocation ≠ 100%.

Find employees whose department has never run a project.

Find employees who were never given a salary raise.

Find projects that started before any employee was hired.

🧪 Real Interview Logic Questions

Write a query to return exactly one row per department, choosing the highest paid employee, breaking ties alphabetically.

Return employees who are top paid in their department but not top paid company-wide.

Find employees whose salary is closer to department max than department min.

Find departments where manager salary is less than team average.

Find employees who earn more than their department’s 75th percentile but less than company 75th percentile.

Find employees who worked on every project in their department.

Find departments where no employee works on more than one project.