-- Get all data from a table
select * from actors;

-- Select specific column
select first_name from actors;

-- Select specific columns
select first_name, last_name from actors;

-- Select column with Alias
select first_name as fName from actors;

-- The column Alias remains fName and is not lowercase when mentioned explicitly in "" not ''
select first_name as "fName" from actors;

-- As keyword is optional for ALIAS
SELECT 
	movie_name "Movie",
	movie_lang "Language"
FROM movies;

-- Combining Columns using ||

select first_name || ' ' || last_name as "Full Name" from actors;

-- Select for expression evaluation
select 10^2;

-- Sort Ascending based on single column
select * from movies order by release_date ASC;

-- Sort Descending based on single column
select * from movies order by release_date DESC;

-- Sort based on multiple columns
select * from movies order by release_date DESC, movie_name ASC;

-- order by with alias
select 
	first_name, 
	last_name as surname 
from actors 
order by surname DESC;

-- Sorting rows by an expression using order by
-- Sorting actors by an length of name desc
select 
	first_name, 
	length(first_name) as len
from actors 
order by 
	len desc;


-- Using column name for sorting

select 
	first_name, 
	last_name,
	date_of_birth
from actors 
order by
	1 ASC,
	3 DESC;

-- Sorting ascending sends null to last by default
select 
	first_name, 
	length(first_name) as len
from actors 
order by 
	len nulls last;

-- Sorting by nulls first
select 
	first_name, 
	length(first_name) as len
from actors 
order by 
	len desc nulls first;

-- Selecting unique value
select
	distinct director_id
from movies
order by 1;

-- Selecting multiple unique values
select
	distinct movie_lang, director_id
from movies
order by 1;


-- Selecting all unique records
select 
	distinct * 
from movies
order by movie_id asc;
