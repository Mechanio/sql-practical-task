CREATE OR REPLACE FUNCTION fn_adjust_book_price()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS
$$
DECLARE 
	total_quantity INTEGER;
BEGIN
	SELECT SUM(quantity) INTO total_quantity
	FROM sales 
	WHERE book_id = NEW.book_id;

	IF total_quantity >= 5 THEN
		 UPDATE books
		 SET price = price * 1.1
		 WHERE book_id = NEW.book_id;
	END IF;
	RETURN NEW;

END;
$$;

CREATE TRIGGER tr_adjust_book_price
AFTER INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION fn_adjust_book_price();
