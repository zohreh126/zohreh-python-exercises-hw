CREATE TYPE u_role as enum('buyer','admin'); 
create table Users(
	user_id serial primary key,
	name text not null,
	Email varchar(255) UNIQUE,
	address text,
	phone_number int,
	creation_date date,
	UserRole u_role
);
select * from Users;


insert into Users(name,Email,address,phone_number,creation_date,UserRole)
values('Raheleh','Raheleh@gmail.com', 'Hakim street', 338, Date('1403-08-15'),'buyer');
select * from Users;


create table Publisher(
	publisher_id serial primary key,
	name varchar not null,
	address text,
	description text
);
select * from Publisher;

insert into Publisher(name,address,description)
values('Ava_e_farhang','Tehran','Choose any song and album you like');
select * from Publisher;


create table Album(
	album_id serial primary key,
	publisher_id int REFERENCES Publisher(publisher_id),
	title text,
	genre text,
	creation_date date,
	total_track integer,
	price integer
);
select * from Album;

INSERT INTO Album (publisher_id, title,genre,creation_date,total_track,price)
VALUES (1, 'ghalb','pop',Date('1403-08-13'), 3,78);
select * from Album;


create table Track(
	track_id serial primary key,
	name text not null,
	file_size float,
	price integer,
	format text,
	album_id int REFERENCES Album(album_id),
	artist_id int REFERENCES Artist(artist_id)
);
select * from Track;

insert into Track (name, file_size, price, format, album_id,artist_id)
VALUES ('ghalb_e_man',68.6 ,78, 'mp3',5,3);
select * from Track;


create table Orders(
	Order_id serial primary key,
	buyer_id int REFERENCES Users (user_ID),
	total_price integer,
	date date,
	quantity integer
);
select * from Orders;

INSERT INTO Orders (buyer_id,total_price,date,quantity)
VALUES (6, 73, Date('1403-08-20'), 1);
select * from Orders;



create table Artist(
	artist_id serial primary key,
	name text not null ,
	genre text
);
select * from Artist;

INSERT INTO Artist ( name,genre)
VALUES ('Emad','pop');
select * from Artist;


create table Track_Orders(
	Track_Order_id serial primary key,
	track_id int REFERENCES Track (track_id),
	order_id int REFERENCES Orders (order_id) 
);
select * from Track_Orders;

INSERT INTO Track_Orders (track_id, order_id)
VALUES (5,9);
select * from Track_Orders;

===================================================================
===================================================================

select album_id,total_track, price
FROM Album
ORDER BY price ASC;

===================================================================

SELECT track_id, COUNT(track_id) as total_sales 
FROM Track_Orders 
GROUP BY track_id 
HAVING COUNT(track_id) > (SELECT 0.6 * MAX(total_sales) 
FROM (SELECT track_id, COUNT(track_id) as total_sales FROM Track_Orders 
GROUP BY track_id) as subquery);

===================================================================

SELECT DISTINCT A.name
FROM Artist A
JOIN Track T ON A.artist_id = T.artist_id
JOIN Album Al ON T.album_id = Al.album_id
WHERE Al.genre = 'pop'
GROUP BY A.name
HAVING COUNT(T.track_id) >= 2;

===================================================================

SELECT name, max(date) as lastorderdate
FROM Users
JOIN Orders ON Users.user_id = Orders.buyer_id
GROUP BY name;

===================================================================

SELECT a.title
FROM Album a
JOIN Track t ON a.album_id = t.album_id
JOIN Track_Orders t_o ON t.track_id = t_o.track_id
GROUP BY a.title
HAVING COUNT(DISTINCT t_o.order_id) <= 1;

===================================================================
-- UPDATE Album
-- SET price = price * 0.5
-- WHERE album_id IN (
--     SELECT album_id
--     FROM (
--         SELECT album_id, SUM(price * quantity) as total_sales
--         FROM Track
--         INNER JOIN Track_Orders ON Track.track_id = Track_Orders.track_id
--         INNER JOIN Orders ON Track_Orders.order_id = Orders.order_id
--         GROUP BY album_id
--         HAVING SUM(price * quantity) < 0.002 * (
--             SELECT SUM(price * quantity) 
--             FROM Track 
--             INNER JOIN Track_Orders ON Track.track_id = Track_Orders.track_id
--             INNER JOIN Orders ON Track_Orders.order_id = Orders.order_id
--             WHERE Track.album_id = album_id
--         )
--     ) AS subquery
-- );

===================================================================
