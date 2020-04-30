CREATE OR REPLACE PROCEDURE metricsreport IS
  -- Declare variables
  totalaccounts NUMBER;
  totalcards NUMBER;
  totalspending NUMBER;
  avgtrips NUMBER;
  topentrance NUMBER;
  topexit NUMBER;

BEGIN
    -- total # of accounts
    SELECT COUNT(DISTINCT rider_account_id) INTO totalaccounts FROM rider;
    dbms_output.put_line('Total # of Accounts: ' || totalaccounts);
    
    -- total # of cards
    SELECT COUNT(DISTINCT card_id) INTO totalcards FROM metro_card;
    dbms_output.put_line('Total # of Cards: ' || totalcards);

    -- total spending
    SELECT SUM(trip_cost) INTO totalspending FROM trips;
    dbms_output.put_line('Total Spending: $' || totalspending);

    -- average trips per person
    SELECT avg(DISTINCT metro_card_used) INTO avgtrips FROM trips; 
    dbms_output.put_line('Average Trips: ' || avgtrips);
    
    -- top entrance station
    SELECT STATS_MODE(entrance_station_id) INTO topentrance FROM trips;
    dbms_output.put_line('Top Entrance Station: ' || topentrance);
    
    -- top exit station
    SELECT STATS_MODE(exit_station_id) INTO topexit FROM trips;
    dbms_output.put_line('Top Exit Station: ' || topexit);

EXCEPTION
  -- default exceptions
  WHEN no_data_found THEN dbms_output.put_line ('no data found');
  WHEN too_many_rows THEN dbms_output.put_line ('Your SELECT statement retrieved multiple rows. Consider using a cursor.');
  WHEN dup_val_on_index THEN dbms_output.put_line ('Duplicate value on index.');
  WHEN OTHERS THEN dbms_output.put_line ('something went wrong here');
END;
/


EXECUTE metricsreport;
