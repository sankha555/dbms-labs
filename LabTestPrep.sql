-- Q1
SELECT z1.state, count(*) as cnt_horror_rating
FROM rating r1 NATURAL JOIN movies m1 NATURAL JOIN users u1 NATURAL JOIN zipcodes z1
WHERE (
    SELECT count(*) 
    FROM rating r NATURAL JOIN movies m NATURAL JOIN users u NATURAL JOIN zipcodes z
    WHERE m.horror = 1 AND z.state = z1.state
) > (
    SELECT count(*) 
    FROM rating r NATURAL JOIN movies m NATURAL JOIN users u NATURAL JOIN zipcodes z
    WHERE m.horror = 0 AND z.state = z1.state
)
GROUP BY z1.state
ORDER BY cnt_horror_rating;

-- Q2
SELECT movie_id FROM movies
WHERE movie_id IN (
    SELECT movie_id
    FROM movies m NATURAL JOIN ratings r NATURAL JOIN users u 
    WHERE u.gender = "M"
) INTERSECT (
    SELECT movie_id
    FROM movies m NATURAL JOIN ratings r NATURAL JOIN users u 
    WHERE u.gender = "F"
);

-- Q3
SELECT title FROM movies
WHERE movie_id IN (
    SELECT movie_id
    FROM movies m NATURAL JOIN ratings r
    WHERE YEAR(m.releaseDate) > 2000 AND movie_id NOT IN (
        SELECT movie_id 
        FROM ratings
        WHERE rating >= 3;
    )
);

-- Q4
SELECT movie_id FROM movies
WHERE movie_id NOT IN (
    SELECT movie_id
    FROM movies m 
    WHERE(
        SELECT AVG(rating)
        FROM movies m1 JOIN ratings r1 
        ON m1.movie_id  = r1.movie_id
        WHERE m1.movie_id = m.movie_id
    ) > ANY(
        SELECT AVG(rating)
        FROM movies m2 JOIN ratings r 
        ON m2.movie_id  = r.movie_id
        WHERE m2.children = 1
        GROUP BY m2.movie_id
    )
);

-- Q5
SELECT movie_id
FROM movies 
WHERE movie_id IN(
    SELECT movie_id FROM movies
    WHERE romance = 1 AND musical = 0 AND comedy = 0 
) UNION (
    SELECT movie_id FROM movies
    WHERE romance = 0 AND musical = 1 AND comedy = 0 
) UNION (
    SELECT movie_id FROM movies
    WHERE romance = 0 AND musical = 0 AND comedy = 1 
);

-- Q7
SELECT city 
FROM zipcodes z
WHERE zipcode IN (
    SELECT z1.zipcode
    FROM zipcodes z1 NATURAL JOIN users u NATURAL JOIN ratings r NATURAL JOIN movies m 
    WHERE m.children = 1 
);


-- Q8
SELECT movie_id 
FROM movies m
WHERE movie_id IN (
    SELECT movie_id FROM (
        SELECT movie_id, count(DISTINCT user.id) as male_votes
        FROM rating r NATURAL JOIN users u 
        WHERE u.gender = "M"
        GROUP BY movie_id
    )m1 JOIN (
        SELECT movie_id, count(DISTINCT user.id) as female_votes
        FROM rating r NATURAL JOIN users u 
        WHERE u.gender = "F"
        GROUP BY movie_id
    )m2 ON m1.movie_id = m2.movie_id
    WHERE male_votes > female_votes
);


/* from IndiaMotors */

/* SALY ratio */
SELECT productCode, sales3/sales4 as SALY
FROM (
    SELECT productCode, SUM(quantityOrdered*priceEach) as sales3
    FROM orderdetails o NATURAL JOIN products p
    WHERE o.orderID IN (
        SELECT orderID 
        FROM orders 
        WHERE YEAR(orderDate) = 2003
    )
    GROUP BY productCode
)s3 NATURAL JOIN (
    SELECT productCode, SUM(quantityOrdered*priceEach) as sales4
    FROM orderdetails o NATURAL JOIN products p
    WHERE o.orderID IN (
        SELECT orderID 
        FROM orders 
        WHERE YEAR(orderDate) = 2004
    )
    GROUP BY productCode
)s4
GROUP BY productCode;

-- August Value
SELECT MONTH(o1.orderDate), SUM(quantityOrdered*priceEach) as net_value
FROM orderdetails o NATURAL JOIN orders o1 
WHERE YEAR(o1.orderDate) = 2004 AND MONTH(o1.orderDate) = 8;

-- customers per sales rep
SELECT salesRepEmpID, count(customerID)
FROM customers
GROUP BY salesRepEmpID
ORDER BY count(customerID) DESC;

-- line profitability
SELECT orderLineNumber, SUM((priceEach - buyPrice)*quantityOrdered) as profitability
FROM orderdetails o NATURAL JOIN products p
GROUP BY orderLineNumber;

-- monthly orders
SELECT MONTH(orderDate) as Month, count(orderID)
FROM orders 
WHERE YEAR(orderDate) = 2004
GROUP BY Month
ORDER BY Month;

-- percentage payments
SELECT Month, mamount/(SELECT SUM(amount) FROM payments WHERE YEAR(paymentDate) = 2004) as frac
FROM (
    SELECT MONTH(paymentDate) as Month, SUM(amount) as mamount
    FROM payments
    WHERE YEAR(paymentDate) = 2004
    GROUP BY Month 
)m
ORDER BY Month;

-- procedure to change price
DELIMITER $
CREATE PROCEDURE change_msrp(IN proType VARCHAR(50), IN perc INT)
BEGIN
    UPDATE products
    SET msrp = (1 + 0.01*perc)*msrp 
    WHERE type = proType;
END $
DELIMITER ;

-- orders containing more than two products
SELECT productCode, orderID, quantityOrdered*priceEach/(
    SELECT SUM(quantityOrdered*priceEach) 
    FROM orderdetails o1 
    WHERE o1.orderID = o.orderID
) as frac
FROM orderdetails o
WHERE orderID IN (
    SELECT orderID
    FROM orderdetails 
    GROUP BY orderID
    HAVING count(productCode)> 2
)AND quantityOrdered*priceEach/(
    SELECT SUM(quantityOrdered*priceEach) 
    FROM orderdetails o1 
    WHERE o1.orderID = o.orderID
) > 0.5;

-- reports to mary
SELECT employeeID, CONCAT(firstname, ' ', lastname) as name
FROM employees
WHERE reportsTo = (
    SELECT employeeID
    FROM employees
    WHERE firstname = 'Mary' AND lastname = 'Patterson'
);

-- stock on hand ratio  (wrong)
SELECT orderLineNumber, productCode, quantityInStock/su AS ratio
FROM orderdetails o1 NATURAL JOIN (
    SELECT orderLineNumber, SUM(quantityInStock) as su
    FROM products p NATURAL JOIN orderdetails o 
    GROUP BY orderLineNumber 
) 
ORDER BY orderLineNumber, productCode;

SELECT orderLineNumber, productCode, quantityInStock/su
FROM products p NATURAL JOIN orderdetails o NATURAL JOIN (
    SELECT orderLineNumber, SUM(quantityInStock) as su
    FROM products p1 NATURAL JOIN orderdetails o1 
    WHERE o1.orderLineNumber = o.orderLineNumber
)s 
ORDER BY orderLineNumber, productCode;

-- ratio of customer payments
SELECT customerID, p3/p4 
FROM customers c NATURAL JOIN (
    SELECT SUM(amount) as p3
    FROM payments p
    WHERE YEAR(p.paymentDate) = 2003
)s3 NATURAL JOIN (
    SELECT SUM(amount) as p4
    FROM payments p
    WHERE YEAR(p.paymentDate) = 2004    
)s4;

