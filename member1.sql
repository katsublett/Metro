--IS 420 – Project: Individual deliverable
--Group #4. -----Members: Karina Lopez, Mahnoor Tariq, Katherine Sublett, Shlock Mehta, Maaz Amin-----
-- Member 1: Karina Lopez: Task 1 and Task 2 
/*Task 1: allow a passenger to create a rider account with input including email address, name, password, and age. First check whether email exists. If so, print a message that the account exists. Otherwise, create a new rider account with new account id and age and print out the new account id.*/

/*Function to check if email exists */
create or replace FUNCTION return_email (rider_email_param VARCHAR) return number
IS
  temp NUMBER;
BEGIN
  SELECT COUNT(*) INTO temp 
  FROM rider
  WHERE rider_email = rider_email_param;

  return temp;
END;

/*Procedure to create a new rider account or letting the user to know that her/his account exists based on the existence of their email in the database. */

create or replace PROCEDURE new_rider_account (
  rider_email_param IN VARCHAR2,
  rider_password_param IN VARCHAR2,
  rider_name_param IN VARCHAR2,
  rider_age_param IN NUMBER
)
IS
  rider_email VARCHAR2(50);
  rider_account_id NUMBER;
  rider_password VARCHAR2(50);
  rider_name VARCHAR2(50);
  rider_age INTEGER;

BEGIN
  rider_email := return_email(rider_email_param);

  IF rider_email = 0 then
    INSERT INTO rider (rider_account_id, rider_email, rider_password, rider_name, rider_age) VALUES (rider_id_seq.nextval, rider_email_param, rider_password_param, rider_name_param, rider_age_param); /*FIX RIDER_ACCOUNT */
    dbms_output.put_line('Account Created');
  ELSE
   dbms_output.put_line('Your account already exists with the email: ' || rider_email_param  || ' Try to log in.');
  END IF;

EXCEPTION
  WHEN no_data_found THEN dbms_output.put_line('no data found');
END;

--To run the program: we need to use actual values in order to try it out. The values in it are examples.
EXECUTE new_rider_account('rider1@aol.com', 'mi874G', 'Eliana Nown', 54);


/* Task 2: login to an account with email address and password. If both matches an existing account, print a message login is successful.  If email does not match, print a message no such account. If email matches but password does not match, print wrong password.*/

/* Check username(email): function to check whether the email matches an existing account  */

create or replace FUNCTION check_username (rider_email_param VARCHAR) return NUMBER
IS
  temp NUMBER;
BEGIN
  SELECT COUNT(*) INTO temp
  FROM rider
  WHERE rider_email = rider_email_param;

  return temp;
END;
/* Check Function: function to check whether email and password matches an existing account */

create or replace FUNCTION check_password (rider_password_param VARCHAR, rider_email_param VARCHAR) return number
IS
  temp NUMBER;
BEGIN
  SELECT COUNT(*) INTO temp
  FROM rider
  WHERE rider_password = rider_password_param AND rider_email = rider_email_param;

  return temp;
END;

/* Login Procedure */

create or replace PROCEDURE login (rider_email_param IN VARCHAR, rider_password_param IN VARCHAR)
AS
  Username VARCHAR(50);
  Pass VARCHAR(50);

BEGIN
  Username := rider_email_param; --this corresponds to email address
  Pass := rider_password_param;

  IF check_username(Username) > 0 AND check_password(Pass, Username) > 0 THEN
    dbms_output.put_line('login is successful');
  ELSIF check_username(Username) > 0 AND check_password(Pass, Username) = 0 THEN
    dbms_output.put_line('Wrong Password');
  ELSIF check_username(Username) = 0 THEN
    dbms_output.put_line('No such account');
  END IF;

EXCEPTION
  WHEN no_data_found THEN dbms_output.put_line('no data found');

END;

EXEC LOGIN('test1@umbc.com', 'IS420');--to execute use actual values. i.e EXEC LOGIN(‘test’,’pass’) 

