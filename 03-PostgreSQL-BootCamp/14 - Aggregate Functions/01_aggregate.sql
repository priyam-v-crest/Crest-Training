-- Count
-- Count total number of movies

select count(*) from movies;

select * from movies;

-- Count all records of a specific column
select count(movie_length) from movies;

-- Count with distinct
select count(distinct(movie_lang)) from movies;

-- Count all distinct directors
select count(distinct(director_id)) from movies;

-- Count all english movies
select count(*) from movies where movie_lang = 'English';

-- Sum funciton
select sum(revenues_domestic::numeric) from movies_revenues;

select count(revenues_domestic), count(*) from movies_revenues;

select sum(movie_length::numeric) from movies where movie_lang = 'English';

-- longest movie in movies table
select max(movie_length) from movies;

-- shortest movie in movies table
select min(movie_length) from movies;

-- latest released english movie
select max(release_date)
from movies
where movie_lang = 'English';

select * from movies;

-- first movie released in chinese
select min(release_date)
from movies
where movie_lang = 'Chinese';

-- Greatest and Least
select greatest(200,20,30);

select least(-10,10,45);

select least('A','B','C');

-- Average
select avg(movie_length::numeric) from movies;

select avg(distinct movie_length::numeric)
from movies 
where movie_lang = 'English'

-- Combining columns using mathematical operators
SELECT
	movie_id,
	revenues_domestic,
	revenues_international,
	(revenues_domestic::numeric + revenues_international::numeric) AS "total revenue"
FROM movies_revenues;

SELECT
	movie_id,
	revenues_domestic,
	revenues_international,
	(revenues_domestic::numeric + revenues_international::numeric) AS "total revenue"
FROM movies_revenues
where (revenues_domestic::numeric + revenues_international::numeric) is not null
order by 4 desc nulls last;












