create database students;
use students;

/*-- Create the student_grades table
CREATE TABLE student_grades (
    student_id INT NOT NULL,
    student_name VARCHAR(255) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    grade INT NOT NULL,
    exam_date DATE NOT NULL,
    -- A composite primary key to ensure each grade record is unique
    PRIMARY KEY (student_id, subject, exam_date)
);



-- Insert the sample data into the student_grades table
INSERT INTO student_grades (student_id, student_name, subject, grade, exam_date) VALUES
(101, 'Alice', 'Math', 85, '2099-10-15'),
(101, 'Alice', 'Science', 92, '2099-10-15'),
(102, 'Bob', 'Math', 78, '2099-10-15'),
(102, 'Bob', 'History', 65, '2099-10-15'),
(103, 'Charlie', 'Science', 95, '2099-10-15'),
(103, 'Charlie', 'History', 88, '2099-10-15'),
(104, 'Diana', 'Math', 90, '2099-10-15');
*/
select * from student_grades;
-- 1. Find the names of all students who have a grade of 90 or higher in either 'Math' or 'Science'
select distinct student_id,student_name from student_grades
where grade >=90  and subject in ('Math','Science')

-- 2. For each student, calculate their average grade across all subjects.
select student_id,student_name,
avg(grade) as average_grade 
from student_grades
group by student_id,student_name;


-- 3. Find all subjects where the average grade is above 80.
select subject,avg(grade) avg_grade from student_grades
group by subject
having avg(grade)>=80;

-- 4. Create a report that lists each student, their grade in each subject, and a new column pass_status.
-- The pass_status should be 'Pass' if the grade is 70 or higher, and 'Need to improve otherwise.
SELECT student_name,
       subject,
       grade,
       CASE
           WHEN grade >= 70 THEN 'Pass'
           ELSE 'Need to improve'
       END AS pass_status
FROM student_grades;

-- 5. Find the highest grade achieved by a student in each subject.
with cte as(select student_name,grade,subject,
row_number() over(partition by subject order by grade desc) as highest_grd_achiver
from student_grades)
select * from cte where highest_grd_achiver=1


-- 6. If there are ties for the highest grade, list all students who achieved that grade.
with cte as(select student_name,grade,subject,
dense_rank() over(partition by subject order by grade desc) as highest_grd_achiver
from student_grades)
select * from cte where highest_grd_achiver=1