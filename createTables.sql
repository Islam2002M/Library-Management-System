CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY, 
    Title NVARCHAR(255) NOT NULL,         
    Author NVARCHAR(255) NOT NULL,       
    ISBN NVARCHAR(13) UNIQUE NOT NULL,    
    PublishedDate DATE NOT NULL,          
    Genre NVARCHAR(100),                  
    ShelfLocation NVARCHAR(50),          
    CurrentStatus NVARCHAR(10) CHECK (CurrentStatus IN ('Available', 'Borrowed')) NOT NULL 
);
CREATE TABLE Borrowers (
    BorrowerID INT IDENTITY(1,1) PRIMARY KEY, 
    FirstName NVARCHAR(255) NOT NULL,        
    LastName NVARCHAR(255) NOT NULL,         
    Email NVARCHAR(255) UNIQUE NOT NULL,     
    DateOfBirth DATE NOT NULL,               
    MembershipDate DATE NOT NULL            
);
CREATE TABLE Loans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT NOT NULL,
    BorrowerID INT NOT NULL,
    DateBorrowed DATE NOT NULL,
    DueDate DATE NOT NULL,
    DateReturned DATE NULL,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (BorrowerID) REFERENCES Borrowers(BorrowerID)
);



