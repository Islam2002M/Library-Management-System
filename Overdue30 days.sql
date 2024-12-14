SELECT 
    B.Title,
    L.BorrowerID,
    L.DateBorrowed,
    L.DueDate,
	L.Datereturned
FROM 
    Loans L
JOIN 
    Books B ON L.BookID = B.BookID
WHERE 
    (L.DateReturned IS NULL AND DATEDIFF(DAY, L.DueDate, GETDATE()) > 30)
    OR (L.DateReturned IS NOT NULL AND DATEDIFF(DAY, L.DueDate, L.DateReturned) > 30)
