-- Member 3: Display of card information.
-- Task 5: Create a procedure to allow a passenger to list all cards related to an account, and print out card id and balance on each card. 
-- In case the account id is not valid, print out a message saying invalid account id.

-- Task 6: Create a procedure to allow a passenger to look up all transactions of a card in a given time
-- period. Input includes card id, start date and end date. In case the input card id is invalid, print a message
-- saying invalid card. Otherwise print out the transaction date and amount added for each transaction
-- during the period.
SET SERVEROUTPUT ON;

-- Task 5
CREATE OR REPLACE PROCEDURE listCards (
    accountnum IN NUMBER
)
IS
    CURSOR c1 IS
    SELECT card_id, card_balance FROM metro_card WHERE rider_account_id = accountnum;
    c1_rec c1%rowtype;
    
    invalid_id EXCEPTION;
BEGIN
    OPEN c1;
    LOOP
    FETCH c1 INTO c1_rec;
    EXIT WHEN c1%notfound;
        dbms_output.put_line('Metro Card ID: ' || c1_rec.card_id || ' Card Balance: $' || c1_rec.card_balance);
    END LOOP;
    IF c1%rowcount = 0 THEN RAISE invalid_id; END IF;
    CLOSE c1;
   
EXCEPTION    
    WHEN no_data_found THEN dbms_output.put_line('no data found');
    WHEN invalid_id THEN dbms_output.put_line('Invalid ID');
    WHEN OTHERS THEN dbms_output.put_line('error');
END; 
/
EXECUTE listcards(13);

-- Task 6
CREATE OR REPLACE PROCEDURE viewtransactions (
    cardid IN NUMBER,
    startdate IN TIMESTAMP,
    enddate IN TIMESTAMP
) 
IS
    CURSOR c1 IS
    SELECT transaction_id, metro_card_id, transaction_time, transaction_amt 
        FROM transactions 
            WHERE metro_card_id = cardid AND (transaction_time BETWEEN startdate AND enddate);
    c1_rec c1%rowtype;
    invalid_id EXCEPTION;
BEGIN
    OPEN c1;
    LOOP
    FETCH c1 INTO c1_rec;
    EXIT WHEN c1%notfound;
        dbms_output.put_line('Metro Card ID: ' || c1_rec.metro_card_id || ' Transaction ID: ' || c1_rec.transaction_id ||
                             '. Date: ' || c1_rec.transaction_time || '. Amount: $' || c1_rec.transaction_amt);
    END LOOP;
    IF c1%rowcount = 0 THEN RAISE invalid_id; END IF;
    CLOSE c1;
EXCEPTION
    WHEN no_data_found THEN dbms_output.put_line('no data found');
    WHEN invalid_id THEN dbms_output.put_line('Invalid ID');
    WHEN OTHERS THEN dbms_output.put_line('error');
END;
/
EXECUTE viewtransactions(1, '02-FEB-20 03.17.18.758000000 AM', '07-FEB-22 03.17.18.758000000 AM');