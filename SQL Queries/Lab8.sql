-- Examples
DELIMITER $
CREATE DEFINER = 'root'@'localhost' TRIGGER creds_trigger
AFTER INSERT
ON takes
FOR EACH ROW
BEGIN
    DECLARE cred INT;
    SELECT credits INTO cred
    FROM course c WHERE
    c.course_id = NEW.course_id;

    UPDATE student
    SET tot_cred = IF(tot_cred IS NULL, cred, tot_cred + cred); 
END$
DELIMITER ;


DELIMITER $
CREATE DEFINER = 'root'@'localhost' TRIGGER creds_trigger
BEFORE INSERT
ON orders
FOR EACH ROW
BEGIN
    SET NEW.price = 1.18*NEW.price;
END$
DELIMITER ;

-- Exercises

-- Q1 -- doesn't work in the current sql version
DELIMITER $
CREATE TRIGGER touppercase
BEFORE INSERT
ON employees
FOR EACH ROW
BEGIN
    DECLARE INSERT_EMPLOYEE_ID DECIMAL(9,0);
    DECLARE INSERT_firstname VARCHAR(30);
    DECLARE INSERT_lastname VARCHAR(30);
    DECLARE INSERT_dept char(5);
    DECLARE INSERT_sal decimal(9,2);

    DECLARE INSERT_CURSOR CURSOR FOR SELECT * FROM INSERTED;
    OPEN INSERT_CURSOR;
    FETCH NEXT FROM INSERT_CURSOR INTO
    INSERT_EMPLOYEE_ID, INSERT_firstname, INSERT_lastname, INSERT_dept, INSERT_sal;
    
    UPDATE employees
    SET firstname = UPPER(INSERT_firstname), lastname = UPPER(INSERT_lastname)
    WHERE employeeid = INSERT_EMPLOYEE_ID;
    CLOSE INSERT_CURSOR;
END$
DELIMITER ;
