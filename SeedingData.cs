using Bogus;
using System;
using System.Collections.Generic;
using System.IO;

class SeedingData
{
    static void Main(string[] args)
    {
        var bookFaker = new Faker<Book>()
            .RuleFor(b => b.Title, f => f.Lorem.Sentence(3))
            .RuleFor(b => b.Author, f => f.Name.FullName())
            .RuleFor(b => b.ISBN, f => $"978{f.Random.Number(100000000, 999999999)}")
            .RuleFor(b => b.PublishedDate, f => f.Date.Past(20))
            .RuleFor(b => b.Genre, f => f.PickRandom(new[] { "Adventure", "Fantasy", "Mystery", "Thriller", "Romance" }))
            .RuleFor(b => b.ShelfLocation, f => f.Random.AlphaNumeric(5))
            .RuleFor(b => b.CurrentStatus, f => f.PickRandom(new[] { "Available", "Borrowed" }));

        var borrowerFaker = new Faker<Borrower>()
            .RuleFor(b => b.FirstName, f => f.Name.FirstName())
            .RuleFor(b => b.LastName, f => f.Name.LastName())
            .RuleFor(b => b.Email, f => f.Internet.Email())
            .RuleFor(b => b.DateOfBirth, f => f.Date.Past(40, DateTime.Now.AddYears(-18)))
            .RuleFor(b => b.MembershipDate, f => f.Date.Past(5));

        var loanFaker = new Faker<Loan>()
            .RuleFor(l => l.BookID, f => f.Random.Int(1, 1000))  
            .RuleFor(l => l.BorrowerID, f => f.Random.Int(1, 1000)) 
            .RuleFor(l => l.DateBorrowed, f => f.Date.Past(2))
            .RuleFor(l => l.DueDate, (f, l) => l.DateBorrowed.AddDays(14))
            .RuleFor(l => l.DateReturned, (f, l) => f.Random.Bool() ? l.DateBorrowed.AddDays(f.Random.Int(1, 30)) : (DateTime?)null);

        var books = bookFaker.Generate(1000);
        var borrowers = borrowerFaker.Generate(1000);
        var loans = loanFaker.Generate(1000);

        WriteToSqlFile(books, borrowers, loans);
    }

    public class Book
    {
        public string Title { get; set; }
        public string Author { get; set; }
        public string ISBN { get; set; }
        public DateTime PublishedDate { get; set; }
        public string Genre { get; set; }
        public string ShelfLocation { get; set; }
        public string CurrentStatus { get; set; }
    }

    public class Borrower
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public DateTime DateOfBirth { get; set; }
        public DateTime MembershipDate { get; set; }
    }

    public class Loan
    {
        public int BookID { get; set; }
        public int BorrowerID { get; set; }
        public DateTime DateBorrowed { get; set; }
        public DateTime DueDate { get; set; }
        public DateTime? DateReturned { get; set; }
    }

    static void WriteToSqlFile(List<Book> books, List<Borrower> borrowers, List<Loan> loans)
    {
        using (StreamWriter sw = new StreamWriter("data_seed.sql"))
        {
            sw.WriteLine("INSERT INTO Books (Title, Author, ISBN, PublishedDate, Genre, ShelfLocation, CurrentStatus) VALUES");
            foreach (var book in books)
            {
                sw.WriteLine($"('{EscapeSqlString(book.Title)}', '{EscapeSqlString(book.Author)}', '{book.ISBN}', '{book.PublishedDate:yyyy-MM-dd}', '{EscapeSqlString(book.Genre)}', '{EscapeSqlString(book.ShelfLocation)}', '{book.CurrentStatus}'),");
            }

            sw.WriteLine("INSERT INTO Borrowers (FirstName, LastName, Email, DateOfBirth, MembershipDate) VALUES");
            foreach (var borrower in borrowers)
            {
                sw.WriteLine($"('{EscapeSqlString(borrower.FirstName)}', '{EscapeSqlString(borrower.LastName)}', '{EscapeSqlString(borrower.Email)}', '{borrower.DateOfBirth:yyyy-MM-dd}', '{borrower.MembershipDate:yyyy-MM-dd}'),");
            }

            sw.WriteLine("INSERT INTO Loans (BookID, BorrowerID, DateBorrowed, DueDate, DateReturned) VALUES");
            foreach (var loan in loans)
            {
                sw.WriteLine($"({loan.BookID}, {loan.BorrowerID}, '{loan.DateBorrowed:yyyy-MM-dd}', '{loan.DueDate:yyyy-MM-dd}', {(loan.DateReturned.HasValue ? $"'{loan.DateReturned:yyyy-MM-dd}'" : "NULL")}),");
            }
        }
        Console.WriteLine("SQL file 'data_seed.sql' has been generated.");
    }

    static string EscapeSqlString(string str) => str.Replace("'", "''");
}
