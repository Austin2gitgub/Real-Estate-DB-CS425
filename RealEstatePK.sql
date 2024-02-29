create database RealEstate;
use RealEstate;

-- Creating User table
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Name VARCHAR(255),
    email VARCHAR(255),
    mobileNumber VARCHAR(20),
    BuyerSeller ENUM('Buyer', 'Seller', 'Both'),
    Address VARCHAR(255)
);

-- Creating Agent table
CREATE TABLE Agents (
    AgentID INT PRIMARY KEY,
    UserID INT,
    AgentCompany VARCHAR(255),
    -- propertyID INT,
    Agent_Name VARCHAR(255),
    Experience INT,
    Location VARCHAR(255),
    Languages VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
    -- Assuming propertyID is a reference to a specific property managed by the agent. 
    -- This design might be reconsidered based on real-world requirements.
    -- FOREIGN KEY (propertyID) REFERENCES Properties(PropertyID)
);

-- Creating Properties table
CREATE TABLE Properties (
    PropertyID INT PRIMARY KEY,
    AgentID INT,
    Status ENUM('sold', 'unsold', 'Rent'),
    Address VARCHAR(255),
    ZipCode VARCHAR(10),
    City VARCHAR(255),
    State VARCHAR(255),
    SquareFeet INT,
    Price DECIMAL(10, 2),
    Type VARCHAR(50),
    LotSize DECIMAL(10, 2),
    Beds INT,
    Baths INT,
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);

-- Adjusting the Agent table to remove propertyID since it creates a circular dependency and is not practical
-- ALTER TABLE Agents DROP COLUMN propertyID;

-- Creating SoldProperties table
CREATE TABLE SoldProperties (
    Sold_SNumber INT PRIMARY KEY,
    PropertyID INT,
    SoldPrice DECIMAL(10, 2),
    SoldDate DATE,
    AgentID INT,
    BuyerID INT,
    SellerID INT,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID),
    FOREIGN KEY (BuyerID) REFERENCES Users(UserID),
    FOREIGN KEY (SellerID) REFERENCES Users(UserID)
);

-- Creating UnsoldProperties table
CREATE TABLE UnsoldProperties (
    Unsold_SNumber INT PRIMARY KEY,
    PropertyID INT,
    Price DECIMAL(10, 2),
    SellerID INT,
    daysOnMarket INT,
    Status ENUM('Active', 'pre-release'),
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (SellerID) REFERENCES Users(UserID)
);

-- Creating RentProperties table
CREATE TABLE RentProperties (
    Rent_SNumber INT PRIMARY KEY,
    PropertyID INT,
    RentPrice DECIMAL(10, 2),
    Location VARCHAR(255),
    AgentID INT,
    SellerID INT,
    BuyerID INT, -- In the context of rentals, this might be more accurately named TenantID
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID),
    FOREIGN KEY (SellerID) REFERENCES Users(UserID),
    FOREIGN KEY (BuyerID) REFERENCES Users(UserID) -- Again, consider renaming BuyerID to TenantID for clarity
);
