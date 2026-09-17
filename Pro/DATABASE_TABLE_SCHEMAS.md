# Database Table Schemas

This document provides a detailed, dictionary-level breakdown of each database table designed for the **SIET Smart Library Book Locator** system. It describes the data types, constraints (Primary Key, Foreign Key, Unique Key, Nullability), default values, and functional business descriptions for every field.

---

## Table of Contents
1. [Table: students](#1-table-students)
2. [Table: librarians](#2-table-librarians)
3. [Table: shelf_locations](#3-table-shelf_locations)
4. [Table: books](#4-table-books)
5. [Table: book_issues](#5-table-book_issues)

---

## 1. Table: `students`
This table stores registration data, profiles, and credentials for students who use the Smart Library system to search for books.

| Field Name | Data Type | Constraints (PK/FK/Unique/Not Null) | Default Value | Description |
| :--- | :--- | :--- | :--- | :--- |
| **`student_id`** | `VARCHAR(50)` | Primary Key (PK), Not Null | *None* | Unique Register Number issued by SIET College (e.g., `714025104***`). |
| **`first_name`** | `VARCHAR(50)` | Not Null | *None* | First name of the student. |
| **`last_name`** | `VARCHAR(50)` | Not Null | *None* | Last name (surname) of the student. |
| **`email`** | `VARCHAR(100)` | Unique Key (UK), Not Null | *None* | Student's institutional email address. Used for authentication. |
| **`phone`** | `VARCHAR(15)` | Not Null | *None* | 10-digit primary phone contact number. |
| **`department`** | `VARCHAR(50)` | Not Null | *None* | Department branch (e.g., Computer Science, Information Technology, Electronics, Mechanical, Civil, AIDS, AIML). |
| **`year_of_study`** | `VARCHAR(20)` | Not Null | *None* | Academic year indicator (e.g., 1st Year, 2nd Year, 3rd Year, 4th Year). |
| **`password_hash`**| `VARCHAR(255)`| Not Null | *None* | Securely hashed password credential (e.g., bcrypt/argon2 format). |
| **`created_at`** | `TIMESTAMP` | Not Null | `CURRENT_TIMESTAMP` | System audit timestamp indicating when the student account was registered. |
| **`library_card_active`** | `TINYINT(1)` | Not Null | `1` | Boolean flag (1 = Active, 0 = Suspended) representing checkout privileges. |

---

## 2. Table: `librarians`
This table stores credential and contact profiles for administrative library staff members who manage the catalog inventory and authorize book issues.

| Field Name | Data Type | Constraints (PK/FK/Unique/Not Null) | Default Value | Description |
| :--- | :--- | :--- | :--- | :--- |
| **`staff_id`** | `VARCHAR(50)` | Primary Key (PK), Not Null | *None* | Unique staff identifier code (e.g., `LIB001`). |
| **`first_name`** | `VARCHAR(50)` | Not Null | *None* | First name of the library staff member. |
| **`last_name`** | `VARCHAR(50)` | Not Null | *None* | Last name of the library staff member. |
| **`email`** | `VARCHAR(100)` | Unique Key (UK), Not Null | *None* | Librarian's work email address. Used for login authentication. |
| **`phone`** | `VARCHAR(15)` | Not Null | *None* | 10-digit primary phone contact number. |
| **`password_hash`**| `VARCHAR(255)`| Not Null | *None* | Securely hashed password credential. |
| **`created_at`** | `TIMESTAMP` | Not Null | `CURRENT_TIMESTAMP` | Timestamp indicating when the librarian profile was created. |

---

## 3. Table: `shelf_locations`
This table acts as a spatial look-up dictionary. By storing coordinates here and linking them to books via foreign keys, duplicate text storage is avoided and physical library reorganizations are simplified.

| Field Name | Data Type | Constraints (PK/FK/Unique/Not Null) | Default Value | Description |
| :--- | :--- | :--- | :--- | :--- |
| **`location_id`** | `INT` | Primary Key (PK), Auto Incremented | *None* | System generated index identifier for a physical coordinate slot. |
| **`rack`** | `VARCHAR(50)` | Not Null, Part of Composite UK | *None* | Physical shelf rack identifier (e.g., "Rack 1", "Rack A"). |
| **`column_name`** | `VARCHAR(50)` | Not Null, Part of Composite UK | *None* | Vertical divider coordinate (e.g., "Col 2"). |
| **`row_name`** | `VARCHAR(50)` | Not Null, Part of Composite UK | *None* | Horizontal shelf level coordinate (e.g., "Row 3"). |
| **`pos`** | `VARCHAR(50)` | Not Null, Part of Composite UK | *None* | Exact item index location in that cell slot (e.g., "1st", "2nd"). |

> **Note on Integrity**: A composite Unique constraint `uk_shelf_coordinates` is placed on `(rack, column_name, row_name, pos)` to ensure two book records cannot share overlapping coordinate structures in database logic without deliberate intent.

---

## 4. Table: `books`
This table represents the library catalog inventory, holding bibliographic metadata and linking each copy to its physical location.

| Field Name | Data Type | Constraints (PK/FK/Unique/Not Null) | Default Value | Description |
| :--- | :--- | :--- | :--- | :--- |
| **`book_id`** | `INT` | Primary Key (PK), Auto Incremented | *None* | Unique book identifier accession number. |
| **`title`** | `VARCHAR(255)`| Not Null | *None* | Title of the book. |
| **`author`** | `VARCHAR(255)`| Not Null | *None* | Author of the book. |
| **`available`** | `TINYINT(1)` | Not Null, Check Constraint (0/1) | `1` | Boolean status tracker (1 = Available on shelf, 0 = Borrowed/Issued). |
| **`location_id`** | `INT` | Foreign Key (FK), Not Null | *None* | Maps to `shelf_locations(location_id)`. Prevents database orphan rows. |
| **`created_at`** | `TIMESTAMP` | Not Null | `CURRENT_TIMESTAMP` | Timestamp indicating when the book was cataloged into the inventory. |

> **Constraint Behavior**: `location_id` has `ON DELETE RESTRICT` and `ON UPDATE CASCADE`. A location slot cannot be deleted if a book is currently assigned to it.

---

## 5. Table: `book_issues`
This transaction table records audit logs of book checkouts and returns, linking students, books, and administrative librarians.

| Field Name | Data Type | Constraints (PK/FK/Unique/Not Null) | Default Value | Description |
| :--- | :--- | :--- | :--- | :--- |
| **`issue_id`** | `INT` | Primary Key (PK), Auto Incremented | *None* | Unique sequence ID for the borrowing transaction. |
| **`book_id`** | `INT` | Foreign Key (FK), Not Null | *None* | Maps to `books(book_id)`. Tracks the book copy checked out. |
| **`student_id`** | `VARCHAR(50)` | Foreign Key (FK), Not Null | *None* | Maps to `students(student_id)`. Identifies the borrowing student. |
| **`issued_by`** | `VARCHAR(50)` | Foreign Key (FK), Not Null | *None* | Maps to `librarians(staff_id)`. Logs who authorized the transaction. |
| **`issue_date`** | `TIMESTAMP` | Not Null | `CURRENT_TIMESTAMP` | Timestamp when the book was lent out. |
| **`return_date`** | `TIMESTAMP` | Nullable | `NULL` | Timestamp when the book was returned to the library. |
| **`status`** | `VARCHAR(20)` | Not Null, Check Constraint | `'ISSUED'` | Loan state (Values: `'ISSUED'`, `'RETURNED'`). |

> **Constraint Behavior**:
> - `book_id` and `student_id` use `ON DELETE CASCADE` to delete issue history if a user or book copy is deleted.
> - `issued_by` has `ON DELETE RESTRICT` to ensure a transaction record cannot lose its authorizing librarian signature.
