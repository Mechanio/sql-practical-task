CREATE PROCEDURE sp_bulk_update_book_prices_by_genre(
	p_genre_id INTEGER,
	p_percentage_change NUMERIC(5, 2)
)
LANGUAGE plpgsql    
AS $$
DECLARE 
	updated_rows_count INTEGER;
BEGIN
    UPDATE books
    SET price = price * (1 + p_percentage_change / 100)
    WHERE genre_id = p_genre_id;
	GET DIAGNOSTICS updated_rows_count = ROW_COUNT;
	RAISE NOTICE 'Number of books updated: %', updated_rows_count;
end;
$$;


CALL sp_bulk_update_book_prices_by_genre(3, 5.00);
