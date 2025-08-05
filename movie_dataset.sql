-- Create database
CREATE DATABASE IF NOT EXISTS MovieDB;
USE MovieDB;

-- Create table
CREATE TABLE Movies (
    MovieID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    Genre VARCHAR(50),
    ReleaseYear INT,
    Rating DECIMAL(3,1)
);

-- Insert sample data
INSERT INTO Movies (Title, Genre, ReleaseYear, Rating) VALUES
('Inception', 'Sci-Fi', 2010, 8.8),
('Titanic', 'Romance', 1997, 7.9),
('The Dark Knight', 'Action', 2008, 9.0),
('Interstellar', 'Sci-Fi', 2014, 8.6),
('Joker', 'Drama', 2019, 8.5);

-- Basic SELECT
SELECT * FROM Movies;

-- Filter with WHERE
SELECT * FROM Movies WHERE Genre = 'Sci-Fi';

-- Sorting
SELECT * FROM Movies ORDER BY Rating DESC;

-- Get movies after 2010
SELECT Title, ReleaseYear FROM Movies WHERE ReleaseYear > 2010;

-- Get average rating
SELECT AVG(Rating) AS AverageRating FROM Movies;

-- Group by Genre
SELECT Genre, COUNT(*) AS TotalMovies FROM Movies GROUP BY Genre;

-- Update data
UPDATE Movies SET Rating = 9.1 WHERE Title = 'The Dark Knight';

-- Delete a movie
DELETE FROM Movies WHERE Title = 'Titanic';
