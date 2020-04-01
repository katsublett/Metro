set serveroutput on;
CREATE OR REPLACE PROCEDURE displayschedulesforx (
  timeParam IN varchar,
  x IN NUMBER,
  stationNameParam IN VARCHAR2
)
IS
    rec_count NUMBER := 0;
    startTime varchar2(30);
    endTime interval day to second;

    CURSOR c1 IS
        SELECT 
            schedule_id, 
            line_id, 
            direction,
            arrival_time
        FROM station
            INNER JOIN schedule_station USING (station_id)
            INNER JOIN schedule USING (schedule_id)
        WHERE station_name = stationNameParam and arrival_time between starttime and endtime;
    
        c1_rec c1%rowtype;

    invalid_station EXCEPTION;
BEGIN
  starttime := ('0 ' || timeParam || ':00');
  starttime := to_dsinterval(TO_DSINTERVAL(starttime));
  endtime := to_dsinterval(starttime) + numtodsinterval(x, 'minute');

    -- check if station name is valid
    SELECT COUNT(*) INTO rec_count FROM station WHERE station_name = stationNameParam;
    IF rec_count > 0 THEN
            dbms_output.put_line('Timetable at ' || stationNameParam || ' Station ' || 'from ' || timeparam || ' to ' || extract(hour from endtime) || ':' || extract(minute from endtime) );
            dbms_output.put_line('Departures in the next ' || x || ' Minutes ');
            dbms_output.put_line('--------------------------------------------------');
            dbms_output.put_line('ID | ' || 'Line | ' || 'Direction | ' || '  Departure');
            dbms_output.put_line('--------------------------------------------------');
        OPEN c1;
            LOOP
            FETCH c1 INTO c1_rec;
            EXIT WHEN c1%notfound;
              dbms_output.put_line(c1_rec.schedule_id || '     '|| c1_rec.line_id || '         '|| c1_rec.direction || '           '|| extract(hour from c1_rec.arrival_time) || ':' || extract(minute from c1_rec.arrival_time) );
            END LOOP;
        CLOSE c1;
    ELSE  
      RAISE invalid_station;
    END IF;  
EXCEPTION
    WHEN no_data_found THEN dbms_output.put_line('no data found');
    WHEN invalid_station THEN dbms_output.put_line('Wrong Station Name');
    
    WHEN ACCESS_INTO_NULL THEN DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    WHEN CASE_NOT_FOUND THEN DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    WHEN COLLECTION_IS_NULL THEN DBMS_OUTPUT.PUT_LINE('Invalid Cursor');

    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('Duplicate value on index.');
    WHEN INVALID_CURSOR THEN DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    WHEN INVALID_NUMBER THEN DBMS_OUTPUT.PUT_LINE('Invalid Number');
    
    WHEN PROGRAM_ERROR THEN DBMS_OUTPUT.PUT_LINE('Program Error');
    WHEN ROWTYPE_MISMATCH THEN DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    WHEN STORAGE_ERROR THEN DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    
    WHEN SUBSCRIPT_BEYOND_COUNT THEN DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    WHEN SUBSCRIPT_OUTSIDE_LIMIT THEN DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    
    WHEN SYS_INVALID_ROWID THEN DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('Your SELECT statement retrieved multiple rows. Consider using a cursor.');
    
    WHEN VALUE_ERROR THEN DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    WHEN zero_divide THEN DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    
    WHEN OTHERS THEN dbms_output.put_line('something went wrong here');
END;
/
EXECUTE displayschedulesforx('07:30', 60, 'Greenbelt');
