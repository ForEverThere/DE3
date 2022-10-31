--1 Вывести количество фильмов в каждой категории, отсортировать по убыванию.
select category.name as Category_name, count(film.film_id) as Film_count
from film
join film_category on film.film_id =film_category.film_id
join category on film_category.category_id = category.category_id
group by category.name 
order by Film_count desc

--2 Вывести 10 актеров, чьи фильмы большего всего арендовали, отсортировать по убыванию.
select actor.first_name, actor.last_name, count(*) as Count_of_films
from actor
join film_actor ON film_actor.actor_id = actor.actor_id
join film ON film.film_id = film_actor.film_id
join inventory ON inventory.film_id = film.film_id
join rental ON rental.inventory_id = inventory.inventory_id
group by rental.inventory_id, inventory.film_id, actor.first_name, actor.last_name
order by Count_of_films desc
limit 10
--3 Вывести категорию фильмов, на которую потратили больше всего денег.
select category."name" as Category, sum(payment.amount) as Payment
from category
join film_category on category.category_id= film_category.category_id
join film on film_category.film_id = film.film_id
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by Category
order by Payment desc
limit 1

--4 Вывести названия фильмов, которых нет в inventory. Написать запрос без использования оператора IN.
select film.title
from film
where not exists 
	(select inventory.film_id
	from inventory
	where film_id = film.film_id)
--5 Вывести топ 3 актеров, которые больше всего появлялись в фильмах в категории “Children”.
--Если у нескольких актеров одинаковое кол-во фильмов, вывести всех.
select actor.first_name, actor.last_name, count(*) as Count_of_Actors
from category
join film_category on category.category_id = film_category.category_id
join film on film_category.film_id = film.film_id
join film_actor on film.film_id = film_actor.film_id
join actor on film_actor.actor_id = actor.actor_id
where category."name" like 'Children'
group by actor.first_name, actor.last_name
order by Count_Of_Actors desc
fetch first 3 rows with ties

--6Вывести города с количеством активных и неактивных клиентов (активный — customer.active = 1).
--Отсортировать по количеству неактивных клиентов по убыванию.
select city.city, count(customer.active = 1) as Active, count(customer.active = 0) as Inactive
from city
join address on city.city_id = address.city_id
join customer on address.address_id = customer.address_id
group by city.city
order by Inactive desc

--7Вывести категорию фильмов, у которой самое большое кол-во часов суммарной аренды
--в городах (customer.address_id в этом city), и которые начинаются на букву “a”.
--То же самое сделать для городов в которых есть символ “-”. Написать все в одном запросе.
select category."name", sum(rental.return_date::date - rental.rental_date::date) as Amount_Of_Days
from rental
join customer ON customer.customer_id = rental.customer_id
join address ON address.address_id = customer.address_id
join city ON city.city_id = address.city_id
join inventory ON rental.inventory_id = inventory.inventory_id
join film ON film.film_id = inventory.film_id
join film_category ON film_category.film_id = film.film_id
join category ON category.category_id = film_category.category_id
where city.city like 'A%'
group by category."name"
order by Amount_Of_Days desc
limit 1 --Delete to check truth
--union 
select category."name", sum(rental.return_date::date - rental.rental_date::date) as Amount_Of_Days
from rental
join customer ON customer.customer_id = rental.customer_id
join address ON address.address_id = customer.address_id
join city ON city.city_id = address.city_id
join inventory ON rental.inventory_id = inventory.inventory_id
join film ON film.film_id = inventory.film_id
join film_category ON film_category.film_id = film.film_id
join category ON category.category_id = film_category.category_id
where city.city like '%-%'
group by category."name"
order by Amount_Of_Days desc
limit 1 --Delete to check truth

--Условие where крашит union
