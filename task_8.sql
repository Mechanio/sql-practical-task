CREATE TABLE CustomersLog (
 log_id SERIAL PRIMARY KEY,
 column_name VARCHAR(50),
 old_value TEXT,
 new_value TEXT,
 changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 changed_by VARCHAR(50) -- This assumes you can track the user making the change
);

CREATE OR REPLACE FUNCTION fn_log_sensitive_data_changes()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS
$$
BEGIN
	IF NEW.first_name <> OLD.first_name THEN
		 INSERT INTO CustomersLog
		 (column_name, old_value, new_value, changed_by)
		 VALUES('first_name',OLD.first_name, NEW.first_name, current_user);
	END IF;

	IF NEW.last_name <> OLD.last_name THEN
		INSERT INTO CustomersLog
		(column_name, old_value, new_value, changed_by)
		VALUES('last_name',OLD.last_name, NEW.last_name, current_user);
	END IF;

	IF NEW.email <> OLD.email THEN
		INSERT INTO CustomersLog
		(column_name, old_value, new_value, changed_by)
		VALUES('email',OLD.email, NEW.email, current_user);
	END IF;
	
	RETURN NEW;
END;
$$;

CREATE TRIGGER tr_log_sensitive_data_changes
AFTER UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION fn_log_sensitive_data_changes();
