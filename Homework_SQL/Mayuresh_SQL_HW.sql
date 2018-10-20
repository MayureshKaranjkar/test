use sakila;

### 1a. Display the first and last names of all actors from the table `actor`.
Select first_name, last_name
from actor;

###* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
Select concat(upper(first_name), upper(last_name)) as "Actor Name"
from actor;

###2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
Select actor_id
from actor
where first_name = 'Joe';

###* 2b. Find all actors whose last name contain the letters `GEN`:
Select first_name, last_name
from actor
where last_name like '%GEN%';

###* 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
Select first_name, last_name
from actor
where last_name like '%LI%'
order by last_name, first_name;


###* 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
Select country_id, country
from country
where country IN ('Afghanistan', 'Bangladesh', 'China');

###3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
###so create a column in the table `actor` named `description` and use the data type `BLOB` 
###(Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor ADD description BLOB;
###desc actor;
###select description from actor;

### 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor
  DROP COLUMN description;
###select description from actor;

###* 4a. List the last names of actors, as well as how many actors have that last name.
Select last_name, count(*) as count_last_name
from actor
group by last_name
order by count_last_name;

###* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
Select last_name, count(*) as count_last_name
from actor
group by last_name
having count_last_name >=2;

###* 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
Update actor
	set first_name = 'HARPO'
    where 	first_name = 'GROUCHO' and
			last_name = 'WILLIAMS';

###* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
Update actor
	set first_name = 'GROUCHO'
    where 	first_name = 'HARPO' and
			last_name = 'WILLIAMS';
            
###* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SELECT `table_schema` 
FROM `information_schema`.`tables` 
WHERE `table_name` = 'address';

###* 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select first_name, last_name, address
from staff s left join address a on s.address_id = a.address_id;

###* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select first_name, last_name, sum(amount) as total_amount_August05
from staff s left join payment p on s.staff_id = p.staff_id
where p.payment_date >= '08012005' and p.payment_date <= '08312005'
group by first_name, last_name;

###* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select f.title, a.first_name, a.last_name
from actor a 	inner join film_actor fa on a.actor_id = fa.actor_id
				inner join film f on f.film_id = fa.film_id;
                
###* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select count(i.inventory_id) as film_copies
from inventory i 	inner join film f on f.film_id = i.film_id
where f.title = 'Hunchback Impossible'
group by i.inventory_id;

###* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select first_name, last_name, sum(amount) as cust_paid
from customer c left join payment p on c.customer_id = p.customer_id
group by first_name, last_name;

###* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
###As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
###Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select title
	from film f
    where title like 'K%' or title like 'Q%'
		and language_id = (select language_id from language where name = 'English');

###* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select a.first_name, a.last_name
	from actor a inner join film_actor fa on a.actor_id = fa.actor_id
    where fa.film_id = (select film_id from film where title = 'Alone Trip');
    
###7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
###Use joins to retrieve this information.
select c.first_name, c.last_name, c.email
	from customer c inner join address on address.address_id = c.address_id
					inner join city on address.city_id = city.city_id
                    inner join country on city.country_id = country.country_id
	where country.country = 'Canada';
    
###* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
select f.title as film_title
from film f 
where f.rating = 'G';

###* 7e. Display the most frequently rented movies in descending order.
select f.title, count(rental_id) as num_rented
from film f inner join inventory i on f.film_id = i.film_id
			inner join rental r on i.inventory_id = r.inventory_id
group by f.title
order by count(rental_id);

###* 7f. Write a query to display how much business, in dollars, each store brought in.
select staff.store_id, sum(p.amount) as sum_revenue
from staff  inner join on payment p on p.staff_id = staff.staff_id
group by staff.store_id;

###* 7g. Write a query to display for each store its store ID, city, and country.
select store.store_id, city.city, country.country
from store  inner join address a on a.address_id = store.address_id
			inner join city on address.city_id = city.city_id
			inner join country on city.country_id = country.country_id;
            
###* 7h. List the top five genres in gross revenue in descending order. 
###(**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select category.name, sum(p.amount) as sum_revenue
from category inner join film_category fc on category.category_id = fc.category_id
				inner join inventory i on i.film_id = fc.film_id
                inner join rental r on r.inventory_id = i.inventory_id
                inner join payment p on p.rental_id = r.rental_id
group by category.name
order by 2 desc;

###* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
###Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
Create View Top_Five_Genre AS
select category.name, sum(p.amount) as sum_revenue
from category inner join film_category fc on category.category_id = fc.category_id
				inner join inventory i on i.film_id = fc.film_id
                inner join rental r on r.inventory_id = i.inventory_id
                inner join payment p on p.rental_id = r.rental_id
group by category.name
order by 2
limit 5;

###* 8b. How would you display the view that you created in 8a?
Desc Top_Five_Genre;
Select * from Top_Five_Genre;

###* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view Top_Five_Genre;

###Thank You for reviewing my homework