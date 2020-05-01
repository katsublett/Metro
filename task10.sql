--•	Input 
	--> start time (interval day to second type), 
	--> time gap (interval data type), 
	--> name of the origin, 
	--> name destination station,
	--> line name (assuming origin and destination stations are on the same line)

--•	If any of the station name is invalid, the procedure prints out a message saying wrong station. 

--•	If the line name is invalid, print a message saying wrong line name.

--•	If all names are valid, the procedure finds schedules on that line that is in the right direction (from the origin station to the destination station). You can use Task 9 to check.

--•	The procedure also makes sure the arrival time at the origin station is between the start time and start time plus the gap. E.g., if start time is 7:30 am and gap is one hour, the schedule arrival time at origin station should be 7:30 to 8:30. 

--•	Finally, the procedure prints out the schedule ID and scheduled arrival time at origin and destination station for each schedule.

set serveroutput on;
--INPUTS start, gap, origin, destination, line
CREATE OR REPLACE PROCEDURE print_schedules_pasgr_can_take (
   start_time_param IN INTERVAL DAY TO SECOND, 
   gap_param NUMBER, 
   origin_station_param IN VARCHAR2, 
   destination_station_param IN VARCHAR2,
   line_name_param IN VARCHAR2
)
IS
   start_time INTERVAL DAY(2) TO SECOND(6);
   gap NUMBER;
   origin_station VARCHAR2(50);
   destination_station VARCHAR2(50);
   line_name VARCHAR2(50);
   schedule_id NUMBER(10,0);
   endtime INTERVAL DAY(2) TO SECOND(6);

   CURSOR c1 IS-- cursor to select arrival_time into a variable
	SELECT 
	   arrival_time, 
	   station_id--arrival time to destination
	FROM schedule_station
	WHERE station_id = (SELECT station_id FROM station WHERE station_name = destination_station)
	AND schedule_id = (SELECT schedule_id FROM schedule_station JOIN station 
	ON station.station_id = schedule_station.station_id 
	WHERE station_name = origin_station 
	AND arrival_time = start_time);     
        
	c1_rec c1%rowtype;

   CURSOR c2 IS
	SELECT 
	   arrival_time--arrival time to destination with gap
	FROM schedule_station
	WHERE station_id = (SELECT station_id FROM station WHERE station_name = destination_station)
	AND schedule_id = (SELECT schedule_id FROM schedule_station JOIN station 
	ON station.station_id = schedule_station.station_id 
	WHERE station_name = origin_station 
	AND arrival_time = endtime);
    	
	c2_rec c2%rowtype;

BEGIN
   start_time:= start_time_param;
   gap:= gap_param;
   origin_station:= origin_station_param;
   destination_station:= destination_station_param;
   dbms_output.put_line(start_time + gap);
   endtime := to_dsinterval(start_time) + numtodsinterval(gap, 'minute');

	--Checking if origin and destination are in the same line
	IF check_station_line(origin_station, destination_station) = 0 THEN
	dbms_output.put_line('origen and destionation not in the same line');
	END IF;

	--check if the origin station name is valid
	IF check_station(origin_station) < 1 THEN
	dbms_output.put_line('station' ||origin_station || 'does not exist');
	END IF;

	--check if the destination station name is valid
	IF check_station(destination_station) < 1 THEN
	dbms_output.put_line('destination' ||destination_station || 'does not exist');
	END IF;

	--check if the line name is valid
	IF check_station(line_name) < 1 THEN
	dbms_output.put_line('line station' ||line_name || 'does not exist');
	END IF;

	   OPEN c1;
	   OPEN c2;
	   FETCH c1 INTO c1_rec;
	   FETCH c2 INTO c2_rec;

		dbms_output.put_line(schedule_id); 
		dbms_output.put_line(start_time);--earliest time
		dbms_output.put_line(start_time + gap); --last time 
		dbms_output.put_line(c1_rec.arrival_time);
		dbms_output.put_line(c2_rec.arrival_time);

	   CLOSE c1;
	   CLOSE c2;

EXCEPTION
    WHEN no_data_found THEN dbms_output.put_line('no data found');

END;
/


--**********FUNCTIONS***************************

--function to check if any of the stations is invalid. If invalid will print wrong station.
CREATE OR REPLACE FUNCTION check_station (
   stationName in VARCHAR
   ) 
   RETURN NUMBER
IS
   temp NUMBER;

BEGIN
   SELECT COUNT(*) INTO temp 
   FROM station 
   WHERE station_name = stationName;

      RETURN temp;
END;

--function to check if the line is invalid. If invalid print wrong line name.
CREATE OR REPLACE FUNCTION check_line (
   lineName in VARCHAR
   )
   RETURN NUMBER
IS
   temp NUMBER;

BEGIN
   SELECT COUNT(*) INTO temp 
   FROM transit_line 
   WHERE line_name = lineName;

      RETURN temp;
END;

--function to check line station origin and destination. *************************************************
CREATE OR REPLACE FUNCTION check_station_line (
   origen IN VARCHAR, 
   destination IN VARCHAR
   ) 
   RETURN VARCHAR2
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
/