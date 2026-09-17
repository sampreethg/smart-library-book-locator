# SQL Syntax and Definitions Reference Guide

This reference guide provides definitions, generic syntax templates, and concrete project examples for every SQL command, clause, constraint, and transactional block implemented in the **SIET Smart Library Book Locator** database.

---

## Table of Contents
1. [Data Definition Language (DDL)](#1-data-definition-language-ddl)
2. [Data Manipulation Language (DML)](#2-data-manipulation-language-dml)
3. [Data Query Language (DQL)](#3-data-query-language-dql)
4. [Data Control Language (DCL)](#4-data-control-language-dcl)
5. [Transaction Control Language (TCL)](#5-transaction-control-language-tcl)

---

## 1. Data Definition Language (DDL)
DDL commands define, alter, and delete database structures (schemas, tables, indexes, and constraints).

### 1.1 DROP
* **Definition**: Permanently removes a table, view, index, or schema from the database, along with its metadata and records. Used during database initialization to wipe existing tables to enable clean builds.
* **Generic Syntax**:
  ```sql
  DROP TABLE [IF EXISTS] table_name;
  ```
* **Concrete Project Example**:
  ```sql
  DROP TABLE IF EXISTS book_issues;
  ```

### 1.2 CREATE TABLE
* **Definition**: Establishes a new table in the database schema, defining column names, data types, and integrity constraints.
* **Generic Syntax**:
  ```sql
  CREATE TABLE table_name (
      column_name data_type [constraints],
      ...
      [table_level_constraints]
  );
  ```
* **Concrete Project Example**:
  ```sql
  CREATE TABLE shelf_locations (
      location_id INT AUTO_INCREMENT,
      rack VARCHAR(50) NOT NULL,
      column_name VARCHAR(50) NOT NULL,
      row_name VARCHAR(50) NOT NULL,
      pos VARCHAR(50) NOT NULL,
      CONSTRAINT pk_shelf_locations PRIMARY KEY (location_id)
  );
  ```

### 1.3 ALTER TABLE
* **Definition**: Modifies the structure of an existing table by adding, deleting, or changing columns, keys, indexes, and constraints.
* **Generic Syntax**:
  ```sql
  ALTER TABLE table_name ADD COLUMN column_name data_type [constraints];
  ALTER TABLE table_name ADD INDEX index_name (column1, column2);
  ```
* **Concrete Project Example**:
  ```sql
  ALTER TABLE books ADD INDEX idx_book_search (title, author);
  ```

### 1.4 TRUNCATE TABLE
* **Definition**: Fast operation that empties a table by deallocating the data pages used to store its records. Unlike `DELETE`, it does not scan row-by-row and resets auto-increment values.
* **Generic Syntax**:
  ```sql
  TRUNCATE TABLE table_name;
  ```
* **Concrete Project Example**:
  ```sql
  TRUNCATE TABLE book_issues;
  ```

---

## 2. Data Manipulation Language (DML)
DML commands are used to manage data records within the existing database tables.

### 2.1 INSERT INTO
* **Definition**: Adds one or more new data records to a specific table.
* **Generic Syntax**:
  ```sql
  INSERT INTO table_name (column1, column2, ...) VALUES (value1, value2, ...);
  ```
* **Concrete Project Example**:
  ```sql
  INSERT INTO students (student_id, first_name, last_name, email, phone, department, year_of_study, password_hash)
  VALUES ('714025104001', 'Sampreeth', 'G', 'sampreeth.g@siet.edu.in', '9876543210', 'Computer Science', '3rd Year', '$2b$12$Kj67RfgH76hgfd87tgfduie874');
  ```

### 2.2 UPDATE
* **Definition**: Modifies existing values in one or more records in a table based on a filtering criteria (`WHERE`).
* **Generic Syntax**:
  ```sql
  UPDATE table_name 
  SET column1 = value1, column2 = value2 
  WHERE condition;
  ```
* **Concrete Project Example**:
  ```sql
  UPDATE books 
  SET available = 0 
  WHERE book_id = 1;
  ```

### 2.3 DELETE
* **Definition**: Removes specific records from a table based on a filtering criteria (`WHERE`).
* **Generic Syntax**:
  ```sql
  DELETE FROM table_name WHERE condition;
  ```
* **Concrete Project Example**:
  ```sql
  DELETE FROM books 
  WHERE book_id = 5 AND available = 1;
  ```

---

## 3. Data Query Language (DQL)
DQL is used to retrieve and format records stored in the database.

### 3.1 SELECT with WHERE and LIKE
* **Definition**: Retrieves specific columns from a table and filters results based on comparison operations. The `LIKE` operator is used with wildcards (`%`) for pattern matching.
* **Generic Syntax**:
  ```sql
  SELECT column1, column2 
  FROM table_name 
  WHERE column_name LIKE '%search_pattern%';
  ```
* **Concrete Project Example**:
  ```sql
  SELECT book_id, title, author, available 
  FROM books 
  WHERE title LIKE '%Database%' OR author LIKE '%Silberschatz%';
  ```

### 3.2 INNER JOIN
* **Definition**: Combines records from two tables by comparing shared columns. Returns only the rows where the join condition matches in both tables.
* **Generic Syntax**:
  ```sql
  SELECT t1.col, t2.col 
  FROM table1 t1
  INNER JOIN table2 t2 ON t1.shared_col = t2.shared_col;
  ```
* **Concrete Project Example**:
  ```sql
  SELECT b.title, b.author, s.rack, s.column_name, s.row_name
  FROM books b
  INNER JOIN shelf_locations s ON b.location_id = s.location_id;
  ```

### 3.3 LEFT JOIN (Outer Join)
* **Definition**: Retrieves all records from the left table and matching records from the right table. If there are no matches, the right side returns `NULL` values.
* **Generic Syntax**:
  ```sql
  SELECT t1.col, t2.col 
  FROM table1 t1
  LEFT JOIN table2 t2 ON t1.shared_col = t2.shared_col;
  ```
* **Concrete Project Example**:
  ```sql
  SELECT s.student_id, s.first_name, bi.issue_id, bi.status
  FROM students s
  LEFT JOIN book_issues bi ON s.student_id = bi.student_id;
  ```

### 3.4 RIGHT JOIN (Outer Join)
* **Definition**: Retrieves all records from the right table and matching records from the left table. If there are no matches, the left side returns `NULL` values.
* **Generic Syntax**:
  ```sql
  SELECT t1.col, t2.col 
  FROM table1 t1
  RIGHT JOIN table2 t2 ON t1.shared_col = t2.shared_col;
  ```
* **Concrete Project Example**:
  ```sql
  SELECT bi.issue_id, bi.status, l.staff_id, l.first_name
  FROM book_issues bi
  RIGHT JOIN librarians l ON bi.issued_by = l.staff_id;
  ```

### 3.5 GROUP BY & HAVING
* **Definition**: `GROUP BY` aggregates query result rows sharing the same values into summary buckets. `HAVING` filters these aggregated groups (acting like a `WHERE` clause for groupings).
* **Generic Syntax**:
  ```sql
  SELECT group_column, aggregate_function(col) 
  FROM table_name 
  GROUP BY group_column
  HAVING condition_on_aggregate;
  ```
* **Concrete Project Example**:
  ```sql
  SELECT s.department, COUNT(s.student_id) AS total_registered_students
  FROM students s
  GROUP BY s.department
  HAVING total_registered_students >= 1;
  ```

### 3.6 ORDER BY
* **Definition**: Sorts the query results in ascending (`ASC`) or descending (`DESC`) order.
* **Generic Syntax**:
  ```sql
  SELECT col1, col2 
  FROM table_name 
  ORDER BY col1 [ASC|DESC];
  ```
* **Concrete Project Example**:
  ```sql
  SELECT title, author 
  FROM books 
  ORDER BY title ASC;
  ```

### 3.7 Aggregate Functions
* **Definition**: Math functions that process values across multiple records to compute a single summary value (e.g. counts, sums, averages).
* **Generic Syntax**:
  ```sql
  SELECT COUNT(col), SUM(col), AVG(col), MAX(col), MIN(col) FROM table_name;
  ```
* **Concrete Project Example**:
  ```sql
  SELECT 
      COUNT(DISTINCT b.book_id) AS total_books,
      SUM(CASE WHEN b.available = 0 THEN 1 ELSE 0 END) AS total_issued_books
  FROM books b;
  ```

---

## 4. Data Control Language (DCL)
DCL commands manage roles, permissions, security controls, and database user access levels.

### 4.1 GRANT
* **Definition**: Assigns specific data permissions (read, write, modify, delete) to a database user or role.
* **Generic Syntax**:
  ```sql
  GRANT privilege_type ON object_name TO user_profile;
  ```
* **Concrete Project Example**:
  ```sql
  GRANT SELECT, INSERT, UPDATE, DELETE ON SmartLibrary.* TO 'librarian_admin'@'localhost';
  ```

### 4.2 REVOKE
* **Definition**: Removes previously granted security privileges from a database user or role.
* **Generic Syntax**:
  ```sql
  REVOKE privilege_type ON object_name FROM user_profile;
  ```
* **Concrete Project Example**:
  ```sql
  REVOKE DELETE ON books FROM 'librarian_admin'@'localhost';
  ```

---

## 5. Transaction Control Language (TCL)
TCL commands manage logical database transactions, ensuring transactional integrity (ACID properties).

### 5.1 START TRANSACTION (or BEGIN)
* **Definition**: Signals the start of a series of SQL operations that must execute as a single, atomic unit of work (either all succeed or all are discarded).
* **Generic Syntax**:
  ```sql
  START TRANSACTION;
  ```
* **Concrete Project Example**:
  ```sql
  START TRANSACTION;
  ```

### 5.2 SAVEPOINT
* **Definition**: Establishes a temporary landmark within a transaction. This allows operations to be partially rolled back to the savepoint without cancelling the entire transaction.
* **Generic Syntax**:
  ```sql
  SAVEPOINT savepoint_name;
  ```
* **Concrete Project Example**:
  ```sql
  SAVEPOINT before_borrow;
  ```

### 5.3 COMMIT
* **Definition**: Saves all changes made during the current active transaction permanently to disk, rendering them visible to other database users.
* **Generic Syntax**:
  ```sql
  COMMIT;
  ```
* **Concrete Project Example**:
  ```sql
  COMMIT;
  ```

### 5.4 ROLLBACK
* **Definition**: Undoes all operations performed in the current transaction, returning the database state back to its pre-transaction baseline or back to a specific `SAVEPOINT`.
* **Generic Syntax**:
  ```sql
  ROLLBACK [TO SAVEPOINT savepoint_name];
  ```
* **Concrete Project Example**:
  ```sql
  ROLLBACK TO SAVEPOINT before_borrow;
  ```
