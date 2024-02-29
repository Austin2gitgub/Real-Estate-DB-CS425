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
    TenentID INT, -- In the context of rentals, this might be more accurately named TenantID
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID),
    FOREIGN KEY (SellerID) REFERENCES Users(UserID),
    FOREIGN KEY (TenentID) REFERENCES Users(UserID) -- consider renaming BuyerID to TenantID for clarity
);


-- Created tables



-- inserting data now



-- Insert 30 records into the Users table with fake data
INSERT INTO Users (UserID, Name, email, mobileNumber, BuyerSeller, Address)
VALUES
    (1, 'John Doe', 'john.doe@example.com', '123-456-7890', 'Buyer', '123 Main St, Anytown, USA'),
    (2, 'Jane Smith', 'jane.smith@example.com', '987-654-3210', 'Seller', '456 Elm St, Othertown, USA'),
    (3, 'Michael Johnson', 'michael.johnson@example.com', '555-123-4567', 'Both', '789 Oak St, Somewhere, USA'),
    -- Insert more records as needed, generating fake data for each attribute
    -- You can use random name generators or tools to generate fake data for testing purposes
    -- For demonstration, I'll insert 27 more records with randomly generated data
    (4, 'Emily Wilson', 'emily.wilson@example.com', '111-222-3333', 'Buyer', '321 Pine St, Anycity, USA'),
    (5, 'David Lee', 'david.lee@example.com', '444-555-6666', 'Seller', '987 Cedar Ave, Othertown, USA'),
    (6, 'Sarah Brown', 'sarah.brown@example.com', '777-888-9999', 'Both', '654 Birch Ln, Anywhere, USA'),
    -- Continue inserting more records until you have 30
    (7, 'Robert Taylor', 'robert.taylor@example.com', '111-222-3333', 'Buyer', '789 Maple St, Somewhere, USA'),
    (8, 'Amanda Martinez', 'amanda.martinez@example.com', '444-555-6666', 'Seller', '456 Walnut Dr, Anycity, USA'),
    (9, 'Christopher Harris', 'christopher.harris@example.com', '777-888-9999', 'Both', '321 Oak Ave, Othertown, USA'),
    (10, 'Stephanie Clark', 'stephanie.clark@example.com', '111-222-3333', 'Buyer', '987 Elm St, Anytown, USA'),
    (11, 'Matthew Young', 'matthew.young@example.com', '444-555-6666', 'Seller', '654 Pine St, Anycity, USA'),
    (12, 'Jennifer King', 'jennifer.king@example.com', '777-888-9999', 'Both', '123 Cedar Ln, Somewhere, USA'),
    (13, 'Daniel Scott', 'daniel.scott@example.com', '111-222-3333', 'Buyer', '789 Birch St, Othertown, USA'),
    (14, 'Lisa Rodriguez', 'lisa.rodriguez@example.com', '444-555-6666', 'Seller', '456 Oak Dr, Anywhere, USA'),
    (15, 'Mark Lewis', 'mark.lewis@example.com', '777-888-9999', 'Both', '321 Elm Ave, Anytown, USA'),
    (16, 'Karen Hall', 'karen.hall@example.com', '111-222-3333', 'Buyer', '987 Maple St, Anycity, USA'),
    (17, 'Jason Adams', 'jason.adams@example.com', '444-555-6666', 'Seller', '654 Walnut Ln, Somewhere, USA'),
    (18, 'Michelle Cook', 'michelle.cook@example.com', '777-888-9999', 'Both', '123 Pine St, Othertown, USA'),
    (19, 'Andrew Wright', 'andrew.wright@example.com', '111-222-3333', 'Buyer', '789 Cedar Dr, Anywhere, USA'),
    (20, 'Jessica Turner', 'jessica.turner@example.com', '444-555-6666', 'Seller', '456 Birch Ave, Anytown, USA'),
    (21, 'Ryan Parker', 'ryan.parker@example.com', '777-888-9999', 'Both', '321 Elm St, Othertown, USA'),
    (22, 'Lauren Scott', 'lauren.scott@example.com', '111-222-3333', 'Buyer', '987 Pine Ln, Anywhere, USA'),
    (23, 'Justin Diaz', 'justin.diaz@example.com', '444-555-6666', 'Seller', '654 Cedar St, Anycity, USA'),
    (24, 'Ashley Martinez', 'ashley.martinez@example.com', '777-888-9999', 'Both', '123 Walnut Dr, Somewhere, USA'),
    (25, 'Nicholas Nelson', 'nicholas.nelson@example.com', '111-222-3333', 'Buyer', '789 Oak Ave, Othertown, USA'),
    (26, 'Brittany Hill', 'brittany.hill@example.com', '444-555-6666', 'Seller', '456 Pine St, Anywhere, USA'),
    (27, 'Kevin Ramirez', 'kevin.ramirez@example.com', '777-888-9999', 'Both', '321 Cedar Ln, Anytown, USA'),
    (28, 'Megan Carter', 'megan.carter@example.com', '111-222-3333', 'Buyer', '987 Elm St, Anycity, USA'),
    (29, 'Joshua Barnes', 'joshua.barnes@example.com', '444-555-6666', 'Seller', '654 Maple Dr, Somewhere, USA'),
    (30, 'Heather Cooper', 'heather.cooper@example.com', '777-888-9999', 'Both', '123 Birch Ave, Othertown, USA');




-- Agents table now



INSERT INTO Agents (AgentID, UserID, AgentCompany, Agent_Name, Experience, Location, Languages)
VALUES
    (1, 2, 'Prestige Realty', 'Jane Smith', 5, 'San Francisco, CA', 'English, Spanish'),
    (2, 5, 'Homeward Bound', 'David Lee', 8, 'Austin, TX', 'English, French'),
    (3, 8, 'NextHome Leaders', 'Amanda Martinez', 10, 'Miami, FL', 'English, Portuguese'),
    (4, 11, 'Skyline Agents', 'Matthew Young', 4, 'Seattle, WA', 'English, German'),
    (5, 14, 'Horizon Properties', 'Lisa Rodriguez', 6, 'Denver, CO', 'English, Italian'),
    (6, 17, 'Prime Estate', 'Jason Adams', 7, 'Boston, MA', 'English, Russian'),
    (7, 20, 'Elite Realty Group', 'Jessica Turner', 9, 'Chicago, IL', 'English, Mandarin'),
    (8, 23, 'Trusty Homes', 'Justin Diaz', 3, 'Las Vegas, NV', 'English, Japanese'),
    (9, 26, 'Home Connect', 'Brittany Hill', 11, 'Nashville, TN', 'English, Korean'),
    (10, 29, 'Global Realtors', 'Joshua Barnes', 2, 'New York, NY', 'English, Dutch');
