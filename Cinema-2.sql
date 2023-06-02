-- 1. Get the Top 3 film that have the most Customer book
-- limit 3 desc

SELECT film.id, COUNT(booking.id) AS number_booking_per_film
FROM film
JOIN screening ON film.id = screening.film_id
JOIN booking ON screening.id = booking.screening_id
GROUP BY film.id
ORDER BY number_booking_per_film DESC
LIMIT 3;

-- Van chua nghi ra the worst scenarios :D
-- count, offset 0, 1, 2???

SELECT film.id, COUNT(booking.id) AS number_booking_per_film
FROM film
JOIN screening ON film.id = screening.film_id
JOIN booking ON screening.id = booking.screening_id
GROUP BY film.id
HAVING COUNT(booking.id) >= (
  SELECT COUNT(booking.id) AS booking_count
  FROM film
  JOIN screening ON film.id = screening.film_id
  JOIN booking ON screening.id = booking.screening_id
  GROUP BY film.id
  ORDER BY booking_count DESC
  LIMIT 1
)
ORDER BY number_booking_per_film DESC;

-- 2. Get all films that longer than avarage length
SELECT *
FROM film
WHERE length_min > (
	SELECT AVG(length_min)
    FROM film);
    
-- 3. Get the room which have the highest and lowest screenings in 1 SQL

SELECT room.id AS room_id, COUNT(screening.id) AS number_screening_per_room
FROM screening
JOIN room ON screening.room_id = room.id
GROUP BY room.id
HAVING
  COUNT(screening.id) = (
    SELECT MAX(screening_count) AS max_number_screening
    FROM (
      SELECT room.id AS room_id, COUNT(screening.id) AS screening_count
      FROM screening
      JOIN room ON screening.room_id = room.id
      GROUP BY room.id
    ) AS subquery
  )
  OR
  COUNT(screening.id) = (
    SELECT MIN(screening_count) AS min_number_screening
    FROM (
      SELECT room.id AS room_id, COUNT(screening.id) AS screening_count
      FROM screening
      JOIN room ON screening.room_id = room.id
      GROUP BY room.id
    ) AS subquery
  );

-- 4. Get number of booking of each room of film 'Tom&Jerry'

SELECT room.id, COUNT(room.id)
FROM room 
JOIN screening ON screening.room_id = room.id
JOIN film ON film.id = screening.film_id
JOIN booking ON screening.id = booking.screening_id
WHERE film.name = 'Tom&Jerry'
GROUP BY room.id;

-- 5. What seat is being book the most?

SELECT seat.*, COUNT(seat.id)
FROM reserved_seat
JOIN seat ON reserved_seat.seat_id = seat.id
GROUP BY seat.id
HAVING COUNT(seat.id) =
	(SELECT COUNT(reserved_seat.id) as number_booking_per_seat
	FROM seat JOIN reserved_seat ON seat.id = reserved_seat.seat_id
	GROUP BY seat.id
	ORDER BY number_booking_per_seat DESC
	LIMIT 1);
    
-- 6. What film have the most screens in 2022?
SELECT film.id, film.name, count(screening.id) as having_the_most_screens
FROM film
JOIN screening ON film.id = screening.film_id
WHERE screening.start_time LIKE '2022%'
GROUP BY film.id
HAVING COUNT(screening.id) >=
	(SELECT count(screening.id)
	FROM film
	JOIN screening ON film.id = screening.film_id
	WHERE screening.start_time LIKE '2022%'
	GROUP BY film.id
	HAVING COUNT(screening.id)
	ORDER BY COUNT(screening.id) DESC
	LIMIT 1);

-- 7. Which day has the most screen?
SELECT CAST(start_time AS DATE), COUNT(*) AS number_screens
FROM screening
GROUP BY CAST(start_time AS DATE)
HAVING COUNT(*) >=
	(SELECT COUNT(*) AS number_screens
	FROM screening
	GROUP BY CAST(start_time AS DATE)
	ORDER BY number_screens DESC
	LIMIT 1);


-- 8. Show film on 2022-May
SELECT DISTINCT film.name
FROM screening
JOIN film ON film.id = screening.film_id
WHERE YEAR(start_time) = 2022
AND MONTH(start_time) = 5;

-- 9. Film end with chracter "n"
SELECT `name`
FROM film
WHERE `name` LIKE "%n";

-- 10. Show customer name/ first 3 characters and last 3 chracters in UPPERCASE
SELECT customer.id, LEFT(customer.first_name,3), UPPER(RIGHT(customer.last_name,3))
FROM customer;

-- 11. film longer than 2 hours
SELECT *
FROM film
WHERE length_min >= 120



