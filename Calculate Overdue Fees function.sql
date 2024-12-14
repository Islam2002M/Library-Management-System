CREATE FUNCTION fn_CalculateOverdueFees (@LoanID INT)
RETURNS INT
AS
BEGIN
    DECLARE @OverdueDays INT , @Fee INT;
    DECLARE @DueDate DATE, @DateReturned DATE;

    SELECT 
        @DueDate = DueDate,
        @DateReturned = DateReturned
    FROM Loans
    WHERE LoanID = @LoanID;

    IF @DateReturned IS NULL
        SET @OverdueDays = DATEDIFF(DAY, @DueDate, GETDATE());
    ELSE
        SET @OverdueDays = DATEDIFF(DAY, @DueDate, @DateReturned);

    IF @OverdueDays <= 0
        RETURN 0;
    ELSE IF @OverdueDays <= 30
        RETURN @OverdueDays;

    RETURN 30 + (@OverdueDays - 30) * 2;
END;
