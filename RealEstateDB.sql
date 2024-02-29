CREATE DATABASE RealEstateDB;

-- Switch to the newly created database
USE RealEstateDB;

-- Create Users table
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    mobileNumber VARCHAR(20) UNIQUE,
    BuyerSeller ENUM('Buyer', 'Seller', 'Both'),
    Location VARCHAR(255),
    Ratings DECIMAL(3, 2)
);

-- Create Agents table
CREATE TABLE Agents (
    UserID INT,
    AgentID INT PRIMARY KEY,
    AgentCompany VARCHAR(255),
    Agent_Name VARCHAR(255),
    Experience INT,
    Location VARCHAR(255),
    Languages VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create Properties table
CREATE TABLE Properties (
    AgentID INT,
    propertyID INT PRIMARY KEY,
    Status ENUM('sold', 'unsold', 'Rent'),
    Address VARCHAR(255),
    Location VARCHAR(255),
    zip_code VARCHAR(10),
    city VARCHAR(255),
    state VARCHAR(255),
    square_feet INT,
    Price DECIMAL(15, 2),
    Type VARCHAR(255),
    Lot_size VARCHAR(50),
    beds INT,
    baths INT,
    yearBuilt INT,
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);

-- Create Sold_Properties table
CREATE TABLE Sold_Properties (
    SoldPrice DECIMAL(15, 2),
    SoldDate DATE,
    agentUserID INT,
    buyerUserID INT,
    Sold_SNumber INT AUTO_INCREMENT,
    PRIMARY KEY (Sold_SNumber),
    FOREIGN KEY (agentUserID) REFERENCES Users(UserID),
    FOREIGN KEY (buyerUserID) REFERENCES Users(UserID)
);

-- Create Unsold_Properties table
CREATE TABLE Unsold_Properties (
    Price DECIMAL(15, 2),
    sellingUserID INT,
    daysOnMarket INT CHECK (daysOnMarket >= 0),
    Active_pre_release ENUM('Active', 'pre-release'),
    Unsold_SNumber INT AUTO_INCREMENT,
    PRIMARY KEY (Unsold_SNumber),
    FOREIGN KEY (sellingUserID) REFERENCES Users(UserID)
);

-- Create Rent_Properties table
CREATE TABLE Rent_Properties (
    RentPrice DECIMAL(15, 2),
    Location VARCHAR(255),
    sellingUserID INT,
    buyerUserID INT,
    MonthsRented INT,
    Rent_SNumber INT AUTO_INCREMENT,
    PRIMARY KEY (Rent_SNumber),
    FOREIGN KEY (sellingUserID) REFERENCES Users(UserID),
    FOREIGN KEY (buyerUserID) REFERENCES Users(UserID)
);
INSERT INTO Users (UserID, Name, email, mobileNumber, BuyerSeller, Location, Ratings)
VALUES
(1, 'John Doe', 'john.doe@example.com', '1234567890', 'Buyer', 'New York', 4.5),
(2, 'Jane Smith', 'jane.smith@example.com', '9876543210', 'Seller', 'Los Angeles', 4.2),
(3, 'Michael Johnson', 'michael.j@example.com', '5555555555', 'Both', 'Chicago', 4.8),
(4, 'Alice Garcia', 'alice.g@example.com', '2223334444', 'Buyer', 'Miami', 4.7),
(5, 'David Hernandez', 'david.h@example.com', '3334445555', 'Seller', 'Houston', 4.3),
(6, 'Sarah Wilson', 'sarah.w@example.com', '4445556666', 'Both', 'Phoenix', 4.0),
(7, 'Robert Miller', 'robert.m@example.com', '5556667777', 'Buyer', 'San Antonio', 4.9),
(8, 'Ashley Young', 'ashley.y@example.com', '6667778888', 'Seller', 'San Diego', 4.1),
(9, 'Brian Lee', 'brian.l@example.com', '7778889999', 'Both', 'Dallas', 4.6),
(10, 'Emily Walker', 'emily.w@example.com', '8889990000', 'Buyer', 'San Jose', 4.4),
(11, 'Charles Rodriguez', 'charles.r@example.com', '9990001111', 'Seller', 'Atlanta', 4.8),
(12, 'Katherine Thomas', 'katherine.t@example.com', '0001112222', 'Buyer', 'Seattle', 4.2),
(13, 'William Jackson', 'william.j@example.com', '1112223333', 'Both', 'Denver', 4.9),
(14, 'Elizabeth Brown', 'elizabeth.b@example.com', '2223394444', 'Seller', 'Washington DC', 4.5),
(15, 'Joseph Garcia', 'joseph.g@example.com', '3334495555', 'Buyer', 'Las Vegas',  4.1);

