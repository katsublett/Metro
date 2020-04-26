--function to check if any of the stations is invalid. If invalid will print wrong station. 
CREATE 
OR 
replace FUNCTION check_station(stationname IN varchar)RETURN number IS temp number;BEGIN 
  SELECT Count(*) 
  INTO   temp 
  FROM   station 
  WHERE  station_name = stationname; 
   
  RETURN temp; 
END; 
--function to check if the line is invalid. If invalid print wrong line name.*****************************CREATE
OR 
replace FUNCTION check_line(linename IN varchar)RETURN number IS temp number;BEGIN 
  SELECT Count(*) 
  INTO   temp 
  FROM   transit_line 
  WHERE  line_name = linename; 
   
  RETURN temp; 
END; 
--function to check line station origin and destination. *************************************************CREATE
OR 
replace FUNCTION check_station_line(origen IN varchar, destination IN varchar)RETURN           varchar2 IS origen_line varchar(50);destination_line varchar(50);BEGIN
  SELECT line_name 
  INTO   origen_line 
  FROM   transit_line 
  WHERE  line_name = origen; 
   
  SELECT line_name 
  INTO   destination_line 
  FROM   transit_line 
  WHERE  line_name = destination; 
   
  IF origen_line = destination_line then 
  RETURN 'true'; 
  else 
  RETURN 'false'; 
ENDIF;END; 
--Procedure NEED A CURSOR ********************************************************************************SET serveroutput ON;
--INPUTS start, gap, origen, destination, lineCREATE 
OR 
replace PROCEDURE print_schedules_pasgr_can_take(start_time_param IN varchar, gap_param IN number, origin_station_param IN varchar2, destination_station_param IN varchar2, line_name_param IN varchar2) AS start_time varchar(50);gap                 number;origin_station      varchar(50);destination_station varchar2(50);line_name           varchar(50);CURSOR c1 IS         -- cursor select arrival_time into a variableSELECT arrival_time--arrival time to destination 
  FROM   schedule_station 
  WHERE  station_id = 
         ( 
                SELECT station_id 
                FROM   station 
                WHERE  station_name = destination) 
AND    schedule_id = 
       ( 
              SELECT schedule_id 
              FROM   schedule_station 
              JOIN   station 
              ON     station.station_id = schedule_station.station_id 
              WHERE  station_name = origin 
              AND    arrival_time = start_time);c1_rec c1%rowtype; -- elimanate duplicates in the schedule station table. Specify to sql to pick the first row... Modify select statement to return 1 row (at the end of the subquery Limit 1)***CURSOR c2 ISSELECT arrival_time--arrival time to destination with gap 
  FROM   schedule_station 
  WHERE  station_id = 
         ( 
                SELECT station_id 
                FROM   station 
                WHERE  station_name = destination) 
AND    schedule_id = 
       ( 
              SELECT schedule_id 
              FROM   schedule_station 
              JOIN   station 
              ON     station.station_id = schedule_station.station_id 
              WHERE  station_name = origin 
              AND    arrival_time = start_time + gap);c2_rec c2%rowtype;BEGIN 
  START_TIME:=start_time_param; 
  GAP:= gap_pram; 
  ORIGIN_STATION:= origin_station_param; 
  DESTINATION_STATION_PARAM:=destination_station_param; 
  LINE_NAME:= line_name_param; 
  IF Check_station_line(origen, destination) = false --Checking if origin and destination are in the same line 
  PRINT('origen and destionation not in the same line'); 
  EXIT; 
ENDIF; 
--check if the origin station name is validIF Check_station(origen) < 1 
PRINT('station' ||origen || 'does not exist');EXIT;ENDIF; 
--check if the destination station name is validIF Check_station(destination) < 1 
PRINT('destination' ||destination || 'does not exist');EXIT;ENDIF; 
--check if the line name is validIF Check_station(line) < 1 
PRINT('line' ||line || 'does not exist');EXIT;ENDIF; 
--OPEN c1;OPEN c2;FETCH c1 
INTO  c1_rec;FETCH c2 
INTO  c2_rec; 

--add some formattingdbms_output.put_line(schedule_id);dbms_output.put_line(start);       --earliest timedbms_output.put_line(start + gap); --last timedbms_output.put_line(c1_rec.arrival_time);dbms_output.put_line(c2_rec.arrival_time);CLOSE c1;CLOSE c2;EXCEPTION
WHEN no_data_found THEN 
  dbms_output.put_line('no data found');END;
