create database RealEstate_Final_Final;
use RealEstate_Final_Final;

-- -- Creating User table
CREATE TABLE Users (
    UserID INT PRIMARY KEY auto_increment,
    Name VARCHAR(255),
    email VARCHAR(255),
    mobileNumber VARCHAR(20),
    BuyerSellerAgent ENUM('Buyer', 'Seller', 'Both', 'Agent'),
    Address VARCHAR(255)
);



-- -- Creating Agent table
CREATE TABLE Agents (
    AgentID INT primary key auto_increment,
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


-- -- Creating Properties table
CREATE TABLE Properties (
    PropertyID INT PRIMARY KEY auto_increment,
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

-- -- Adjusting the Agent table to remove propertyID since it creates a circular dependency and is not practical
-- -- ALTER TABLE Agents DROP COLUMN propertyID;

-- -- Creating SoldProperties table
CREATE TABLE SoldProperties (
    Sold_SNumber INT PRIMARY KEY auto_increment,
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

-- -- Creating UnsoldProperties table
-- -- drop table unsoldproperties;
CREATE TABLE UnsoldProperties (
    Unsold_SNumber INT PRIMARY KEY auto_increment,
    PropertyID INT,
    Price DECIMAL(10, 2),
    SellerID INT,
    daysOnMarket INT,
    Status ENUM('Active', 'pre-release'),
    AgentID int,
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID),
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (SellerID) REFERENCES Users(UserID)
);

-- -- Creating RentProperties table
-- -- drop table rentproperties;
CREATE TABLE RentProperties (
    Rent_SNumber INT PRIMARY KEY auto_increment,
    PropertyID INT,
    RentPrice DECIMAL(10, 2),
    Location VARCHAR(255),
    AgentID INT,
    SellerID INT,
    TenantID INT, -- In the context of rentals, this might be more accurately named TenantID
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID),
    FOREIGN KEY (SellerID) REFERENCES Users(UserID),
    FOREIGN KEY (TenantID) REFERENCES Users(UserID) -- consider renaming BuyerID to TenantID for clarity
);


-- -- Created tables



-- -- inserting data now



-- -- Insert 30 records into the Users table
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


-- select count(*) from Users
-- where BuyerSellerAgent in ('Seller', 'Both'); 


-- -- Agents table now
-- delete from agents;
-- set sql_safe_updates = 0;


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


-- SELECT distinct UserID FROM Agents;


-- select userId, agentid from agents;






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
(11, 1, 'sold', '11120 Birch Street', '85001', 'Phoenix', 'AZ', 2500, 530000.00, 'House', 0.25, 5, 4),
(12, 2, 'sold', '12345 Cedar Ave', '02101', 'Boston', 'MA', 1600, 1100000.00, 'Apartment', 0.00, 2, 2),
(13, 3, 'sold', '13098 Elm Street', '37201', 'Nashville', 'TN', 2200, 460000.00, 'House', 0.19, 3, 2),
(14, 4, 'sold', '14802 Oak Drive', '48201', 'Detroit', 'MI', 1900, 420000.00, 'House', 0.16, 4, 2),
(15, 5, 'sold', '15703 Pine Lane', '80201', 'Denver', 'CO', 1800, 690000.00, 'House', 0.11, 3, 2),
(16, 7, 'unsold', '1604 Maple Dr', '32801', 'Orlando', 'FL', 1400, 300000.00, 'Condo', 0.00, 2, 2),
(17, 6, 'unsold', '1725 Cedar St', '97201', 'Portland', 'OR', 2000, 450000.00, 'House', 0.13, 3, 2),
(18, 9, 'unsold', '1846 Elm Ave', '78701', 'Austin', 'TX', 2200, 510000.00, 'House', 0.20, 4, 3),
(19, 2, 'unsold', '1957 Oak Blvd', '94101', 'San Francisco', 'CA', 1200, 1100000.00, 'Condo', 0.00, 1, 1),
(20, 4, 'unsold', '2098 Pine St', '10001', 'New York', 'NY', 1700, 1400000.00, 'Apartment', 0.00, 3, 2),
(21, 3, 'unsold', '2211 Birch Rd', '32801', 'Orlando', 'FL', 1300, 350000.00, 'Condo', 0.00, 2, 1),
(22, 8, 'unsold', '2375 Cedar Lane', '97201', 'Portland', 'OR', 1950, 470000.00, 'House', 0.14, 3, 2),
(23, 1, 'unsold', '2486 Elm Street', '78701', 'Austin', 'TX', 2150, 520000.00, 'House', 0.21, 4, 3),
(24, 5, 'unsold', '2597 Oak Drive', '94101', 'San Francisco', 'CA', 1150, 1050000.00, 'Condo', 0.00, 1, 1),
(25, 8, 'unsold', '2678 Pine Street', '10001', 'New York', 'NY', 1650, 1350000.00, 'Apartment', 0.00, 2, 2),
(26, 1, 'unsold', '2761 Birch Avenue', '32801', 'Orlando', 'FL', 1450, 320000.00, 'Condo', 0.00, 2, 2),
(27, 5, 'unsold', '2845 Cedar Way', '97201', 'Portland', 'OR', 1980, 460000.00, 'House', 0.15, 3, 2),
(28, 7, 'unsold', '2936 Elm Road', '78701', 'Austin', 'TX', 2100, 500000.00, 'House', 0.22, 4, 2),
(29, 2, 'unsold', '3027 Oak Street', '94101', 'San Francisco', 'CA', 1100, 1080000.00, 'Condo', 0.00, 1, 1),
(30, 4, 'unsold', '3189 Pine Lane', '10001', 'New York', 'NY', 1600, 1300000.00, 'Apartment', 0.00, 3, 2),
(31, 2, 'Rent', '3301 Cedar Park', '90001', 'Los Angeles', 'CA', 850, 2500.00, 'Apartment', 0.00, 1, 1),
(32, 7, 'Rent', '3420 Birch Street', '60601', 'Chicago', 'IL', 900, 2200.00, 'Apartment', 0.00, 2, 1),
(33, 6, 'Rent', '3539 Oak Avenue', '77001', 'Houston', 'TX', 1200, 1800.00, 'Townhouse', 0.05, 2, 2),
(34, 3, 'Rent', '3658 Pine Road', '30301', 'Atlanta', 'GA', 1100, 1950.00, 'Condo', 0.00, 2, 2),
(35, 9, 'Rent', '3767 Elm Drive', '98101', 'Seattle', 'WA', 750, 2100.00, 'Studio', 0.00, 0, 1),
(36, 4, 'Rent', '3886 Birch Lane', '02101', 'Boston', 'MA', 950, 2300.00, 'Apartment', 0.00, 1, 1),
(37, 8, 'Rent', '3995 Cedar Plaza', '33101', 'Miami', 'FL', 1000, 2200.00, 'Apartment', 0.00, 2, 2),
(38, 7, 'Rent', '4014 Oak Street', '10001', 'New York', 'NY', 700, 3500.00, 'Studio', 0.00, 0, 1),
(39, 2, 'Rent', '4133 Pine Avenue', '94101', 'San Francisco', 'CA', 800, 2700.00, 'Condo', 0.00, 1, 1),
(40, 9, 'Rent', '4252 Birch Road', '90001', 'Los Angeles', 'CA', 1300, 3100.00, 'Apartment', 0.00, 3, 2),
(41, 9, 'Rent', '4371 Elm Street', '60601', 'Chicago', 'IL', 1150, 2500.00, 'Condo', 0.00, 2, 2),
(42, 5, 'Rent', '4480 Oak Lane', '77001', 'Houston', 'TX', 1400, 1600.00, 'Townhouse', 0.06, 3, 2),
(43, 3, 'Rent', '4599 Pine Road', '30301', 'Atlanta', 'GA', 1050, 2000.00, 'Condo', 0.00, 2, 1),
(44, 8, 'Rent', '4718 Elm Drive', '98101', 'Seattle', 'WA', 800, 2050.00, 'Studio', 0.00, 0, 1),
(45, 6, 'Rent', '4837 Birch Avenue', '02101', 'Boston', 'MA', 1200, 2400.00, 'Apartment', 0.00, 2, 2);




-- -- Doing Sold properties now
-- select Userid from Users
-- where buyersellerAgent in ('seller', 'both');

-- select * from properties;



INSERT INTO SoldProperties (Sold_SNumber, PropertyID, SoldPrice, SoldDate, AgentID, BuyerID, SellerID)
VALUES 
(1, 1, 800000.00, '2023-03-15', 4, 1, 2),
(2, 2, 1200000.00, '2023-04-10', 2, 3, 5),
(3, 3, 650000.00, '2023-05-21', 6, 4, 6),
(4, 4, 550000.00, '2023-06-07', 3, 6, 8),
(5, 5, 950000.00, '2023-07-19', 1, 7, 9),
(6, 6, 700000.00, '2023-08-05', 5, 9, 11),
(7, 7, 800000.00, '2023-09-16', 7, 10, 12),
(8, 8, 750000.00, '2023-10-03', 9, 12, 14),
(9, 9, 600000.00, '2023-11-22', 8, 13, 15),
(10, 10, 480000.00, '2023-12-09', 10, 15, 17),
(11, 11, 530000.00, '2024-01-18', 2, 16, 18),
(12, 12, 1100000.00, '2024-02-28', 4, 18, 20),
(13, 13, 460000.00, '2024-03-07', 3, 19, 21),
(14, 14, 420000.00, '2024-04-15', 5, 21, 23),
(15, 15, 690000.00, '2024-05-05', 6, 22, 24);


--     








INSERT INTO UnsoldProperties (Unsold_SNumber, PropertyID, Price, SellerID, AgentID, daysOnMarket, Status)
VALUES
(1, 16, 295000.00, 2, 3, 45, 'Active'),
(2, 17, 440000.00, 3, 2, 60, 'Pre-release'),
(3, 18, 500000.00, 5, 1, 30, 'Active'),
(4, 19, 1080000.00, 6, 7, 75, 'Active'),
(5, 20, 1380000.00, 8, 5, 15, 'Pre-release'),
(6, 21, 350000.00, 23, 5, 40, 'Active'),
(7, 22, 465000.00, 9, 6, 90, 'Active'),
(8, 23, 515000.00, 11, 7, 50, 'Pre-release'),
(9, 24, 1040000.00, 12, 4, 20, 'Active'),
(10, 25, 1330000.00, 14, 9, 85, 'Active'),
(11, 26, 315000.00, 15, 10, 10, 'Pre-release'),
(12, 27, 455000.00, 17, 8, 55, 'Active'),
(13, 28, 495000.00, 18, 2, 25, 'Pre-release'),
(14, 29, 1060000.00, 20, 10, 65, 'Active'),
(15, 30, 1280000.00, 21, 3, 35, 'Active');









INSERT INTO RentProperties (Rent_SNumber, PropertyID, RentPrice, AgentID, SellerID, TenantID)
VALUES
(1, 31, 2500, 7, 2, 3),
(2, 32, 2200, 1, 3, 1),
(3, 33, 1800, 9, 5, 4),
(4, 34, 1950, 3, 8, 7),
(5, 35, 2100, 5, 11, 9),
(6, 36, 2300, 2, 14, 12),
(7, 37, 2200, 4, 17, 15),
(8, 38, 3500, 6, 20, 18),
(9, 39, 2700, 8, 23, 19),
(10, 40, 3100, 10, 26, 22),
(11, 41, 2500, 7, 27, 24),
(12, 42, 1600, 1, 29, 25),
(13, 43, 2000, 3, 30, 27),
(14, 44, 2050, 5, 21, 28),
(15, 45, 2400, 2, 18, 30);






-- -- Testing

-- select * from soldproperties INNER JOIN properties ON soldproperties.PropertyID = Properties.PropertyID;

-- -- Negotiations might be a buisness logic




















-- Views

-- Number of properties sold by each agent

CREATE VIEW AgentSales AS
SELECT AgentID, COUNT(*) AS TotalSales FROM SoldProperties
GROUP BY AgentID;

-- Properties Listing Views

CREATE VIEW PropertiesListings AS
SELECT p.PropertyID, p.Address, p.Type, IFNULL(sp.SoldPrice, up.Price) AS Price, IF(sp.SoldDate IS NULL, 'Available', 'Sold') AS Status FROM properties p
LEFT JOIN SoldProperties sp ON p.PropertyID = sp.PropertyID
LEFT JOIN UnsoldProperties up ON p.PropertyID = up.PropertyID;

-- Agent performances

CREATE VIEW AgentPerformance AS
SELECT AgentID, COUNT(*) AS PropertiesSold, SUM(SoldPrice) AS TotalSalesValue, AVG(SoldPrice) AS AverageSalePrice FROM SoldProperties
GROUP BY AgentID;

-- A view to analyze the sales trends over time

CREATE VIEW MonthlySalesTrends AS
SELECT YEAR(SoldDate) AS Year, MONTH(SoldDate) AS Month, COUNT(*) AS PropertiesSold, SUM(SoldPrice) AS TotalSalesValue FROM SoldProperties
GROUP BY YEAR(SoldDate), MONTH(SoldDate);

-- Active Listings along with Agent Information

CREATE VIEW ActiveListingsWithAgents AS
SELECT up.PropertyID, up.Price, up.daysOnMarket, up.Status, u.UserID AS AgentID, u.Name FROM UnsoldProperties up
JOIN Users u ON up.AgentID = u.UserID
WHERE up.Status = 'Active';

-- A view focusing on properties available for rent

CREATE VIEW RentalPropertiesOverview AS
SELECT rp.PropertyID, rp.RentPrice, u1.UserID AS AgentID, u1.Name AS AgentName, u2.UserID AS TenantID, u2.Name  AS TenantName FROM RentProperties rp
JOIN Users u1 ON rp.AgentID = u1.UserID
LEFT JOIN Users u2 ON rp.TenantID = u2.UserID;

-- Most Recent Sales

CREATE VIEW RecentSales AS
SELECT sp.PropertyID, sp.SoldPrice, sp.SoldDate, u.UserID AS AgentID, u.Name
FROM SoldProperties sp
JOIN Users u ON sp.AgentID = u.UserID
ORDER BY sp.SoldDate DESC;


-- Do more like filterling properties by location, type, price, and more etc




-- An index on PropertyID in the properties table would speed up lookups, joins, and searches based on PropertyID.
CREATE INDEX idx_property_id ON properties(PropertyID);

-- Address on Properties Table: If queries often search by address, an index here would help.
CREATE INDEX idx_address ON properties(Address);

-- AgentID on SoldProperties: Improves the performance of queries filtering by AgentID, common in reporting and analytics.
CREATE INDEX idx_soldproperties_agentid ON SoldProperties(AgentID);
-- SoldDate on SoldProperties: Helps with queries that sort or filter by the sale date, useful for generating sales reports or trends over time.
CREATE INDEX idx_solddate ON SoldProperties(SoldDate);


-- Status on UnsoldProperties: An index on the Status column can speed up queries looking for properties with specific statuses like 'Active' or 'Pre-release'.
CREATE INDEX idx_unsold_status ON UnsoldProperties(Status);

-- daysOnMarket on UnsoldProperties: Optimizes queries sorting or filtering properties based on how long they've been on the market.
CREATE INDEX idx_days_on_market ON UnsoldProperties(daysOnMarket);

-- RentPrice on RentProperties: For queries filtering or sorting based on rental price.
CREATE INDEX idx_rentprice ON RentProperties(RentPrice);

-- buyerSellerAgent on Users: If queries often filter by the role of the user (buyer, seller, agent), an index here would be beneficial.
CREATE INDEX idx_role ON Users(buyerSellerAgent);

-- Composite Index on SoldProperties for Date and Price: If there are common queries that filter or sort by both SoldDate and SoldPrice, a composite index could be useful.
CREATE INDEX idx_solddate_soldprice ON SoldProperties(SoldDate, SoldPrice);






-- Agregated Sales report

CREATE TEMPORARY TABLE MonthlySales AS
SELECT
    EXTRACT(MONTH FROM SoldDate) AS SaleMonth,
    EXTRACT(YEAR FROM SoldDate) AS SaleYear,
    COUNT(*) AS TotalSales,
    AVG(SoldPrice) AS AveragePrice
FROM SoldProperties
GROUP BY SaleMonth, SaleYear;


-- Top Performing Agents

CREATE TEMPORARY TABLE AgentPerformance AS
SELECT
    AgentID,
    COUNT(*) AS PropertiesSold,
    SUM(SoldPrice) AS TotalSalesValue
FROM SoldProperties
GROUP BY AgentID
ORDER BY TotalSalesValue DESC;


--  Properties on Market Duration
CREATE TEMPORARY TABLE MarketDuration AS
SELECT
    p.PropertyID,
    DATEDIFF(sp.SoldDate, p.ListDate) AS DaysOnMarket
FROM Properties p
JOIN SoldProperties sp ON p.PropertyID = sp.PropertyID;

-- Comparison of Listed vs. Sold Prices
CREATE TEMPORARY TABLE PriceComparison AS
SELECT
    p.PropertyID,
    p.Price AS ListedPrice,
    sp.SoldPrice AS SoldPrice,
    (sp.SoldPrice - p.Price) AS PriceDifference
FROM Properties p
JOIN SoldProperties sp ON p.PropertyID = sp.PropertyID;




-- Triggers

-- Trigger to Update Property Status:
DELIMITER //
CREATE TRIGGER Update_Property_Status
AFTER INSERT ON SoldProperties
FOR EACH ROW
BEGIN
    UPDATE Properties
    SET Status = 'sold'
    WHERE PropertyID = NEW.PropertyID;
END;
//
DELIMITER ;

-- Trigger to Update Agent Experience:
DELIMITER //
CREATE TRIGGER Update_Agent_Experience
BEFORE UPDATE ON Agents
FOR EACH ROW
BEGIN
    IF NEW.Experience < OLD.Experience THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Experience cannot be decreased.';
    END IF;
END;
//
DELIMITER ;

-- Trigger to Update Property Price:
DELIMITER //
CREATE TRIGGER Update_Property_Price
AFTER INSERT ON PriceChanges
FOR EACH ROW
BEGIN
    UPDATE Properties
    SET Price = NEW.NewPrice
    WHERE PropertyID = NEW.PropertyID;
END;
//
DELIMITER ;

-- Trigger to update the status of a property to 'rent'
DELIMITER $$
CREATE TRIGGER Update_property_status_to_rent
AFTER INSERT ON RentProperties
FOR EACH ROW
BEGIN
  UPDATE Properties 
    SET Status = 'Rent'
    WHERE PropertyID = NEW.PropertyID;
END$$  
DELIMITER ;












-- Stored procedures

-- Stored Procedure to Retrieve Sold Properties by Agent:
DELIMITER //
CREATE PROCEDURE Get_Sold_Properties_By_Agent(IN agent_id INT)
BEGIN
    SELECT * FROM SoldProperties WHERE AgentID = agent_id;
END;
//
DELIMITER ;

-- Stored Procedure to Insert a New Property:
DELIMITER //
CREATE PROCEDURE Insert_New_Property(
    IN agent_id INT, 
    IN status VARCHAR(255), 
    IN address VARCHAR(255), 
    IN price DECIMAL(10,2), 
    IN beds INT, 
    IN baths INT
)
BEGIN
    INSERT INTO Properties (AgentID, Status, Address, Price, Beds, Baths)
    VALUES (agent_id, status, address, price, beds, baths);
END;
//
DELIMITER ;

-- Stored Procedure to retrieve all properties listed by a specific agent
DELIMITER //
CREATE PROCEDURE GetAgentProperties (IN agentID INT)
BEGIN
    SELECT *
    FROM Properties
    WHERE AgentID = agentID;
END //
DELIMITER ;

-- Stored Procedure to add Properties
DELIMITER //
CREATE PROCEDURE AddProperty(
    IN p_Address VARCHAR(255),
    IN p_Type VARCHAR(50),
    IN p_Price DECIMAL(10, 2),
    IN p_AgentID INT,
    IN p_ListingDate DATE
)
BEGIN
    INSERT INTO Properties(Address, Type, Price, AgentID, ListingDate)
    VALUES (p_Address, p_Type, p_Price, p_AgentID, p_ListingDate);
END //
DELIMITER ;

-- Stored Procedure to delete Properties
DELIMITER //
CREATE PROCEDURE DeleteProperty(IN p_PropertyID INT)
BEGIN
    DELETE FROM Properties WHERE PropertyID = p_PropertyID;
END //
DELIMITER ;

-- Stored Procedure to update price
DELIMITER //
CREATE PROCEDURE UpdatePropertyPrice(
    IN p_PropertyID INT,
    IN p_NewPrice DECIMAL(10, 2)
)
BEGIN
    UPDATE Properties
    SET Price = p_NewPrice
    WHERE PropertyID = p_PropertyID;
END //
DELIMITER ;




-- Functions
-- Function to calculate sales commission
DELIMITER //
CREATE FUNCTION sales_commission(sale_price DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE commission DECIMAL(10,2);
  
  SET commission = sale_price * 0.06;
  
  RETURN (commission);
END //
DELIMITER ;

-- Function to lookup agent name
DELIMITER //
CREATE FUNCTION get_agent_name(agent_id INT)
RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
  DECLARE a_name VARCHAR(255);
  
  SELECT Name INTO a_name
    FROM Users
  WHERE UserID = agent_id;
  
  RETURN (a_name);
END //
DELIMITER ;

-- Function to format property address
DELIMITER //
CREATE FUNCTION format_address(street VARCHAR(255), city VARCHAR(255), state VARCHAR(255), zip VARCHAR(10))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
  DECLARE address VARCHAR(255);

  SET address = CONCAT(street, ', ', city, ', ', state, ' ', zip);
  
  RETURN (address);
END //
DELIMITER ;

-- Function to get days on market
DELIMITER //
CREATE FUNCTION days_on_market(p_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE dom INT;
  
  SELECT DATEDIFF(CURRENT_DATE(), ListDate) 
    INTO dom
  FROM Properties
  WHERE PropertyID = p_id;

  RETURN (dom);
END //
DELIMITER ;

-- Function to calculate property price per square foot:
DELIMITER //
CREATE FUNCTION price_per_sqft(property_id INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE sqft INT;
  DECLARE price DECIMAL(10,2);
  DECLARE ppg DECIMAL(10,2);
  
  SELECT SquareFeet, Price 
    INTO sqft, price
  FROM Properties
  WHERE PropertyID = property_id;
  
  SET ppg = price / sqft;
  
  RETURN (ppg);  
END //
DELIMITER ;


-- New functions for Deliverable #5

-- Set Union
-- Get the demographic location of all our users for advertaisement purposes and personalized ad monitoring

SELECT Address AS 'Demographics of our Users' FROM Users
UNION
SELECT Location FROM Agents;

-- Set EXCEPT
-- Find Properties that are not rented out, ie. unsold & sold properties

SELECT PropertyID, Address FROM properties
WHERE PropertyID NOT IN (SELECT PropertyID FROM rentproperties);

-- SET Membership
-- Show all the properties that AgentID='1' is sold or unsold
SELECT AgentID, PropertyID, Status, Address FROM properties
WHERE AgentID IN (SELECT AgentID FROM Agents WHERE AgentID='1');

-- SET comparison
-- All properties that are less than 500k
SELECT *
FROM properties
WHERE Price < ANY(SELECT Price FROM properties WHERE Price<"500000");

-- WITH clause
-- Finding properties that are above the average price in market

WITH tempTable(averageValue) AS
	(SELECT avg(Price)
    from properties)
		SELECT PropertyID, Address, Status, Price
        FROM properties, tempTable
        WHERE properties.Price > tempTable.averageValue;
        
-- Advanced Aggregate Functions
-- Minimum price to rent or buy in each city
SELECT City, MIN(Price) AS Minimum_Rent_Price_In_Each_Location
FROM properties
GROUP BY City;

-- OLAP
-- total sold properties based on type on the real-estate website
SELECT Type, COUNT(propertyID) AS Total_Sold
FROM properties
WHERE Status = 'sold'
GROUP BY Type;

-- SELECT p.PropertyType, COUNT(*) AS TotalSold
-- FROM SoldProperties sp
-- JOIN Properties p ON sp.PropertyID = p.PropertyID
-- GROUP BY p.PropertyType
-- ORDER BY TotalSold DESC;

-- SELECT p.Type, COUNT(*) AS TotalSold
-- FROM SoldProperties sp
-- JOIN Properties p ON sp.PropertyID = p.PropertyID
-- GROUP BY p.Type
-- ORDER BY TotalSold DESC;

-- SELECT p.City, p.State, ROUND(AVG(sp.SoldPrice),2) AS AvgSellingPrice
-- FROM SoldProperties sp
-- JOIN Properties p ON sp.PropertyID = p.PropertyID
-- GROUP BY p.City, p.State
-- ORDER BY AvgSellingPrice DESC

-- SELECT a.Agent_Name, COUNT(p.PropertyID) AS NumOfProperties
-- FROM Agents a
-- LEFT JOIN Properties p ON a.AgentID = p.AgentID
-- GROUP BY  Agent_Name

-- SELECT 
-- 	ROUND(100 * SUM(IF(Status = 'sold',1,0))/COUNT(*),2) AS PercentSold,
--     ROUND(100 * SUM(IF(Status = 'unsold',1,0))/COUNT(*),2) AS PercentUnSold,
--     ROUND(100 * SUM(IF(Status = 'rent',1,0))/COUNT(*),2) AS PercentRent
-- FROM Properties;

-- SELECT a.Agent_Name, SUM(sp.SoldPrice) AS TotalSalesValue
-- FROM SoldProperties sp
-- JOIN Agents a ON sp.AgentID = a.AgentID
-- GROUP BY a.Agent_Name
-- ORDER BY TotalSalesValue DESC
-- LIMIT 5;

-- SELECT YEAR(SoldDate) AS Year, MONTH(SoldDate) AS Month, ROUND(AVG(SoldPrice),2) AS AvgSoldPrice
-- FROM SoldProperties
-- GROUP BY YEAR(SoldDate), MONTH(SoldDate)
-- ORDER BY Year, Month;

-- SELECT Type, ROUND(AVG(Price / SquareFeet),2) AS AvgPricePerSqft
-- FROM Properties
-- GROUP BY Type;

-- SELECT Address, LotSize
-- FROM Properties
-- WHERE LotSize > 0.15
-- ORDER BY LotSize DESC;

-- SELECT ROUND(AVG(up.daysOnMarket),2) AS AvgDaysOnMarket
-- FROM UnsoldProperties up
-- JOIN Properties p ON up.PropertyID = p.PropertyID;

-- SELECT * 
-- FROM properties 
-- WHERE Status ="unsold" AND (Price BETWEEN 300000 AND 500000);

-- SELECT * 
-- FROM properties 
-- WHERE Status='sold' AND Price > (SELECT AVG(Price) FROM properties);



-- SELECT * 
-- FROM SoldProperties 
-- WHERE AgentID = 1;

-- SELECT PropertyID, MAX(SoldDate) AS MostRecentSaleDate 
-- FROM SoldProperties 
-- GROUP BY PropertyID;

-- SELECT AgentID, COUNT(*) AS PropertiesSold, SUM(SoldPrice) AS TotalSalesValue, ROUND(AVG(SoldPrice),2) AS AverageSalePrice 
-- FROM SoldProperties 
-- GROUP BY AgentID;

-- SELECT * 
-- FROM SoldProperties 
-- WHERE SoldDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- SELECT AgentID, COUNT(*) AS PropertiesSold, SUM(SoldPrice) AS TotalSalesValue, AVG(SoldPrice) AS AverageSalePrice 
-- FROM SoldProperties 
-- GROUP BY AgentID 
-- ORDER BY AverageSalePrice DESC;

-- SELECT ROUND(AVG(Price / SquareFeet), 2) AS AveragePricePerSqFt
-- FROM Properties;

-- SELECT AgentID, COUNT(*) AS TotalSales 
-- FROM SoldProperties 
-- GROUP BY AgentID WITH ROLLUP;

-- SELECT sp.PropertyID, sp.SoldPrice, sp.SoldDate, u.Name AS AgentName, buyer.Name AS BuyerName 
-- FROM SoldProperties sp
-- JOIN Users u ON sp.AgentID = u.UserID
-- JOIN Users buyer ON sp.BuyerID = buyer.UserID
-- WHERE sp.SoldDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- SELECT AgentID, AVG(daysOnMarket) AS AverageDaysOnMarket
-- FROM UnsoldProperties
-- GROUP BY AgentID
-- ORDER BY AverageDaysOnMarket DESC
-- LIMIT 1;

-- SELECT AgentID, COUNT(*) AS PropertiesSold, SUM(SoldPrice) AS TotalSalesValue, AVG(SoldPrice) AS AverageSalePrice 
-- FROM SoldProperties 
-- GROUP BY AgentID 
-- ORDER BY AverageSalePrice DESC;



-- SELECT City, State, ROUND(AVG(SoldPrice),2) AS AvgSellingPrice
-- FROM SoldProperties sp
-- JOIN Properties p ON sp.PropertyID = p.PropertyID
-- GROUP BY City, State;

-- SELECT AgentID, SUM(SoldPrice) AS TotalSalesValue,
--        RANK() OVER(ORDER BY SUM(SoldPrice) DESC) AS SalesRank
-- FROM SoldProperties
-- GROUP BY AgentID;

-- SELECT SoldDate, COUNT(*) AS PropertiesSold,
--        SUM(COUNT(*)) OVER(ORDER BY SoldDate) AS RunningTotal
-- FROM SoldProperties
-- GROUP BY SoldDate;

-- SELECT City, State, SquareFeet, Price,
--        AVG(Price/SquareFeet) OVER(PARTITION BY City) AS AvgPricePerSqFt
-- FROM Properties;

-- SELECT AgentID, SUM(SoldPrice) AS TotalSalesValue,
--        RANK() OVER(ORDER BY SUM(SoldPrice) DESC) AS SalesRank,
--        SUM(SUM(SoldPrice)) OVER(ORDER BY AgentID) AS RunningTotalSales
-- FROM SoldProperties
-- GROUP BY AgentID;

-- SELECT SoldDate, COUNT(*) AS PropertiesSold,
--        SUM(COUNT(*)) OVER(ORDER BY SoldDate) AS CumulativePropertiesSold,
--        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS PercentageSold
-- FROM SoldProperties
-- GROUP BY SoldDate;

-- SELECT p.PropertyID, p.Address, p.City, p.State, up.daysOnMarket
-- FROM UnsoldProperties up
-- JOIN Properties p ON up.PropertyID = p.PropertyID;

-- SELECT * FROM properties

-- SELECT a.AgentID, a.Agent_Name, COUNT(sp.PropertyID) AS PropertiesSold
-- FROM Agents a
-- JOIN SoldProperties sp ON a.AgentID = sp.AgentID
-- GROUP BY a.AgentID, a.Agent_Name
-- ORDER BY PropertiesSold DESC;

-- SELECT a.AgentID, a.Agent_Name, SUM(sp.SoldPrice) AS TotalRevenue
-- FROM Agents a
-- JOIN SoldProperties sp ON a.AgentID = sp.AgentID
-- WHERE YEAR(sp.SoldDate) = 2023
-- GROUP BY a.AgentID, a.Agent_Name;

-- SELECT a.AgentID, a.Agent_Name, SUM(sp.SoldPrice) AS TotalSalesValue
-- FROM Agents a
-- JOIN SoldProperties sp ON a.AgentID = sp.AgentID
-- GROUP BY a.AgentID, a.Agent_Name;

-- SELECT AgentID, Agent_Name, COUNT(*) AS PropertiesSold, SUM(SoldPrice) AS TotalSalesValue, AVG(SoldPrice) AS AverageSalePrice 
-- FROM SoldProperties 
-- GROUP BY AgentID 
-- ORDER BY AverageSalePrice DESC;

-- SELECT a.Agent_Name, COUNT(*) AS PropertiesSold,SUM(sp.SoldPrice) AS TotalSalesValue, ROUND(AVG(SoldPrice),2) AS AverageSalePrice 
-- FROM SoldProperties sp
-- JOIN Agents a ON sp.AgentID = a.AgentID
-- GROUP BY a.Agent_Name, a.AgentID
-- ORDER BY TotalSalesValue DESC;
