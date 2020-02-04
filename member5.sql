-- Task 8: Create a procedure that given a time (just hours and minutes) and station name, list all schedules
-- departing that station within X minutes after the given time. Here X is an input. 

-- The procedure first checks whether the input station name matches any existing station. If not it prints an error message saying wrong station name. 
-- Otherwise it prints out schedule ID, line name, direction (1 or 2), scheduled arrival time at the station.

-- Hint: use interval day to second for input time and X.
CREATE OR REPLACE PROCEDURE displayschedulesforx (
    --timeHrMin IN interval day(2) to second(0),-- INTERVAL DAY [(day_precision)] TO SECOND [(fractional_seconds_precision)]
    --X IN interval day(2) to second(0),
    stationname IN VARCHAR2
)
IS
    rec_count NUMBER := 0;

    CURSOR c1 IS
        SELECT 
            schedule_id, 
            line_id, 
            direction,
            arrival_time
        FROM station
            INNER JOIN schedule_station USING (station_id)
            INNER JOIN schedule USING (schedule_id)
        WHERE station_name = 'Greenspring';
    
        c1_rec c1%rowtype;

    invalid_station EXCEPTION;
BEGIN
    -- check if station name is valid
    SELECT COUNT(*) INTO rec_count FROM station WHERE station_name = stationname;
    IF rec_count > 0 THEN
            dbms_output.put_line('Timetable at ' || stationname || ' Station.');
            dbms_output.put_line('--------------------------------------------------');
            dbms_output.put_line('ID | ' || 'Line | ' || 'Direction | ' || '  Arrival at Next Station');
            dbms_output.put_line('--------------------------------------------------');
        OPEN c1;
            LOOP
            FETCH c1 INTO c1_rec;
            EXIT WHEN c1%notfound;
                dbms_output.put_line(c1_rec.schedule_id || '     '|| c1_rec.line_id || '         '|| c1_rec.direction || '           '|| c1_rec.arrival_time);
            END LOOP;
        CLOSE c1;

    ELSE  
      RAISE invalid_station;
    END IF;  
EXCEPTION
    WHEN no_data_found THEN dbms_output.put_line('no data found');
    WHEN invalid_station THEN dbms_output.put_line('Wrong Station Name');
    WHEN OTHERS THEN dbms_output.put_line('error');
END;
/
EXECUTE displayschedulesforx('Greenspring');