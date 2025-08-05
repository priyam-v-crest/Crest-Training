-- upper, lower and initcap
select upper('priyam vyas');

select 
	upper(first_name) as first_name,
	upper(last_name) as last_name
from directors;

select lower('PRIYAM VYAS');

select initcap('I am priyam vyas');

select initcap(first_name || ' ' || last_name) as full_name
from directors 
order by full_name;

-- left and right
select left('ABCD', 1);

select left('ABCD', -1);

-- Get initial for all directors name
select left(first_name, 1) as initial 
from directors 
order by 1;

-- get first 6 characters from all movies
select 
	movie_name,
	left(movie_name, 6)
from movies;

select right('ABCD', 3);
select right('ABCD', -1);

select last_name, right(last_name, 2)
from directors 
where right(last_name, 2) = 'on';

-- reverse
select reverse('Priyam Vyas')

-- split part 
select split_part('1,2,3', ',', 3);

select split_part('one, two, three', ',', 1);

-- Get release year of all movies

select
	movie_name,
	release_date,
	split_part(release_date::text, '-',1) as release_year
from movies;

select * from movies;


-- trim, btrim, ltrim and rtrim
select 
	trim(leading from '    Priyam Vyas     '),
	trim(leading from '     Priyam Vyas      '),
	trim('   Priyam  Vyas     ');
	

-- removing leading zeros
select trim(leading '0'
			from
				cast(00000012345 as text)
	);

select ltrim('yummy','y');

select rtrim('yummy','y');

select btrim('yummy','y');

-- lpad and rpad
select lpad ('Databsae', 15, '*');
select rpad ('Databsae', 15, '*');

select 
	mv.movie_name,
	r.revenues_domestic,
	lpad('*', cast(trunc(r.revenues_domestic / 10) as int), '*') as chart
from movies mv
inner join movies_revenues r on r.movie_id = mv.movie_id
order by 3 desc nulls last;
	
select * from movies

select length ('Priyam Vyas');

select length(cast (10900000 as text));

select char_length(' ');

select char_length(null);

select 
	first_name || ' ' || last_name as full_name,
	length(first_name || ' ' || last_name) as full_name_length
from directors 
order by full_name_length desc;

-- position
select position('yas' in 'Priyam Vyas');

-- strpos
select strpos('world bank','bank');


select
	first_name,
	last_name
from directors
where strpos(last_name, 'on')>0;

-- substring
select substring('what a wonderful day' from 2 for 8);

select substring('what a wonderful day' for 8);


-- repeat
select repeat('-x-', 50);

-- replace
select replace('Priyam', 'yam', 'ya');







