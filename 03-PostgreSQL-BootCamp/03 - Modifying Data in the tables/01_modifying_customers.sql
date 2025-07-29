CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(150),
	age INT
);

select * from customers;

-- Inserting Values into table
insert into customers(first_name, last_name, email, age)
values ('Priyam','Vyas','priyamvyas12345@gmail.com','21')

-- Inserting Multiple Records into table
insert into customers(first_name, last_name)
values
('P','v'),
('A','v'),
('N','P'),
('D', 'R');

-- Inserting Data with Quotes
insert into customers (first_name)
values
('M''Bappe');

-- Get info on added rows returning all 
insert into customers(first_name)
values
('ADAM') returning *;

-- Get info on added rows returning specific column 
insert into customers(first_name)
values
('Joseph') returning customer_id;

-- Update data in table
-- Single Column
update customers 
set email = 'pv@gmail.com'
where customer_id = 1

-- Multiple Columns

update customers
set email = 'abc@gmail.com',
age = 18
where customer_id = 1


-- Returning updated row

update customers 
set email = 'pv@gmail.com'
where customer_id = 1
returning *;


select * from customers;

-- Updating all records
update customers 
set is_enabled = 'Y';


-- Deleting Records
delete from customers
where customer_id = 9;

-- Delete All Records
delete from customers;

-- New Sample
create table t_tags(
	id serial primary key,
	tag text unique,
	update_date timestamp default now() 
);

select * from t_tags

insert into t_tags(tag)
values 
('pen'),
('pencil');

-- Insert a record, on conflict do nothing
insert into t_tags(tag)
values ('pen')
on conflict (tag)
do nothing;

-- Insert a record, on conflict set new value
insert into t_tags(tag)
values ('pen')
on conflict (tag)
do 
	update set
		tag = excluded.tag || '1',
		update_date = now();





