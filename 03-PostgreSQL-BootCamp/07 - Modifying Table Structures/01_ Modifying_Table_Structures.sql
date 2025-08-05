-- Create Database
CREATE DATABASE mydata
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    TEMPLATE template0;

-- Create database
create table persons(
	person_id serial primary key,
	first_name varchar(20) not null,
	last_name varchar(20) not null
);

-- Adding column
alter table persons
add column age int not null;

select * from persons;

alter table persons
add column nationality varchar(20),
add column email varchar(100) unique;

-- Renaming Table
alter table users 
rename to persons;

-- Rename Column
alter table persons 
rename column age to person_age;


-- Drop a column
alter table persons 
drop column person_age;

alter table persons
add column age varchar(10);

-- Change column data type
alter table persons
alter column age type int
using age::integer;

alter table persons
alter column age type varchar(20);

-- set default values of column
alter table persons
add column is_enable varchar(1);

alter table persons
alter column is_enable set default 'Y';

insert into persons(first_name, last_name, nationality, age)
values ('Priyam', 'Vyas', 'India', '21');


create table web_links(
	link_id serial primary key,
	link_url varchar(255) not null,
	link_target varchar(20)
);

select * from web_links;

insert into web_links (link_url, link_target) 
values ('https://www.google.com','_blank');

-- Adding unique constraint
alter table web_links
add constraint unique_web_url unique (link_url);


-- set a column to accept only defined allowed values
alter table web_links
add column is_enable varchar(2);

insert into web_links (link_url, link_target, is_enable) values ('https://www.CITI.com', '_blank', 'q');

alter table web_links
add check (is_enable IN ('Y', 'N'));

update web_links
set is_enable = 'Y'
where link_id = 1
















 