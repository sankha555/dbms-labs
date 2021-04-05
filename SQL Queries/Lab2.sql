// Q1.

// a)
SELECT ID, SUM(gp) 
FROM (
    SELECT ID, course_id, semester, year, grade ,
        CASE grade  
            WHEN "A " THEN 4.0 
            WHEN "A-" THEN 3.7 
            WHEN "B+" THEN 3.3 
            WHEN "B " THEN 3.0 
            WHEN "B-" THEN 2.7 
            WHEN "C+" THEN 2.3 
            WHEN "C " THEN 2.0 
            WHEN "C-" THEN 1.7 
        END as gp 
    FROM takes 
    WHERE ID=1000
)gps;

// b)
SELECT ID, SUM(gp*course.credits)/SUM(course.credits) AS gpa 
FROM 
    course JOIN (
        SELECT ID, course_id, semester, year, grade,
        CASE grade  
            WHEN "A " THEN 4.0
            WHEN "A-" THEN 3.7 
            WHEN "B+" THEN 3.3 
            WHEN "B " THEN 3.0 
            WHEN "B-" THEN 2.7 
            WHEN "C+" THEN 2.3 
            WHEN "C " THEN 2.0 
            WHEN "C-" THEN 1.7 
        END as gp 
        FROM takes 
        WHERE ID=1000
    )gps 
    ON course.course_id = gps.course_id;

// c)
SELECT ID, SUM(gp*course.credits)/SUM(course.credits) AS gpa 
FROM 
    course JOIN (
        SELECT ID, course_id, semester, year, grade,
        CASE grade  
            WHEN "A " THEN 4.0 
            WHEN "A-" THEN 3.7 
            WHEN "B+" THEN 3.3 
            WHEN "B " THEN 3.0 
            WHEN "B-" THEN 2.7 
            WHEN "C+" THEN 2.3 
            WHEN "C " THEN 2.0 
            WHEN "C-" THEN 1.7 
        END as gp 
    FROM takes)gps 
    ON course.course_id = gps.course_id 
GROUP BY ID;

// d)
SELECT ID, SUM(gp*course.credits)/SUM(course.credits) AS gpa 
FROM 
    course JOIN (
        SELECT ID, course_id, semester, year, grade,
        CASE grade  
            WHEN "A " THEN 4.0 
            WHEN "A-" THEN 3.7 
            WHEN "B+" THEN 3.3 
            WHEN "B " THEN 3.0 
            WHEN "B-" THEN 2.7 
            WHEN "C+" THEN 2.3 
            WHEN "C " THEN 2.0 
            WHEN "C-" THEN 1.7 
            WHEN NULL THEN 0
        END as gp 
    FROM takes)gps 
    ON course.course_id = gps.course_id 
GROUP BY ID;

// Q2.

// a)

SELECT student.ID, name 
FROM 
    student JOIN (
        SELECT DISTINCT ID 
        FROM (
            SELECT course_id, ID 
            FROM takes
        )taken JOIN (
            SELECT course_id, dept_name 
            FROM course 
            WHERE dept_name="Comp. Sci."
        )crs 
        ON taken.course_id = crs.course_id
    )stucrs 
    ON student.ID = stucrs.ID;

// b) 

-- Q1 a
SELECT s.ID, SUM(c.credits) as total_credits
FROM (
    SELECT ID, name FROM student
    WHERE ID = 99289
)s NATURAL JOIN takes t NATURAL JOIN course c;

SELECT ID, SUM(credits*gp) as total_gp FROM (
    SELECT 
    s.ID, c.credits,  
    CASE t.grade
        WHEN "A " THEN 4.0 
        WHEN "A-" THEN 3.7 
        WHEN "B+" THEN 3.3 
        WHEN "B " THEN 3.0 
        WHEN "B-" THEN 2.7 
        WHEN "C+" THEN 2.3 
        WHEN "C " THEN 2.0 
        WHEN "C-" THEN 1.7 
    END as gp 
    FROM (
        SELECT ID, name FROM student
        WHERE ID = 99289
    )s NATURAL JOIN takes t NATURAL JOIN course c
)gps;

/*
+-------+----------+
| ID    | total_gp |
+-------+----------+
| 99289 |     77.5 |
+-------+----------+
*/

-- Q1 b
SELECT ID, SUM(credits*gp)/SUM(credits) as cgpa FROM (
    SELECT 
    s.ID, c.credits,  
    CASE t.grade
        WHEN "A " THEN 4.0 
        WHEN "A-" THEN 3.7 
        WHEN "B+" THEN 3.3 
        WHEN "B " THEN 3.0 
        WHEN "B-" THEN 2.7 
        WHEN "C+" THEN 2.3 
        WHEN "C " THEN 2.0 
        WHEN "C-" THEN 1.7 
    END as gp 
    FROM (
        SELECT ID, name FROM student
        WHERE ID = 99289
    )s NATURAL JOIN takes t NATURAL JOIN course c
)gps;

/*
+-------+---------+
| ID    | cgpa    |
+-------+---------+
| 99289 | 2.03947 |
+-------+---------+
*/

-- Q1 c
SELECT ID, SUM(credits*gp)/SUM(credits) as cgpa FROM (
    SELECT 
    s.ID, c.credits,  
    CASE t.grade
        WHEN "A " THEN 4.0 
        WHEN "A-" THEN 3.7 
        WHEN "B+" THEN 3.3 
        WHEN "B " THEN 3.0 
        WHEN "B-" THEN 2.7 
        WHEN "C+" THEN 2.3 
        WHEN "C " THEN 2.0 
        WHEN "C-" THEN 1.7 
        WHEN NULL THEN 0
    END as gp 
    FROM student s NATURAL JOIN takes t NATURAL JOIN course c
)gps
GROUP BY ID;

-- Q2
-- Same a Lab 5 Questions