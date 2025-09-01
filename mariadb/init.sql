-- Create database
CREATE DATABASE IF NOT EXISTS crud_db;
USE crud_db;

-- Create items table
CREATE TABLE IF NOT EXISTS items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO items (name, description) VALUES
('First Item', 'This is the first sample item'),
('Second Item', 'This is the second sample item'),
('Third Item', 'This is the third sample item');
