{% exercise %}
In this exercise, we'll use a smart contract to represent a Library where you can lend and return books. Your first task is to understand the main components: `Lender`, `Book`, `Librarian` in the contract shown below.

An important thing that you might have noticed in the contract is the role of the Librarian, which is to register lenders. Also, notice how the `lenders` mapping is used to maintain the list of lenders that are allowed to take books from the library.

Now your task is to implement the missing functions: `returnBook` and `lendBook`. Make sure to use the `lenders` and `books` mappings correctly.
Hint: Make sure you revert all the state variables after a book is returned.

{% initial %}
pragma solidity >=0.4.22 <0.6.0;
contract Library {

    struct Lender {
        uint id;
        bool bookLent;
    }
    struct Book {
        bool lent;
        address lender;
    }

    address librarian;
    mapping(address => Lender) lenders;
    mapping(uint => Book) books;
    uint numRegisteredLenders;

    // Create a new library with $(numBooks) different books.
    constructor(uint8 numBooks) public {
        librarian = msg.sender;
        numRegisteredLenders = 0;
        for (uint bookId = 0; bookId < numBooks; bookId++) {
            books[bookId].lent = false;
        }
    }

    // Give $(lender) the right to lend books from this library.
    // May only be called by $(librarian).
    function registerLender(address lender) public {
        if (msg.sender != librarian || lenders[lender].bookLent) return;
        lenders[lender].bookLent = false;
        lenders[lender].id = numRegisteredLenders;
        numRegisteredLenders += 1;
    }

    function lendBook(uint bookId) public {
        Lender storage lender = lenders[msg.sender];
        // Write your code here
    }

    function checkAvailability(uint bookId) public returns (bool) {
        return !books[bookId].lent;
    }

    function returnBook(uint bookId) public {
        Lender storage lender = lenders[msg.sender];
        // Write your code here.
    }
}

{% solution %}
pragma solidity >=0.4.22 <0.6.0;
contract Library {

    struct Lender {
        uint id;
        bool bookLent;
    }
    struct Book {
        bool lent;
        address lender;
    }

    address librarian;
    mapping(address => Lender) lenders;
    mapping(uint => Book) books;
    uint numRegisteredLenders;

    // Create a new library with $(numBooks) different books.
    constructor(uint8 numBooks) public {
        librarian = msg.sender;
        numRegisteredLenders = 0;
        for (uint bookId = 0; bookId < numBooks; bookId++) {
            books[bookId].lent = false;
        }
    }

    // Give $(lender) the right to lend books from this library.
    // May only be called by $(librarian).
    function registerLender(address lender) public {
        if (msg.sender != librarian || lenders[lender].bookLent) return;
        lenders[lender].bookLent = false;
        lenders[lender].id = numRegisteredLenders;
        numRegisteredLenders += 1;
    }

    function lendBook(uint bookId) public {
        Lender storage lender = lenders[msg.sender];
        Book storage book = books[bookId];
        if (lender.bookLent || book.lent) return;
        lender.bookLent = true;
        book.lent = true;
        book.lender = msg.sender;
    }

    function checkAvailability(uint bookId) public returns (bool) {
        return !books[bookId].lent;
    }

    function returnBook(uint bookId) public {
        Lender storage lender = lenders[msg.sender];
        Book storage book = books[bookId];
        if (!book.lent) return;
        lender.bookLent = false;
        book.lent = false;
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Library.sol';

contract LibraryTest {

    Library libraryToTest;
    function beforeAll () public {
       libraryToTest = new Library(3);
    }

    function checkBookLending () public {
        libraryToTest.registerLender(address(this));
        libraryToTest.lendBook(1);
        Assert.equal(libraryToTest.checkAvailability(1), false, "book 1 should be unavailable");
        Assert.equal(libraryToTest.checkAvailability(2), true, "book 2 should be available");
    }

    function checkBookReturn () public {
        libraryToTest.registerLender(address(this));
        libraryToTest.lendBook(1);
        libraryToTest.returnBook(1);
        Assert.equal(libraryToTest.checkAvailability(2), true, "book 1 should be available after return");
    }
}

{% endexercise %}
