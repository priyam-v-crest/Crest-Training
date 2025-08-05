-- create a sequence
create sequence if not exists test_seq;

-- Advance sequence and return new value
select nextval('test_seq');

-- select most current value of sequence
select currval('test_seq');

-- set a sequence
select setval('test_seq', 100)

-- set a sequnce and do not skip over
select setval('test_seq', 200, false)

-- Control the sequence start value
create sequence if not exists test_seq2 start with 100

-- alter a sequence
select nextval('test_seq');

alter sequence test_seq restart with 100;

alter sequence test_seq rename to mysequence;

select nextval('mysequence');

-- create sequence with increment, min, max value, starts with.
create sequence if not exists test_seq3
increment 50
minvalue 400
maxvalue 6000
start with 500

select nextval('test_seq3');

-- specify data type --> default bigint
create sequence if not exists test_seq_smallint as smallint
create sequence if not exists test_seq_int as int
create sequence if not exists test_seq_default

select nextval('test_seq_int')

-- create a descending sequence and cycle
create sequence seq_asc
select nextval('seq_asc')

create sequence seq_dsc
increment -1
minvalue 1
maxvalue 3
start 3
cycle;

select nextval('seq_dsc');


-- Delete a sequence
drop sequence mysequence;

-- attaching sequence to a table
create table users(
	user_id serial primary key,
	user_name varchar(50)
)

insert into users (user_name) values ('Priyam')

select * from users;

alter sequence users_user_id_seq restart with 100

create table users2(
	user2_id int primary key,
	user2_name varchar(50)
);

create sequence users2_user2_id_seq
start with 100 owned by users2.user2_id;

alter table users2
alter column user2_id set default nextval('users2_user2_id_seq');

insert into users2 (user2_name) values ('Priyam');

select * from users2;

--  list all sequences in a database
select relname sequence_name
from pg_class
where 
relkind = 'S';

-- share one sequence between two tables
create sequence common_fruits_seq start with 100

create table apples (
	fruit_id int default nextval('common_fruits_seq') not null,
	fruit_name varchar(50)
);

create table mangoes (
	fruit_id int default nextval('common_fruits_seq') not null,
	fruit_name varchar(50)
);

insert into apples(fruit_name) values ('big apple');

select * from apples;
select * from mangoes;

-- create an alphanumeric sequence 

create table contacts (
	contact_id serial primary key,
	contact_name varchar(150)
);

insert into contacts (contact_name) values ('priyam');

select * from contacts;

drop table contacts;

create sequence table_seq;

create table contacts (
	contact_id text not null default ('ID' || nextval('table_seq')) ,
	contact_name varchar(150)
);

alter sequence table_seq owned by contacts.contact_id

insert into contacts (contact_name) values ('Priyam');

select * from contacts;




