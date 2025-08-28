-- Create database
CREATE DATABASE IF NOT EXISTS ECommerceDB;
USE ECommerceDB;

---------------------------------------------------
-- Customers Table
---------------------------------------------------
CREATE TABLE Customers (
    CustID INT AUTO_INCREMENT PRIMARY KEY,
    CustName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

---------------------------------------------------
-- Products Table
---------------------------------------------------
CREATE TABLE Products (
    ProdID INT AUTO_INCREMENT PRIMARY KEY,
    ProdName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2) NOT NULL,
    Stock INT DEFAULT 0
);

---------------------------------------------------
-- Orders Table
---------------------------------------------------
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustID INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustID) REFERENCES Customers(CustID)
);

---------------------------------------------------
-- OrderDetails Table (Many-to-Many Relation)
---------------------------------------------------
CREATE TABLE OrderDetails (
    DetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProdID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProdID) REFERENCES Products(ProdID)
);

---------------------------------------------------
-- Transactions Table
---------------------------------------------------
CREATE TABLE Transactions (
    TransID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    PaymentMethod ENUM('CASH','CARD','UPI'),
    Amount DECIMAL(12,2),
    TransDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

---------------------------------------------------
-- Sample Data
---------------------------------------------------
INSERT INTO Customers (CustName, Email, Phone, Address) VALUES
('Abhay', 'abhay@example.com', '9876543210', 'Pune, India'),
('Ravi', 'ravi@example.com', '9876541110', 'Delhi, India'),
('Meena', 'meena@example.com', '9876542220', 'Mumbai, India');

INSERT INTO Products (ProdName, Category, Price, Stock) VALUES
('Laptop', 'Electronics', 55000, 10),
('Phone', 'Electronics', 30000, 20),
('Shoes', 'Fashion', 2500, 50),
('Watch', 'Accessories', 7000, 30);

---------------------------------------------------
-- STORED PROCEDURE: Place Order
---------------------------------------------------
DELIMITER //
CREATE PROCEDURE PlaceOrder(IN c_id INT, IN p_id INT, IN qty INT, IN pay_method VARCHAR(10))
BEGIN
    DECLARE total_price DECIMAL(12,2);

    -- Calculate total
    SELECT Price * qty INTO total_price FROM Products WHERE ProdID = p_id;

    -- Insert into Orders
    INSERT INTO Orders (CustID) VALUES (c_id);
    SET @order_id = LAST_INSERT_ID();

    -- Insert into OrderDetails
    INSERT INTO OrderDetails (OrderID, ProdID, Quantity) VALUES (@order_id, p_id, qty);

    -- Deduct stock
    UPDATE Products SET Stock = Stock - qty WHERE ProdID = p_id;

    -- Add transaction
    INSERT INTO Transactions (OrderID, PaymentMethod, Amount) VALUES (@order_id, pay_method, total_price);
END //
DELIMITER ;

---------------------------------------------------
-- TRIGGER: Prevent negative stock
---------------------------------------------------
DELIMITER //
CREATE TRIGGER check_stock BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.Stock < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock!';
    END IF;
END //
DELIMITER ;

---------------------------------------------------
-- VIEWS
---------------------------------------------------
-- Customer Order Summary
CREATE VIEW CustomerOrders AS
SELECT c.CustName, o.OrderID, o.OrderDate, SUM(od.Quantity * p.Price) AS TotalAmount
FROM Customers c
JOIN Orders o ON c.CustID = o.CustID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProdID = p.ProdID
GROUP BY o.OrderID;

-- Product Sales Summary
CREATE VIEW ProductSales AS
SELECT p.ProdName, SUM(od.Quantity) AS TotalSold, SUM(od.Quantity * p.Price) AS Revenue
FROM Products p
JOIN OrderDetails od ON p.ProdID = od.ProdID
GROUP BY p.ProdID;

---------------------------------------------------
-- INDEXES
---------------------------------------------------
CREATE INDEX idx_customer_email ON Customers(Email);
CREATE INDEX idx_order_date ON Orders(OrderDate);

---------------------------------------------------
-- Test the procedure
---------------------------------------------------
CALL PlaceOrder(1, 1, 2, 'CARD'); -- Abhay buys 2 Laptops
CALL PlaceOrder(2, 3, 5, 'UPI');  -- Ravi buys 5 Shoes

-- Show reports
SELECT * FROM CustomerOrders;
SELECT * FROM ProductSales;
SELECT * FROM Transactions;
