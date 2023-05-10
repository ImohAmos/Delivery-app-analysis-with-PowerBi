USE FoodDeliveryApp;

SELECT * FROM customers;

SELECT * FROM orders;

SELECT * FROM stores;


--Total number of orders

SELECT COUNT (id) as total_orders
FROM orders;


--Total number of orders by City

SELECT city, COUNT (id) as total_orders
FROM orders
WHERE start_time
BETWEEN '2022-01-01' AND '2022-01-31'
GROUP BY city;


--Total number of orders coming from food partners

SELECT COUNT (store_id) AS Food_Orders
FROM orders
INNER JOIN stores ON orders.store_id = stores.id
WHERE start_time
BETWEEN '2022-01-01' AND '2022-01-31'
AND is_food = 1 --meaning TRUE;



--Total number of orders coming from food partners by City

SELECT COUNT (store_id) AS Food_Orders, stores.city
FROM orders
INNER JOIN stores ON orders.store_id = stores.id
WHERE start_time
BETWEEN '2022-01-01' AND '2022-01-31'
AND is_food = 1 --meaning TRUE
GROUP BY stores.city;


-- Percentage of orders that were delivered in less than 45 minutes

SELECT COUNT (id) AS no_of_orders, city,
COUNT(id) * 100 / (SELECT COUNT(*) FROM orders) AS percentage
FROM orders
WHERE start_time
BETWEEN '2022-01-01' AND '2022-01-31'
AND datediff(minute, start_time, end_time) < 45
GROUP BY city;


--This below,shows the total percentage of orders with delivery time < 45 minutes

SELECT COUNT(id) AS no_of_orders,
	COUNT(id) * 100 / (SELECT COUNT(*) FROM orders WHERE start_time
BETWEEN '2022-01-01' AND '2022-01-31') AS percentage
FROM orders WHERE start_time
BETWEEN '2022-01-01' AND '2022-01-31'
AND datediff(minute, start_time, end_time) < 45;


--The number and percentage of the orders that came from the top stores as shown

SELECT stores.city,top_store,
COUNT (store_id) AS num_of_stores,
COUNT(store_id) * 100 / (SELECT COUNT(*) FROM orders) AS percentage
FROM orders
INNER JOIN stores ON orders.store_id = stores.id
WHERE start_time
BETWEEN '2022-01-01' AND '2022-01-31'
AND top_store = 1
GROUP BY stores.city,top_store;


-- No of stores that received no orders during the time period per city

SELECT city,
COUNT (id) as no_orders
FROM stores
WHERE stores.id
NOT IN (SELECT store_id FROM orders WHERE start_time
BETWEEN '2022-01-01' AND '2022-01-31')
GROUP BY city;


-- Average spend from customers per city in eur

SELECT city, AVG (total_cost_eur) AS Average_Spend
FROM orders
WHERE start_time
BETWEEN '2022-01-01' AND '2022-01-31'
GROUP BY city;


-- This calculates Difference in average spend in euros between prime and non prime users
-- 1 is TRUE and 0 is FALSE
SELECT
AVG (total_cost_eur) -
(SELECT AVG ((total_cost_eur))
FROM orders
INNER JOIN customers
ON customers.id = orders.customer_id
WHERE is_prime = 0) AS difference_avg_spend --the subquery is used to minus the averages
FROM orders
INNER JOIN customers ON customers.id = orders.customer_id
WHERE start_time
BETWEEN '2022-01-01' AND '2022-01-31'-- Taking January 2022 as previous month
AND is_prime = 1;