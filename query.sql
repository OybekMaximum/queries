SELECT
  rs.store_id,
  rs.staff_id,
  rs.staff_first_name,
  rs.staff_last_name,
  rs.total_revenue
FROM (
  SELECT
    s.store_id,
    s.staff_id,
    s.first_name AS staff_first_name,
    s.last_name AS staff_last_name,
    SUM(p.amount) AS total_revenue,
    ROW_NUMBER() OVER (PARTITION BY s.store_id ORDER BY SUM(p.amount) DESC) AS revenue_rank
  FROM staff s
  JOIN payment p ON s.staff_id = p.staff_id
  WHERE EXTRACT(YEAR FROM p.payment_date) = 2017
  GROUP BY s.store_id, s.staff_id, staff_first_name, staff_last_name
) AS rs
WHERE rs.revenue_rank = 1;


SELECT
  f.film_id,
  f.title,
  AVG(EXTRACT(YEAR FROM NOW()) - EXTRACT(YEAR FROM cust.create_date)) AS expected_age
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer cust ON r.customer_id = cust.customer_id
GROUP BY f.film_id, f.title
ORDER BY COUNT(r.rental_id) DESC
LIMIT 5;





SELECT
  a.actor_id,
  a.first_name AS actor_first_name,
  a.last_name AS actor_last_name,
  (MAX(f.release_year) - MIN(f.release_year)) AS acting_duration
FROM film_actor fa
JOIN film f ON fa.film_id = f.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, actor_first_name, actor_last_name
ORDER BY acting_duration;
