-- Q1
CREATE VIEW stu3 AS
SELECT takes.year, sum(course.credits) AS num_credits
FROM takes NATURAL JOIN course
GROUP BY takes.year;
