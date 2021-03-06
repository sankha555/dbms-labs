-- Examples
SELECT * FROM
ingredients WHERE unitprice*inventory > ANY (
    SELECT price FROM items WHERE name LIKE "%Salad%"
);

SELECT * FROM
ingredients WHERE vendorid NOT IN ('SPWTR', 'VGRUS');

SELECT name FROM ingredients 
WHERE unitprice >= ALL(
    SELECT unitprice FROM ingredients
    WHERE ingredientid IN (
        SELECT ingredientid FROM madewith 
        WHERE itemid IN (
            SELECT itemid FROM items
            WHERE name LIKE "%Salad%"
        )
    )
)

SELECT name FROM ingredients 
WHERE vendorid IN (
    SELECT vendorid FROM vendors 
    WHERE companyname NOT IN ('Veggies_R_Us', 'Spring Water Supply')
);

SELECT name FROM items
WHERE itemid NOT IN (
    SELECT itemid FROM items WHERE price < ANY(
        SELECT price FROM items
    )
);

SELECT * FROM customer
WHERE customer_id IN (
    SELECT customer_id FROM payment
);


SELECT SUM(assignedtime) FROM workson 
WHERE employeeid = (
    SELECT employeeid FROM employees
    WHERE firstname="Abe" and lastname="Advice"
)

-- Q1
SELECT CONCAT(firstname, ' ', lastname) as name
FROM employees e NATURAL JOIN departments d
WHERE d.name = 'Consulting';

-- Q2
SELECT CONCAT(firstname, ' ', lastname) as name
FROM (
    SELECT e.employeeid, e.firstname, e.lastname 
    FROM employees e NATURAL JOIN departments d
    WHERE d.name = 'Consulting'
)ec NATURAL JOIN workson w
WHERE w.projectid = 'ADT4MFIA' AND w.assignedtime > 0.2;

-- Q3
SELECT CONCAT(firstname, ' ', lastname) as name, SUM(w.assignedtime) 
FROM employees e NATURAL JOIN workson w 
WHERE e.firstname = "Abe" and e.lastname = "Advice";

-- Q4
SELECT name FROM departments WHERE code NOT IN(
    SELECT deptcode FROM projects
);

-- Q5
SELECT firstname, lastname FROM employees
WHERE salary > (
    SELECT AVG(e.salary) FROM
    employees e NATURAL JOIN departments d 
    WHERE d.name = "Accounting"
);

-- Q6
SELECT description FROM projects 
WHERE projectid IN(
    SELECT projectid FROM 
    projects p NATURAL JOIN workson w 
    WHERE w.assignedtime > 0.7
);

-- Q7
SELECT firstname, lastname FROM 
employees WHERE salary > ANY (
    SELECT salary FROM employees
    WHERE deptcode = (
        SELECT code FROM departments
        WHERE name = 'Accounting'
    )
);

-- Q8
SELECT MIN(salary) as min_salary 
FROM employees WHERE salary > ALL(
    SELECT salary FROM employees
    WHERE deptcode = (
        SELECT code FROM departments
        WHERE name = 'Accounting'
    )
);

-- Q9
SELECT firstname, lastname 
FROM employees 
WHERE employeeid NOT IN (
    SELECT employeeid
    FROM employees WHERE salary < ANY(
        SELECT salary FROM employees
        WHERE deptcode = (
            SELECT code FROM departments
            WHERE name = 'Accounting'
        )
    )
);

-- Q10
SELECT e.employeeid 
FROM employees e NATURAL JOIN workson w
NATURAL JOIN projects p
WHERE p.deptcode <> e.deptcode AND w.assignedtime > 0.5
ORDER BY w.assignedtime;

-- Q11
SELECT d.code, d.name FROM departments d WHERE
(SELECT COUNT(projectid) FROM projects WHERE deptcode = d.code) = 
(SELECT COUNT(w.projectid) FROM workson w WHERE w.employeeid IN 
    (SELECT e.employeeid FROM employees e WHERE e.deptcode = d.code)
);

-- Q12 a (Does not return anything since table IT dept doesn't exist lol)
SELECT CONCAT(firstname, ' ', lastname) as name
FROM employees e NATURAL JOIN departments d
WHERE d.name = 'IT';

-- Q12 b (Does not return anything since table IT dept doesn't exist lol)
SELECT CONCAT(firstname, ' ', lastname) as name
FROM (
    SELECT e.employeeid, e.firstname, e.lastname 
    FROM employees e NATURAL JOIN departments d
    WHERE d.name = 'IT'
)ec NATURAL JOIN workson w
WHERE w.projectid = 'health' AND w.assignedtime > 0.2;

-- Q12 c
SELECT CONCAT(firstname, ' ', lastname) as name
FROM employees WHERE salary > (
    SELECT AVG(salary) FROM employees
    WHERE deptcode = (
        SELECT code FROM departments
        WHERE name = 'Accounting'
    )
);

-- Q12 d
SELECT projectid
FROM workson 
WHERE assignedtime > 0.5;

-- Q12 e1 (Does not return anything since employee Bob Smith doesn't exist)
SELECT SUM(assignedtime) AS total_assigned_time
FROM workson WHERE
employeeid = (
    SELECT employeeid FROM employees
    WHERE CONCAT(firstname, ' ', lastname) = 'Bob Smith'
);

-- Q12 e2
SELECT * FROM departments d
WHERE NOT EXISTS
(SELECT * FROM projects p WHERE p.deptcode = d.code);

-- Q12 f
SELECT * 
FROM employees
WHERE salary > ANY(
    SELECT salary FROM employees
    WHERE deptcode = (
        SELECT code FROM departments
        WHERE name = 'Accounting'
    )
);

-- Q12 g
SELECT * 
FROM employees
WHERE salary > ALL(
    SELECT salary FROM employees
    WHERE deptcode = (
        SELECT code FROM departments
        WHERE name = 'Accounting'
    )
);

-- Q12 h -- wrong
SELECT *
FROM employees e
WHERE e.salary > ALL(
    SELECT salary FROM employees e1
    WHERE e1.employeeid IS NOT NULL AND e1.employeeid <> e.employeeid
) AND e.employeeid NOT IN (
    SELECT employeeid FROM employees e3
    WHERE deptcode NOT IN (
        SELECT code FROM departments
        WHERE name = 'Accounting'
    )
);

-- Q12 h -- correct
SELECT *
FROM employees e
WHERE e.employeeid NOT IN (
    SELECT e1.employeeid FROM employees e1
    WHERE e1.salary < ANY(
        SELECT salary FROM employees 
        WHERE deptcode = (
            SELECT code FROM departments
            WHERE name = 'Accounting'
        ) 
    )
) AND e.deptcode = (
    SELECT code FROM departments
    WHERE name = 'Accounting'
);
