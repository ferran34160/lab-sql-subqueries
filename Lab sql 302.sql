USE sakila;
-- 1 / How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*) AS Copies
FROM sakila.inventory
WHERE film_id = 
	(SELECT film_id
	FROM sakila.film
	WHERE title = "HUNCHBACK IMPOSSIBLE");

-- 2 / List all films whose length is longer than the average of all the films.
SELECT Title, length
FROM sakila.film
WHERE length > 
	(SELECT AVG(Length) 
	FROM sakila.film);

-- 3 / Use subqueries to display all actors who appear in the film Alone Trip.
SELECT last_name, first_name
FROM sakila.actor
WHERE actor_id IN 
	(SELECT actor_id
	FROM sakila.film_actor
	WHERE film_id =
		(SELECT film_id
		FROM sakila.film
		WHERE title = "ALONE TRIP")
	);
    
-- 4 / Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT title, description 
FROM sakila.film 
WHERE film_id IN
	(SELECT film_id 
    FROM sakila.film_category 
    WHERE category_id IN
		(SELECT category_id 
        FROM sakila.category 
        WHERE name = "Family")
	);

-- 5 / Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT first_name, last_name, email
FROM sakila.customer
WHERE address_id IN 
	(SELECT address_id
	FROM sakila.address
	WHERE city_id IN
		(SELECT city_id 
		FROM sakila.city
		WHERE country_id =
			(SELECT country_id
			FROM sakila.country
			WHERE country = "Canada")
		)
	)
	;
    
    SELECT first_name, last_name, email
    FROM sakila.customer
    JOIN sakila.address	USING (address_id)
    JOIN sakila.city USING (city_id)
    JOIN country USING (country_id)
    WHERE country.country = "Canada";

-- 6 / Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id =	
    (SELECT actor_id
	FROM sakila.film_actor
	GROUP BY actor_id
	ORDER BY COUNT(*) DESC
	LIMIT 1)
;

-- 7 / Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT first_name, last_name 
FROM sakila.customer
WHERE customer_id =
	(SELECT customer_id
	FROM sakila.payment
	GROUP BY customer_id
	ORDER BY SUM(amount) DESC
	LIMIT 1)
;

-- 8 / Customers who spent more than the average payments.
SELECT first_name, last_name
FROM sakila.customer
WHERE customer_id IN 
	(SELECT customer_id
	FROM sakila.payment
	GROUP BY customer_id
	HAVING SUM(amount) >
		(SELECT AVG(amount)
		FROM sakila.payment)
	)

;
