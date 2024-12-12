SELECT 
    Loans.BookID, 
    Loans.BorrowerID, 
    Books.Title
FROM 
    Loans
JOIN 
    Books 
ON 
    Loans.BookID = Books.BookID
WHERE 
    Loans.BorrowerID = 2;