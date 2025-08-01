-- CREATE DOMAIN

-- 'addr' domain with varchar(100) not null 
create domain addr varchar(100) not null;

create table locations(
	address addr
);

insert into locations(address) values ('124'), ('london'), (null);

create domain positive_numeric int not null check (value>0);

create table sample(
	sample_id serial primary key,
	value_num positive_numeric
);

insert into sample(value_num) values(-10);

select * from sample;

-- us postal code domain
CREATE DOMAIN us_postal_code AS TEXT
CHECK(
        VALUE ~'^\d{5}$' OR VALUE ~'^\d{5}-\d{4}$'
    )

create table addresses(
	address_id serial primary key,
	postal_code us_postal_code
)

insert into addresses (postal_code) values  ('10000-10000');

-- proper email domain

create domain proper_email varchar(150)
check (value ~* '[^A-Za-z0-9._%-]+@[^A-Za-z0-9.-]+[,][A-Za-z]+$')

create table clients_names
(
	client_name_id serial primary key,
	email proper_email
)

insert into clients_names(email) values('a@b.com');
select * from clients_names;


-- create an enumeration type domain 
 
create domain valid_color varchar(10)
check (value in ('red', 'green', 'blue'))

create table colors(
	colors valid_color
);


insert into colors (color) values ('orange');

select * from colors;

create domain user_status varchar(10)
check (value in ('enable','disable','temp')

create table users_check(
	status user_status
)

-- get all domain in a schema

SELECT t.typname
FROM pg_catalog.pg_type t
JOIN pg_catalog.pg_namespace n
  ON t.typnamespace = n.oid
WHERE t.typtype = 'd'
  AND n.nspname = 'public';

SELECT t.typname AS domain_name,
       pg_catalog.format_type(t.typbasetype, t.typtypmod) AS base_type,
       t.typnotnull AS is_not_null,
       t.typdefault AS default_value,
       n.nspname AS schema_name
FROM pg_catalog.pg_type t
JOIN pg_catalog.pg_namespace n ON t.typnamespace = n.oid
WHERE t.typtype = 'd' AND n.nspname = 'public';

-- Drop domain name
select * from sample
drop domain positive_numeric cascade


-- Create a address composite data type
create type address as (
	city varchar(50),
	country varchar(20)
)

create table companies(
	comp_id serial primary key,
	address address
)

insert into companies (address) values (row('london','uk'));

select * from companies;

select (address).country from companies;

--when dealing with multiple tables use this
select (companies.address).city from companies;

-- Create composite invertory item
create type inventory_item as (
	prodcut_name varchar(200),
	supplier_id int,
	price numeric
)

create table inventory (
	inventory_id serial primary key,
	item inventory_item
);

select * from inventory;

insert into inventory (item) values(row('paper',20,10.99));

SELECT (item).prodcut_name
FROM inventory
WHERE (item).price > 3.99;

-- create currency enum
create type currency as enum ('usd', 'eur', 'gbp')

select 'usd' :: currency 

alter type currency add value 'chf' after 'eur'

create table stocks (
	stock_id serial primary key,
	stock_currency currency
)

insert into stocks(stock_currency) values ('chf');

select * from stocks

-- drop type name
create type sample_type as enum ('abc','123');

drop type sample_type;

-- Alter data types
create type myaddress as(
	city varchar(50),
	country varchar(20)
);

-- Renaming
alter type myaddress rename to my_address;

-- Change the owner
alter type my_address owner to postgres;

-- Change the schema
alter type my_address set schema test_scm;

-- Add a new attribute 
alter type test_scm.my_address add attribute street_address varchar(150);

-- Create a sample enum data type
create type mycolors as enum ('green','red','blue');

-- update a value
alter type mycolors rename value 'red' to 'orange';

-- list all enum values
select enum_range(null::mycolors);

-- add a new value
alter type mycolors add value 'pink' before 'green' 

-- update enum in prod server
create type status_enum as enum ('queued', 'waiting', 'running', 'done');

create table jobs(
	job_id serial primary key,
	job_status status_enum
);

insert into jobs(job_status) values ('done');

select * from jobs;

UPDATE jobs
SET job_status = 'running'
WHERE job_status = 'waiting';


-- Enum with default value

create type status as enum ('pending','approved','declined')

create table cron_jobs(
	cron_job_id int,
	status status default 'pending'
);

insert into cron_jobs (cron_job_id) values (3, 'approved');

select * from cron_jobs;

-- create type if not exists
do
$$
begin 
	if not exists ( select *
						from pg_type typ
							inner join pg_namespace nsp
								on nsp.oid = typ.typnamespace	
						where nsp.nspname = current schema()
							and typ.typname = 'ai') then
		create type ai
					as (a text,
						i integer);
	end if;
end;







