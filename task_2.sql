WITH TheIdentification AS (
	SELECT 
		*
	FROM 
		books 
	WHERE
		title ~* '(^|\W)the(\W|$)'
) 
SELECT
	t.title,
	g.genre_name,
	a.name AS author_name,
	t.published_date
FROM
	TheIdentification t
JOIN
	genres g ON t.genre_id = g.genre_id
JOIN
	authors a ON t.author_id = a.author_id;
