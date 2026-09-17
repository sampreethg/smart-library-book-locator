# Smart Library Book Locator 📚

> A web-based system designed to quickly locate books in a college library using title or author search with exact physical shelf coordinates (Rack, Column, Row, Position) and real-time inventory management.

## 🌟 Features

### 🔍 Student Features
- **Instant Book Search**: Search by Title, Author, or Keyword with instant real-time results.
- **Exact Shelf Location Mapping**: View precise physical shelf coordinates (`Rack`, `Column`, `Row`, and `Position`).
- **Real-time Status Tracking**: Instantly check if a book is currently "Available" on the shelf or "Issued".
- **Student Authentication**: Secure registration and login portal supporting college student registration numbers and departments.

### 👨‍💼 Librarian Administrative Panel
- **Inventory Management**: Add new books to the catalog with exact physical grid coordinates.
- **Status Toggle**: Change book availability status between "Available" and "Issued" with one click.
- **Catalog Control**: Remove decommissioned or missing books from the library system.
- **Search & Filter**: Real-time filtering across the library inventory.

### 🗄️ Relational Database Architecture (Production-Ready)
- **Comprehensive DDL, DML, DQL, DCL, TCL Scripts**: Ready for MySQL / MariaDB deployments.
- **Entity-Relationship Diagram (ERD)**: Fully modeled relationships between Students, Librarians, Shelf Locations, Books, and Borrow Transactions.
- **Normalized Data Dictionary**: Complete table schemas and constraint definitions.

---

## 🛠️ Tech Stack

- **Frontend**: HTML5, CSS3 (Modern Glassmorphism & Responsive UI), Vanilla JavaScript (ES6+)
- **Client Storage**: `localStorage` with automatic data seeding for immediate local & GitHub Pages preview
- **Database Backend**: SQL (MySQL / MariaDB compatible)
- **Deployment**: GitHub Pages

---

## 🚀 Live Demo & Usage

1. **Open the live application on GitHub Pages**:
   [https://sampreethg.github.io/smart-library-book-locator/](https://sampreethg.github.io/smart-library-book-locator/)

2. **Search Books**:
   - Enter a title (e.g., *"Introduction to Algorithms"*, *"Database System Concepts"*, *"Clean Code"*) or author name in the search bar.
   - View exact shelf location chips (`🗄️ Rack 1`, `🗂 Col 1`, `↕ Row 1`, `🎯 Pos: 1st`) and availability badge.

3. **Login & Role Portals**:
   - Access the **Student Portal** to search and view borrowing details.
   - Access the **Librarian Control Panel** to add books and manage inventory.
   - *Default Demo Credentials*:
     - **Student**: `student@siet.edu.in` | Password: `student123` | Reg No: `714025104001`
     - **Librarian**: `librarian@siet.edu.in` | Password: `admin123`

---

## 📁 Project Structure

```text
smart-library-book-locator/
├── index.html                      # Main entry point & live search landing page
├── shared_library.js               # Shared data layer (catalog seed, auth & session helper)
├── README.md                       # Comprehensive project documentation
├── LICENSE                         # MIT License
├── .gitignore                      # Git ignore file
├── Pro/                            # Application Core Module
│   ├── Home_page.html              # Library home page
│   ├── siet_register_login.html    # Authentication portal for Students & Librarians
│   ├── After_login_page.html       # Student book locator dashboard
│   ├── Librarian_Desktop.html      # Librarian inventory control panel
│   ├── shared_library.js           # Shared library helper script
│   ├── DATABASE_QUERIES.sql        # Production SQL scripts (DDL, DML, DQL, DCL, TCL)
│   ├── DATABASE_ERD.md             # Mermaid.js Entity-Relationship Diagrams
│   ├── DATABASE_TABLE_SCHEMAS.md   # Data dictionary & column specifications
│   ├── SQL_SYNTAX_AND_DEFINITIONS.md# SQL command definitions & reference
│   └── README.md                   # Pro module overview
└── ppt/                            # Project Presentation & Documentation Slides
    ├── SmartLibrary_BookLocator.pptx
    ├── SmartLibrary_BookLocator.2.0.pptx
    ├── SmartLibrary_Completed.pptx
    └── SmartLibrary_Completed 2.0.pptx
```

---

## 💻 Local Development

To run this project locally without any server setup:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/sampreethg/smart-library-book-locator.git
   ```

2. **Navigate into the directory**:
   ```bash
   cd smart-library-book-locator
   ```

3. **Open `index.html` in your browser**:
   ```bash
   # On Windows
   start index.html

   # On macOS
   open index.html

   # On Linux
   xdg-open index.html
   ```

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Sampreeth G**
- GitHub: [@sampreethg](https://github.com/sampreethg)
