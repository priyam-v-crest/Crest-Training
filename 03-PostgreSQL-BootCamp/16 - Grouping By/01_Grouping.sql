-- Using group by
select 
	movie_lang,
	count(movie_lang)
from movies
group by movie_lang;

-- Average movie length group by movie language
select 
	movie_lang,
	avg(movie_length::numeric)
from movies
group by movie_lang
order by movie_lang;

select * from movies
-- sum total movie length per age certificate
select
	age_certificate,
	sum(movie_length::int)
from movies
group by age_certificate

-- list minimum and maximum movie length group by language
select
	movie_lang,
	max(movie_length),
	min(movie_length)
from movies
group by movie_lang
order by max (movie_length) desc;

-- Group by with multiple columns
--  Get average movie length group by movie language and age certi
select
	movie_lang,
	age_certificate,
	avg(movie_length::numeric) as "Avg Movie Length"
from movies
group by movie_lang, age_certificate
order by movie_lang, 3 desc;

-- How many directors per each nationality
select 
	nationality, 
	count(*) as "Total Directors"
from directors
group by nationality
order by 2 desc;

-- Total sum movie length for each age certificate
select 
	movie_lang,
	age_certificate,
	sum(movie_length::numeric)
from movies
group by movie_lang, age_certificate
order by 3 desc;

-- Using having
-- Get languages having over 200 movies

select 
	movie_lang,
	sum(movie_length::numeric)
from movies
group by movie_lang
having sum(movie_length::numeric) > 200
order by sum(movie_length::numeric)


-- directors with total length greater than 200

select 
	director_id,
	sum(movie_length::numeric)
from movies
group by director_id
having sum(movie_length::numeric) > 200
order by 2 desc

-- Handling null values with group by
create table employees_test(
	employeee_id serial primary key,
	employee_name varchar(100),
	department varchar(100),
	salary int
);

select * from employees_test;

insert into employees_test(employee_name, department, salary) values
('John', 'finance',2500),
('Mary',null, 3000),
('Adam', null, 4000),
('Linda', 'IT', 5000);

select * from employees_test;

select * from employees_test order by department;

-- Employees in each group
select 
	department,
	count(salary) as "Total Employees"
from employees_test
group by department
order by department

-- Handle null value
select 
	coalesce (department, '* No Department *') as department,
	count(salary) as total_employees
from employees_test
group by department
order by department;
