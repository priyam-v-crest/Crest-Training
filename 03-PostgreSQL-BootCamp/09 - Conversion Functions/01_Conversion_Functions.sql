-- Using to_char
-- convert integer to string
select 
	to_char(
		100870,
		'9,99999'
	);
-- Movie release in DD-MM-YYYY format
select 
	release_date,
	to_char(release_date, 'DD-MM-YYYY'),
	to_char(release_date, 'Dy, MM, YYYY')
from movies;

-- Timestamp literal to string 
select
	to_char(
		timestamp '2020-01-01 10:30:45',
		'HH24:MI:SS'
	);

-- Adding dolla sign to revenue
select
	movie_id,
	revenues_domestic,
	to_char(revenues_domestic,'$99999D99')
from movies_revenue;


-- Using to_number
-- Convert string to number
select to_number(
		'1420.89',
		'9999.'
	);

select to_number(
		'10,625.89-',
		'99G999D99S'
	);

-- formatting
select to_number(
		'$1420.89',
		'L9G999'
	);
	
select to_number(
		'1,234,567.89',
		'9G999g99999'
	);
select to_number(
		'1,234,567.89',
		'9G999g999D99'
	);
select to_number(
		'$1,234,567.89',
		'L9G999g999.99'
	);


-- Using to_date
-- String to date

select to_date(
	'2020/10/22',
	'YYYY/MM/DD'
);

select to_date(
	'022199',
	'MMDDYY'
);

select to_date(
	'March 07, 2019',
	'Month DD, YYYY'
);
-- error handling 
select to_date(
	'2020/02/25',
	'YYYY/MM/DD'
);

-- to_timestamp
select to_timestamp(
	'2020/02/25 10:30:17',
	'YYYY/MM/DD HH:MI:SS	'
);

-- it skips spaces
select to_timestamp(
	'2004	May','YYYY MON'
	);

-- minimal error checking
select to_timestamp(
	'2020-02-25 32:30:17',
	'YYYY-MM-DD HH24:MI:SS'
);




















