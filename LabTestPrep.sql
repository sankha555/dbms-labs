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
