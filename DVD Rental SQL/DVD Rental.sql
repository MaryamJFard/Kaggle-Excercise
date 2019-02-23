/* List the customers, sort according to last name, in cases with
the same last name, then sort according to their first name */
select * 
from customer 
order by
last_name asc,
first_name asc; 

-- distinct on
select distinct on (language_id) language_id, rating
from film

/* Who pays for less than one dollar or more than 8 dollars,
and also how many times that happened? */
select c.first_name, c.last_name, count(*)
from payment p inner join customer c on (p.customer_id = c.customer_id)
and (p.amount < 1 or p.amount > 8) 
group by first_name, last_name;

-- which films were released after 2005? show 5 of them with offset 5.
select title, release_year
from film 
where release_year > 2005
order by title asc
limit 5 offset 5;

-- or
select title, release_year
from film
order by title asc
offset 5 rows
fetch first 5 rows only; 

/* How many days customer with ids 1, 2, 3, 4 and 5 rent a DVD totally? */
select c.first_name, c.last_name, sum(r.return_date - r.rental_date)
from rental r inner join customer c on r.customer_id = c.customer_id
where r.customer_id in (1,2,3,4,5)
group by c.first_name, c.last_name;

/* Who paied between 7th and 15th of Feb in 2007?*/
select c.first_name, c.last_name, p.amount, p.payment_date
from payment p inner join customer c on p.customer_id = c.customer_id
where p.payment_date between '2007-02-07' and '2007-02-15';

/* Which customer's first name consists of "er"?*/
select first_name, last_name
from customer where first_name like '%er%';

/* What is each film's genre?*/
select f.title, c.name
from film f inner join film_category fc on f.film_id = fc.film_id 
inner join category c on fc.category_id = c.category_id;

/* How many movie each genre has?*/
select c.name, count(*)
from film f inner join film_category fc on f.film_id = fc.film_id 
inner join category c on fc.category_id = c.category_id
group by c.name;

/* Which languages is there no DVD in?*/
select l.name
from language l left join film f on l.language_id = f.language_id
where f.language_id is null;

/* Which films have the same length?*/
select f1.title, f2.title, f1.length 
from film f1 inner join film f2 on f1.film_id <> f2.film_id and f1.length = f2.length;

/* How much money did each customer pay?*/
select c.first_name, c.last_name, sum(p.amount)
from customer c inner join payment p on c.customer_id = p.customer_id
group by c.first_name, c.last_name;

/* Who are in top 10 customers with the most payments?*/
select c.first_name, c.last_name, sum(p.amount)
from customer c inner join payment p on c.customer_id = p.customer_id
group by c.first_name, c.last_name
order by sum(p.amount) desc

/* Who pays more than 5 times of the customer with minimum total of payments?*/
select c.first_name, c.last_name, sum(p.amount)
from customer c inner join payment p on c.customer_id = p.customer_id
group by c.first_name, c.last_name
having sum(p.amount) > 5 * (select min(s) from (select c.first_name, c.last_name, sum(p.amount) s
from customer c inner join payment p on c.customer_id = p.customer_id
group by c.first_name, c.last_name) sq);

