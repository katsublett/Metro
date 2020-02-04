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
  rider_account_id number(10),
  rider_email varchar2(50),
  rider_password varchar2(50),
  rider_name varchar2(50),
  rider_age number(10),
  constraint rider_id_pk primary key (rider_account_id)
);
create table metro_card (
  card_id number(10),
  card_balance number(10, 2),
  discount_type number(10),
  rider_account_id number(10),
  constraint card_id_pk primary key (card_id),
  constraint rider_id_fk foreign key (rider_account_id) references rider(rider_account_id)
);
create table discounts (
  discount_id number(10),
  regular_rate number(10, 2),
  discount_amt number(10, 2),
  constraint discount_id_pk primary key (discount_id)
);
create table transactions (
  transaction_id number(10),
  metro_card_id number(10),
  transaction_time timestamp,
  transaction_amt number(10, 2),
  constraint transaction_id_pk primary key (transaction_id),
  constraint metro_card_id_fk foreign key (metro_card_id) references metro_card(card_id)
);
create table station (
  station_id number(10),
  station_name varchar2(50),
  station_address varchar2(50),
  station_status number(10),
  constraint station_id_pk primary key (station_id)
);
create table trips (
  trip_id number(10),
  metro_card_used number(10),
  entrance_station_id number(10),
  exit_station_id number(10),
  entrance_time timestamp,
  exit_time timestamp,
  trip_cost number(10, 2),
  constraint trip_id_pk primary key (trip_id),
  constraint metro_card_used_fk foreign key (metro_card_used) references metro_card(card_id),
  constraint entrance_station_id_fk foreign key (entrance_station_id) references station(station_id),
  constraint exit_station_id_fk foreign key (exit_station_id) references station(station_id)
);
create table transit_line (
  line_id number(10),
  line_name varchar2(50),
  stops_qty number(10),
  constraint line_id_pk primary key (line_id)
);
create table line_station (
  seq_id number(10),
  station_id number(10),
  line_id number(10),
  constraint station_id_fk foreign key (station_id) references station(station_id),
  constraint line_id_fk foreign key (line_id) references transit_line(line_id)
);
create table schedule (
  schedule_id number(10),
  line_id number(10),
  direction number(10),
  constraint schedule_id_pk primary key (schedule_id),
  constraint line_id_schedule_fk foreign key (line_id) references transit_line(line_id)
);
create table schedule_station (
  arrival_time interval day to second,
  schedule_id number(10),
  station_id number(10),
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