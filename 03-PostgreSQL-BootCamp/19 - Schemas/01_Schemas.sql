-- Schemas
-- create schema
create schema sales;
create schema hr;


-- Rename schema
Alter schema sales rename to programming;

-- Drop a schema
drop schema hr

select * from mydata.public.employees_test;

-- select a table from public schema
-- database.schema.object
select * from employees_test;

-- select table other than public schema
select * from mydata.humanresources.employees;

-- move table to a new schema
alter table humanresources.employees set schema public;

-- View current schema
select current_schema();

-- view current search path
show search_path;

-- Add new schema to search path
set search_path to humanresources, public;

set search_path to '$user', humanresources, public;

-- Change a schema ownership
alter schema humanresources owner to adam

-- Duplicate a schema with all data
-- Sample database
create database test_schema;
