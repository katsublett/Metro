set serveroutput on;
CREATE OR REPLACE FUNCTION task9 (
  originstation IN VARCHAR2,
  destinationstation IN VARCHAR2,
  lineid IN NUMBER
  )
  RETURN NUMBER 
IS 
  origin number;
  destination number;
  direction NUMBER;
BEGIN
  select station_id into origin from station where station_name = originstation;
  select station_id into destination from station where station_name = destinationstation;
  
  if (origin < destination) then
    direction :=1;
  else
    direction := 2;
  end if;
  
  return(direction);
END;
/

create or replace procedure main_p IS
    a number;
begin
    a := task9('Chinatown', 'Greenbelt', 1);
    dbms_output.put_line(a);
end;
/
execute main_p;
