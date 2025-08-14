-- create index on order date
create index idx_orders_order_date on orders(order_date);

create index idx_orders_ship_city on orders(ship_city);

-- create index on multiple fields 
create index idx_orders_customer_id_order_id on orders(customer_id, order_id);

-- create unique indexes
-- create index on products table
create unique index idx_u_products_product_id on products(product_id);

-- create index on employees table
create unique index idx_u_employees_employee_id on employees(employee_id);

-- On multiple columns
create unique index idx_u_orders_order_id_customer_id on orders(order_id,customer_id);

create unique index idx_u_employees_employee_id_hire_date on employees(employee_id,hire_date);

create table t1(
	id serial primary key,
	tag text
);

insert into t1(tag) values ('a'),('b')

create unique index idx_u_t1_tag on t1(tag);

-- List all indexes
select * from pg_indexes
where schemaname = 'public'
order by tablename, indexname

-- indexes of a table
select
	* 
from pg_indexes
where tablename = 'orders'

-- Size of table index
select
	pg_size_pretty(pg_indexes_size('suppliers'));

select count(*) from suppliers;

-- Create index on supplier -> region
create index idx_suppliers_region on suppliers(region)

create unique index idx_u_suppliers_supplier_id on suppliers(supplier_id)

-- list counts for all indexes
-- all stats
select
	* 
from pg_stat_all_indexes

-- for schema
select
* 
from pg_stat_all_indexes
where schemaname = 'public'
order by relname, indexrelname;

-- for table
select
* 
from pg_stat_all_indexes
where relname = 'orders'
order by relname, indexrelname;

-- Drop index
drop index idx_suppliers_region;

create index idx_orders_order_date_on on orders
using hash(order_date);

select * from orders order by order_date;

explain select * from orders where order_date = '2020-01-01';

-- See a Query plan
select * from suppliers;