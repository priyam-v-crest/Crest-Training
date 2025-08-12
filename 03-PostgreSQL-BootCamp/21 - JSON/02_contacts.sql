select 
*
from contacts_docs;

-- Get all records where first name is 'John'
select 
*
from contacts_docs
where body @> '{"first_name":"John"}'

-- Total Execution time of above query
explain analyze select 
	*
from contacts_docs
where body @> '{"first_name":"John"}'
-- Execution time : 9.4 ms

-- Create a GIN Index
create index idx_gin_contacts_docs_body on contacts_docs using gin(body);

-- Execution time after GIN index
explain analyze select 
	*
from contacts_docs
where body @> '{"first_name":"John"}'
-- Execution time : 1.125 ms

-- Faster index?
create index idx_gin_contacts_docs_body_cool on contacts_docs using gin(body jsonb_path_ops);

select pg_size_pretty(pg_relation_size('idx_gin_contacts_docs_body_cool'::regclass)) as index_name
-- 2512 kB

-- Creating index on specific JSON key
create index idx_gin_contacts_docs_body_fname on contacts_docs using gin((body->'first_name') jsonb_path_ops);

select pg_size_pretty(pg_relation_size('idx_gin_contacts_docs_body_fname'::regclass)) as index_name
-- 288 kB

