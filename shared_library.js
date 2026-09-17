/**
 * SIET Smart Library Book Locator - Shared Library Module
 * Handles default data seeding, storage persistence, user authentication, and utilities.
 */

const DEFAULT_BOOKS = [
  {
    id: 1,
    title: "Introduction to Algorithms",
    author: "Thomas H. Cormen",
    rack: "Rack 1",
    column: "Col 1",
    row: "Row 1",
    pos: "1st",
    available: true
  },
  {
    id: 2,
    title: "Database System Concepts",
    author: "Abraham Silberschatz",
    rack: "Rack 1",
    column: "Col 1",
    row: "Row 2",
    pos: "2nd",
    available: true
  },
  {
    id: 3,
    title: "Clean Code",
    author: "Robert C. Martin",
    rack: "Rack 2",
    column: "Col 3",
    row: "Row 1",
    pos: "3rd",
    available: false
  },
  {
    id: 4,
    title: "The C Programming Language",
    author: "Brian W. Kernighan",
    rack: "Rack 3",
    column: "Col 2",
    row: "Row 3",
    pos: "1st",
    available: true
  },
  {
    id: 5,
    title: "Artificial Intelligence: A Modern Approach",
    author: "Stuart Russell",
    rack: "Rack 4",
    column: "Col 1",
    row: "Row 1",
    pos: "2nd",
    available: true
  },
  {
    id: 6,
    title: "Computer Networks",
    author: "Andrew S. Tanenbaum",
    rack: "Rack 5",
    column: "Col 2",
    row: "Row 2",
    pos: "4th",
    available: false
  },
  {
    id: 7,
    title: "Operating System Concepts",
    author: "Abraham Silberschatz",
    rack: "Rack 2",
    column: "Col 2",
    row: "Row 2",
    pos: "1st",
    available: true
  },
  {
    id: 8,
    title: "Software Engineering",
    author: "Ian Sommerville",
    rack: "Rack 3",
    column: "Col 1",
    row: "Row 2",
    pos: "2nd",
    available: true
  }
];

const DEFAULT_USERS = {
  students: [
    {
      studentId: "714025104001",
      firstName: "Sampreeth",
      lastName: "G",
      email: "student@siet.edu.in",
      phone: "9876543210",
      department: "Computer Science",
      year: "3rd Year",
      password: "student123"
    }
  ],
  librarians: [
    {
      staffId: "LIB001",
      firstName: "Library",
      lastName: "Admin",
      email: "librarian@siet.edu.in",
      phone: "8765432109",
      password: "admin123"
    }
  ]
};

function getBooks() {
  try {
    const data = localStorage.getItem("libraryBooks");
    if (!data) {
      localStorage.setItem("libraryBooks", JSON.stringify(DEFAULT_BOOKS));
      return DEFAULT_BOOKS;
    }
    const parsed = JSON.parse(data);
    if (!Array.isArray(parsed) || parsed.length === 0) {
      localStorage.setItem("libraryBooks", JSON.stringify(DEFAULT_BOOKS));
      return DEFAULT_BOOKS;
    }
    return parsed;
  } catch (e) {
    console.error("Error loading libraryBooks from localStorage", e);
    return DEFAULT_BOOKS;
  }
}

function saveBooks(books) {
  try {
    localStorage.setItem("libraryBooks", JSON.stringify(books));
  } catch (e) {
    console.error("Error saving libraryBooks to localStorage", e);
  }
}

function getUsers() {
  try {
    const data = localStorage.getItem("libraryUsers");
    if (!data) {
      localStorage.setItem("libraryUsers", JSON.stringify(DEFAULT_USERS));
      return DEFAULT_USERS;
    }
    const parsed = JSON.parse(data);
    if (!parsed.students || !parsed.librarians) {
      localStorage.setItem("libraryUsers", JSON.stringify(DEFAULT_USERS));
      return DEFAULT_USERS;
    }
    return parsed;
  } catch (e) {
    console.error("Error loading libraryUsers from localStorage", e);
    return DEFAULT_USERS;
  }
}

function saveUsers(users) {
  try {
    localStorage.setItem("libraryUsers", JSON.stringify(users));
  } catch (e) {
    console.error("Error saving libraryUsers to localStorage", e);
  }
}

function getCurrentUser() {
  try {
    const data = localStorage.getItem("libraryCurrentUser");
    return data ? JSON.parse(data) : null;
  } catch (e) {
    return null;
  }
}

function setCurrentUser(user) {
  try {
    localStorage.setItem("libraryCurrentUser", JSON.stringify(user));
  } catch (e) {
    console.error("Error setting libraryCurrentUser", e);
  }
}

function clearCurrentUser() {
  try {
    localStorage.removeItem("libraryCurrentUser");
  } catch (e) {
    console.error("Error clearing libraryCurrentUser", e);
  }
}

function escapeHtml(str) {
  if (str === null || str === undefined) return "";
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

// Auto-seed on script execution
getBooks();
getUsers();
