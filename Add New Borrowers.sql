CREATE PROCEDURE sp_AddNewBorrower
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @DateOfBirth DATE,
    @MembershipDate DATE,
    @OutputMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Borrowers WHERE Email = @Email)
    BEGIN
        SELECT @OutputMessage = 'Email already exists.';
		PRINT 'Checking Email existence...';

    END
    ELSE
    BEGIN
        INSERT INTO Borrowers (FirstName, LastName, Email, DateOfBirth, MembershipDate)
        VALUES (@FirstName, @LastName, @Email, @DateOfBirth, @MembershipDate);
        SELECT @OutputMessage = 'New borrower added successfully.';
    END
END;

DECLARE @Message NVARCHAR(100);

EXEC sp_AddNewBorrower 
    @FirstName = 'Asma',
    @LastName = 'Ali',
    @Email = 'asma2@gmail.com',
    @DateOfBirth = '1999-06-15',
    @MembershipDate = '2024-12-01',
    @OutputMessage = @Message OUTPUT;

PRINT @Message;
