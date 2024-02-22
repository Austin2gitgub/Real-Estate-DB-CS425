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


