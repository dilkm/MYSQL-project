Create database if not EXISTS OYO;
use OYO;
create table oyo_hotel
(
booking_id INT NOT NULL, 
customer_id INT,
status text,
check_in TEXT,
check_out TEXT,
no_of_rooms int,
hotel_id int,
amount float,
discount float,
date_of_booking text);
select * from oyo_hotel;
create table city_hotel
(
hotel_id int,
city varchar(255)
);
select * from city_hotel;

alter table city_hotel
add Foreign key (hotel_id) REFERENCES oyo_hotel (hotel_id);

/*number of hotels in city_hotel*/
select count(distinct(hotel_id)) from city_hotel;

/*number of city in city_hotel*/
select count(distinct(city)) from city_hotel;

/*Number of hotels by city*/
select count(hotel_id),city from city_hotel group by city; 

/* average room rate in city*/

/* insert column price */
alter table oyo_hotel add column price float; 
update oyo_hotel set price = amount + discount;

/* insert column newcheck_in */
alter table oyo_hotel add column newcheck_in date;
update oyo_hotel set newcheck_in = str_to_date(substr(check_in,1,10),'%d-%m-%Y');

/* insert column newcheck_out */
 alter table oyo_hotel add column newcheck_out date;
 update oyo_hotel set newcheck_out = str_to_date(substr(check_out,1,10),'%d-%m-%Y');

/* insert column no_of_nights */
alter table oyo_hotel add column no_of_nights int; 
update oyo_hotel set no_of_nights =datediff(newcheck_out,newcheck_in);

ALTER TABLE oyo_hotel DROP COLUMN no_of_nights;

/* insert column new_date_of_booking */
alter table oyo_hotel add column new_date_of_booking date;
update oyo_hotel set new_date_of_booking = str_to_date(substr(date_of_booking,1,10),'%d-%m-%Y');
select * from oyo_hotel;

/* insert column rate */
alter table oyo_hotel drop column rate;
alter table oyo_hotel add column rate float;
update oyo_hotel set rate = round(if(no_of_rooms=1, (price/no_of_nights),(price/no_of_nights)/no_of_rooms),2);

/* Average Room rate by BY BOOKING*/
select round(avg(rate),2) as avg_rate_by_city , city from oyo_hotel o, city_hotel c  where o.hotel_id = c.hotel_id group by city order by 1 desc;

/* Booking made in month of jan feb and march in different cities*/
select count(booking_id),city, month(new_date_of_booking) from oyo_hotel o , city_hotel c where month(new_date_of_booking) between 1 and 3 and o.hotel_id = c.hotel_id group by city,month(new_date_of_booking) order by city;

/* how many day prior booking was made*/
select count(*),datediff(newcheck_in,new_date_of_booking ) as date_diff from oyo_hotel group by 2 order by 2 asc;


