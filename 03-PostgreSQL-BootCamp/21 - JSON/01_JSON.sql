-- Exploring Json objects
-- Representing a json object
select '{"title": "The lord of the rings"}':: text

-- cast data type to make it json
select '{"title":"The lord of the rings"}'::json

-- If we do not want white spaces
select '{
	"title":"The lord of the rings",
	"author":"J.R.R"
}'::jsonb

-- Creating first table with jsonb data type
create table books(
	book_id serial primary key,
	book_info jsonb
);

-- insert json data
-- Single record
insert into books(book_info) values
('{
	"title":"Book title1",
	"author":"author"
}
')

select * from books;

-- multiple records
insert into books(book_info) values
('{
	"title":"Book title2",
	"author":"author2"
}
'),
('{
	"title":"Book title3",
	"author":"author3"
}
'),
('{
	"title":"Book title4",
	"author":"author4"
}
');

select * from books;

-- Using selectors
select book_info from books;

select book_info -> 'title' from books; -- Returns as a field in quotes

select book_info ->> 'title' from books; -- Returns as text

select 
	book_info ->> 'title' as title,
	book_info ->> 'author' as author
from books
where book_info ->> 'author' = 'author2';

-- Update json data
insert into books (book_info) values
('{"title":"Book title 10","author":"author10"}')

update books
set book_info = book_info || '{"author":"Priyam"}'
where book_info ->> 'author' = 'author10'

update books
set book_info = book_info || '{"title":"The Future 1.0"}'
where book_info ->> 'author' = 'Priyam'
Returning *

-- Add additional field with boolean value
update books
set book_info = book_info || '{"Best Seller":true}'
where book_info ->> 'author' = 'Priyam'
Returning *

-- Let's add multiple key - values
-- Add additional field with boolean value
update books
set book_info = book_info || '{"category":"Science"}'
where book_info ->> 'author' = 'Priyam'
Returning *

-- Delete best seller boolean key-value
-- Using - operator
update books
set book_info = book_info -'Best Seller'
where book_info ->> 'author' = 'Priyam'
Returning *

-- Add a nested array data in json 
update books
set book_info = book_info || '{"availability_locations": [
	"New York",
	"New Jersey"
	]}'
where book_info ->> 'author' = 'Priyam'
Returning *

-- Delete from arrays via path'#-'
update books
set book_info = book_info #- '{availability_locations,1}'
where book_info ->> 'author' = 'Priyam'
Returning *

update books
set book_info = book_info - 'pages'
where book_info ->> 'author' = 'Priyam'
Returning *

-- Create JSON from table
-- Directors in json format 
select * from directors

select row_to_json(directors) from directors;

select row_to_json(t) from
(
	select
		director_id,
		first_name,
		last_name,
		nationality
	from directors
) as t

-- Using json_agg() to aggregate data
select
*,
(
	select json_agg(x) as all_movies from 
	(
		select
			movie_name
		from movies
		where director_id = directors.director_id
	)as x
)
from directors;

-- select director_id, name, and all movies by that director
select
director_id,
first_name,
last_name,
(
	select json_agg(x) as all_movies from 
	(
		select
			movie_name
		from movies
		where director_id = directors.director_id
	)as x
)
from directors;

-- Build a json array
-- sample
select json_build_array(1,2,3,4,5);

-- strings and numbers together
select json_build_array(1,2,3,4,5,'HI');

-- json object
select json_build_object(1,2,3,4,5,6,7,'HI');

-- Can we supply key/value style data 
select json_build_object('name','Priyam','email','p@v.com');

select json_object('{name,email}','{Priyam,"p@v.com"}');

-- Create documents from data
create table directors_docs(
	id serial primary key,
	body jsonb
);

-- Prep data for insert ops
insert into directors_docs(body)
select row_to_json(a) from (
	select
		director_id,
		first_name,
		last_name,
		date_of_birth,
		nationality,
		(
		select json_agg(x) as all_movies from 
		(
			select
				movie_name
			from movies
			where director_id = directors.director_id
		)as x
	)
	from directors
)as a

select * from directors_docs;

-- Null values in json documents
select * from directors_docs;

select jsonb_array_elements(body->'all_movies') from directors_docs
where (body->'all_movies') is not null;

-- Populate data with empty array element for all_movies
delete from directors_docs;

insert into directors_docs(body)

select row_to_json(a) from (
	select
		director_id,
		first_name,
		last_name,
		date_of_birth,
		nationality,
		(
		select case count(x) when 0 then '[]' else json_agg(x) end as all_movies
		from
		(
			select
				movie_name
			from movies
			where director_id = directors.director_id
		)as x
	)
	from directors
)as a

select jsonb_array_elements(body->'all_movies') from directors_docs

-- Getting info from JSON docs
-- Count total movies for each director
select 
	*,
	jsonb_array_elements(body->'all_movies') as total_movies
from directors_docs
order by jsonb_array_elements(body->'all_movies') desc;

-- List all keys within each JSON row
select 
	*,
	jsonb_object_keys(body)
from directors_docs

-- key/value style output
select
	j.key,
	j.value
from directors_docs, jsonb_each(directors_docs.body) j

-- Turning JSON into table format
select
	j.*
from directors_docs, jsonb_to_record(directors_docs.body) j (
	director_id int,
	first_name varchar(255),
	nationality varchar(100)
);

-- Existence Operator -> ?
-- find all first name equal to 'John'
select 
*
from 
directors_docs
where body->'first_name' ? 'John';

select 
*
from 
directors_docs
where body ? 'John';

-- Find all records with director id 1
select 
*
from 
directors_docs
where body->'director_id' ? '1';

-- Containment Operator -> @>
-- find all first name equal to 'John'
select 
*
from 
directors_docs
where body @> '{"first_name":"John"}';

-- Find all records with director id 1
select 
*
from 
directors_docs
where body@> '{"director_id":1}';

-- Find record for the movie "Toy Story"
select 
*
from 
directors_docs
where body->'all_movies' @> '[{"movie_name":"Toy Story"}]'

-- Mix and match JSON search
-- Find all records where first name starts with 'J'
explain select 
*
from 
directors_docs
where body->>'first_name' like 'J%';

-- Find all records where director id > 2
select 
*
from 
directors_docs
where (body->>'director_id')::integer>2

-- Indexing on JSONB
-- Find all records where director id in 1,2,3,4,5 and 10
select 
*
from 
directors_docs
where (body->>'director_id')::integer in (1,2,3,4,5,10);