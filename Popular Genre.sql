WITH GenrePopularity AS (
    SELECT 
        b.Genre,
        COUNT(l.LoanID) AS BorrowingCount,
        RANK() OVER (ORDER BY COUNT(l.LoanID) DESC) AS GenreRank
    FROM 
        Books b
    JOIN 
        Loans l ON b.BookID = l.BookID
    WHERE 
        MONTH(l.DateBorrowed) = 1
    GROUP BY 
        b.Genre
)
SELECT 
    Genre,
    BorrowingCount
FROM 
    GenrePopularity
WHERE 
    GenreRank = 1; 