select * from movies

-- Where clause use ''
select * from movies
where
	movie_lang = 'English'
	-- AND operator
	and age_certificate = '18';


select * from movies
where
	movie_lang = 'English'
	-- or operator
	or movie_lang = 'Chinise'
order by movie_lang;

-- Combining AND and OR
-- without paranthesis
select * from movies
where
	movie_lang = 'English'
	or movie_lang = 'Chinise'
	and age_certificate = '12'
order by movie_lang;

-- with paranthesis
select * from movies
where
	(movie_lang = 'English'
	or movie_lang = 'Chinise')
	and age_certificate = '12'
order by movie_lang;

-- Using logical operators 

select * from movies
where
	movie_length > 100
order by movie_length;

select * from movies
where
	release_date > '1999-12-31'

select * from movies
where
	movie_lang < 'English'

-- <> or !=
select * from movies
where
	movie_lang <> 'English'


-- No '' for nums 
select * from movies
where
	movie_length > 100

-- Using limit and offset
-- Top 5 movies
select * from movies
order by movie_length desc
limit 5;


-- Top 5 oldest American directors

select * from directors
where nationality = 'American'
order by date_of_birth 
limit 5;

-- Top 10 youngest female actors
select * from actors
where gender = 'F'
order by date_of_birth desc
limit 10;

-- 5 films from 4th order by movie id
select * from movies
order by movie_id
limit 5 offset 4;

-- Next Top 5 highest domestic profit movies
select * from movies_revenue
order by revenues_domestic desc nulls last
limit 5 offset 5;



-- Using Fetch first/next x row/rows only
-- Get first row of movies
select * from movies
fetch first row only;

-- top 5 biggest movies in length

select * from movies
order by movie_length desc
fetch first 5 row only;

-- Top 5 oldest American directors

select * from directors
where nationality = 'American'
order by date_of_birth 
fetch first 5 row only;


-- Top 10 youngest female actors
select * from actors
where gender = 'F'
order by date_of_birth desc
fetch first 10 row only;


-- first 5 after 5 movies on movie length
select * from movies
order by movie_length desc
offset 5
fetch first 5 row only;

-- Using IN, NOT IN

-- Get all movies with english, chinese and japanese language 

select * from movies
where movie_lang in ('English', 'Chinese', 'Japanese');


-- Get all movies with age certification in 12 or pg

select * from movies
where age_certificate in ('12','PG');

-- Get all movies where director id is not 13 or 10

select * from movies
where director_id not in ('10','13');

-- Get all movies where actor id is not 1,2,3 or 4
select * from actors
where actor_id not in (1,2,3,4);


-- Get all actors born between 1991 and 1995

select * from actors
where date_of_birth between '1991-01-01' and '1995-12-31'; 

-- Movies released between 1998 and 2002
select * from movies
where release_date between '1998-01-01' and '2002-12-31'
order by release_date;

-- Movies where domestic revenue between 100 and 300
select * from movies_revenue
where revenues_domestic between '100' and '300'
order by revenues_domestic desc;


-- Movie length not between 100 and 200
select * from movies
where movie_length not between '100' and '200'
order by movie_length desc;



-- Using LIKE and ILIKE

-- 1 Full character search
select 'hello' like 'hello';

-- 2 Partial character search
select 'hello' like 'h%';
select 'hello' like '%e%';
select 'hello' like 'hell%';
select 'hello' like '%ll';

-- 3 Single character search

select 'hello' like '_ello';

-- 4 Checking occurance of search with '_'
select 'hello' like '__ll_';


--5 using % and _ together
select 'hello' like '%ell_';

--6 get all actors with names starting from A
select * from actors
where first_name like 'A%'
order by first_name;

--7 Actor last names ending with a

select * from actors
where last_name like '%a'
order by last_name;


--8 first name with 5 characters only

select * from actors
where first_name like '_____'
order by first_name;

--9 Actor names with first name having l on secod place

select * from actors
where first_name like '_l%'
order by first_name;



-- IS NULL and IS NOT NULL

-- Actors with missing birth date or missing first name
select * from actors
where date_of_birth is null or first_name is null;

-- Movies with domestic revenue null
select * from movies_revenue
where revenues_domestic is null;

-- Movies with either domestic or international revenue null
select * from movies_revenue
where 
	revenues_domestic is null
	or revenues_international is null;

-- Concatenation

-- 1 Let's combine Hello and world
select 'hello' || 'world' as new_str;

-- 2 Combine Actor First and Last Names 
select concat(first_name,' ' ,last_name) as "Actor Name"

-- 3 print first, last name and dob cs
select concat_ws(', ', first_name, last_name, date_of_birth)
from actors
order by first_name;

select 'hello' || null || 'world';

select concat(revenues_domestic, revenues_international) as profits
from movies_revenue








