-- Create database
CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

-- Create Department table
CREATE TABLE Departments (
    DeptID INT AUTO_INCREMENT PRIMARY KEY,
    DeptName VARCHAR(50)
);

-- Create Employees table
CREATE TABLE Employees (
    EmpID INT AUTO_INCREMENT PRIMARY KEY,
    EmpName VARCHAR(100),
    Age INT,
    Salary DECIMAL(10,2),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

-- Insert into Departments
INSERT INTO Departments (DeptName) VALUES
('Human Resources'),
('IT'),
('Marketing'),
('Finance');

-- Insert into Employees
INSERT INTO Employees (EmpName, Age, Salary, DeptID) VALUES
('Alice', 30, 50000.00, 1),
('Bob', 25, 60000.00, 2),
('Charlie', 28, 45000.00, 3),
('Diana', 35, 70000.00, 2),
('Eve', 29, 52000.00, 4);

-- Select all employees with their department name (JOIN)
SELECT EmpName, Age, Salary, DeptName
FROM Employees
JOIN Departments ON Employees.DeptID = Departments.DeptID;

-- Count employees in each department
SELECT DeptName, COUNT(*) AS TotalEmployees
FROM Employees
JOIN Departments ON Employees.DeptID = Departments.DeptID
GROUP BY DeptName;

-- Find average salary by department
SELECT DeptName, AVG(Salary) AS AvgSalary
FROM Employees
JOIN Departments ON Employees.DeptID = Departments.DeptID
GROUP BY DeptName;

-- Employees earning more than 55000
SELECT EmpName, Salary FROM Employees WHERE Salary > 55000;

-- Update department name
UPDATE Departments SET DeptName = 'Information Technology' WHERE DeptName = 'IT';

-- Delete employee named Charlie
DELETE FROM Employees WHERE EmpName = 'Charlie';
