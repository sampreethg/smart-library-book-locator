-- =============================================================================
-- SIET Smart Library Book Locator - Database Script
-- Script Type: Production-Grade SQL Script (DDL, DML, DQL, DCL, TCL)
-- Dialect: MySQL / MariaDB compatible
-- =============================================================================

-- =============================================================================
-- 1. DATA DEFINITION LANGUAGE (DDL)
-- Responsible for defining and modifying database structure/schemas.
-- Commands covered: DROP, CREATE, ALTER, TRUNCATE
-- =============================================================================

-- [DDL] Initialize Database
CREATE DATABASE IF NOT EXISTS smart_library;
USE smart_library;

-- [DDL] DROP: Remove tables in reverse dependency order to avoid foreign key errors
DROP TABLE IF EXISTS book_issues;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS shelf_locations;
DROP TABLE IF EXISTS librarians;
DROP TABLE IF EXISTS students;

-- [DDL] CREATE: Create STUDENTS table to store student accounts
CREATE TABLE students (
    student_id VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    department VARCHAR(50) NOT NULL,
    year_of_study VARCHAR(20) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_students PRIMARY KEY (student_id),
    CONSTRAINT uk_student_email UNIQUE (email)
);

-- [DDL] CREATE: Create LIBRARIANS table to store library administrative staff
CREATE TABLE librarians (
    staff_id VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_librarians PRIMARY KEY (staff_id),
    CONSTRAINT uk_librarian_email UNIQUE (email)
);

-- [DDL] CREATE: Create SHELF_LOCATIONS table to normalize physical grid coordinates
CREATE TABLE shelf_locations (
    location_id INT AUTO_INCREMENT,
    rack VARCHAR(50) NOT NULL,
    column_name VARCHAR(50) NOT NULL,
    row_name VARCHAR(50) NOT NULL,
    pos VARCHAR(50) NOT NULL,
    CONSTRAINT pk_shelf_locations PRIMARY KEY (location_id),
    CONSTRAINT uk_shelf_coordinates UNIQUE (rack, column_name, row_name, pos)
);

-- [DDL] CREATE: Create BOOKS table containing catalog details and location references
CREATE TABLE books (
    book_id INT AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    available TINYINT(1) DEFAULT 1 CHECK (available IN (0, 1)),
    location_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_books PRIMARY KEY (book_id),
    CONSTRAINT fk_books_location FOREIGN KEY (location_id) 
        REFERENCES shelf_locations (location_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- [DDL] CREATE: Create BOOK_ISSUES table to log borrow/loan transactions
CREATE TABLE book_issues (
    issue_id INT AUTO_INCREMENT,
    book_id INT NOT NULL,
    student_id VARCHAR(50) NOT NULL,
    issued_by VARCHAR(50) NOT NULL,
    issue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    return_date TIMESTAMP NULL DEFAULT NULL,
    status VARCHAR(20) DEFAULT 'ISSUED' CHECK (status IN ('ISSUED', 'RETURNED')),
    CONSTRAINT pk_book_issues PRIMARY KEY (issue_id),
    CONSTRAINT fk_issues_book FOREIGN KEY (book_id) 
        REFERENCES books (book_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_issues_student FOREIGN KEY (student_id) 
        REFERENCES students (student_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_issues_librarian FOREIGN KEY (issued_by) 
        REFERENCES librarians (staff_id)
        ON DELETE RESTRICT
);

-- [DDL] ALTER: Add indexing on books search columns to speed up DQL lookup
ALTER TABLE books ADD INDEX idx_book_search (title, author);

-- [DDL] ALTER: Modify description field or demonstrate altering constraints
ALTER TABLE students ADD COLUMN library_card_active TINYINT(1) DEFAULT 1;

-- [DDL] TRUNCATE: Reference syntax for emptying logs (Commented out to prevent execution data loss)
-- TRUNCATE TABLE book_issues;


-- =============================================================================
-- 2. DATA MANIPULATION LANGUAGE (DML)
-- Responsible for modifying table records.
-- Commands covered: INSERT, UPDATE, DELETE
-- =============================================================================

-- [DML] INSERT: Insert sample physical shelf locations (Grids matching UI options)
INSERT INTO shelf_locations (rack, column_name, row_name, pos) VALUES
('Rack 1', 'Col 1', 'Row 1', '1st'),
('Rack 1', 'Col 1', 'Row 2', '2nd'),
('Rack 2', 'Col 3', 'Row 1', '3rd'),
('Rack 3', 'Col 2', 'Row 3', '1st'),
('Rack 4', 'Col 1', 'Row 1', '2nd'),
('Rack 5', 'Col 2', 'Row 2', '4th');

-- [DML] INSERT: Insert registered students (matching data forms)
INSERT INTO students (student_id, first_name, last_name, email, phone, department, year_of_study, password_hash) VALUES
('714025104001', 'Sampreeth', 'G', 'sampreeth.g@siet.edu.in', '9876543210', 'Computer Science', '3rd Year', '$2b$12$Kj67RfgH76hgfd87tgfduie874'),
('714025104002', 'Bhavana', 'Ramesh', 'bhavana.r@siet.edu.in', '9876543211', 'Information Technology', '4th Year', '$2b$12$Lh88YhUj88jhgt76yhfdsaqw34'),
('714025104003', 'Chandra', 'Sekhar', 'chandra.s@siet.edu.in', '9876543212', 'Electronics', '2nd Year', '$2b$12$Pj99OiJk99hgfd54redcvbnm98'),
('714025104004', 'Dinesh', 'Karthik', 'dinesh.k@siet.edu.in', '9876543213', 'Mechanical', '1st Year', '$2b$12$Zq11WxEs11jhgt32wsxzqwed43');

-- [DML] INSERT: Insert library admin staff (librarians)
INSERT INTO librarians (staff_id, first_name, last_name, email, phone, password_hash) VALUES
('LIB001', 'Sivakumar', 'Narayanan', 'sivakumar.n@siet.edu.in', '8765432109', '$2b$12$Ab12Cd34Ef56Gh78Ij90Kl12Mn'),
('LIB002', 'Meenakshi', 'Sundaram', 'meenakshi.s@siet.edu.in', '8765432108', '$2b$12$Op34Qr56St78Uv90Wx12Yz34Ab');

-- [DML] INSERT: Insert books tied to physical locations
INSERT INTO books (title, author, available, location_id) VALUES
('Introduction to Algorithms', 'Thomas H. Cormen', 1, 1),
('Database System Concepts', 'Abraham Silberschatz', 1, 2),
('Clean Code', 'Robert C. Martin', 0, 3),
('The C Programming Language', 'Brian W. Kernighan', 1, 4),
('Artificial Intelligence: A Modern Approach', 'Stuart Russell', 1, 5),
('Computer Networks', 'Andrew S. Tanenbaum', 0, 6);

-- [DML] INSERT: Insert historical or active issues
INSERT INTO book_issues (book_id, student_id, issued_by, issue_date, return_date, status) VALUES
(3, '714025104001', 'LIB001', '2026-08-15 10:00:00', NULL, 'ISSUED'),
(6, '714025104002', 'LIB002', '2026-08-10 11:30:00', NULL, 'ISSUED'),
(2, '714025104003', 'LIB001', '2026-08-01 09:00:00', '2026-08-08 16:00:00', 'RETURNED');

-- [DML] UPDATE: Update a book's availability when issued or toggled by librarian
UPDATE books 
SET available = 0 
WHERE book_id = 1;

-- [DML] UPDATE: Update return date and status on check-in
UPDATE book_issues 
SET return_date = NOW(), status = 'RETURNED' 
WHERE issue_id = 1;

-- [DML] DELETE: Delete a student record or decommissioned book (Safe reference)
DELETE FROM books 
WHERE book_id = 5 AND available = 1;


-- =============================================================================
-- 3. DATA QUERY LANGUAGE (DQL)
-- Responsible for fetching and filtering data from the database.
-- Commands covered: SELECT with WHERE, JOIN (INNER, LEFT, RIGHT), GROUP BY, HAVING, ORDER BY, Aggregates
-- =============================================================================

-- [DQL] Simple SELECT: Find books matching a search query by title (used in dashboard search)
SELECT book_id, title, author, available 
FROM books 
WHERE title LIKE '%Database%' OR author LIKE '%Silberschatz%';

-- [DQL] INNER JOIN: Fetch book catalog details along with physical library map coordinates
SELECT 
    b.book_id,
    b.title,
    b.author,
    b.available,
    s.rack,
    s.column_name,
    s.row_name,
    s.pos
FROM books b
INNER JOIN shelf_locations s ON b.location_id = s.location_id
ORDER BY s.rack ASC, s.column_name ASC;

-- [DQL] LEFT JOIN: List all students and show their borrow logs (if any)
-- Students who haven't borrowed books yet will return NULL for transaction fields.
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    s.department,
    bi.issue_id,
    bi.issue_date,
    bi.status
FROM students s
LEFT JOIN book_issues bi ON s.student_id = bi.student_id
ORDER BY s.student_id ASC;

-- [DQL] RIGHT JOIN: Fetch all librarian activity logs
-- Shows all staff members and lists the issue logs they authorized.
SELECT 
    bi.issue_id,
    bi.issue_date,
    bi.status,
    l.staff_id,
    l.first_name,
    l.last_name
FROM book_issues bi
RIGHT JOIN librarians l ON bi.issued_by = l.staff_id
ORDER BY l.staff_id ASC;

-- [DQL] GROUP BY, HAVING, ORDER BY, & AGGREGATES: Count catalog holdings per department by mapping students
-- Finds departments with more than 1 registered students borrowing books, ordered.
SELECT 
    s.department, 
    COUNT(s.student_id) AS total_registered_students,
    COUNT(bi.issue_id) AS total_book_borrowings
FROM students s
LEFT JOIN book_issues bi ON s.student_id = bi.student_id
GROUP BY s.department
HAVING total_registered_students >= 1
ORDER BY total_book_borrowings DESC;

-- [DQL] Aggregates: Generate system statistics (Total Books, Total Racks, Borrowed Books)
SELECT 
    (SELECT COUNT(*) FROM books) AS total_books,
    (SELECT COUNT(DISTINCT rack) FROM shelf_locations) AS total_racks,
    (SELECT COUNT(*) FROM books WHERE available = 0) AS total_issued_books;


-- =============================================================================
-- 4. DATA CONTROL LANGUAGE (DCL)
-- Responsible for privileges, security, and permissions.
-- Commands covered: GRANT, REVOKE
-- =============================================================================

-- Create database roles/users (Conceptual placeholder representing system setup)
-- CREATE USER 'librarian_admin'@'localhost' IDENTIFIED BY 'LibSecurePass123!';
-- CREATE USER 'student_search'@'localhost' IDENTIFIED BY 'StudentPass123!';

-- [DCL] GRANT: Give librarian administrative privileges (DML, DQL, DDL)
GRANT SELECT, INSERT, UPDATE, DELETE ON smart_library.* TO 'librarian_admin'@'localhost';

-- [DCL] GRANT: Give students read-only access to books and locations, and insert access to registration
GRANT SELECT ON books TO 'student_search'@'localhost';
GRANT SELECT ON shelf_locations TO 'student_search'@'localhost';
GRANT INSERT ON students TO 'student_search'@'localhost';

-- [DCL] REVOKE: Revoke delete permissions from general application staff accounts
REVOKE DELETE ON books FROM 'librarian_admin'@'localhost';


-- =============================================================================
-- 5. TRANSACTION CONTROL LANGUAGE (TCL)
-- Responsible for managing data consistency and changes in logical units of work.
-- Commands covered: START TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT
-- =============================================================================

-- Scenario: A student registers a request to borrow "Introduction to Algorithms" (book_id = 1).
-- This requires updating the availability state in `books` and creating a log record in `book_issues`.

-- Start transactional unit of work
START TRANSACTION;

-- Create savepoint after establishing the baseline
SAVEPOINT before_borrow;

-- Step A: Insert transaction log entry
INSERT INTO book_issues (book_id, student_id, issued_by, issue_date, return_date, status) 
VALUES (1, '714025104001', 'LIB001', NOW(), NULL, 'ISSUED');

-- Step B: Update the book table to toggle availability
UPDATE books 
SET available = 0 
WHERE book_id = 1;

-- Conditional check verification (Simulated via rollback if a constraint fails)
-- If the book was already issued (available = 0 before our query), we roll back to savepoint
-- ROLLBACK TO SAVEPOINT before_borrow;

-- [TCL] COMMIT: Save all operations permanently to disk since transaction was successful
COMMIT;

-- Demonstration of ROLLBACK in case of failure:
START TRANSACTION;

-- Attempt to delete shelf locations that are currently linked to books (will trigger constraint error)
DELETE FROM shelf_locations WHERE location_id = 1;

-- [TCL] ROLLBACK: Undo the delete operation, reverting state because of the error
ROLLBACK;
