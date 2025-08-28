-- Netflix project
USE netflix_db;

CREATE TABLE netflix
(
    show_id	VARCHAR(6),
    type VARCHAR(10),
    title	VARCHAR(150),
    director VARCHAR(208),
    casts	VARCHAR(1000),
    country VARCHAR(150),	
    date_added	VARCHAR(50),
    release_year INT,
    rating	VARCHAR(10),
    duration VARCHAR(15),	
    listed_in	VARCHAR(100),
    description VARCHAR(250)
);
 
SELECT * FROM netflix;

SELECT 
COUNT(*) AS total_content 
FROM netflix;

SELECT 
DISTINCT TYPE
 FROM netflix;

SELECT * FROM netflix

-- Business Problems
-- 1. Find the total number of TV Shows and Movies in the dataset.

SELECT
 type, 
 count(*) AS total_count 
FROM netflix 
GROUP BY type;

-- 2. Find the most common rating for TV Shows and Movies 
SELECT 
type,
rating
FROM
( 
   SELECT 
  type, 
  rating, 
  COUNT(*),
  RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
 FROM netflix
GROUP BY 1, 2) AS d1
WHERE ranking = 1;
-- ORDER BY 1, 3 DESC;

-- 3. List all movies released in a given year (e.g., 2020).
-- filter 2020
-- filter movies
SELECT * FROM netflix
WHERE 
   type = 'Movie' AND release_year = 2020;

--- 4 find the top 5 with the most content on netflix
SELECT 
 country,
 COUNT(show_id) AS total_content
FROM netflix
 GROUP BY 1
-- ORDER BY 2 DESC

-- Get the first country

SELECT
  TRIM(SUBSTRING_INDEX(country, ',', 1)) AS new_country,
  COUNT(show_id) AS total_content
FROM netflix
GROUP BY new_country
ORDER BY 2 DESC
LIMIT 5;

--5 dentify the longest  movie
SELECT * FROM netflix
WHERE
   type = 'Movie'
   AND 
   duration = (SELECT MAX(duration) FROM netflix);

-- 6. Find the content added in the last five years.
SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y')>= CURDATE() - INTERVAL 5 YEAR;

SELECT CURRENT_DATE - INTERVAL 5 YEAR;

--7 Find all the movies/TV showsdone by director 'Rajiv Chilaka'
SELECT *
 FROM netflix 
 WHERE director LIKE '%Rajiv Chilaka%'; 

--8 List all the shows with more than 5 Seasons
SELECT 
    *,
    CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) AS seasons
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

--9 count the no of content items in each genre
SELECT 
     SUBSTRING_INDEX(listed_in, ',', 1) AS genre,
    COUNT(show_id) AS total_content
FROM netflix
    GROUP BY genre; 

---10. Find each year and the average numbers of content released by United states by netflix

SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y')) AS Year,
    COUNT(*) AS total_content,
   ROUND(
    (COUNT(*) * 100.0 / 
        (SELECT COUNT(*) FROM netflix WHERE country = 'United States')
    ), 2
    ) AS avg_content_per_year
FROM netflix
WHERE country = 'United States'
GROUP BY Year
ORDER BY Year;

--11. List all the movies that ae documentaries 

SELECT * FROM netflix
WHERE 
    listed_in LIKE '%Documentaries%'

--12. Find all the content without a director
 SELECT * FROM netflix
 WHERE director IS NULL 

 --13 Ffind the top 10 actors who have appeared in the most movies/TV shows on Netflix in the United States

SELECT 
    SUBSTRING_INDEX(casts, ',', 1) AS Actor,
    COUNT(show_id) AS total_appearances
FROM netflix
WHERE country = 'United States' 
  AND casts IS NOT NULL
GROUP BY Actor
ORDER BY total_appearances DESC
LIMIT 10;

--14. Categorize  the content based on the presence of the keywords 'kill' and 'violence' in the description field. label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category
SELECT 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad_content'
        ELSE 'Good_content'
    END AS content_category,
    COUNT(*) AS total_count
FROM netflix
GROUP BY content_category;

