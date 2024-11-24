create table inventory (
	inventory_id serial primary key,
	name text not null,
	quantity int,
	price decimal(10,2),
	type varchar(50),
	extra_info text
	);
select * from inventory;