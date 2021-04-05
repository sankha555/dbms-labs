-- Examples
SELECT AVG(credits) as avg_credits, COUNT(course_id)
FROM course 
GROUP BY dept_name
HAVING avg_credits > 3.5
ORDER BY dept_name; 

-- Q1 a
SELECT DISTINCT s.name
FROM student s NATURAL JOIN takes t
WHERE t.course_id IN (
    SELECT course_id 
    FROM course 
    WHERE dept_name = 'Comp. Sci.'
);

--- OR ---

SELECT name
FROM student
WHERE ID IN (
    SELECT DISTINCT s.ID 
    FROM student s NATURAL JOIN takes t
    WHERE t.course_id IN (
        SELECT course_id 
        FROM course 
        WHERE dept_name = 'Comp. Sci.'
    )
);

-- Q1 b
SELECT name, ID
FROM student
WHERE ID NOT IN (
    SELECT s.ID 
    FROM student s NATURAL JOIN takes t 
    WHERE t.year < 2009 
);

-- Q1 c
SELECT dept_name, MAX(salary) as max_salary
FROM instructor
GROUP BY dept_name;

-- OR -- 

SELECT dept_name, salary 
FROM instructor
WHERE ID NOT IN (
    SELECT i.ID 
    FROM instructor i
    WHERE i.salary < ANY(
        SELECT salary
        FROM instructor i1
        WHERE i1.dept_name = i.dept_name
    )
)
ORDER BY dept_name;

-- Q1 d

SELECT dept_name, ms1.max_salary FROM (
    SELECT dept_name, MAX(salary) AS max_salary
    FROM instructor
    GROUP BY dept_name
)ms1 WHERE ms1.max_salary = (
    SELECT MIN(ms.max_salary) FROM (
        SELECT dept_name, MAX(salary) AS max_salary
        FROM instructor
        GROUP BY dept_name
    )ms
);

-- Q2 
-- Lite, lab test me nhi puchenge (hopefully)


