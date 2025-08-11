-- Constructing arrays and ranges

select 
	int4range (1,6) as "Default {( closed opened",
	numrange(1.4213, 6.2986, '[]') as "closed - closed",
	daterange('20100101','20201220', '()') as "opened - opened",
	tsrange(localtimestamp, localtimestamp + interval '8 days', '(]') as "opened - closed"

select 
	array[1,2,3] as "int arrays",
	array[2.12225::float] as "floating numbers with putting explicit typing",
	array[current_date, current_date + 5]

-- using comparision operators
select
	array[1,2,3,4] = array[1,2,3,4] as "Equality",
	array[1,2,3,4] = array[2,3,4] as "Equality",
	array[1,2,3,4] <> array[2,3,4,5] as "Not Equal to",
	array[1,2,3,4] < array[2,3,4,5] as "Less than",
	array[1,2,3,4] <= array[2,3,4,5] as "Less than Equal to",
	array[1,2,3,4] > array[2,3,4,5] as "Greater than",
	array[1,2,3,4] > array[2,3,4,5]] as "Greater than Equal to",

-- For ranges
select
	int4range(1,4) @> int4range(2,3) as "Contains",
	daterange(current_date, current_date + 30) @> current_date + 15 as "Contains Value",
	numrange(1.6, 5.2) && numrange(0,4)

-- Inclusion Operators
select
	array[1,2,3,4] @> array[2,3,4] as "Contains",
	array['a','b'] @> array['a','b', 'c'] as "Contained By",
	array[1,2,3,4] @> array[2,3,4] as "Is overlap"

-- Array constructions
-- With ||
select
	array[1,2,3] || array[4,5,6] as "Combine Arrays";

select array_cat(array[1,2,3], array[4,5,6]) as "Combine Arrays via Array_cat"

-- Add an item to array

select 
	4 || array[1,2,3] as "Adding to an array";

select 
	array_prepend(4, array[1,2,3]) as "Using Prepend";

select
	array[1,2,3] || 4 as "Adding to array";

select
	array_append(array[1,2,3], 4) as "Using Append";

-- Array Metadata Functions
select
	array_ndims(array[[1],[2]]) as "Dimensions";

select
	array_ndims(array[[1,2,3],[4,5,6],[4,5,6]]);

select
	array_dims(array[[1],[2]]);

select
	array_length(array[1,2,3,4],1);

select
	array_length(array[]::integer[],1);

select
	array_lower(array[1,2,3,4],1);

select
	array_lower(array[1,4],1);

select
	array_upper(array[1,2,2,4],1);

select
	cardinality(array[[1],[2],[3],[4]]),
	cardinality(array[[1],[2],[3],[4],[5]])

-- Array Search Functions

select
	array_position(array['Jan','Feb','March','April'], 'March');

select
	array_position(array[1,2,3,4], 2);

select
	array_positions(array[1,2,2,3,4], 2);

-- Array Modification Functions
-- Concatenation
select
	array_cat(array['Jan','Feb'],array['March','April']);

-- Add element at end
select
	array_append(array[1,2,3],4);

-- Add element to start
select
	array_prepend(0,array[1,2,3,4]);

-- Remove all occurences
select
	array_remove(array[1,2,2,3,4], 2);

-- Replace all occurences 
select
	array_replace(array[1,2,2,3,4], 2, 0);

-- Array Comparision with In, all, any and some
-- In
select 
	20 in (1,2,20,40) as "Results";

select 
	29 in (1,2,20,40) as "Results";

-- Not in
select 
	20 not in (1,2,20,40) as "Results";

select 
	29 not in (1,2,20,40) as "Results";

-- All
select 
	25 = all(array[1,2,20,40]) as "Results";

select 
	25 = all(array[25,25]) as "Results";

-- Any
select 
	25 = any(array[1,2,20,40]) as "Results";

select 
	25 = any(array[25,25]) as "Results";

select 
	25 <> any(array[1,2,25,NULL]) as "Results";

select 
	25 = some(array[1,2,3,4]) as "Results";

select 
	25 = some(array[1,2,3,4,25]) as "Results";

-- Formatting and converting an array
-- String to text array

select
	string_to_array('1,2,3,4',',');

-- Setting a non-empty value to null
select
	string_to_array('1,2,3,4,abc',',','abc');

-- Setting a empty value to null
select
	string_to_array('1,2,3,4,,6',',','');

-- Array to string
-- Setting a non-empty value to null
select
	array_to_string(array[1,2,3,4], '|');

select
	array_to_string(array[1,2,3,4], ',');

-- Array to string with nulls 
select
	array_to_string(array[1,2,null,4], '|');
	
select
	array_to_string(array[1,2,null,4,null], '|', 'Empty Data');

-- Using arrays in tables
-- Creating table with array data
create table teachers(
	teacher_id serial primary key,
	name varchar (150),
	phones text []
);

-- Can also use array keyword
create table teachers1(
	teacher_id serial primary key,
	name varchar (150),
	phones text array
);

-- Insert data into arrays
insert into teachers(name, phones) values
(
	'Adam', array['111111111111','22222222222']
);

insert into teachers(name, phones) values
('Linda', '{"33333333333"}'),
('Jeff', '{"44444444444","55555555555"}')

-- Query array data
-- Find all phone records
select name, phones from teachers;

-- Accessing elements
select name, phones[2] from teachers;

-- Using filters
select name, phones[2] from teachers
where phones[1] = '111111111111';

-- Search any array for all rows
select * from teachers
where '111111111111' = any(phones);

-- Modifying Array data
select * from teachers

update teachers
set phones[2] = '0000000000'
where teacher_id = 2

-- Creating table with one dimensional array
create table teachers2(
	teacher_id serial primary key,
	name varchar (150),
	phones text array[1]
);
-- Array dims are ignored
insert into teachers2(name, phones) values
(
	'Adam', array['111111111111','22222222222']
);

select * from teachers2;

-- display all array elements
select teacher_id, name, unnest(phones) from teachers;

-- Using order by
select 
	teacher_id, 
	name, 
	unnest(phones) 
from teachers
order by 3;

-- using multidimensional array
create table students(
	student_id serial primary key,
	student_name varchar(100),
	student_grade integer[][]
);

insert into students(student_name, student_grade) values
('s1','{90,2020}');

select * from students;

insert into students(student_name, student_grade) values
('s2','{80,2020}'),
('s3','{70,2019}'),
('s4','{60,2018}');

-- Get specific array dimension data
select student_grade[1] from students;
select student_grade[2] from students;

select * from students where student_grade @> '{2020}';
select * from students where 2020 = any(student_grade);

select * from students where student_grade[1] > 70