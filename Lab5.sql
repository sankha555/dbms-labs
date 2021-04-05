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

-- Q12 e
SELECT * FROM departments d
WHERE NOT EXISTS
(SELECT * FROM projects p WHERE p.deptcode = d.code);