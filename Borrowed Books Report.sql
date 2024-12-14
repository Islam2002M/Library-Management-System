CREATE PROCEDURE sp_BorrowedBooksReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        L.LoanID,
        B.Title,         
        L.BorrowerID,       
        L.dateborrowed,
        L.DateReturned
    FROM 
        Loans L
    JOIN 
        Books B ON L.BookID = B.BookID   
    WHERE 
        L.dateborrowed BETWEEN @StartDate AND @EndDate
    ORDER BY 
        L.dateborrowed;
END;
