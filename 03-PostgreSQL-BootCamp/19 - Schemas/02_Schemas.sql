-- create table
create table test_schema.public.songs(
	song_id serial primary key,
	song_title varchar(100) 
)

insert into test_schema.public.songs (song_title) values
('Counting Stars'), ('Rolling on');

select * from songs;

-- pg_dump -d test_schema -h localhost -U postgres -n public > dump.sql

-- Rename public to old_schema

-- import back dumped file
-- psql -h localhost -U postgres -d test_schema -f dump.sql