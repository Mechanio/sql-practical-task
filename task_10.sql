CREATE TABLE SalesArchive (
    sale_id SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    sale_date DATE NOT NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE PROCEDURE sp_archive_old_sales(
p_cutoff_date DATE
)
LANGUAGE plpgsql    
AS $$
DECLARE
	sales_cursor CURSOR FOR
	SELECT *
	FROM sales 
	WHERE sale_date < p_cutoff_date;
    sales_record RECORD;
BEGIN
	OPEN sales_cursor;
    LOOP
        FETCH NEXT FROM sales_cursor INTO sales_record;
        EXIT WHEN NOT FOUND;

        INSERT INTO SalesArchive (sale_id, book_id, customer_id, quantity, sale_date)
        VALUES (sales_record.sale_id, sales_record.book_id, sales_record.customer_id, sales_record.quantity, sales_record.sale_date);
		
		DELETE FROM Sales WHERE CURRENT OF sales_cursor;

    END LOOP;
    CLOSE sales_cursor;
end;
$$;

CALL sp_archive_old_sales('2023-01-01');
