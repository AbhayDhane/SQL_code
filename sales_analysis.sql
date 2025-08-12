-- Create database
CREATE DATABASE IF NOT EXISTS SalesDB;
USE SalesDB;

-- Create table
CREATE TABLE Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SaleDate DATE,
    Quantity INT,
    Price DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO Sales (ProductName, Category, SaleDate, Quantity, Price) VALUES
('Laptop', 'Electronics', '2025-01-10', 5, 55000),
('Phone', 'Electronics', '2025-02-14', 8, 30000),
('Headphones', 'Accessories', '2025-03-01', 12, 2000),
('Shoes', 'Fashion', '2025-01-25', 15, 3000),
('Watch', 'Fashion', '2025-02-18', 7, 8000),
('Tablet', 'Electronics', '2025-03-05', 4, 25000),
('Jacket', 'Fashion', '2025-03-15', 6, 4500);

-- Total revenue
SELECT SUM(Quantity * Price) AS TotalRevenue FROM Sales;

-- Subquery: Products above average price
SELECT ProductName, Price
FROM Sales
WHERE Price > (SELECT A
