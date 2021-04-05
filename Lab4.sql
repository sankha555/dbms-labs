CREATE VIEW stu3 AS
SELECT takes.year, sum(course.credits) AS num_credits
FROM takes NATURAL JOIN course
GROUP BY takes.year;


/* Lab 5 */

/* Lab 7 */
DELIMITER $$
CREATE DEFINER='root'@'localhost' PROCEDURE list_sem(IN sem VARCHAR(10))
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
SELECT semester, count(ID) as no_of_students 
FROM takes
WHERE semester=sem
GROUP BY semester
ORDER BY no_of_students;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER='root'@'localhost' PROCEDURE dec_cnt(INOUT cnt INT, IN inc INT)
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
SET cnt = cnt - inc;
END$$

/* Q1 */
DELIMITER $$
CREATE DEFINER = 'root'@'localhost' PROCEDURE stu_course_sem(IN course VARCHAR(20), IN sem VARCHAR(20))
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
SELECT ID, name FROM
STUDENT WHERE ID in (
    SELECT takes.ID FROM 
    takes NATURAL JOIN (
        SELECT course_id FROM course 
        WHERE title = course
    )c
    WHERE semester = sem
);
END$$
DELIMITER ;

/* Q3 */
DELIMITER $$
CREATE DEFINER = 'root'@'localhost' PROCEDURE inst_avg(IN amt INT)
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
SELECT ID, name FROM
instructor WHERE salary BETWEEN 
(SELECT AVG(salary) from instructor)+amt AND (SELECT AVG(salary) from instructor)-amt;
END$$
DELIMITER ;

delimiter $$
create definer = 'root'@'localhost' procedure inst_id_name(in amount int)
comment 'List instructor’s name and ID whose salary is less or more than a given amount to
the average salary of all instructors in the university'
sql security invoker 
reads SQL data
deterministic
begin 
	declare avg_sal int;
    select avg(salary) into avg_sal
    from instructor;
    
	select ID, instructor.name 
    from instructor 
    where instructor.salary not between avg_sal-5000 and avg_sal+5000;
end$$
delimiter ;