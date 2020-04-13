SET SERVEROUTPUT ON;
-- Member 4
-- Task 7
-- [X] Verify if card_id exists if exists
-- [X] If exists, gather discount ID and discount amount
-- [X] Compute cost of trip based on discount ID of card
-- [X] Create new Trip in Trips table
-- [X] Create new transaction in transaction table
-- [X] Deduct cost of trip from card balance.
-- [X] OPTIONAL: Not mentioned in the prompt, but check if sufficient funds exist on card
CREATE OR REPLACE PROCEDURE addtrip (
	-- accepts Card_ID, entrance_station_ID, exit_station_ID, entrance_time, and exit_time cardID IN NUMBER,
	cardid IN NUMBER,
  entranceid IN NUMBER,
	exitid IN NUMBER,
	entrancetime IN DATE,
	exittime IN DATE
) IS 
	tripID number(10,0);
  tripCost NUMBER(10,2);
  newBalance NUMBER(10,2);
	rec_card metro_card%rowtype;
  discount_rec discounts%rowtype;
  entrance_station_rec station%rowtype;
  exit_station_rec station%rowtype;
	invalid_card EXCEPTION;
  insufficient_funds EXCEPTION;
BEGIN
-- [X] STEP 1
  -- Check if card is valid 
  BEGIN
    SELECT * INTO rec_card FROM metro_card WHERE card_id = cardid;
    EXCEPTION WHEN NO_DATA_FOUND THEN RAISE invalid_card;
  END;
  
-- OPTIONAL - NOT MENTIONED ON PROMPT
  -- Check if sufficient funds exist on card
  IF (tripCost > rec_card.card_balance) THEN RAISE insufficient_funds; END IF;
  
-- [X] STEP 2
  -- Get discount ID and amount
  select * INTO discount_rec FROM discounts WHERE discount_id = rec_card.discount_type;
  
  -- Get station names
  select * INTO entrance_station_rec FROM station WHERE station_id = entranceid;
  select * INTO exit_station_rec FROM station WHERE station_id = exitid;
  
  -- Compute Trip Cost
  tripCost := discount_rec.regular_rate - discount_rec.discount_amt;

  -- Insert new trip into TRIPS table
  -- Generate trip ID
  tripId := trip_id_seq.nextval;
  
  INSERT INTO trips (trip_id, metro_card_used, entrance_station_id, exit_station_id, entrance_time, exit_time, trip_cost)
  VALUES (tripId, cardid, entranceid, exitid, entrancetime, exittime, tripcost);
  
  -- Print: generated trip ID (trips table), computed cost, entrance station naame, exit station name
    dbms_output.put_line('Trip ID: ' || tripId);
    dbms_output.put_line('Computed Cost: $' || tripCost);
    dbms_output.put_line('Entrance Station Name: ' || entrance_station_rec.station_name);
    dbms_output.put_line('Exit Station Name: ' || exit_station_rec.station_name);
    
-- [X] STEP 3
  -- Update card balance
  newBalance := rec_card.card_balance - tripCost;
  
  UPDATE metro_card
  SET card_balance = newBalance
  WHERE card_id = cardid;
  
EXCEPTION
  WHEN invalid_card THEN dbms_output.put_line ('Invalid Card');
  WHEN insufficient_funds THEN dbms_output.put_line ('Insufficient Funds');
  WHEN no_data_found THEN dbms_output.put_line ('no data found');
  WHEN too_many_rows THEN dbms_output.put_line ('Your SELECT statement retrieved multiple rows. Consider using a cursor.');
  WHEN dup_val_on_index THEN dbms_output.put_line ('Duplicate value on index.');
  WHEN OTHERS THEN dbms_output.put_line ('something went wrong here');
END;
/
EXECUTE addtrip(1, 1, 3, to_date('06/06/2019 06:57:25', 'DD/MM/YYYY HH:MI:SS AM'), to_date('06/06/2019 06:57:25', 'DD/MM/YYYY HH:MI:SS AM'));

