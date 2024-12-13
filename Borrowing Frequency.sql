SELECT 
    borrowers.BorrowerID,
    COUNT(loans.LoanID) AS BorrowingFrequency,
    RANK() OVER (ORDER BY COUNT(loans.LoanID) DESC) AS RankByFrequency
FROM 
    Borrowers
JOIN 
    Loans ON borrowers.BorrowerID = loans.BorrowerID
GROUP BY 
    borrowers.BorrowerID

