-- Create database
CREATE DATABASE IF NOT EXISTS BankingDB;
USE BankingDB;

-- Create Customers table
CREATE TABLE Customers (
    CustID INT AUTO_INCREMENT PRIMARY KEY,
    CustName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Balance DECIMAL(12,2) DEFAULT 0.00
);

-- Create Transactions table
CREATE TABLE Transactions (
    TransID INT AUTO_INCREMENT PRIMARY KEY,
    CustID INT,
    TransType ENUM('DEPOSIT','WITHDRAW') NOT NULL,
    Amount DECIMAL(12,2),
    TransDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustID) REFERENCES Customers(CustID)
);

-- Insert sample customers
INSERT INTO Customers (CustName, Email, Balance) VALUES
('Abhay', 'abhay@example.com', 10000.00),
('Ravi', 'ravi@example.com', 5000.00),
('Meena', 'meena@example.com', 15000.00);

---------------------------------------------------
-- STORED PROCEDURE: Deposit Money
---------------------------------------------------
DELIMITER //
CREATE PROCEDURE DepositMoney(IN c_id INT, IN amt DECIMAL(12,2))
BEGIN
    UPDATE Customers SET Balance = Balance + amt WHERE CustID = c_id;
    INSERT INTO Transactions (CustID, TransType, Amount) VALUES (c_id, 'DEPOSIT', amt);
END //
DELIMITER ;

---------------------------------------------------
-- STORED PROCEDURE: Withdraw Money
---------------------------------------------------
DELIMITER //
CREATE PROCEDURE WithdrawMoney(IN c_id INT, IN amt DECIMAL(12,2))
BEGIN
    DECLARE current_balance DECIMAL(12,2);
    SELECT Balance INTO current_balance FROM Customers WHERE CustID = c_id;

    IF current_balance >= amt THEN
        UPDATE Customers SET Balance = Balance - amt WHERE CustID = c_id;
        INSERT INTO Transactions (CustID, TransType, Amount) VALUES (c_id, 'WITHDRAW', amt);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient Balance!';
    END IF;
END //
DELIMITER ;

---------------------------------------------------
-- TRIGGER: Auto log whenever balance changes
---------------------------------------------------
DELIMITER //
CREATE TRIGGER after_balance_update
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO Transactions (CustID, TransType, Amount)
    VALUES (NEW.CustID, 'DEPOSIT', NEW.Balance - OLD.Balance);
END //
DELIMITER ;

---------------------------------------------------
-- INDEXES for optimization
---------------------------------------------------
CREATE INDEX idx_customer_email ON Customers(Email);
CREATE INDEX idx_transaction_date ON Transactions(TransDate);

---------------------------------------------------
-- Test the procedures
---------------------------------------------------
CALL DepositMoney(1, 2000.00);   -- Abhay deposits
CALL WithdrawMoney(2, 1000.00);  -- Ravi withdraws

-- Show balances
SELECT * FROM Customers;

-- Show transaction history
SELECT * FROM Transactions;
