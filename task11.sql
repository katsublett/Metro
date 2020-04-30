SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE findtransferstations (
  origin_station VARCHAR2,-- entrance station name
  destination_station VARCHAR2-- exit station name
) IS
  -- Declare variables
  origin_check NUMBER;
  origin_id NUMBER;
  origin_line NUMBER;
 
  destination_check NUMBER;
  destination_id NUMBER;
  destination_line NUMBER;
  
  transfer_line_one varchar2(50);
  transfer_line_two varchar2(50);
  
  transfer_direction_one NUMBER;
  transfer_direction_two NUMBER;
  
  -- Exception declarations
  wrong_station EXCEPTION;
  different_line EXCEPTION;
  
  -- LineCheck Cursor
  CURSOR lineCheck IS
    SELECT line_id, COUNT(*)
    FROM line_station 
    WHERE station_id = destination_id 
    GROUP BY line_id 
    HAVING COUNT(*) >= 1;
  
  -- record for lineCheck
  lc_rec lineCheck%rowtype;
  
  -- C1 Cursor
  CURSOR c1 IS 
    SELECT
    s.station_name,
    ls.station_id, COUNT(*) 
    FROM line_station ls
    JOIN station s on s.station_id = ls.station_id
    GROUP BY ls.station_id, s.station_name
    HAVING COUNT(*) > 1 ORDER BY ls.station_id DESC;
  
  -- record for c1
  c1_rec c1%rowtype;
  
  -- test variables
  testcount number;
  testrec line_station%rowtype;

  
BEGIN

  SELECT COUNT(*) INTO origin_check FROM station WHERE station_name = origin_station AND ROWNUM = 1;
  SELECT COUNT(*) INTO destination_check FROM station WHERE station_name = destination_station AND ROWNUM = 1;
  
  IF origin_check = 1 AND destination_check = 1 THEN 
    -- check if these stations are on different lines
    SELECT station_id INTO origin_id FROM station WHERE station_name = origin_station;
    SELECT station_id INTO destination_id FROM station WHERE station_name = destination_station;

    SELECT line_id, COUNT(*) INTO origin_line, testcount FROM line_station WHERE station_id = origin_id GROUP BY line_id HAVING COUNT(*) >= 1;
    
    OPEN lineCheck;
     LOOP
      FETCH lineCheck INTO lc_rec; 
      EXIT WHEN lineCheck%NOTFOUND;
       if (origin_line > lc_rec.line_id ) THEN destination_line := 1; 
       ELSIF (origin_line < lc_rec.line_id ) THEN destination_line := 2;
       end if;
      END LOOP;
      CLOSE lineCheck;

    IF (origin_line != destination_line) THEN
    
        dbms_output.put_line('__________________________________________________________');
        dbms_output.put_line('From ' || origin_station || ' to ' || destination_station);
        OPEN c1;
          LOOP
          FETCH c1 INTO c1_rec; EXIT WHEN c1%notfound;
            IF (origin_line = 1 OR destination_line = 1) 
              THEN 
                transfer_line_one := 'Green Line'; 
                transfer_line_two := 'Red Line'; 
              ELSE 
                transfer_line_one := 'Red Line'; 
                transfer_line_two := 'Green Line'; 
              END IF;
            --select direction into schedule_test from schedule where line_id = origin_line;
            -- line name and direction (1 or 2) from origin to transfer station
            
            If origin_id < c1_rec.station_id THEN
              transfer_direction_one := 1;
              transfer_direction_two := 2;
            ELSE
              transfer_direction_one := 2;
              transfer_direction_two := 1;
            END IF;
            --transfer station and on the same line, then direction = 1 else 2.
            dbms_output.put_line('  Option ' || c1%ROWCOUNT || ':');
            dbms_output.put_line('      1. Take the '|| transfer_line_one || ' in direction ' || transfer_direction_one || ' - Transfer at ' || c1_rec.station_name);
            dbms_output.put_line('      2. Then, take the ' || transfer_line_two  || ' in direction ' || transfer_direction_two);
            dbms_output.put_line('');
            dbms_output.put_line('');
            
            
             
          END LOOP;
        CLOSE c1;
    ELSE
      RAISE different_line;
    END IF;
    
  ELSE
    RAISE wrong_station;
  END IF;


EXCEPTION
  -- user-defined exceptions
  WHEN wrong_station THEN dbms_output.put_line('Wrong station name.');
  WHEN different_line THEN dbms_output.put_line('Those stations are not on different lines. - No transfer station needed.');
  
  
  -- default exceptions
  WHEN no_data_found THEN dbms_output.put_line ('no data found');
  WHEN access_into_null THEN dbms_output.put_line('Invalid Cursor');
  WHEN case_not_found THEN dbms_output.put_line('Invalid Cursor');
  WHEN collection_is_null THEN dbms_output.put_line('Invalid Cursor');

  WHEN dup_val_on_index THEN dbms_output.put_line('Duplicate value on index.');
  WHEN invalid_cursor THEN dbms_output.put_line('Invalid Cursor');
  WHEN invalid_number THEN dbms_output.put_line('Invalid Number');
    
  WHEN program_error THEN dbms_output.put_line('Program Error');
  WHEN rowtype_mismatch THEN dbms_output.put_line('Invalid Cursor');
  WHEN storage_error THEN dbms_output.put_line('Invalid Cursor');
    
  WHEN subscript_beyond_count THEN dbms_output.put_line('Invalid Cursor');
  WHEN subscript_outside_limit THEN dbms_output.put_line('Invalid Cursor');
    
  WHEN sys_invalid_rowid THEN dbms_output.put_line('Invalid Cursor');
  WHEN too_many_rows THEN dbms_output.put_line('Your SELECT statement retrieved multiple rows. Consider using a cursor.');
    
  WHEN value_error THEN dbms_output.put_line('Invalid Cursor');
  WHEN zero_divide THEN dbms_output.put_line('Invalid Cursor');
END;
/
EXECUTE findtransferstations('Greenbelt', 'Rockville');
