-- Create Database
CREATE DATABASE IF NOT EXISTS food_delivery;
USE food_delivery;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(15) NOT NULL,
  address VARCHAR(255),
  role ENUM('customer', 'restaurant_owner', 'admin') DEFAULT 'customer',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Restaurants Table
CREATE TABLE IF NOT EXISTS restaurants (
  id INT PRIMARY KEY AUTO_INCREMENT,
  owner_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  cuisine_type VARCHAR(50) DEFAULT 'Mixed',
  address VARCHAR(255),
  phone VARCHAR(15),
  rating DECIMAL(3,2) DEFAULT 0,
  delivery_time INT DEFAULT 30,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_owner_id (owner_id)
);

-- Food Items Table
CREATE TABLE IF NOT EXISTS food_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  restaurant_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  category ENUM('Veg', 'Non-Veg', 'Beverage') NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  image_url VARCHAR(255),
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
  INDEX idx_restaurant_id (restaurant_id),
  INDEX idx_category (category)
);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  restaurant_id INT NOT NULL,
  order_number VARCHAR(50) UNIQUE,
  total_amount DECIMAL(10,2),
  status ENUM('Pending', 'Confirmed', 'Preparing', 'Out for Delivery', 'Delivered', 'Cancelled') DEFAULT 'Pending',
  delivery_address VARCHAR(255),
  estimated_delivery_time DATETIME,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
  INDEX idx_customer_id (customer_id),
  INDEX idx_restaurant_id (restaurant_id),
  INDEX idx_status (status)
);

-- Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  food_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (food_id) REFERENCES food_items(id) ON DELETE CASCADE,
  INDEX idx_order_id (order_id)
);

-- Insert Sample Data
-- Sample Users
INSERT INTO users (name, email, password, phone, address, role) VALUES
('John Customer', 'customer@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWDedu4IkaJh5eo2', '9876543210', '123 Main St', 'customer'),
('Restaurant Owner', 'owner@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWDedu4IkaJh5eo2', '9876543211', '456 Business Ave', 'restaurant_owner'),
('Admin User', 'admin@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWDedu4IkaJh5eo2', '9876543212', '789 Admin Rd', 'admin');

-- Sample Restaurants
INSERT INTO restaurants (owner_id, name, cuisine_type, address, phone, rating, delivery_time) VALUES
(2, 'Pizza Palace', 'Italian', '456 Business Ave', '9876543211', 4.5, 30),
(2, 'Burger Bonanza', 'Fast Food', '789 Food Lane', '9876543213', 4.2, 25);

-- Sample Food Items
INSERT INTO food_items (restaurant_id, name, category, description, price) VALUES
(1, 'Margherita Pizza', 'Veg', 'Classic pizza with tomato, mozzarella, and basil', 250.00),
(1, 'Pepperoni Pizza', 'Non-Veg', 'Pizza with pepperoni and cheese', 300.00),
(1, 'Coke', 'Beverage', 'Cold carbonated drink', 50.00),
(2, 'Chicken Burger', 'Non-Veg', 'Grilled chicken with special sauce', 200.00),
(2, 'Veggie Burger', 'Veg', 'Fresh vegetables with mayo', 150.00),
(2, 'Fries', 'Veg', 'Crispy french fries', 80.00);
