# SIET Smart Library Book Locator 📚

A web-based system designed to quickly locate books in a college library using title or author search with exact physical shelf location details. 

## 🌟 Features

### For Students
* **Search & Locate:** Instantly find books by Title or Author.
* **Exact Shelf Mapping:** See the precise `Rack`, `Column`, `Row`, and `Position` of the book in the physical library.
* **Real-time Availability:** Check whether a book is currently "Available" on the shelf or "Issued" to someone else.
* **Secure Authentication:** Register and log in using your SIET Student Register Number.

### For Librarians (Admin Panel)
* **Manage Inventory:** Add new books to the catalog along with their exact physical coordinates.
* **Toggle Status:** Instantly mark a book as issued or available.
* **Inventory Control:** Remove decommissioned or lost books from the catalog.

## 🛠️ Technology Stack
* **Frontend:** HTML5, CSS3, Vanilla JavaScript
* **Current Storage:** Client-side `localStorage` (for immediate prototyping and demonstration without a local server)
* **Production Database Design:** Relational SQL Database (MySQL/MariaDB)

## 📁 Project Structure

### Web Pages
* `Home_page.html` - Landing page of the library system.
* `siet_register_login.html` - Secure authentication portal for Students and Librarians.
* `After_login_page.html` - The Student Dashboard for searching the catalog.
* `Librarian_Desktop.html` - The Librarian Dashboard for inventory management.

### Database Documentation (Production Ready)
We have fully modeled the backend relational database for this project to prepare it for full-stack integration:
* `DATABASE_ERD.md` - Entity-Relationship Diagrams defining the data architecture.
* `DATABASE_TABLE_SCHEMAS.md` - Detailed dictionary of all tables, fields, and constraints.
* `DATABASE_QUERIES.sql` - Production-grade SQL scripts containing DDL, DML, DQL, DCL, and TCL commands.
* `SQL_SYNTAX_AND_DEFINITIONS.md` - A reference guide for the SQL commands used in the queries.

## 🚀 How to Run (Prototype)
Since the current frontend iteration uses `localStorage` for data persistence, no complex server or backend setup is required to test the UI!
1. Clone or download this repository.
2. Open `Home_page.html` in any modern web browser.
3. Register a new Student or Librarian account.
4. Log in and start managing or searching the library catalog!
