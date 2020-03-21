-- Drop Table Script
DROP TABLE rider CASCADE CONSTRAINTS;
DROP TABLE metro_card CASCADE CONSTRAINTS;
DROP TABLE discounts CASCADE CONSTRAINTS;
DROP TABLE transactions CASCADE CONSTRAINTS;
DROP TABLE station CASCADE CONSTRAINTS;
DROP TABLE trips CASCADE CONSTRAINTS;
DROP TABLE transit_line CASCADE CONSTRAINTS;
DROP TABLE line_station CASCADE CONSTRAINTS;
DROP TABLE schedule CASCADE CONSTRAINTS;
DROP TABLE schedule_station CASCADE CONSTRAINTS;

-- Create Table Script
create table rider (
    rider_account_id number(10), -- primary key
    rider_email varchar2(50),
    rider_password varchar2(50),
    rider_name varchar2(50),
    rider_age number(10),
    constraint rider_id_pk primary key (rider_account_id)
);
create table metro_card (
    card_id number(10), -- primary key
    card_balance number(10,2), -- accept 10 digit # with 2 decimal points
    discount_type number(10),
    rider_account_id number(10), -- foreign key
    constraint card_id_pk primary key (card_id),
    constraint rider_id_fk foreign key (rider_account_id) references rider(rider_account_id)
);
create table discounts (
    discount_id number(10), -- primary key
    regular_rate number(10,2),
    discount_amt number(10,2),
    constraint discount_id_pk primary key (discount_id)
);
create table transactions (
    transaction_id number(10), -- primary key
    metro_card_id number(10), -- foreign key
    transaction_time date,
    transaction_amt number(10,2), -- accept 10 digit # with 2 decimal points
    constraint transaction_id_pk primary key (transaction_id),
    constraint metro_card_id_fk foreign key (metro_card_id) references metro_card(card_id)
);
create table station (
    station_id number(10), -- primary key
    station_name varchar2(50),
    station_status number(10), -- should only accept 0 or 1
    station_address varchar2(50),
    station_city varchar2(50),
    station_state varchar2(50),
    station_zip number(10),
    constraint station_id_pk primary key (station_id)
);
create table trips (
    trip_id number(10), -- primary key -- ID needs to be system generated
    metro_card_used number(10), -- foreign key
    entrance_station_id number(10), -- foreign key
    exit_station_id number(10), -- foreign key
    entrance_time date, 
    exit_time date,
    trip_cost number(10,2), -- accept 10 digit # with 2 decimal points
    constraint trip_id_pk primary key (trip_id),
    constraint metro_card_used_fk foreign key (metro_card_used) references metro_card(card_id),
    constraint entrance_station_id_fk foreign key (entrance_station_id) references station(station_id),
    constraint exit_station_id_fk foreign key (exit_station_id) references station(station_id)
);
create table transit_line (
    line_id number(10), -- primary key
    line_name varchar2(50),
    stops_qty number(10),
    constraint line_id_pk primary key (line_id)
);
create table line_station ( -- which station is on which line
    seq_id number(10), 
    station_id number(10), -- foreign key
    line_id number(10), -- foreign key
    constraint station_id_fk foreign key (station_id) references station(station_id),
    constraint line_id_fk foreign key (line_id) references transit_line(line_id)
);
create table schedule (
    schedule_id number(10), -- primary key
    line_id number(10), -- foreign key
    direction number(10), 
    constraint schedule_id_pk primary key (schedule_id),
    constraint line_id_schedule_fk foreign key (line_id) references transit_line(line_id)
);
create table schedule_station (
    arrival_time interval day to second,
    schedule_id number(10), -- foreign key
    station_id number(10), -- foreign key
    constraint schedule_id_fk foreign key (schedule_id) references schedule(schedule_id),
    constraint station_id_schedule_station_fk foreign key (station_id) references station(station_id)
);

-- Drop Sequences Script
DROP SEQUENCE rider_id_seq;
DROP SEQUENCE card_id_seq;
DROP SEQUENCE trip_id_seq;
DROP SEQUENCE transaction_id_seq;
DROP SEQUENCE line_station_station_id;
DROP SEQUENCE line_station_line_id;

-- Create Sequences Script
CREATE SEQUENCE rider_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE card_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE trip_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE transaction_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE line_station_station_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE line_station_line_id START WITH 1 INCREMENT BY 1;

--------------------------------------------------------------
-- RIDER Data
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (1, 'edarrigrand0@indiatimes.com', 'McBNEHKx34d', 'Emalee Darrigrand', 13);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (2, 'ebrandom1@java.com', 'yI6kMQMTrCb', 'Enriqueta Brandom', 68);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (3, 'kpeyto2@abc.net.au', 'dHBhgh', 'Kathy Peyto', 63);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (4, 'mtremmil3@cdbaby.com', 'W1zIKvJC6V', 'Maryrose Tremmil', 59);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (5, 'eredmain4@bandcamp.com', 'HmYqoEQ0', 'Erminie Redmain', 52);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (6, 'lboone5@angelfire.com', 'TQE96bWY', 'Loralyn Boone', 18);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (7, 'hbynert6@icq.com', '99dT7fW', 'Hubert Bynert', 1);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (8, 'fskittrall7@discovery.com', '1m0XWW', 'Fallon Skittrall', 99);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (9, 'kbothbie8@wp.com', 'c1EdO39p', 'Kelly Bothbie', 17);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (10, 'pperrelli9@desdev.cn', 'vgS078', 'Phillie Perrelli', 75);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (11, 'cjamrowicza@house.gov', 'UYfbNGlX', 'Carlyn Jamrowicz', 88);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (12, 'ddeloozeb@elegantthemes.com', 'amZup0hmgQ', 'Delmar Delooze', 84);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (13, 'gbellenyc@edublogs.org', 'tKJR26dSo', 'Germaine Belleny', 44);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (14, 'gpielld@yolasite.com', 'BVnTzBKiQzlj', 'Gleda Piell', 75);
insert into rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) values (15, 'uhinriche@comcast.net', 'Nr3hw7aJ0', 'Ulrikaumeko Hinrich', 3);

-- METRO_CARD Data
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (1, 286.53, 1, 6);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (2, 385.5, 1, 7);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (3, 485.37, 1, 4);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (4, 83.35, 2, 8);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (5, 101.67, 2, 3);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (6, 274.0, 1, 15);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (7, 167.38, 2, 6);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (8, 118.15, 2, 7);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (9, 493.5, 3, 6);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (10, 58.86, 1, 12);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (11, 333.08, 2, 7);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (12, 128.79, 2, 8);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (13, 143.79, 2, 14);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (14, 355.58, 3, 15);
insert into metro_card (card_id, card_balance, discount_type, rider_account_id) values (15, 385.77, 3, 12);

-- DISCOUNTS Data
insert into discounts (discount_id, regular_rate, discount_amt) values (1, 7.50, 0);
insert into discounts (discount_id, regular_rate, discount_amt) values (2, 7.50, 2.50);
insert into discounts (discount_id, regular_rate, discount_amt) values (3, 7.50, 3.00);

-- TRANSACTIONS Data
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (1, 10, to_date('2019-05-08 20:59:52', 'YYYY-MM-DD HH24:MI:SS'), 13.17);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (2, 10, to_date('2019-03-25 06:09:15', 'YYYY-MM-DD HH24:MI:SS'), 23.74);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (3, 1, to_date('2019-06-28 23:54:16', 'YYYY-MM-DD HH24:MI:SS'), 123.72);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (4, 4, to_date('2020-02-01 12:43:27', 'YYYY-MM-DD HH24:MI:SS'), 42.09);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (5, 2, to_date('2019-12-01 20:09:02', 'YYYY-MM-DD HH24:MI:SS'), 122.75);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (6, 11, to_date('2019-12-29 23:08:37', 'YYYY-MM-DD HH24:MI:SS'), 126.47);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (7, 7, to_date('2019-05-29 22:34:02', 'YYYY-MM-DD HH24:MI:SS'), 132.2);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (8, 14, to_date('2019-03-03 12:50:37', 'YYYY-MM-DD HH24:MI:SS'), 65.53);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (9, 9, to_date('2019-08-29 14:33:31', 'YYYY-MM-DD HH24:MI:SS'), 126.31);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (10, 6, to_date('2019-07-31 11:01:05', 'YYYY-MM-DD HH24:MI:SS'), 60.6);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (11, 9, to_date('2019-07-29 16:04:39', 'YYYY-MM-DD HH24:MI:SS'), 9.65);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (12, 9, to_date('2019-12-12 06:13:29', 'YYYY-MM-DD HH24:MI:SS'), 140.75);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (13, 10, to_date('2019-09-08 22:29:28', 'YYYY-MM-DD HH24:MI:SS'), 116.79);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (14, 1, to_date('2019-06-22 23:12:00', 'YYYY-MM-DD HH24:MI:SS'), 149.53);
insert into transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) values (15, 5, to_date('2019-04-12 10:21:32', 'YYYY-MM-DD HH24:MI:SS'), 147.11);

-- STATION Data
insert into station (station_id, station_name, station_address, station_city, station_state, station_zip, station_status) values (1, 'Washington', '6 Sage Lane', 'Frederick', 'DC', '20530', 0);
insert into station (station_id, station_name, station_address, station_city, station_state, station_zip, station_status) values (2, 'Silver Spring', '3 Jackson Hill', 'Washington', 'MD', '20918', 0);
insert into station (station_id, station_name, station_address, station_city, station_state, station_zip, station_status) values (3, 'Baltimore', '3 Carioca Pass', 'Bethesda', 'MD', '21211', 1);
insert into station (station_id, station_name, station_address, station_city, station_state, station_zip, station_status) values (4, 'Laurel', '79855 Little Fleur Pass', 'Washington', 'MD', '20709', 1);
insert into station (station_id, station_name, station_address, station_city, station_state, station_zip, station_status) values (5, 'Bethesda', '3 Sachtjen Plaza', 'Washington', 'MD', '20816', 0);
insert into station (station_id, station_name, station_address, station_city, station_state, station_zip, station_status) values (6, 'Gaithersburg', '94637 Alpine Court', 'Washington', 'MD', '20883', 0);

-- TRIPS Data
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (1, 14, 2, 5, to_date('2019-06-06 06:57:25', 'YYYY-MM-DD HH24:MI:SS'), to_date('2020-01-24 15:39:17','YYYY-MM-DD HH24:MI:SS'), 60.82);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (2, 5, 3, 3, to_date('2019-03-01 01:57:48', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-10-02 06:38:21','YYYY-MM-DD HH24:MI:SS'), 10.34);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (3, 4, 5, 2, to_date('2019-06-28 02:01:40', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-12-02 19:42:15','YYYY-MM-DD HH24:MI:SS'), 94.17);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (4, 12, 5, 1, to_date('2019-12-10 03:20:20', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-06-28 19:20:11','YYYY-MM-DD HH24:MI:SS'), 64.39);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (5, 1, 5, 5, to_date('2019-09-17 23:23:21', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-03-12 19:54:38','YYYY-MM-DD HH24:MI:SS'), 46.32);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (6, 14, 1, 3, to_date('2019-11-15 10:08:03', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-11-24 12:40:23','YYYY-MM-DD HH24:MI:SS'), 65.95);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (7, 15, 4, 3, to_date('2019-04-02 14:01:40', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-06-29 09:23:38','YYYY-MM-DD HH24:MI:SS'), 30.85);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (8, 10, 6, 5, to_date('2019-07-20 08:39:01', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-03-23 15:17:06','YYYY-MM-DD HH24:MI:SS'), 44.23);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (9, 15, 3, 4, to_date('2020-02-09 01:12:09', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-03-29 22:21:22','YYYY-MM-DD HH24:MI:SS'), 39.29);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (10, 2, 2, 6, to_date('2019-09-18 05:55:03', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-09-02 04:18:01','YYYY-MM-DD HH24:MI:SS'), 48.4);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (11, 7, 2, 3, to_date('2019-11-08 10:04:10', 'YYYY-MM-DD HH24:MI:SS'), to_date('2020-01-22 19:02:30','YYYY-MM-DD HH24:MI:SS'), 32.01);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (12, 9, 2, 2, to_date('2020-01-01 18:00:24', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-07-27 00:33:29','YYYY-MM-DD HH24:MI:SS'), 57.59);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (13, 8, 4, 6, to_date('2019-08-22 01:13:12', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-02-14 12:53:46','YYYY-MM-DD HH24:MI:SS'), 59.51);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (14, 3, 5, 3, to_date('2019-08-14 15:40:22', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-08-30 20:24:48','YYYY-MM-DD HH24:MI:SS'), 94.72);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (15, 1, 2, 2, to_date('2019-02-27 14:18:10', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-10-12 00:41:07','YYYY-MM-DD HH24:MI:SS'), 6.03);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (16, 1, 1, 6, to_date('2019-03-31 09:03:09', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-12-05 12:50:39','YYYY-MM-DD HH24:MI:SS'), 50.22);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (17, 13, 5, 3, to_date('2019-11-20 11:15:53', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-05-18 16:33:48','YYYY-MM-DD HH24:MI:SS'), 67.57);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (18, 6, 3, 6, to_date('2019-05-17 00:08:08', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-04-07 04:19:29','YYYY-MM-DD HH24:MI:SS'), 22.39);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (19, 4, 5, 6, to_date('2019-06-13 11:08:38', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-05-17 15:38:36','YYYY-MM-DD HH24:MI:SS'), 72.38);
insert into trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost) values (20, 8, 1, 6, to_date('2019-12-25 08:40:23', 'YYYY-MM-DD HH24:MI:SS'), to_date('2019-05-10 17:57:44','YYYY-MM-DD HH24:MI:SS'), 16.54);

-- TRANSIT_LINE Data
insert into transit_line (line_id, line_name, stops_qty) values (1, 'Purple', 2);
insert into transit_line (line_id, line_name, stops_qty) values (2, 'Crimson', 6);
insert into transit_line (line_id, line_name, stops_qty) values (3, 'Orange', 3);

-- LINE_STATION Data
insert into line_station (seq_id, station_id, line_id) values (1, 6, 2);
insert into line_station (seq_id, station_id, line_id) values (2, 1, 3);
insert into line_station (seq_id, station_id, line_id) values (3, 4, 2);
insert into line_station (seq_id, station_id, line_id) values (4, 1, 2);
insert into line_station (seq_id, station_id, line_id) values (5, 5, 1);
insert into line_station (seq_id, station_id, line_id) values (6, 3, 1);

-- SCHEDULE Data
insert into schedule (schedule_id, line_id, direction) values (1, 3, 4);
insert into schedule (schedule_id, line_id, direction) values (2, 1, 5);
insert into schedule (schedule_id, line_id, direction) values (3, 2, 4);
insert into schedule (schedule_id, line_id, direction) values (4, 2, 6);
insert into schedule (schedule_id, line_id, direction) values (5, 1, 3);
insert into schedule (schedule_id, line_id, direction) values (6, 2, 5);
insert into schedule (schedule_id, line_id, direction) values (7, 1, 5);
insert into schedule (schedule_id, line_id, direction) values (8, 2, 5);
insert into schedule (schedule_id, line_id, direction) values (9, 1, 1);
insert into schedule (schedule_id, line_id, direction) values (10, 3, 2);
insert into schedule (schedule_id, line_id, direction) values (11, 1, 3);
insert into schedule (schedule_id, line_id, direction) values (12, 2, 2);
insert into schedule (schedule_id, line_id, direction) values (13, 2, 5);
insert into schedule (schedule_id, line_id, direction) values (14, 3, 5);
insert into schedule (schedule_id, line_id, direction) values (15, 3, 5);

-- SCHEDULE_STATION Data
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 20:07:24' DAY TO SECOND, 4, 1);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 02:48:12' DAY TO SECOND, 12, 2);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 08:01:06' DAY TO SECOND, 14, 5);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 17:07:28' DAY TO SECOND, 4, 6);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 06:41:29' DAY TO SECOND, 6, 2);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 04:02:30' DAY TO SECOND, 5, 3);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 03:19:18' DAY TO SECOND, 9, 2);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 11:45:58' DAY TO SECOND, 14, 5);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 13:55:15' DAY TO SECOND, 8, 3);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 15:29:44' DAY TO SECOND, 4, 2);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 20:37:13' DAY TO SECOND, 3, 5);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 1:54:10' DAY TO SECOND, 15, 2);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 07:49:24' DAY TO SECOND, 2, 3);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 21:18:22' DAY TO SECOND, 14, 1);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 19:56:31' DAY TO SECOND, 9, 4);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 23:47:03' DAY TO SECOND, 3, 1);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 00:10:41' DAY TO SECOND, 2, 1);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 19:52:50' DAY TO SECOND, 7, 6);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 0:24:18' DAY TO SECOND, 5, 3);
insert into schedule_station (arrival_time, schedule_id, station_id) values (INTERVAL '0 2:03:49' DAY TO SECOND, 12, 1);