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

-- Updatable views using WITH LOCAL and CASCADED 
create or replace view v_cities_c as 
select
	country_id,
	country_code,
	city_name
from countries
where city_name like 'C%'

select * from v_cities_c;

create or replace view v_cities_c_us as 
select
	country_id,
	country_code,
	city_name
from v_cities_c
where country_code = 'US'
with local check option;

insert into v_cities_c_us(country_code, city_name) values
('US','Connecticut');

select * from v_cities_c_us;

create or replace view v_cities_c_us as 
select
	country_id,
	country_code,
	city_name
from v_cities_c
where country_code = 'US'
with cascaded check option;

insert into v_cities_c_us(country_code, city_name) values
('US','Boston');

insert into v_cities_c_us(country_code, city_name) values
('US','Clearwater');

-- Creating a materialized view
create materialized view if not exists mv_directors as
select
	first_name,
	last_name
from directors
with data;

select * from mv_directors;

create materialized view if not exists mv_directors_no_data as
select
	first_name,
	last_name
from directors
with no data;

select * from mv_directors_no_data;

refresh materialized view mv_directors_no_data;

-- Drop materialized view
drop materialized view mv_director2

-- Changing materialized view data
select * from mv_directors;

insert into directors (first_name) values ('dir1'),('dir2');

refresh materialized view mv_directors;

delete from mv_directors
where first_name='dir1';

update mv_directors set first_name = 'ddir1'
where first_name = 'dir1';

-- Check if materialized view is populated or not
create materialized view mv_directors2 as
select
	first_name
from directors
with no data;

select * from mv_directors2;

select relispopulated from pg_class where relname = 'mv_directors2';

-- Refreshing data in materialized views
create materialized view mv_directors_us as
select
	director_id,
	first_name,
	last_name,
	date_of_birth,
	nationality
from directors
where nationality = 'American'
with no data;

select * from mv_directors_us;

refresh materialized view mv_directors_us;

select * from mv_directors_us;

create unique index idx_u_mv_directors_us_director_id on mv_directors_us(director_id);

select * from mv_directors_us;

-- Using materialized view for website page clicks analytics
create table page_clicks(
	rec_id serial primary key,
	page varchar(200),
	click_time timestamp,
	user_id bigint
);

insert into page_clicks(page, click_time, user_id)
select
(
	case(random() *2)::int
		when 0 then 'klickanalytics.com'
		when 1 then 'clickapis.com'
		when 2 then 'google.com'
	end
) as page,
now() as click_time,
(floor(random() * (111111111 - 1000000 + 1)+1000000))::int as user_id
from generate_series(1,10000) seq;

select * from page_clicks;

-- For daily trend analysis
create materialized view mv_page_clicks as 
select 
	date_trunc('day', click_time) as day,
	page,
	count(*) as total_clicks
from page_clicks
group by day, page;

refresh materialized view mv_page_clicks;

create materialized view mv_page_clicks_daily as 
select 
	click_time as day,
	page,
	count(*) as cnt
from page_clicks
where 
	click_time>=date_trunc('day',now())
	and click_time<timestamp 'tomorrow'
group by day, page;

refresh materialized view mv_page_clicks;

create unique index idx_mv_page_clicks_daily_day_page on mv_page_clicks_daily(day, page);

select * from mv_page_clicks_daily;

-- List all materialized views
select oid::regclass::text
from pg_class
where relkind = 'm'
order by 1;

-- list materialized views with no unique indexes
with matviews_with_no_unique_keys as(
	select c.oid, c.relname, c2.relname as idx_name
	from pg_catalog.pg_class c, pg_catalog.pg_class c2, pg_catalog.pg_index i
	left join pg_catalog.pg_constraint con 
	on (
		conrelid = i.indrelid and conindid = i.indexrelid and contype in ('p','u')
	)
	where 
	c.relkind = 'm'
	and c.oid = i.indrelid
	and i.indexrelid = c2.oid
	and indisunique
)
select c.relname as materialized_view_name
from pg_class c
where c.relkind = 'm'
except
select mwk.relname
from matviews_with_no_unique_keys as mwk;
