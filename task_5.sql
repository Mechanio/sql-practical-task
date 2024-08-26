CREATE PROCEDURE sp_update_customer_join_date()
LANGUAGE plpgsql    
AS $$
BEGIN
    UPDATE customers
    SET join_date = s.first_purchase_date
	FROM (
		SELECT 
			customer_id,
			MIN(sale_date) AS first_purchase_date
		FROM
			sales
		GROUP BY
			customer_id
	) AS s
    WHERE customers.customer_id = s.customer_id AND
	customers.join_date > s.first_purchase_date;
end;
$$;

CALL sp_update_customer_join_date();
