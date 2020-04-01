SET SERVEROUTPUT ON;
-- Member 2: Tasks for metro card.
-- Task 3: Create a procedure to allow a passenger to buy a metro card and add it to an existing account. Input includes account id, initial balance (payment).

-- The procedure first checks if the input account id exists. If not, print out a message saying that the account does not exist.
-- Otherwise the procedure inserts a new row to metro card table with given account id, balance and a new card id (using sequence).

-- In addition, please look up age of the account holder. 
-- If holder's age <= 12, set discount id to 2 (child). 
-- If holder's age >= 65, set discount id to 3 (senior). 
-- Otherwise the discount rate should be 1 (regular).
CREATE OR REPLACE PROCEDURE purchasemetrocard (
  -- accepts ID and initial $ to load onto card
  accountid IN NUMBER,
  initialbalance IN NUMBER
)
IS
    discount NUMBER := 1; -- do i need to set it to 1? or can i just not set it at all?
    rec_count NUMBER := 0;
    rec_rider rider%rowtype;
    invalid_user EXCEPTION;
    
BEGIN
  SELECT * INTO rec_rider FROM rider WHERE rider_account_id = accountid;  

  -- check if account exists in RIDER table
  SELECT COUNT(*) INTO rec_count FROM rider WHERE rider_account_id = accountid;
  
  IF rec_count > 0 THEN
    -- add discount based on age    
    discount :=
      CASE WHEN rec_rider.rider_age <= 12 THEN 2
           WHEN rec_rider.rider_age >= 65 THEN 3
           ELSE 1
           END;
    
    INSERT INTO metro_card (card_id, card_balance, discount_type, rider_account_id) VALUES (card_id_seq.nextval, initialbalance, discount, accountid);
    
    dbms_output.put_line('Card Created!');
  ELSE 
    RAISE invalid_user;
  END IF;
  
EXCEPTION
  WHEN no_data_found THEN dbms_output.put_line('no data found');
  WHEN invalid_user THEN dbms_output.put_line('Account for that ID does not exist');
 WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('Your SELECT statement retrieved multiple rows. Consider using a cursor.');
 WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('Duplicate value on index.');
  WHEN OTHERS THEN dbms_output.put_line('something went wrong here');
END;
/
EXECUTE purchasemetrocard(7, 1350);
  -- DROP SEQUENCE card_id_seq; 
  -- CREATE SEQUENCE card_id_seq START WITH 16 INCREMENT BY 1;

-- Task 4: Allow a passenger to add money to an existing card, with input card id and amount.
  -- The procedure first checks if there is a metro card with given card id. If not, print a message saying no such card. 
  -- Otherwise, add input amount to balance of the card and 
  -- insert a row to metro card transaction table with time as current time. 
  -- Finally print out new balance.

CREATE OR REPLACE PROCEDURE addMoneyToCard (
  -- accepts ID and initial $ to load onto card
  cardID IN NUMBER,
  addAmount IN NUMBER
)
IS
    rec_count NUMBER := 0;
    rec_card metro_card%rowtype;
    invalid_card EXCEPTION;
    
BEGIN
  SELECT * INTO rec_card FROM metro_card WHERE card_ID = cardID;  

  -- check if account exists in RIDER table
  SELECT COUNT(*) INTO rec_count FROM metro_card WHERE card_ID = cardID;
  
  IF rec_count > 0 THEN
    -- add amount to card total
    UPDATE metro_card SET card_balance = (addAmount + rec_card.card_balance) WHERE card_id = cardid;

    -- Add new row to TRANSACTIONS table
    INSERT INTO transactions (transaction_id, metro_card_id, transaction_time, transaction_amt) VALUES (TRANSACTION_ID_SEQ.nextval, cardID, SYSDATE, addAmount);
    
    -- print new card balance
    dbms_output.put_line('Card with ID ' || rec_card.card_id || ' was topped up.');
    dbms_output.put_line('Old Card Balance = ' || rec_card.card_balance);
    dbms_output.put_line('New Amount = ' || addAmount);
    dbms_output.put_line('New Card Balance = ' || (addAmount + rec_card.card_balance));
  ELSE 
    RAISE invalid_card;
  END IF;
  
EXCEPTION
  WHEN no_data_found THEN dbms_output.put_line('no data found');
  WHEN invalid_card THEN dbms_output.put_line('Account for that ID does not exist');
  WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('Your SELECT statement retrieved multiple rows. Consider using a cursor.');
  WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('Duplicate value on index.');
  WHEN OTHERS THEN dbms_output.put_line('something went wrong here');
END;
/
-- card ID and amount
EXECUTE addMoneyToCard(1, 1350.22);
