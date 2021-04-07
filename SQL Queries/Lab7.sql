-- Q1
USE university;
DELIMITER $
CREATE DEFINER=`root`@`localhost` PROCEDURE `course_stu`(IN crs VARCHAR(20))
    READS SQL DATA
    SQL SECURITY INVOKER
BEGIN
    SELECT s.name
    FROM student s NATURAL JOIN takes t
    WHERE t.course_id IN (
        SELECT course_id FROM course
        WHERE title = crs
    );
END$
DELIMITER ;

/*
+--------------------+
| name               |
+--------------------+
| Okaf               |
| Jerns              |
| Morales            |
| Robinson           |
| Tzeng              |
| Shiang             |
|        . . .       |
+--------------------+ 
*/

-- Q2 
USE sakila;
DELIMITER $
CREATE DEFINER = `root`@`localhost` PROCEDURE sta(IN stid TINYINT)
BEGIN
    SELECT first_name, last_name 
    FROM customer WHERE customer_id IN (
        SELECT DISTINCT customer_id
        FROM payment WHERE
        staff_id = stid
    );
END$
DELIMITER ;

-- Q3
USE university;
DELIMITER $
CREATE DEFINER=`root`@`localhost` PROCEDURE `inst_avg_range`(IN amt INT)
BEGIN
    SELECT name, ID 
    FROM instructor
    WHERE salary BETWEEN (
        SELECT AVG(salary)
        FROM instructor
    )-amt AND (
        SELECT AVG(salary)+amt
        FROM instructor
    )+amt;
END$
DELIMITER ;

CALL inst_avg_range(5000);
/*
+------------+-------+
| name       | ID    |
+------------+-------+
| Gustafsson | 3199  |
| Romero     | 43779 |
| Pimenta    | 65931 |
| Valtchev   | 81991 |
+------------+-------+
*/

-- Q4
USE restaurant;
DELIMITER $
CREATE DEFINER=`root`@`localhost` PROCEDURE `vendor_ings`(IN vendid VARCHAR(10))
BEGIN
    SELECT name 
    FROM ingredients
    WHERE vendorid = vendid;
END$
DELIMITER ;

/*
+-------+
| name  |
+-------+
| Soda  |
| Water |
+-------+
*/