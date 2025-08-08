-- Inner Join
select * from directors;
select * from movies;

select 
	movies.movie_id,
	movies.movie_name,
	movies.director_id
from movies
inner join directors
on movies.director_id = directors.director_id;

-- Alias way
select 
	mv.movie_id,
	mv.movie_name,
	mv.director_id,
	d.first_name
from movies as mv
inner join directors d
on mv.director_id = d.director_id;

-- filtering
select 
	mv.movie_id,
	mv.movie_name,
	mv.director_id,
	d.first_name
from movies as mv
inner join directors d
on mv.director_id = d.director_id
where 
	mv.movie_lang = 'English'
	and d.director_id = 3;

-- using tablename.* or table_alias.* instead of individual column name
select 
	mv.*,
	d.*
from movies as mv
inner join directors d
on mv.director_id = d.director_id

-- Inner joins with USING
select * from movies
inner join directors using(director_id)

select * from movies
inner join movies_revenues using(movie_id)

-- Joining multiple tables
select * from movies
inner join directors using(director_id)
inner join movies_revenues using(movie_id)

-- select movie_name, director name and domestic revenues for all japanese movies
select 
	mv.movie_name,
	d.first_name,
	d.last_name,
	r.revenues_domestic
from movies mv
inner join directors d on mv.director_id = d.director_id
inner join movies_revenues r on mv.movie_id = r.movie_id;
where movie_lang = 'Japanese'

-- select movie_name, director name for all english, chinese and japanese movies where domestic reveues is greater than 100
select 
	mv.movie_name,
	d.first_name,
	d.last_name,
	r.revenues_domestic
from movies mv
inner join directors d on mv.director_id = d.director_id
inner join movies_revenues r on mv.movie_id = r.movie_id
where 
	movie_lang in ('English','Japanese', 'Chinese')
	and r.revenues_domestic > 100
order by 4 desc;

-- select movie_name, director name, movie language, total revenues for top 5 movies
select 
	mv.movie_name,
	d.first_name,
	d.last_name,
	r.revenues_domestic,
	r.revenues_international,
	(r.revenues_domestic+r.revenues_international) as "Total Revenue"
from movies mv
inner join directors d on mv.director_id = d.director_id
inner join movies_revenues r on mv.movie_id = r.movie_id
order by 6 desc nulls last
limit 5;

-- Inner join with data filter
-- Top 10 most profitable movies between 2005 and 2008
select 
	mv.movie_name,
	mv.movie_lang,
	d.first_name,
	d.last_name,
	r.revenues_domestic,
	r.revenues_international,
	(r.revenues_domestic+r.revenues_international) as "Total Revenue"
from movies mv
inner join directors d on mv.director_id = d.director_id
inner join movies_revenues r on mv.movie_id = r.movie_id
order by 7 desc nulls last
limit 10;

-- Inner join with different data type columns
create table t1 (test int);

create table t2 (test varchar(10));	

select * from t1 inner join t2 on t1.test = t2.test::int;

-- left joins
create table left_products(
	product_id serial primary key,
	product_name varchar(100)
	);
create table right_products(
	product_id serial primary key,
	product_name varchar(100)
	);

insert into left_products(product_id, product_name) values
(1,'Computers'),
(2,'Laptops'),
(3,'Monitors'),
(5,'Mics');

insert into right_products(product_id, product_name) values
(1,'Computers'),
(2,'Laptops'),
(3,'Monitors'),
(4,'pens'),
(5,'Papers');

select * from left_products;

select * from right_products;

select * from left_products
left join right_products on left_products.product_id = 	right_products.product_id;

-- List all directors name and movie name
select 
	d.first_name,
	d.last_name,
	mv.movie_name
from directors d
left join movies mv using (director_id)
--reverse
select 
	d.first_name,
	d.last_name,
	mv.movie_name
from movies mv
left join directors d using (director_id)	

-- Get list of english and chinese movies only using where
select 
	d.first_name,
	d.last_name,
	mv.movie_name,
	mv.movie_lang
from directors d
left join movies mv using (director_id)
where 
	mv.movie_lang in ('English','Chinese')

-- Count all movies for each directors
select 
	d.first_name,
	d.last_name,
	count(*) as "total_movies"
from directors d
left join movies mv using (director_id)
group by d.first_name, d.last_name
order by count(*) desc;

-- Get all movies with age certification for all directors where nationalities are 'American', 'Chinese' and 'Japanese'
select * from directors d
left join movies mv using (director_id)
where d.nationality in ('American', 'Chinese','Japanese')

-- Get all total reveneus by each films for each director
select
	d.first_name,
	d.last_name,
	sum(r.revenues_domestic + r.revenues_international) as "total_revenues"
from directors d
left join movies mv using (director_id)
left join movies_revenues r using (movie_id)
group by d.first_name, d.last_name
having sum(r.revenues_domestic + r.revenues_international) > 100
order by 3 desc nulls last

-- Right Join left_products and right_products
select * from left_products
right join right_products using (product_id)

-- Right joins on movies database
select 
	d.first_name,
	d.last_name,
	mv.movie_name
from directors d
right join movies mv using (director_id);

-- reverse tables
select 
	d.first_name,
	d.last_name,
	mv.movie_name
from movies mv
right join directors d using (director_id)
order by d.first_name;

-- Adding where 
select 
	d.first_name,
	d.last_name,
	mv.movie_name
from movies mv
right join directors d using (director_id)
where mv.movie_lang in ('English','Chinese');

-- Count all movies for each director
select 
	d.first_name,
	d.last_name,
	count(*) as "total_movies"
from directors d
right join movies mv using (director_id)
group by d.first_name, d.last_name
order by count(*) desc, d.first_name;

-- Get all total revenues by each director
select
	d.first_name,
	d.last_name,
	sum(r.revenues_domestic + r.revenues_international) as "total_revenues"
from directors d
right join movies mv using (director_id)
left join movies_revenues r using (movie_id)
group by d.first_name, d.last_name
having sum(r.revenues_domestic + r.revenues_international) > 100
order by 3 desc nulls last, d.first_name;

-- Full Join
select
*
from left_products
full join right_products using (product_id);

-- list all movies with director first and last name, movie name
select 
	d.first_name,
	d.last_name,
	mv.movie_name
from directors d
right join movies mv using (director_id)
order by d.first_name;

-- reverse tables
select 
	d.first_name,
	d.last_name,
	mv.movie_name
from movies mv
right join directors d using (director_id)
order by d.first_name;

-- add where
select 
	d.first_name,
	d.last_name,
	mv.movie_name
from movies mv
full join directors d using (director_id)
where mv.movie_lang in ('English')
order by d.first_name;

-- Joining Multiple tables
select 
	*
from movies mv
join directors d using (director_id)
join movies_revenues r using (movie_id);

-- Join all together
select
*
from actors ac
join movies_actors ma using (actor_id)
join movies mv using (movie_id)
join directors d using (director_id)
join movies_revenues r using (movie_id)

-- Self join left_products table
select 
* 
from left_products t1
inner join left_products t2 using (product_id);

-- Self join directors table
select 
* 
from directors t1
inner join directors t2 using (director_id);

-- Use self join to find all pairs that have same movie length
-- Self join left_products table
SELECT 
    t1.movie_name AS movie_1,
    t2.movie_name AS movie_2,
    t1.movie_length
FROM movies t1
INNER JOIN movies t2 
    ON t1.movie_length = t2.movie_length 
    AND t1.movie_name <> t2.movie_name
ORDER BY t1.movie_length DESC, t1.movie_name;

-- Query hierarchical data 
SELECT 
    t1.movie_name,
    t2.director_id
from movies t1
INNER JOIN movies t2 
    ON t1.director_id = t2.director_id 
ORDER BY t2.director_id, t1.movie_name;

-- Cross Join
select 
* 
from left_products
cross join right_products;

-- equivalent
select 
* 
from left_products, right_products;

-- Method 2
select 
* 
from left_products
inner join right_products on true;

-- Actors and directors
select
*
from directors
cross join actors;

-- Natural joins
-- left
select 
* 
from left_products
Natural left join right_products;

-- right
select 
* 
from right_products
Natural left join left_products;

-- Natural Join movies and directors
select 
* 
from movies
Natural left join directors;

select 
* 
from movies
Natural right join directors;

-- Append tables with different columns
-- Creating tables
create table table2(
	add_date date,
	col1 int,
	col2 int,
	col3 int,
	col4 int,
	col5 int
);

create table table1(
	add_date date,
	col1 int,
	col2 int,
	col3 int
);
-- Inserting data
insert into table2(add_date,col1,col2,col3,col4,col5) values
('2020-01-01',null, 7,8,9,10),
('2020-01-02',11,12,13,14,15),
('2020-01-03',16,17,18,19,20);

select * from table2;

insert into table1(add_date,col1,col2,col3) values
('2020-01-01',1,2,3),
('2020-01-02',4,5,6);

select * from table1;

-- Combine
select 
	coalesce(t1.add_date, t2.add_date) as "add_date",
	coalesce(t1.col1, t2.col1) as col1,
	coalesce(t1.col2, t2.col2) as col2,
	coalesce(t1.col3, t2.col3) as col3,
	t2.col4,
	t2.col5
from table1 t1 full outer join table2 t2 on (t1.add_date = t2.add_date)