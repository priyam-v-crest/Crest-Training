-- Access schema via adam
Grant usage on schema private to adam;

-- give access rights to adam
grant select on all tables in schema private to adam;

-- 
grant create on schema private to adam;