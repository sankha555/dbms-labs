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

-- Q2 (somehow returns empty set)
USE sakila;
DELIMITER $
CREATE DEFINER=`root`@`localhost` PROCEDURE `cust_staff`(IN stid INT)
    READS SQL DATA
    SQL SECURITY INVOKER
BEGIN
    SELECT * FROM customer
    WHERE customer_id IN (
        SELECT c.customer_id
        FROM customer c NATURAL JOIN payment p 
        WHERE p.staff_id = stid
    );
END$
DELIMITER ;

/*

*/

-- Q3
USE university;
DELIMITER $
CREATE DEFINER=`root`@`localhost` PROCEDURE `inst_avg_range`(IN amt INT)
BEGIN
    SELECT name, ID 
    FROM instructor
    WHERE salary BETWEEN (
        SELECT AVG(salary)-amt
        FROM instructor
    ) AND (
        SELECT AVG(salary)+amt
        FROM instructor
    );
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