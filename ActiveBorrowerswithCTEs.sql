WITH ActiveBorrowers AS (
    SELECT 
        Borrowers.BorrowerID, 
        Loans.BookID
    FROM 
        Borrowers
    JOIN 
        Loans 
    ON 
        Borrowers.BorrowerID = Loans.BorrowerID
    WHERE 
        Loans.DateReturned IS NULL
)
SELECT 
    BorrowerID, 
    COUNT(BookID) AS BorrowedBooksCount
FROM 
    ActiveBorrowers
GROUP BY 
    BorrowerID
HAVING 
    COUNT(BookID) >= 2;
