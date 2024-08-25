SELECT
	b.book_id,
	b.title,
	g.genre_name,
	b.price,
	RANK() OVER (
		PARTITION BY 
			genre_name
		ORDER BY
			price DESC
	)
FROM 
	books b
INNER JOIN
	genres g ON b.genre_id=g.genre_id;
