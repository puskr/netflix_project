select * from netflix

	alter table netflix
	alter column duration type varchar(15)


	
select count(*) from netflix as total

--Q1 Count the number of movies vs tv shows

select count(*) as total_content, type
from netflix 
group by type

--Q2 Find the most common rating for movies and TV shows

select 
	type,
	rating
	from 	
(select 
	type, 
	rating, 
	count(*),
	rank() over(partition by type order by count(*) desc) as ranking
 from netflix
group by 1, 2
) as t1

	where ranking = 1


--Q3 List all the movies released in the year 2020

select * from netflix
where
type = 'Movie'
and
release_year = 2020

--Q4 find the top 5 countries with the most content on Netflix

select 
UNNEST(string_to_array(country, ',')) as new_country,
count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5

--Q5 Identify the longest movie

SELECT title, duration
FROM netflix
WHERE type = 'movie' AND duration LIKE '%min%'
ORDER BY CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INTEGER) DESC
LIMIT 1;

SELECT MAX(CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INTEGER)) AS max_duration
FROM netflix
WHERE duration LIKE '%min%';


--Q6 find content added in the last 5 years

select *
	
from netflix
where 
	to_date(date_added, 'Month DD, YYYY') > current_date - interval '5 years'

--Q7 find all the movies/tv shows by director 'Rajiv Chilaka'

select title, type
from netflix
where director IliKE '%Rajiv Chilaka%'

--Q8 List all TV shows with more than 5 seasons

SELECT *,
    split_part(duration, ' ', 1) AS sessions
FROM netflix
WHERE type = 'TV Show' 
    AND CAST(split_part(duration, ' ', 1) AS INTEGER) > 5;

--Q9 Count the number of content items in each genre

SELECT
    unnest(string_to_array(listed_in, ',')) AS genre,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY genre;


--Q10 find each year and the average number of content release by India on Netflix. 
--Return Top 5 year with highest average content release!

SELECT 
    EXTRACT(YEAR FROM to_date(date_added, 'Month DD, YYYY')) AS Yearr,
    COUNT(*) as yearly_content,
	count(*)::numeric/(select count(*) from netflix where country= 'India')::numeric *100 as average_content
FROM netflix
WHERE country = 'India'
GROUP BY Yearr;

--Q11 list all movies that are documentaries

SELECT title, release_year, type
FROM netflix
WHERE listed_in ILIKE '%documentaries%' and type = 'Movie';


--Q12 find all the content without a director

select * from netflix
where director IS null

--Q13 Find how many movies actor 'Salman KHan' APPEARED in last 10 year

select * from netflix
where casts ILIKE '%Salman Khan%' and release_year > extract(year from current_date) - 10

--Q14 Find the top 10 actors who have appeared in the highest numbers of movie produced in India

SELECT 
    UNNEST(string_to_array(casts, ',')) AS ACTORS,
    COUNT(*) AS total_content
FROM netflix
	where country ilike '%India%'
GROUP BY 1
order by 2 desc
limit 10


--Q15 Categorize the content based on the presence of the keyword ' Kill' and 'Voilence' in the description field.
--Label content containing these keywords as 'bad' and all other content as 'Good.' Count how many items fall into each category.



SELECT 
    title, 
    release_year, description,
    CASE 
        WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' 
        THEN 'Bad Film'
        ELSE 'Good Film'
    END AS Category
FROM netflix;






