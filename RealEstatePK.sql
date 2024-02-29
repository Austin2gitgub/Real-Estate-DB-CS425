create database RealEstate_Final;
use RealEstate_Final;

-- Creating User table
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Name VARCHAR(255),
    email VARCHAR(255),
    mobileNumber VARCHAR(20),
    BuyerSellerAgent ENUM('Buyer', 'Seller', 'Both', 'Agent'),
    Address VARCHAR(255)
);

-- Creating Agent table
CREATE TABLE Agents (
    AgentID INT primary key,
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
INSERT INTO Users (UserID, Name, email, mobileNumber, BuyerSellerAgent, Address)
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
    (30, 'Heather Cooper', 'heather.cooper@example.com', '777-888-9999', 'Both', '123 Birch Ave, Othertown, USA'),
    (31, 'Alice Johnson', 'alice.johnson@realestate.com', '202-555-0178', 'Agent', '101 Realty Drive, Cityville, USA'),
    (32, 'Bob Smith', 'bob.smith@realestate.com', '202-555-0199', 'Agent', '202 Estate Road, Townsville, USA'),
    (33, 'Cathy Daniels', 'cathy.daniels@realestate.com', '202-555-0143', 'Agent', '303 Agent Ave, Urbantown, USA'),
    (34, 'David Green', 'david.green@realestate.com', '202-555-0124', 'Agent', '404 Property Pl, Cityscape, USA'),
    (35, 'Eva Lawrence', 'eva.lawrence@realestate.com', '202-555-0155', 'Agent', '505 Realty Row, Suburbia, USA'),
    (36, 'Frank Moore', 'frank.moore@realestate.com', '202-555-0186', 'Agent', '606 Listing Lane, Metropolis, USA'),
    (37, 'Gina Hall', 'gina.hall@realestate.com', '202-555-0137', 'Agent', '707 Housing St, Smalltown, USA'),
    (38, 'Henry Allen', 'henry.allen@realestate.com', '202-555-0118', 'Agent', '808 Home Blvd, Villagetown, USA'),
    (39, 'Ivy Wilson', 'ivy.wilson@realestate.com', '202-555-0169', 'Agent', '909 Estate St, Capital City, USA'),
    (40, 'Jake Foster', 'jake.foster@realestate.com', '202-555-0140', 'Agent', '1010 Property Ave, Seaside, USA');


select count(*) from Users
where BuyerSellerAgent in ('Seller', 'Both'); 


-- Agents table now
delete from agents;
set sql_safe_updates = 0;


INSERT INTO Agents (AgentID, UserID, AgentCompany, Agent_Name, Experience, Location, Languages)
VALUES
    (1, 32, 'Prestige Realty', 'Jane Smith', 5, 'San Francisco, CA', 'English, Spanish'),
    (2, 33, 'Homeward Bound', 'Michael Johnson', 7, 'Austin, TX', 'English, French'),
    (3, 35, 'NextHome Leaders', 'David Lee', 8, 'Miami, FL', 'English, Portuguese'),
    (4, 36, 'Skyline Agents', 'Sarah Brown', 4, 'Seattle, WA', 'English, German'),
    (5, 38, 'Horizon Properties', 'Amanda Martinez', 6, 'Denver, CO', 'English, Italian'),
    (6, 39, 'Prime Estate', 'Christopher Harris', 7, 'Boston, MA', 'English, Russian'),
    (7, 31, 'Elite Realty Group', 'Matthew Young', 9, 'Chicago, IL', 'English, Mandarin'),
    (8, 37, 'Trusty Homes', 'Jennifer King', 3, 'Las Vegas, NV', 'English, Japanese'),
    (9, 34, 'Home Connect', 'Lisa Rodriguez', 11, 'Nashville, TN', 'English, Korean'),
    (10, 40, 'Global Realtors', 'Mark Lewis', 2, 'New York, NY', 'English, Dutch');


SELECT distinct UserID FROM Agents;


select userId, agentid from agents;


-- Time for the Properties tables now lessgo
--  The lot size is in acres btw



INSERT INTO Properties (PropertyID, AgentID, Status, Address, ZipCode, City, State, SquareFeet, Price, Type, LotSize, Beds, Baths)
VALUES
(1, 1, 'sold', '1001 Vista Blvd', '90001', 'Los Angeles', 'CA', 2200, 800000.00, 'House', 0.15, 4, 2),
(2, 2, 'sold', '2207 Oak Drive', '10001', 'New York', 'NY', 1800, 1200000.00, 'Apartment', 0.00, 3, 2),
(3, 3, 'sold', '3487 Pine Street', '60601', 'Chicago', 'IL', 2000, 650000.00, 'House', 0.12, 3, 2),
(4, 4, 'sold', '4920 Maple Ave', '77001', 'Houston', 'TX', 2400, 550000.00, 'House', 0.18, 4, 3),
(5, 5, 'sold', '5832 Cedar St', '94101', 'San Francisco', 'CA', 1500, 950000.00, 'Condo', 0.00, 2, 2),
(6, 6, 'sold', '6409 Birch Road', '33101', 'Miami', 'FL', 2100, 700000.00, 'House', 0.20, 4, 3),
(7, 7, 'sold', '7812 Elm Drive', '98101', 'Seattle', 'WA', 1900, 800000.00, 'House', 0.14, 3, 2),
(8, 8, 'sold', '8304 Oak Lane', '20001', 'Washington', 'DC', 1700, 750000.00, 'Townhouse', 0.05, 3, 2),
(9, 9, 'sold', '9703 Pine Court', '30301', 'Atlanta', 'GA', 2100, 600000.00, 'House', 0.17, 3, 3),
(10, 10, 'sold', '10234 Maple Blvd', '89101', 'Las Vegas', 'NV', 2300, 480000.00, 'House', 0.22, 4, 3),
(11, 11, 'sold', '11120 Birch Street', '85001', 'Phoenix', 'AZ', 2500, 530000.00, 'House', 0.25, 5, 4),
(12, 12, 'sold', '12345 Cedar Ave', '02101', 'Boston', 'MA', 1600, 1100000.00, 'Apartment', 0.00, 2, 2),
(13, 13, 'sold', '13098 Elm Street', '37201', 'Nashville', 'TN', 2200, 460000.00, 'House', 0.19, 3, 2),
(14, 14, 'sold', '14802 Oak Drive', '48201', 'Detroit', 'MI', 1900, 420000.00, 'House', 0.16, 4, 2),
(15, 15, 'sold', '15703 Pine Lane', '80201', 'Denver', 'CO', 1800, 690000.00, 'House', 0.11, 3, 2),
(16, 17, 'unsold', '1604 Maple Dr', '32801', 'Orlando', 'FL', 1400, 300000.00, 'Condo', 0.00, 2, 2),
(17, 6, 'unsold', '1725 Cedar St', '97201', 'Portland', 'OR', 2000, 450000.00, 'House', 0.13, 3, 2),
(18, 9, 'unsold', '1846 Elm Ave', '78701', 'Austin', 'TX', 2200, 510000.00, 'House', 0.20, 4, 3),
(19, 20, 'unsold', '1957 Oak Blvd', '94101', 'San Francisco', 'CA', 1200, 1100000.00, 'Condo', 0.00, 1, 1),
(20, 14, 'unsold', '2098 Pine St', '10001', 'New York', 'NY', 1700, 1400000.00, 'Apartment', 0.00, 3, 2),
(21, 3, 'unsold', '2211 Birch Rd', '32801', 'Orlando', 'FL', 1300, 350000.00, 'Condo', 0.00, 2, 1),
(22, 8, 'unsold', '2375 Cedar Lane', '97201', 'Portland', 'OR', 1950, 470000.00, 'House', 0.14, 3, 2),
(23, 11, 'unsold', '2486 Elm Street', '78701', 'Austin', 'TX', 2150, 520000.00, 'House', 0.21, 4, 3),
(24, 15, 'unsold', '2597 Oak Drive', '94101', 'San Francisco', 'CA', 1150, 1050000.00, 'Condo', 0.00, 1, 1),
(25, 18, 'unsold', '2678 Pine Street', '10001', 'New York', 'NY', 1650, 1350000.00, 'Apartment', 0.00, 2, 2),
(26, 1, 'unsold', '2761 Birch Avenue', '32801', 'Orlando', 'FL', 1450, 320000.00, 'Condo', 0.00, 2, 2),
(27, 5, 'unsold', '2845 Cedar Way', '97201', 'Portland', 'OR', 1980, 460000.00, 'House', 0.15, 3, 2),
(28, 7, 'unsold', '2936 Elm Road', '78701', 'Austin', 'TX', 2100, 500000.00, 'House', 0.22, 4, 2),
(29, 12, 'unsold', '3027 Oak Street', '94101', 'San Francisco', 'CA', 1100, 1080000.00, 'Condo', 0.00, 1, 1),
(30, 4, 'unsold', '3189 Pine Lane', '10001', 'New York', 'NY', 1600, 1300000.00, 'Apartment', 0.00, 3, 2),
(31, 2, 'Rent', '3301 Cedar Park', '90001', 'Los Angeles', 'CA', 850, 2500.00, 'Apartment', 0.00, 1, 1),
(32, 10, 'Rent', '3420 Birch Street', '60601', 'Chicago', 'IL', 900, 2200.00, 'Apartment', 0.00, 2, 1),
(33, 16, 'Rent', '3539 Oak Avenue', '77001', 'Houston', 'TX', 1200, 1800.00, 'Townhouse', 0.05, 2, 2),
(34, 13, 'Rent', '3658 Pine Road', '30301', 'Atlanta', 'GA', 1100, 1950.00, 'Condo', 0.00, 2, 2),
(35, 19, 'Rent', '3767 Elm Drive', '98101', 'Seattle', 'WA', 750, 2100.00, 'Studio', 0.00, 0, 1),
(36, 4, 'Rent', '3886 Birch Lane', '02101', 'Boston', 'MA', 950, 2300.00, 'Apartment', 0.00, 1, 1),
(37, 18, 'Rent', '3995 Cedar Plaza', '33101', 'Miami', 'FL', 1000, 2200.00, 'Apartment', 0.00, 2, 2),
(38, 7, 'Rent', '4014 Oak Street', '10001', 'New York', 'NY', 700, 3500.00, 'Studio', 0.00, 0, 1),
(39, 12, 'Rent', '4133 Pine Avenue', '94101', 'San Francisco', 'CA', 800, 2700.00, 'Condo', 0.00, 1, 1),
(40, 1, 'Rent', '4252 Birch Road', '90001', 'Los Angeles', 'CA', 1300, 3100.00, 'Apartment', 0.00, 3, 2),
(41, 9, 'Rent', '4371 Elm Street', '60601', 'Chicago', 'IL', 1150, 2500.00, 'Condo', 0.00, 2, 2),
(42, 5, 'Rent', '4480 Oak Lane', '77001', 'Houston', 'TX', 1400, 1600.00, 'Townhouse', 0.06, 3, 2),
(43, 3, 'Rent', '4599 Pine Road', '30301', 'Atlanta', 'GA', 1050, 2000.00, 'Condo', 0.00, 2, 1),
(44, 8, 'Rent', '4718 Elm Drive', '98101', 'Seattle', 'WA', 800, 2050.00, 'Studio', 0.00, 0, 1),
(45, 6, 'Rent', '4837 Birch Avenue', '02101', 'Boston', 'MA', 1200, 2400.00, 'Apartment', 0.00, 2, 2);




-- Doing Sold properties now
select Userid from Users
where buyerseller in ('buyer', 'both');





