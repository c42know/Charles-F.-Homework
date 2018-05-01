USE sakila;

SELECT * FROM actor;

#1a. You need a list of all the actors who have Display the first and last names of all actors from the table actor. 


#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. 
SELECT concat(first_name, '  ',last_name) FROM actor AS Actor_Name;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT * FROM actor WHERE first_name = "JOE";

#2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor WHERE last_name LIKE "%GEN%";

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor WHERE last_name LIKE "%LI%"
ORDER BY last_name AND first_name;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT * FROM country WHERE country IN ('Afghanistan', ' Bangladesh',  'China');

#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor 
ADD COLUMN middle_name VARCHAR(15) AFTER first_name;

#3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor 
MODIFY COLUMN middle_name BLOB;
SELECT * FROM actor;

#3c. Now delete the middle_name column.
ALTER TABLE actor 
DROP COLUMN middle_name
SELECT * FROM actor;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS COUNT FROM actor GROUP BY last_name ORDER BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS COUNT FROM actor GROUP BY last_name ORDER BY last_name
WHERE COUNT > 2  ;

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name  = replace(first_name, 'GROUCHO', 'HARPO');
SELECT * FROM actor WHERE last_name = 'WILLIAMS'; 

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, 
#if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, 
#as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO 
#GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name  = replace(first_name, 'HARPO', 'GROUCHO');
SELECT * FROM actor WHERE last_name = 'WILLIAMS'; 

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESCRIBE address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT * FROM staff
SELECT * FROM address

SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON (s.address_id = a.address_id);

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 
SELECT 
	staff.staff_id AS staff_id,
    first_name,
	sum(amount) total_amount_per_member
FROM
	staff
INNER JOIN
	payment ON staff.staff_id = payment.staff_id
WHERE year(payment_date) = 2005 and month(payment_date) = 08
GROUP BY staff_id, first_name;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT 
	film.film_id, 
    title, 
    count(actor_id) num_actors
FROM 
	film_actor
INNER JOIN 
	film ON film_actor.film_id = film.film_id
GROUP BY film.film_id, title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT
	film.film_id,
    title,
    count(inventory_id) num_copies
FROM
	film
INNER JOIN
	inventory ON film.film_id = inventory.film_id
WHERE
	title = "Hunchback Impossible"
GROUP BY film.film_id, title;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT
	first_name,
    last_name,
    sum(amount) AS 'Total Amount Paid'
FROM
	customer
INNER JOIN
	payment ON customer.customer_id = payment.customer_id
GROUP BY first_name, last_name
ORDER BY last_name asc;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also 
#soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 
SELECT 
	title
FROM
	film
WHERE 
	language_id IN (SELECT language_id FROM language WHERE name = "English")
    and title LIKE "K%" or title LIKE  "Q%";
    
#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT
	first_name,
    last_name
FROM
	actor
WHERE actor_id IN(SELECT actor_id FROM film_actor WHERE film_id IN (SELECT film_id FROM film WHERE title = 'Alone Trip'));

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
#Use joins to retrieve this information.
SELECT
	first_name,
    last_name,
    email
FROM
	customer
INNER JOIN
	address ON customer.address_id = address.address_id
INNER JOIN 
	city ON address.city_id = city.city_id
INNER JOIN
	country ON city.country_id = country.country_id
WHERE country = 'Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT
	title
FROM
	film_category
INNER JOIN
	film ON film_category.film_id = film.film_id WHERE category_id IN (SELECT category_id FROM category WHERE name = "Family") ;

#7e. Display the most frequently rented movies in descending order.
SELECT
    title,
    inventory.film_id,
    count(inventory.film_id) num_times_rented
FROM
	rental
INNER JOIN
	inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN
	film ON inventory.film_id = film.film_id
GROUP BY title, inventory.film_id
ORDER BY num_times_rented desc;

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT
	s.store_id, 
    SUM(amount) AS Gross 
FROM 
	payment p 
JOIN rental r ON (p.rental_id = r.rental_id)
JOIN inventory i ON (i.inventory_id = r.inventory_id)
JOIN store s ON (s.store_id = i.store_id)
GROUP BY s.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT 
	store_id,
    city,
    country
FROM 
	store
INNER JOIN
	address ON store.address_id = address.address_id
INNER JOIN
	city ON address.city_id = city.city_id
INNER JOIN
	country ON city.country_id = country.country_id;


#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name, sum(payment.amount) AS revenue
FROM rental
INNER JOIN payment ON rental.rental_id = payment.rental_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY revenue desc 
LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_5_genres AS 
SELECT category.name, sum(payment.amount) AS revenue
FROM rental
INNER JOIN payment ON rental.rental_id = payment.rental_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY revenue desc 
LIMIT 5;

#8b. How would you display the view that you created in 8a?
SELECT * FROM top_5_genres;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_5_genres;