PRAGMA foreign_keys = ON;

--------------------------------------------------
-- Categories
--------------------------------------------------

CREATE TABLE IF NOT EXISTS Categories
(
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name        TEXT NOT NULL,
    Type        TEXT NOT NULL
);

--------------------------------------------------
-- Transactions
--------------------------------------------------

CREATE TABLE IF NOT EXISTS Transactions
(
    ID INTEGER PRIMARY KEY AUTOINCREMENT,

    TDate       TEXT NOT NULL,

    CategoryID  INTEGER NOT NULL,

    Amount      REAL NOT NULL,

    Note        TEXT,

    FOREIGN KEY(CategoryID)
        REFERENCES Categories(ID)
);

--------------------------------------------------
-- Budgets
--------------------------------------------------

CREATE TABLE IF NOT EXISTS Budgets
(
    ID INTEGER PRIMARY KEY AUTOINCREMENT,

    CategoryID INTEGER NOT NULL,

    BudgetMonth TEXT NOT NULL,

    Amount REAL NOT NULL,

    FOREIGN KEY(CategoryID)
        REFERENCES Categories(ID)
);

--------------------------------------------------
-- Settings
--------------------------------------------------

CREATE TABLE IF NOT EXISTS Settings
(
    SettingName TEXT PRIMARY KEY,
    SettingValue TEXT
);

--------------------------------------------------
-- Default Categories
--------------------------------------------------

INSERT INTO Categories(Name,Type)
SELECT 'Salary','Income'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Salary'
);

INSERT INTO Categories(Name,Type)
SELECT 'Bonus','Income'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Bonus'
);

INSERT INTO Categories(Name,Type)
SELECT 'Gift','Income'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Gift'
);

INSERT INTO Categories(Name,Type)
SELECT 'Other Income','Income'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Other Income'
);

INSERT INTO Categories(Name,Type)
SELECT 'Food','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Food'
);

INSERT INTO Categories(Name,Type)
SELECT 'Rent','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Rent'
);

INSERT INTO Categories(Name,Type)
SELECT 'Utilities','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Utilities'
);

INSERT INTO Categories(Name,Type)
SELECT 'Internet','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Internet'
);

INSERT INTO Categories(Name,Type)
SELECT 'Phone','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Phone'
);

INSERT INTO Categories(Name,Type)
SELECT 'Transportation','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Transportation'
);

INSERT INTO Categories(Name,Type)
SELECT 'Fuel','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Fuel'
);

INSERT INTO Categories(Name,Type)
SELECT 'Medical','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Medical'
);

INSERT INTO Categories(Name,Type)
SELECT 'Education','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Education'
);

INSERT INTO Categories(Name,Type)
SELECT 'Entertainment','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Entertainment'
);

INSERT INTO Categories(Name,Type)
SELECT 'Shopping','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Shopping'
);

INSERT INTO Categories(Name,Type)
SELECT 'Other Expense','Expense'
WHERE NOT EXISTS
(
SELECT 1 FROM Categories WHERE Name='Other Expense'
);

--------------------------------------------------
-- Default Settings
--------------------------------------------------

INSERT INTO Settings
VALUES ('Currency','¥');

INSERT INTO Settings
VALUES ('DateFormat','yyyy-MM-dd');

INSERT INTO Settings
VALUES ('BackupFolder','Backup');
