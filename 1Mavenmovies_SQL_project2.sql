USE mavenmovies; 

-- QUES 1) RETRIEVE ALL THE COLUMNS FROM FILM TABLE ?

SELECT * FROM film;


-- QUES 2) RETRIEVE THE FIRST NAMES AND LAST NAMES OF ALL ACTORS OF ALL ACTORS FROM THE "ACTOR" TABLE ?

SELECT first_name,last_name FROM actor;


-- QUES 3)  PRINT ALL FILM_ID AND REPLACEMENT COST WHERE THE REPLACEMENT COST IS NOT 15.99 ?

SELECT film_id , replacement_cost FROM film 
WHERE replacement_cost != 15.99;

-- QUES 4) FIND ALL FILMS WHERE RENTAL DURATION IS LESS THAN 5 DAYS OR GREATER THAN 7 DAYS.

SELECT * FROM film 
WHERE rental_duration < 5 OR rental_duration > 7;

-- QUES 5) WHAT IS THE COUNTRY ID FOR 'INDIA' IN THE "COUNTRY" TABLE?

SELECT country_id
FROM country 
WHERE country = 'India';

-- QUES 6) DISPLAY THE FIRST 3 RECORDS FROM THE CUSTOMER TABLE WHOSE FIRST NAME STARTS WITH ‘B’.?

SELECT * FROM customer WHERE first_name LIKE 'b%'
LIMIT 3;

-- 	QUES 7) DISPLAY THE LIST OF FIRST 4 CITIES WHICH START AND END WITH ‘A’ FROM CITY TABLE?

SELECT * FROM City WHERE city LIKE 'A%A'
LIMIT 4;

-- QUES 8) FIND ALL CUSTOMERS WHOSE FIRST NAME HAS "R" IN THE THIRD POSITION.?

SELECT *  FROM customer
WHERE first_name LIKE '__r%';

-- QUES 9) FIND ALL CUSTOMERS WHOSE FIRST NAME STARTS WITH "D" AND ARE AT LEAST 5 CHARACTERS IN LENGTH.?

SELECT * FROM customer
WHERE first_name LIKE 'D_____%';


-- GROUP BY:

-- QUES 1)  DISPLAY THE ACTOR ID AND THE NUMBER OF FILMS EACH ACTOR HAVE ACTED IN?

SELECT actor_id, count(film_id) FROM film_actor
GROUP BY actor_id;



-- QUES 2) DISPLAY THE FILM ID AND THE NUMBER OF ACTORS ACTED IN EACH FILMS?
     -- table used : Film_actor
     
SELECT film_id , count(actor_id) FROM film_actor
GROUP BY film_id;



-- ORDER BY

-- QUES 3) DISPLAY THE FILM ID AND THE NUMBER OF ACTORS ACTED IN EACH FILMS?
     -- table used :

SELECT film_id , count(actor_id) FROM film_actor
GROUP BY film_id 
ORDER BY film_id DESC;


-- QUES 4)  DISPLAY ALL FILM ID IN WHICH MORE THAN 8 ACTORS HAVE ACTED?

SELECT film_id , count(actor_id) AS actor_count FROM film_actor
GROUP BY film_id 
HAVING actor_count >8
ORDER BY actor_count DESC;


-- QUES 5) DISPLAY THE CUSTOMER IDS AND THE NUMBER OF RENTAL MADE BY EACH CUSTOMER FROM RENTAL TABLE ?
 
SELECT customer_id , COUNT(rental_id) FROM rental
GROUP BY customer_id;

# from payment table

SELECT customer_id , COUNT(rental_id) FROM payment
GROUP BY customer_id;


-- QUES 6) DISPLAY THE CUSTOMER ID AND THE TOTAL AMOUNT PAID BY EACH CUSTOMER?

SELECT customer_id , SUM(amount)
FROM payment
GROUP BY customer_id;


-- JOINS : 

-- QUES 1)  DISPLAY THE CUSTOMER AND THE AMOUNT PAID BY EACH CUSTOMER?
# need 2 tables , customer and payment

SELECT first_name , SUM(amount) FROM  customer c
INNER JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id;


-- QUES 2)  DISPLAY THE COUNTRY NAME AND THE NUMBER OF CITIES IN EACH COUNTRY?

SELECT country , count(city) FROM country cy
INNER JOIN city c  
ON cy.country_id = c.country_id
GROUP BY cy.country_id;


-- QUES 3) DISPLAY THE COUNTRY NAME AND THE NUMBER OF CITIES IN EACH COUNTRY WHO HAVE MORE THAN 40 CITIES?

SELECT country , count(city) AS citycount FROM country cy
INNER JOIN city c  
ON cy.country_id = c.country_id
GROUP BY cy.country_id
HAVING citycount > 40
ORDER BY citycount DESC;



-- QUES 4) DISPLAY THE ACTOR'S FIRST NAME AND THE NUMBER OF FILMS ACTED BY EACH ACTOR?

SELECT first_name , count(film_id) AS filmcount FROM actor a 
JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY filmcount DESC; 


-- QUES 5)  DISPLAY THE COUNTRY NAME AND THE NUMBER OF CITIES IN EACH COUNTRY SUCH THAT EACH CITY STARTS WITH 'A'?

SELECT country , count(city_id) AS citycount FROM country co
JOIN city c 
ON co.country_id = c.country_id
WHERE city LIKE 'A%'
GROUP BY c.country_id
ORDER BY citycount;   -- cannot display city name as it keeps changing in bucket(country) so we cannot access city 
                             -- name 


-- QUES 6) DISPLAY THE COUNTRY NAME AND THE NUMBER OF CITIES IN EACH COUNTRY SUCH THAT EACH CITY STARTS WITH 'A' 
-- AND CITY COUNT IS GREATER THAN 3.


SELECT country , count(city_id) AS citycount FROM country co
JOIN city c 
ON co.country_id = c.country_id
WHERE city LIKE 'A%'
GROUP BY c.country_id
HAVING citycount >3
ORDER BY citycount;


-- QUES 7) DISPLAY ALL CUSTOMER FIRST NAME  WHOSE FIRST NAME LENGTH IS GREATER THAN 5 CHARACTER AND 
-- PRINT THE AVERAGE RENTAL AMOUNT PAID BY EACH OF THEM ORDERED IN DESCENDING MANNER?


SELECT first_name , AVG(amount) as avgamount FROM customer c
JOIN payment p 
ON c.customer_id = p.customer_id
WHERE length(first_name) >5
GROUP BY c.customer_id
ORDER BY avgamount DESC;

-- apply round()

SELECT first_name , ROUND(AVG(amount),2) as avgamount FROM customer c
JOIN payment p 
ON c.customer_id = p.customer_id
WHERE length(first_name) >5
GROUP BY c.customer_id
ORDER BY avgamount DESC;


-- QUES 8) DISPLAY THE NUMBER OF  CUSTOMER FROM EACH COUNTRY WHOSE CITies STARTS WITH ANY VOWELS ?


SELECT co.country ,co.country_id, count(cu.customer_id) as customercount 
FROM customer cu 
JOIN address a
ON cu.address_id  = a.address_id
join city c
on a.city_id = c.city_id
JOIN country co
ON c.country_id = co.country_id
WHERE c.city REGEXP '^[AEIOUaeiou]'
GROUP BY co.country_id, co.country 
order by customercount desc;


-- QUES 9) DISPLAY THE ACTION MOVIES ACTED BY THE ACTOR WHOSE FIRST NAME IS 'PENELOPE' ?

select c.name, a.first_name from actor a
join film_actor fa
on a.actor_id = fa.actor_id
join film_category fc
on fa.film_id = fc.film_id
join category c 
on fc.category_id = c.category_id
where c.name = 'Action' and a.first_name = 'PENELOPE';



-- QUES 10) FIND OUT FOR EACH CUSTOMER HOW MUCH PAYMENT HAVE BEEN  DONE BY EACH STAFFER ?

SELECT customer_id , staff_id, sum(amount) FROM payment 
GROUP BY customer_id , staff_id;   
 

-- if want payment we cannot accss directly as payment is changing with every staff id 
-- we can only apply aggregrate to paymnt 

SELECT customer_id , staff_id, count(payment_id) ,sum(amount) FROM payment 
GROUP BY customer_id , staff_id; 




-- with roll up 

SELECT customer_id , staff_id, sum(amount) FROM payment 
GROUP BY customer_id , staff_id with rollup;


SELECT customer_id , staff_id, count(payment_id) ,sum(amount) FROM payment 
GROUP BY customer_id , staff_id with rollup; 


-- SUBQUERIES 

-- QUES 1. RETRIEVE THE TITLE OF A FILM THAT HAVE A LENGTH GREATER THAN THE AVERAGE LENGTH OF  ALL  FILMS ?

SELECT title FROM film
WHERE length > (SELECT AVG(length) FROM film);


-- QUES 2. FIND THE FILM WITH MAXIMUM RENTAL DURATION ?

SELECT * FROM film 
WHERE rental_duration = 
(
SELECT MAX(rental_duration) FROM film
);


-- IF INNER QUERY RETURNS MULTIPLE VALUES THEN :  ---> IN operator
-- IT RETURNS ONLY ONE COLUMN INSIDE THE SUBQUERY:


-- when there is no dependendency of inner query to the outer query is calleD 

-- NON-CORRELATED SUBQUERIES :

-- QUES 3. WRITE A QUERY THAT RETURN ALL THE CITIES THAT ARE IN INDIA OR PAKISTAN ?

SELECT * from city 
WHERE country_id IN (SELECT country_id from country where country IN ('India','Pakistan'));


-- CORRELATED SUBQUERIES: when there is dependency

-- QUES 4. WRITE A QUERY TO  FIND ALL THE CUSTOMERS WHOSE TOTAL PAYMENTS FOR ALL THE 
-- FILM RENTALS ARE BETWEEN 100 AND 150 DOLLARS? 


SELECT * FROM customer c
WHERE (SELECT SUM(amount) FROM payment p WHERE c.customer_id = p.customer_id) BETWEEN 100 AND 150;


-- CASE EXPRESSION:


-- QUES 1. RETRIEVE THE FILMS FILM TITLE ALONG WITH  A COLUMN THAT CATEGORIZE THEM AS 'LONG',
-- IF THE FILM LENGTH IS GREATER THAN 120 MINUTE AND 'SHORT; OTHERWISE.

-- CASE EXPRESSION : IT is used to perform conditional logic within queries. It allows you to return 
-- specific values based on certain conditions,

SELECT title, length,
CASE
   WHEN length > 120 then 'Long'
   ELSE 'Short'
END AS 'Length_Category'
FROM film;
 
 
 -- QUES 2. RETRIEVE THE FILMS FILM TITLE ALONG WITH  A COLUMN THAT CATEGORIZE THEM AS 'SHORT', 'MEDIUM', 'LONG'
 -- FILM LENGTH WHICH ARE LESS THAN 90 MINUTES ARE 'SHORT' , THOSE BETWEEN 90 AND 120 ARE 'MEDIUM' AND
 -- GREATER THAN 120 ARE 'LONG'.
 
 
 SELECT title, length,
 CASE
     WHEN length > 120 then 'Long'
     When length BETWEEN 90 AND 120 then 'Medium'
     ELSE 'Short' 
 END AS 'Length_Category'
FROM film;


-- QUES 3. RETRIEVE THE CUSTOMER NAME AND THE COLUMN THAT INDICATES WHETHER THEY ARE 'ACTIVE' OR 'INACTIVE' 
-- BASED ON THE VALUE OF THE 'ACTIVE' COLUMN IN THE CUSTOMER TABLE ?

SELECT first_name, last_name,  active , 
CASE
   WHEN active = 1 then 'Active'
   ELSE 'inactive'
END AS 'status'
FROM customer;


-- QUES 4. RETRIEVE THE CUSTOMER NAMES ALONG WITH A COLUMN THAT INDICATE WHETHER THEY HAVE RENTED MORE THAN 20 FILM
-- DISPLAY 'YES'  AND 'NO' OTHERWISE.

SELECT first_name,
CASE
   WHEN (
        SELECT COUNT(*) FROM rental WHERE rental.customer_id = customer.customer_id
        ) > 20 then 'YES' 
	ELSE 'NO'
END AS Rental_Count
FROM customer;


-- USING JOINS :

SELECT first_name,
CASE
	WHEN COUNT(r.rental_id) > 20 THEN 'YES'
	ELSE 'NO'
END AS Rental_Count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;



-- VIEWS

-- VIEWS :  views are virtual tables that are based on the result of a query. They don’t store data themselves 
-- but provide a way to simplify complex queries, enhance readability.

-- QUES 1.  RETRIEVE ALL CUSTOMER (FIRST_NAME , CITY AND ADDRESS) ?

CREATE VIEW Indian_Customers AS
SELECT c.first_name,
ci.city,
a.address
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = ci.country_id
WHERE co.country = 'India';


-- QUES 2. FIND ALL CUSTOMERS FROM 'INDIA' WHOSE FIRST_NAME STARTS WITH A ?

SELECT * FROM indian_customer
WHERE first_name like 'A%';


-- QUES 3. FIND ALL CUSTOMERS WHOSE CITY STARTS WITH 'A' ?

SELECT * FROM Indian_Customer
Where city like 'A%';


-- DROP VIEW 

DROP VIEW indian_customer;

-- UPDATE A VIEW

-- CREATE OR REPLACE  VIEW

CREATE OR REPLACE VIEW indian_customers as 
SELECT c.first_name, last_name,
city,
a.address
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = ci.country_id
WHERE co.country = 'India';

-- 4 FIND A CUSTOMER CALLED 'ADAM GOOCH' CHANGE LAST NAME TO  DONALD 
-- CHECK YOUR VIEWS

UPDATE customer
SET last_name = 'Donald'
Where last_name = 'Gooch' and first_name = 'Adam';


SELECT * FROM INDIAN_CUSTOMERS;

UPDATE customer
SET last_name = 'GOOCH'
WHERE last_name = 'Donald' and first_name = 'Adam';


-- QUES 5. Write a query to retrieve the number of rentals for each active customer. For inactive customers 
-- the result should be 0. Use case expression and correlated subquery.

SELECT first_name, c.last_name,
CASE 
WHEN active = 1 then 
(SELECT COUNT(*) FROM rental r WHERE r.customer_id = c.customer_id)
ELSE 0
END AS num_counts
FROM customer c;

-- second approach 

select c.first_name , c.last_name,
CASE
WHEN ACTIVE = 0 then 0
ELSE
(SELECT COUNT(*) FROM rental r WHERE r.customer_id = c.customer_id)
END AS num_rentals
FROM customer c;


-- QUES 3. WRITE A QUERY TO CATEGORIZE FILMS BASED ON THE INVENTORY LEVEL. 
-- IF THE COUNT OF COPIES IS 0 THEN ‘OUT OF STOCK’ 
-- IF THE COUNT OF COPIES IS 1 OR 2 THEN ‘SCARCE’ 
-- IF THE COUNT OF COPIES IS 3 OR 4 THEN ‘AVAILABLE’ 
-- IF THE COUNT OF COPIES IS >= 5 THEN ‘COMMON’



SELECT title,
       CASE 
           WHEN inventory_count = 0 THEN 'NO_Stock'
           WHEN inventory_count BETWEEN 1 AND 2 THEN 'Scarce'
           WHEN inventory_count BETWEEN 3 AND 4 THEN 'Available'
           ELSE 'Common'
       END AS INV_COUNT
FROM (
    SELECT title, f.film_id, COUNT(*) AS inventory_count
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    GROUP BY f.film_id) filmInventory;
    
    
    
-- QUES 4)  Construct a query against the film table that uses a filter condition with a correlated subquery 
-- against the category table to find all Horror films?


SELECT f.title
FROM film AS f
WHERE EXISTS (
    SELECT 1
    FROM film_category AS fc
    JOIN category AS c ON fc.category_id = c.category_id
    WHERE fc.film_id = f.film_id
    AND c.name = 'Horror'
);


-- OR 

SELECT f.title FROM film f WHERE film_id IN
(
SELECT fc.film_id from film_category fc
JOIN category c on fc.category_id = c.category_id
WHERE c.name = 'Horror');



-- TEMPORARY TABLE
-- exist uptil SQL session is on then it got removed automatically.


CREATE TEMPORARY TABLE TEMP_CUST
   SELECT first_name , email, address_id FROM customer;

SELECT * FROM TEMP_CUST;


-- QUES 1. Create a temporary table that contains information about all the customers who live in the 
-- United Kingdom. Include the following information: customer ID, first name, last name, and email address.

-- Creating the temporary table UK_CUSTOMERS
CREATE TEMPORARY TABLE UK_CUSTOMERS 
SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'United Kingdom';


SELECT * FROM UK_CUSTOMERS;



-- CTE 

-- CTE (COMMON TABLE EXPRESSION) 
-- EXIST ONLY FOR A QUERY THEN VANISHES.

WITH CUST_INFO_CTE AS (
SELECT first_name , email, address_id FROM customer
)
SELECT * FROM CUST_INFO_CTE;



-- CREATE CTE WITH INDIAN CUSTOMERS:

WITH IC_CTE AS (
     SELECT c.first_name,
      city,
      a.address
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = ci.country_id
WHERE co.country = 'India'
)
SELECT * FROM IC_CTE;


-- QUES 1. Create a CTE with two named subqueries. The first one gets the actors with last names starting with s. 
-- The second one gets all the pg films acted by them. Finally show the film id and title.

WITH actor_s AS (
SELECT actor_id,  first_name, last_name FROM actor
WHERE last_name LIKE 'S%' 
),
actor_s_pg AS (
SELECT s.actor_id , s.first_name, s.last_name, f.film_id , f.title FROM actor_s as s
JOIN film_actor fa ON s.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.rating = 'Pg'
)
SELECT film_id , title FROM actor_s_pg;


-- WINDOWS FUNCTION :
-- to access the element in the bucket which (group by cannot do)


-- QUES 1) . DISPLAY THE COUNTRY  ID AND THE NUMBER OF CITIES IN EACH COUNTRY?
-- AGGREGATES FUNCTION 

SELECT country_id , city, 
COUNT(city_id) OVER (PARTITION BY country_id) AS city_count
FROM city;



-- if we want to display country name as well then 

SELECT country, city.country_id , city, 
COUNT(city_id) OVER (PARTITION BY country_id) AS city_count
FROM city
JOIN country ON city.country_id = country.country_id;


-- QUES 2. SHOW THE CUSTOMER ID , FIRST NAME AND THE CUMULATIVE SUM OF THEIR PAYMENTS IN ASCNDNG ODER?
-- AGGREGATES FUNCTION  IN WINDOWS

SELECT c.customer_id, first_name , amount, p.payment_date, 
SUM(amount) OVER (PARTITION BY c.customer_id ) as CUMULATIVE_SUM 
FROM customer c
JOIN payment p ON c.customer_id= p.customer_id;



-- RANKING FUNCTIONS


-- QUES 3) RETRIEVE THE FILM TITLES ALONG WITH THEIR LENGTH AND RANK EACH FILM BASED ON THEIR LENGTH  IN 
-- ASCENDING ORDER ?

-- RANKING FUNCTIONS IN WINDOWS
-- RANK()

SELECT title, length,
RANK() OVER (ORDER BY length) AS length_rank
FROM film;




-- DENSE RANK 

SELECT title, length,
DENSE_RANK() OVER (ORDER BY length) AS length_rank
FROM film;


-- QUES 4) Calculate the dense rank of films from the film table based on their Replacement cost in descending order.
-- Include the film title and Replacement cost in the output.

SELECT title, replacement_cost, 
DENSE_RANK() OVER (ORDER BY replacement_cost DESC) AS denserank
FROM film;


-- ROW NUMBER 

SELECT title, length,
ROW_NUMBER() OVER (ORDER BY length) AS length_rank
FROM film;

-- QUES 5 ) Determine the row number for each customer from the customer table 
-- when ordered by their first name in ascending order.

SELECT first_name , last_name,
ROW_NUMBER() OVER (ORDER BY first_name ASC) as rowNumber
FROM customer;


-- VALUE FUNCTION 
-- (LEAD , LAG)

-- QUES 1) FOR EACH FILM IN THE TABLE LIST THE FILM TITLE , RELEASE YEAR AND THE TITLE OF THE FILM
-- THAT COMES AFTER IT IN TERMS OF RELEASE YEAR ?

-- LEAD: gives next value .... last will be NULL .

SELECT title, release_year,
 LEAD(title) OVER (ORDER BY release_year) AS next_film_title
 FROM film;
 

-- LAG : gives us previous value ... first will be NULL

SELECT title, release_year,
 LAG(title) OVER (ORDER BY release_year) AS next_film_title
 FROM film;
 
 
 
 -- INDEXING
 
 CREATE INDEX idx_first_name1
 ON customer(first_name);
 
 
 -- DROPPING INDEX
 
 ALTER TABLE customer
 DROP INDEX idx_first_name1;
