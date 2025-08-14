-- Creating views
-- Create a view to include all movies with directors names
create or replace view v_movie_quick as
select 
	movie_name,
	movie_length,
	release_date
from movies mv

-- Using view
create or replace view v_movie_directors_all as
select 
	mv.movie_id,
	mv.movie_name,
	mv.movie_length,
	mv.movie_lang,
	mv.age_certificate,
	mv.release_date,
	mv.director_id,

	d.first_name,
	d.last_name,
	d.date_of_birth,
	d.nationality
from movies mv
inner join directors d on d.director_id = mv.director_id


create or replace view v_movie_directors_all as
select 
*
from movies mv
inner join directors d on d.director_id = mv.director_id;

-- Use a view for query datasets
select * from v_movie_quick;
select * from v_movie_directors_all;

-- rename a view
Alter view v_movie_quick rename to v_movie_quick2;

Alter view v_movie_quick2 rename to v_movie_quick;
-- delete a view
drop view v_movie_quick;

-- Using filter with views
-- create view
create or replace view v_movies_after_1977 as
select 
*
from movies
where release_date >= '1997-12-31'
order by release_date desc;

-- select all movies with english language from the view
select * from 
v_movies_after_1977
where movie_lang = 'English'
and age_certificate = '12'
order by movie_lang;

-- select all movies with American and Japanese nationalities
select * from 
v_movie_directors_all
where nationality in ('American', 'Japanese');

-- view with union of multiple tables
create view v_all_actors_directors as 
select
	first_name,
	last_name,
	'actors' as people_type
from actors
union all 
select
	first_name,
	last_name,
	'directors' as people_type
from directors;

select
*
from v_all_actors_directors
where first_name like 'J%'
order by people_type, first_name;

-- connecting multiple tables with a single view 
create view v_movies_directors_revenues as
select 
	mv.movie_id,
	mv.movie_name,
	mv.movie_length,
	mv.movie_lang,
	mv.age_certificate,
	mv.release_date,

	d.director_id,
	d.first_name,
	d.last_name,
	d.nationality,
	d.date_of_birth,

	r.revenue_id,
	r.revenues_domestic,
	r.revenues_international
from movies mv
inner join directors d on d.director_id = mv.director_id
inner join movies_revenues r on r.movie_id = mv.movie_id;

select 
* 
from v_movies_directors_revenues
where age_certificate = '12';

-- Rearrange columns in a view
create view v_directors as
select 
	last_name,
	first_name
from directors

-- delete a column from an existing view
create view v_directors as
select 
	first_name
from directors

create or replace view v_directors as
select 
	first_name,
	last_name,
	nationality
from directors

-- Updateable view for directors table
create or replace view vu_directors as
select 
	first_name,
	last_name
from directors;

-- Add some records via view
insert into vu_directors(first_name, last_name)
values ('dir1', 'lname1'), ('dir2', 'lname2');

-- check contents of directors table via view
select * from vu_directors;

select * from directors;

-- delete some records via view
delete from vu_directors
where first_name = 'dir1'

delete from vu_directors
where first_name = 'dir2'

-- Updatable views with check option
create table countries(
	country_id serial primary key,
	country_code varchar(4),
	city_name varchar(100)
);

insert into countries(country_code, city_name) values
('US','New York'),
('US','New Jersey'),
('UK','London');

-- view content of countries table
select * from countries;

-- create a simple view to list all US based cities
create or replace view v_cities_us as 
select
	country_id,
	country_code,
	city_name
from countries
where country_code = 'US'

select * from v_cities_us;

insert into v_cities_us(country_code, city_name) values
('UK','Greater Manchester');
select * from v_cities_us;

create or replace view v_cities_us as 
select
	country_id,
	country_code,
	city_name
from countries
where country_code = 'US'
with check option

insert into v_cities_us(country_code, city_name) values
('UK','Leeds');

