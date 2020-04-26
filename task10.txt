--function to check if any of the stations is invalid. If invalid will print wrong station. 
create or replace FUNCTION check_station(stationName in VARCHAR) RETURN NUMBER
IS
temp NUMBER;

BEGIN
SELECT COUNT(*) INTO temp 
FROM station 
WHERE station_name = stationName;

RETURN temp;
END;

--function to check if the line is invalid. If invalid print wrong line name.*****************************
create or replace FUNCTION check_line(lineName in VARCHAR) RETURN NUMBER
IS
temp NUMBER;

BEGIN
SELECT COUNT(*) INTO temp 
FROM transit_line 
WHERE line_name = lineName;

RETURN temp;
END;

--function to check line station origin and destination. *************************************************
create or replace FUNCTION check_station_line(origen IN VARCHAR, destination IN VARCHAR) RETURN VARCHAR2
IS
origen_line VARCHAR(50);  
destination_line VARCHAR(50);

BEGIN
SELECT line_name INTO origen_line 
FROM transit_line 
WHERE line_name = origen;

SELECT line_name INTO destination_line 
FROM transit_line 
WHERE line_name = destination;

IF origen_line = destination_line THEN
RETURN 'true';
else 
RETURN 'false';
END IF;
END;

--Procedure NEED A CURSOR ********************************************************************************
set serveroutput on;
--INPUTS start, gap, origen, destination, line
CREATE OR REPLACE PROCEDURE print_schedules_pasgr_can_take(start_time_param IN varchar, gap_param IN NUMBER,
  origin_station_param IN VARCHAR2, destination_station_param IN VARCHAR2, line_name_param IN VARCHAR2)

AS
start_time VARCHAR(50);
gap NUMBER;
origin_station VARCHAR(50);
destination_station VARCHAR2(50);
line_name VARCHAR(50);

CURSOR c1 IS-- cursor select arrival_time into a variable
SELECT arrival_time--arrival time to destination
FROM schedule_station
WHERE station_id = (SELECT station_id FROM station WHERE station_name = destination)
AND schedule_id = (SELECT schedule_id FROM schedule_station JOIN station ON station.station_id = schedule_station.station_id WHERE station_name = origin AND arrival_time = start_time);     
   c1_rec c1%rowtype; -- elimanate duplicates in the schedule station table. Specify to sql to pick the first row... Modify select statement to return 1 row (at the end of the subquery Limit 1)***

CURSOR c2 IS
SELECT arrival_time--arrival time to destination with gap
FROM schedule_station
WHERE station_id = (SELECT station_id FROM station WHERE station_name = destination)
AND schedule_id = (SELECT schedule_id FROM schedule_station JOIN station ON station.station_id = schedule_station.station_id WHERE station_name = origin AND arrival_time = start_time + gap);
    c2_rec c2%rowtype;

BEGIN
start_time:=start_time_param;
gap:= gap_pram;
origin_station:= origin_station_param;
destination_station_param:=destination_station_param;
line_name:= line_name_param;

IF check_station_line(origen, destination) = false --Checking if origin and destination are in the same line
print('origen and destionation not in the same line');
exit;
END IF;

--check if the origin station name is valid
IF check_station(origen) < 1
print('station' ||origen || 'does not exist');
exit;
END IF;

--check if the destination station name is valid
IF check_station(destination) < 1
print('destination' ||destination || 'does not exist');
exit;
END IF;

--check if the line name is valid
IF check_station(line) < 1
print('line' ||line || 'does not exist');
exit;
END IF;

--
OPEN c1;
OPEN c2;
FETCH c1 INTO c1_rec;
FETCH c2 INTO c2_rec;

--add some formatting
dbms_output.put_line(schedule_id); 
dbms_output.put_line(start);--earliest time
dbms_output.put_line(start + gap); --last time 
dbms_output.put_line(c1_rec.arrival_time);
dbms_output.put_line(c2_rec.arrival_time);

CLOSE c1;
CLOSE c2;

EXCEPTION
    WHEN no_data_found THEN dbms_output.put_line('no data found');

END;


--***






 

