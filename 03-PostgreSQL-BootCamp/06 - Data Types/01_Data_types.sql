--Numeric
create table table_serial(
	product_id serial,
	product_name varchar(100)
);

insert into table_serial(product_name)
values('pen');

select * from table_serial;

insert into table_serial(product_name)
values('pencil');

insert into table_serial(product_name)
values('pencil2');

--Decimal
create table table_numbers(
	col_numeric numeric(20,5),
	col_real real,
	col_double double precision
);

insert into table_numbers(col_numeric, col_real, col_double)
values 
	(.9,.9,.9),
	(3.13579, 3.13579, 3.13579),
	(4.9876578231, 4.9876578231, 4.9876578231)

select * from table_numbers;

-- Date
create table table_date(
	id serial primary key,
	employee_name varchar(100) not null,
	hire_date date not null,
	add_date date default current_date
);

insert into table_date(employee_name, hire_date) values
('adam','2020-01-01'),
('linda','2020-02-01');

select * from table_date;

-- get current date
select current_date;

-- get current date and time
select now();

-- Time
create table table_time(
	id serial primary key,
	class_name varchar(100) not null,
	start_time time not null,
	end_time time not null
);

insert into table_time(class_name, start_time, end_time) values
('math','08:00:00','09:00:00'),
('chemistry','09:01:00','10:00:00');

select * from table_time;

-- get current time with precision
select current_time(4);

-- Use local time
select localtime, localtime(4);

-- Arithmetic Ops
select time '12:00' - time '04:00' as result;

-- Using interval
select current_time, current_time + interval '-2 hours' as result;	

-- Time Stamp and Time stampz
create table table_time_tz(
	ts timestamp,
	tstz timestamptz
);

insert into table_time_tz(ts, tstz) values
('2020-02-22 10:10:10-07', '2020-02-22 10:10:10-07');


select * from table_time_tz;

-- Get current timezone
show timezone;

-- Change timezone
set timezone = 'America/New_York';

-- Get timestamp
select current_timestamp;

-- Current time of day
select timeofday();

-- Using timezone() function to convert time based on a time zone
select timezone('Asia/Singapore','2020-01-01 00:00:00')
select timezone('America/New_York','2020-01-01 00:00:00')

-- UUID
-- Enable uuid extension
create extension  if not exists "uuid-ossp";

select uuid_generate_v1();
"7c8a9c7c-6dd5-11f0-8904-4b2b0bf47157"

create table table_uuid(
	product_id uuid default uuid_generate_v1(),
	product_name varchar(100) not null 
);

insert into table_uuid (product_name) values ('abc111');

select * from table_uuid;

-- change default uuid value
alter table table_uuid
alter column product_id
set default uuid_generate_v4();


-- Array
create table table_array(
	id serial,
	name varchar(100),
	phones text []
);

select * from table_array;


insert into table_array (name, phones)
values ('Adam', ARRAY ['(801)-123-4567','(819)-555-2222']);

insert into table_array (name, phones)
values ('LINDA', ARRAY ['(201)-123-4567','(214)-555-2222']);

select * from table_array;

select phones[1] from table_array;


-- hstore
create extension if not exists hstore;

create table table_hstore(
	book_id serial primary key,
	title varchar(100) not null,
	book_info hstore
);

insert into table_hstore(title, book_info) values
(
	'title1',
	'
		"publisher"=>"ABC publisher",
		"paper_cost"=>"10.00",
		"e_cost"=>"5.85"
	'
)

select * from table_hstore;

select book_info -> 'publisher' as publisher from table_hstore;

-- JSON
create table table_json(
	id serial primary key,
	docs JSON
)

select * from table_json;

insert into table_json (docs) values
('[1,2,3,4,5,6]'),
('[2,3,4,5,6,7]'),
('{"key":"value"}');

--search data
select docs from table_json;

alter table table_json
alter column docs type jsonb;

-- search specific data
select * from table_json
where docs @>'2';

create index on table_json using GIN (docs jsonb_path_ops);

-- Network Addresses
create table table_netaddr(
	id serial primary key,
	ip inet
);

insert into table_netaddr (ip) values
('4.35.221.243'),
('4.152.207.126'),
('4.152.207.238'),
('4.249.111.162'),
('12.1.223.132'),
('12.8.192.60');

select * from table_netaddr;

select 
	ip, 
	set_masklen(ip, 24) as inet_24,
	set_masklen(ip::cidr, 24) as cidr_24,
	set_masklen(ip::cidr, 27) as cidr_27,
	set_masklen(ip::cidr, 27) as cidr_28
from table_netaddr;









