 -- Data type conversion

 -- No conversion
 select * from movies
 where movie_id = 1;

 -- implicit integer=string
 select * from movies
 where movie_id = '1';

 -- explicit
 select * from movies
 where movie_id = integer '1';

 -- Using cast
 -- string to int
select 
 	cast('10' as integer)

select 
 	cast('10n' as integer)

-- string to date 
select 
 	cast('2020-01-01' as date),
	cast('2020-01-01' as date);
	 
-- string to boolean 
select 
 	cast('true' as boolean),
	cast('false' as boolean),
	cast('T' as boolean),
	cast('F' as boolean);

select 
 	cast('0' as boolean),
	cast('1' as boolean);

-- string to double
select 
 	cast('3.143' as double precision);
	
-- Use directly
select 
	'10'::integer,
	'2020-01-01' :: date,
	'2020-01-01' :: date;

-- string to timestamp
select '2020-01-01 10:30:25.143' :: timestamp;

-- with timezone 
select '2020-01-01 10:30:25.143' :: timestamptz;


-- string to interval
select 
	'10 minute'::interval,
	'4 hour'::interval,
	'1 day'::interval,
	'2 week'::interval,
	'5 month'::interval;


--Implicit to Explicit Conversions
-- Using integer and factorial 
SELECT factorial(20) AS result;

-- round with numeric
select round  (cast(10 as numeric),4) as "result";

-- cast with text
select substr('123456',2) as "result";

select substr('123456',2) as "implicit";
select substr('123456' as text) as "explicit";

-- Table data conversion
create table ratings(
	rating_id serial primary key,
	rating varchar(1) not null
);

select * from ratings;

insert into ratings (rating) values
('a'),
('b'),
('c'),
('d');

insert into ratings (rating) values
('1'),
('2'),
('3'),
('4');

-- use cast for non-numeric to integer

SELECT 
    rating_id,
    CASE
        WHEN rating ~ '^\d+$' THEN
            CAST(rating AS INTEGER)
        ELSE
            0
    END AS rating_value
FROM ratings;

































