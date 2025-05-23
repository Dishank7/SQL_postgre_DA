select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from return_status;
select * from members;
--Task 1. Create a New Book Record 
-- "(978-1-60129-456-2', 'To Kill a Mockingbird', 
--'Classic', 6.00, 'yes', 'Harper Lee',
--'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

--Update an Existing Member's Address
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

--Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status
WHERE issued_id =   'IS121';

--Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';

--List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1;

--Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
CREATE TABLE book_issued_cnt AS 
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY  b.isbn, b.book_title;

--Retrieve All Books in a Specific Category
SELECT * FROM books
WHERE category = 'Classic';

-- Find Total Rental Income by Category
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1;

--list Members Who Registered in the Last 180 Days

select * from members
where reg_date >= '2024-04-01';
--also we can write rega_date >= current_date - interval '180 days'

insert into members(member_id,member_name,member_address,reg_date)
values 
('C117','Reo','145 Main st','2024-06-01'),
('C129','Isagi','133 Main st','2024-05-01');

--List Employees with Their Branch Manager's Name and their branch details
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id;

--Create a Table of Books with Rental Price Above a Certain Threshold
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;

--Retrieve the List of Books Not Yet Returned
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
