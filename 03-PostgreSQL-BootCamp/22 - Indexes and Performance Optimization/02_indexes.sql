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

insert into t1(tag) values ('a'),('b');

create unique index idx_u_t1_tag on t1(tag);

-- List all indexes
select * from pg_indexes
where schemaname = 'public'
order by tablename, indexname

-- indexes of a table
select
	* 
from pg_indexes
where tablename = 'orders';

-- Size of table index
select
	pg_size_pretty(pg_indexes_size('suppliers'));

select count(*) from suppliers;

-- Create index on supplier -> region
create index idx_suppliers_region on suppliers(region);

create unique index idx_u_suppliers_supplier_id on suppliers(supplier_id);

-- list counts for all indexes
-- all stats
select
	* 
from pg_stat_all_indexes;

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

explain select * from suppliers where supplier_id = 1;

explain select company_name from suppliers
where supplier_id = 1
order by company_name;

-- explain output options
explain (Format JSON) select * from orders where order_id = 1;

explain select * from orders where order_id = 1

-- using explain analyze
explain select * from orders where order_id = 1 order by order_id;

select count(*) from orders;

explain analyze select * from orders where order_id = 1 order by order_id;

-- Understanding Query Cost model
create table t_big(id serial, name text);

insert into t_big (name)
select 'Adam' from generate_series(1, 2000000);

insert into t_big (name)
select 'Linda' from generate_series(1, 2000000);

explain select * from t_big where id = 12345

show max_parallel_workers_per_gather
set max_parallel_workers_per_gather to 0;

select pg_relation_size('t_big') / 8192.0;

show seq_page_cost;

show cpu_tuple_cost;

show cpu_operator_cost;

select 21622*1 + 4000000*0.01 + 4000000*0.0025;

set max_parallel_workers_per_gather to 2;

-- Indexes are not free
select
	pg_size_pretty(pg_indexes_size('t_big'));

select
	pg_size_pretty(
		pg_total_relation_size('t_big')
	);

explain analyze select * from t_big where id = 123456;

create index idx_t_big_id on t_big(id)

-- insert
paraller index creation -> btree index
show max_parallel_maintenance_workers

-- Indexes for sorted output
explain select * from t_big
order by id
limit 20;

explain select * from t_big
order by name
limit 20;

explain select
	min(id),
	max(id)
from t_big

-- Using multiple indexes on a single query
explain select * from t_big
where 
	id = 20
	or id = 40

-- Execution plans depend on input value
create index idx_t_big_name on t_big(name);

explain select * from t_big where name = 'Priyam'
limit 10;

explain select * from t_big
where
	name = 'Priyam'
	or name = 'Linda'

explain select * from t_big
where
	name = 'Priyam2'
	or name = 'Linda2' 

-- Using organized vs random data
select * from t_big order by id limit 10;

explain (analyze true, buffers true, timing true)
select * from t_big where id < 10000;

create table t_big_random as select * from t_big order by random();

create index idx_t_big_random_id on t_big_random(id);

select * from t_big_random limit 10;

vacuum analyze t_big_random;

explain (analyze true, buffers true, timing true)
select * from t_big_random where id<10000

select 
	tablename,
	attname,
	correlation
from pg_stats
where
	tablename in ('t_big','t_big_random')
order by 1,2

-- Try using index only scan
explain analyze select * from t_big where id = 123456;

explain analyze select id from t_big where id = 123456;

-- Partial indexes
select pg_size_pretty(pg_indexes_size('t_big'));

drop index idx_t_big_name;

create index idx_p_t_big_name on t_big(name)
where name not in ('Adam','Linda');

select * from customers;

ALTER TABLE customers
ADD COLUMN is_active CHAR(1);

update customers
set is_active = 'N'
where customer_id in ('ALFKI','ANATR')

explain analyze select * from customers
where
is_active = 'N'

create index idx_p_customers_is_active on customers(is_active)
where is_active = 'N'

select count(*) from customers;

-- Expression Indexes
create table t_dates as 
select d, repeat(md5(d::text),10) as padding 
	from generate_series(timestamp '1800-01-01',
						timestamp '2100-01-01',
						interval '1 day') s(d);
vacuum analyze t_dates;

select count(*) from t_dates;

explain select * from t_dates where d between '2001-01-01' and '2001-01-31';

create index idx_t_dates_d on t_dates(d);

explain analyze select * from t_dates where d between '2001-01-01' and '2001-01-31';

analyze t_dates;

explain analyze select * from t_dates where extract(day from d) = 1;

create index idx_expr_t_dates on t_dates(extract (day from d));

-- adding data while indexing
create index concurrently idx_t_big_name2 on t_big(name);

select oid, relname, relpages, reltuples,
	i.indisunique, i.indisclustered, i.indisvalid,
	pg_catalog.pg_get_indexdef(i.indexrelid,0,true)
	from pg_class c join pg_index i on c.oid = i.indrelid
	where c.relname = 't_big';

-- Invalidating an index
-- view all indexes for a table
select oid, relname, relpages, reltuples,
	i.indisunique, i.indisclustered, i.indisvalid,
	pg_catalog.pg_get_indexdef(i.indexrelid,0,true)
	from pg_class c join pg_index i on c.oid = i.indrelid
	where c.relname = 'orders';

-- See what the query optimizer uses
select * from orders;

explain select * from orders where ship_country = 'USA'

-- new index on orders > ship_country
create index idx_orders_ship_country on orders(ship_country);

explain select * from orders where ship_country = 'USA';

-- disallow query optimizer to use our index
update pg_index
set indisvalid = false
where indexrelid = (select oid from pg_class
					where relkind = 'i'
					and relname= 'idx_orders_ship_country');

-- Reset the value
update pg_index
set indisvalid = true
where indexrelid = (select oid from pg_class
					where relkind = 'i'
					and relname= 'idx_orders_ship_country');

-- rebuilding an index
reindex (verbose) index idx_orders_customer_id_order_id;

reindex (verbose) table orders;

reindex (verbose) schema public;

reindex (verbose) database northwind;

reindex (verbose) table concurrently orders;