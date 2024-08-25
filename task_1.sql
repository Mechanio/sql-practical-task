WITH AuthorBooksCount AS (
SELECT 
	author_id, 
	COUNT(*) AS book_count 
FROM 
	books 
GROUP BY 
	author_id
) 
SELECT
	abc.author_id,
	abc.book_count,
	a.name
FROM
	AuthorBooksCount abc
INNER JOIN
	authors a ON abc.author_id = a.author_id
WHERE
	abc.book_count > 3;
