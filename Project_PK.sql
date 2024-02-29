CREATE DATABASE Project;

-- Switch to the newly created database
USE Project;

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
(15, 'Joseph Garcia', 'joseph.g@example.com', '3334495555', 'Buyer', 'Las Vegas',  4.1),
(16, 'Samantha White', 'samantha.w@example.com', '4445596666', 'Seller', 'Chicago', 4.2),
(17, 'Daniel Martinez', 'daniel.m@example.com', '5556697777', 'Buyer', 'Boston', 4.3),
(18, 'Olivia Lopez', 'olivia.l@example.com', '6667798888', 'Seller', 'Austin', 4.8),
(19, 'Matthew Adams', 'matthew.a@example.com', '7777899999', 'Buyer', 'Portland', 4.6),
(20, 'Ava Scott', 'ava.s@example.com', '8887900000', 'Seller', 'San Francisco', 4.0),
(21, 'Michelle Thompson', 'michelle.t@example.com', '4445996666', 'Seller', 'Boston', 4.6),
(22, 'Daniel Martinez', 'daniel.martinez@example.com', '5556997777', 'Buyer', 'Philadelphia', 4.3),
(23, 'Linda Nguyen', 'linda.n@example.com', '6667998888', 'Seller', 'San Francisco', 4.7),
(24, 'Steven Wright', 'steven.w@example.com', '7777999999', 'Buyer', 'Portland', 4.2),
(25, 'Samantha Clark', 'samantha.c@example.com', '8889900000', 'Seller', 'Austin', 4.4),
(26, 'Steve Smith', 'steve.smith@example.com', '8889900012', 'Both', 'Chicago', 3.9),
(27, 'Virat Kohli', 'v.kohli@example.com', '8889900013', 'Both', 'Denver', 2.2),
(28, 'David Warner', 'david.warner@example.com', '8889900014', 'Both', 'Kansas', 4.8),
(29, 'Sophia Martinez', 'sophia.m@example.com', '9991002003', 'Buyer', 'Orlando', 4.4),
(30, 'Ethan Taylor', 'ethan.t@example.com', '9992003004', 'Seller', 'Atlanta', 4.1),
(31, 'Isabella Wilson', 'isabella.w@example.com', '9993004005', 'Both', 'Nashville', 4.6),
(32, 'Mason Brown', 'mason.b@example.com', '9994005006', 'Seller', 'Baltimore', 4.2),
(33, 'Emma Jones', 'emma.j@example.com', '9995006007', 'Buyer', 'Raleigh', 4.5),
(34, 'Oliver Garcia', 'oliver.g@example.com', '9996007008', 'Seller', 'Tampa', 3.8),
(35, 'Ava Smith', 'ava.smith@example.com', '9997008009', 'Both', 'Minneapolis', 4.0),
(36, 'Charlotte Davis', 'charlotte.d@example.com', '9998009010', 'Buyer', 'St. Louis', 4.7),
(37, 'Noah Miller', 'noah.m@example.com', '9999010020', 'Seller', 'Las Vegas', 4.3),
(38, 'Mia Rodriguez', 'mia.r@example.com', '9991020030', 'Both', 'Charlotte', 4.1),
(39, 'Liam Anderson', 'liam.a@example.com', '9992030040', 'Seller', 'Indianapolis', 4.4),
(40, 'Amelia Thomas', 'amelia.t@example.com', '9993040050', 'Buyer', 'Columbus', 4.3),
(41, 'James Wilson', 'james.w@example.com', '9994050060', 'Seller', 'Fort Worth', 4.5),
(42, 'Harper Martinez', 'harper.m@example.com', '9995060070', 'Both', 'Jacksonville', 4.2),
(43, 'Elijah Roberts', 'elijah.r@example.com', '9996070080', 'Buyer', 'San Francisco', 4.6),
(44, 'Sophie Green', 'sophie.g@example.com', '9997080090', 'Seller', 'Memphis', 4.0),
(45, 'Lucas Clark', 'lucas.c@example.com', '9998090100', 'Both', 'New Orleans', 4.3);


select * from agents;

-- Assuming every seller or both role user is an agent, here are the inserts:
INSERT INTO Agents (UserID, AgentID, AgentCompany, Agent_Name, Experience, Location, Languages) VALUES
(2, 101, 'Real Estates Co.', 'Jane Smith', 5, 'Los Angeles', 'English, Spanish'),
(3, 102, 'Homes & Estates', 'Michael Johnson', 8, 'Chicago', 'English, Russian'),
(5, 103, 'Top Properties', 'David Hernandez', 4, 'Houston', 'English, Spanish'),
(6, 104, 'CityScape Realtors', 'Sarah Wilson', 6, 'Phoenix', 'English'),
(8, 105, 'Sunshine Realty', 'Ashley Young', 3, 'San Diego', 'English, French'),
(9, 106, 'Dream Homes', 'Brian Lee', 7, 'Dallas', 'English, Korean'),
(11, 107, 'Metro Realtors', 'Charles Rodriguez', 5, 'Atlanta', 'English, Spanish'),
(14, 108, 'Capital Estate Agents', 'Elizabeth Brown', 9, 'Washington DC', 'English'),
(16, 109, 'Lakeside Realty', 'Samantha White', 4, 'Chicago', 'English'),
(18, 110, 'Horizon Properties', 'Olivia Lopez', 8, 'Austin', 'English, Spanish'),
(20, 111, 'Golden Gate Estates', 'Ava Scott', 2, 'San Francisco', 'English'),
(21, 112, 'Pioneer Realtors', 'Michelle Thompson', 6, 'Boston', 'English, French'),
(23, 113, 'Bay Area Realty', 'Linda Nguyen', 7, 'San Francisco', 'English, Vietnamese'),
(25, 114, 'Lone Star Listings', 'Samantha Clark', 3, 'Austin', 'English, Spanish'),
(30, 115, 'Peachtree Properties', 'Ethan Taylor', 5, 'Atlanta', 'English'),
(32, 116, 'Harbor Homes', 'Mason Brown', 4, 'Baltimore', 'English'),
(34, 117, 'Coastal Realty', 'Oliver Garcia', 2, 'Tampa', 'English, Spanish'),
(37, 118, 'Desert Dwellings Realty', 'Noah Miller', 6, 'Las Vegas', 'English'),
(39, 119, 'Crossroads Real Estate', 'Liam Anderson', 5, 'Indianapolis', 'English'),
(41, 120, 'Fort Worth Realtors', 'James Wilson', 7, 'Fort Worth', 'English'),
(44, 121, 'Blues City Realty', 'Sophie Green', 3, 'Memphis', 'English'),
(26, 122, 'Windy City Estates', 'Steve Smith', 8, 'Chicago', 'English'),
(28, 123, 'Prairie Homes Realty', 'David Warner', 4, 'Kansas', 'English'),
(35, 124, 'Twin Cities Realty', 'Ava Smith', 5, 'Minneapolis', 'English'),
(38, 125, 'Queen City Real Estate', 'Mia Rodriguez', 6, 'Charlotte', 'English'),
(42, 126, 'Sunshine State Realty', 'Harper Martinez', 7, 'Jacksonville', 'English'),
(45, 127, 'Crescent City Properties', 'Lucas Clark', 4, 'New Orleans', 'English');

INSERT INTO Properties (AgentID, propertyID, Status, Address, Location, zip_code, city, state, square_feet, Price, Type, Lot_size, beds, baths, yearBuilt) VALUES
(101, 1, 'unsold', '123 Main St', 'Los Angeles', '90001', 'Los Angeles', 'CA', 2000, 500000.00, 'House', '5000 sqft', 3, 2, 1980),
(102, 2, 'sold', '456 Pine St', 'Chicago', '60605', 'Chicago', 'IL', 1500, 300000.00, 'Condo', 'N/A', 2, 2, 1990),
(103, 3, 'Rent', '789 Oak St', 'Houston', '77002', 'Houston', 'TX', 2500, 400000.00, 'House', '6000 sqft', 4, 3, 2005),
(104, 4, 'unsold', '101 Desert Rd', 'Phoenix', '85001', 'Phoenix', 'AZ', 1800, 350000.00, 'House', '4500 sqft', 3, 2, 1995),
(105, 5, 'sold', '202 Beach Ave', 'San Diego', '92101', 'San Diego', 'CA', 2200, 600000.00, 'House', '5500 sqft', 4, 3, 2000),
(106, 6, 'Rent', '303 Maple Dr', 'Dallas', '75201', 'Dallas', 'TX', 1600, 250000.00, 'Apartment', 'N/A', 2, 2, 2010),
(107, 7, 'unsold', '404 Peachtree St', 'Atlanta', '30301', 'Atlanta', 'GA', 1400, 200000.00, 'Condo', 'N/A', 2, 1, 1985),
(108, 8, 'sold', '505 Capitol St', 'Washington DC', '20001', 'Washington', 'DC', 3000, 800000.00, 'House', '7000 sqft', 5, 4, 1920),
(109, 9, 'Rent', '606 Lake Shore Dr', 'Chicago', '60605', 'Chicago', 'IL', 1700, 320000.00, 'Apartment', 'N/A', 3, 2, 2000),
(110, 10, 'unsold', '707 River St', 'Austin', '78701', 'Austin', 'TX', 1900, 450000.00, 'House', '5000 sqft', 3, 2, 2010),
(111, 11, 'sold', '808 Golden Gate Ave', 'San Francisco', '94102', 'San Francisco', 'CA', 1500, 1000000.00, 'Condo', 'N/A', 2, 2, 1990),
(112, 12, 'Rent', '909 Liberty St', 'Boston', '02101', 'Boston', 'MA', 2000, 550000.00, 'Apartment', 'N/A', 3, 2, 1980),
(113, 13, 'unsold', '1010 Bay St', 'San Francisco', '94102', 'San Francisco', 'CA', 2500, 1100000.00, 'House', '6000 sqft', 4, 3, 1970),
(114, 14, 'sold', '1111 Lone Star Blvd', 'Austin', '78701', 'Austin', 'TX', 1800, 420000.00, 'House', '4000 sqft', 3, 2, 2005),
(115, 15, 'Rent', '1212 Peach St', 'Atlanta', '30301', 'Atlanta', 'GA', 1300, 220000.00, 'Apartment', 'N/A', 1, 1, 2015),
(116, 16, 'unsold', '1313 Harbor View Rd', 'Baltimore', '21201', 'Baltimore', 'MD', 2100, 350000.00, 'House', '5500 sqft', 4, 3, 1950),
(117, 17, 'sold', '1414 Coastline Dr', 'Tampa', '33601', 'Tampa', 'FL', 2000, 300000.00, 'House', '4500 sqft', 3, 2, 1980),
(118, 18, 'Rent', '1515 Desert Bloom Rd', 'Las Vegas', '89101', 'Las Vegas', 'NV', 2200, 400000.00, 'House', '6000 sqft', 4, 3, 2005),
(119, 19, 'unsold', '1616 Mountain View Rd', 'Denver', '80201', 'Denver', 'CO', 2500, 500000.00, 'House', '7000 sqft', 4, 3, 1990),
(120, 20, 'sold', '1717 Lake Rd', 'Minneapolis', '55401', 'Minneapolis', 'MN', 1500, 250000.00, 'Condo', 'N/A', 2, 2, 2000),
(121, 21, 'Rent', '1818 River Bend Dr', 'Nashville', '37201', 'Nashville', 'TN', 1700, 280000.00, 'Apartment', 'N/A', 2, 2, 2015),
(122, 22, 'unsold', '1919 Sunnyside Ave', 'Seattle', '98101', 'Seattle', 'WA', 2000, 750000.00, 'House', '5000 sqft', 3, 2, 1960),
(123, 23, 'sold', '2020 Highland Rd', 'Los Angeles', '90001', 'Los Angeles', 'CA', 1800, 650000.00, 'Condo', 'N/A', 2, 2, 1975),
(124, 24, 'Rent', '2121 Maple Dr', 'New York', '10001', 'New York', 'NY', 1400, 2000000.00, 'Apartment', 'N/A', 2, 2, 1985),
(125, 25, 'unsold', '2222 Ocean View Dr', 'Miami', '33101', 'Miami', 'FL', 2100, 550000.00, 'House', '4000 sqft', 3, 3, 2000),
(126, 26, 'sold', '2323 Broadway', 'New York', '10001', 'New York', 'NY', 1600, 3000000.00, 'Condo', 'N/A', 3, 2, 1995),
(127, 27, 'Rent', '2424 Vine St', 'Los Angeles', '90001', 'Los Angeles', 'CA', 1900, 700000.00, 'House', '4500 sqft', 3, 2, 1980);






select * from properties;
delete from properties;
SET SQL_SAFE_UPDATES = 0;



INSERT INTO Properties (AgentID, propertyID, Status, Address, Location, zip_code, city, state, square_feet, Price, Type, Lot_size, beds, baths, yearBuilt) VALUES
(101, 1, 'sold', '123 Maple St', 'Downtown', '90001', 'Los Angeles', 'CA', 1200, 450000.00, 'Apartment', 'N/A', 2, 2, 1990),
(102, 2, 'unsold', '456 Oak St', 'Midtown', '60601', 'Chicago', 'IL', 3000, 800000.00, 'House', '0.1 acres', 4, 3, 1985),
(103, 3, 'Rent', '789 Pine St', 'Uptown', '77001', 'Houston', 'TX', 1500, 300000.00, 'Apartment', 'N/A', 3, 2, 2000),
(104, 4, 'unsold', '101 Birch St', 'Suburb', '85001', 'Phoenix', 'AZ', 2000, 350000.00, 'House', '0.2 acres', 3, 2, 1995),
(105, 5, 'sold', '202 Cedar St', 'Downtown', '92101', 'San Diego', 'CA', 5000, 1500000.00, 'Commercial', '0.5 acres', 0, 0, 1990),
(106, 6, 'Rent', '303 Elm St', 'City Center', '75201', 'Dallas', 'TX', 4000, 600000.00, 'Retail', '0.3 acres', 0, 0, 1980),
(107, 7, 'unsold', '404 Fir St', 'Eastside', '30301', 'Atlanta', 'GA', 2500, 450000.00, 'House', '0.25 acres', 4, 3, 2005),
(108, 8, 'sold', '505 Spruce St', 'Westside', '20001', 'Washington DC', 'DC', 3500, 700000.00, 'Industrial', '1 acre', 0, 0, 1975),
(109, 9, 'Rent', '606 Hickory St', 'Northside', '60601', 'Chicago', 'IL', 1800, 400000.00, 'Apartment', 'N/A', 2, 2, 2010),
(110, 10, 'unsold', '707 Willow St', 'Southside', '78701', 'Austin', 'TX', 5500, 1300000.00, 'Commercial', '0.8 acres', 0, 0, 1985),
(111, 11, 'sold', '808 Maple St', 'Downtown', '94101', 'San Francisco', 'CA', 600, 300000.00, 'Apartment', 'N/A', 1, 1, 2015),
(112, 12, 'Rent', '909 Oak St', 'Midtown', '02101', 'Boston', 'MA', 4500, 950000.00, 'Retail', '0.2 acres', 0, 0, 1992),
(113, 13, 'unsold', '1010 Pine St', 'Uptown', '94101', 'San Francisco', 'CA', 2200, 750000.00, 'House', '0.15 acres', 3, 3, 2000),
(114, 14, 'sold', '1111 Birch St', 'Suburb', '33601', 'Tampa', 'FL', 10000, 2500000.00, 'Mixed use', '2 acres', 0, 0, 1980),
(115, 15, 'Rent', '1212 Cedar St', 'Downtown', '30301', 'Atlanta', 'GA', 800, 250000.00, 'Apartment', 'N/A', 1, 1, 2020),
(116, 16, 'unsold', '116 Pine St', 'Downtown', '10001', 'New York', 'NY', 800, 160000.00, 'Apartment', 'N/A', 1, 1, 2020),
(117, 17, 'sold', '117 Oak Ave', 'Midtown', '90001', 'Los Angeles', 'CA', 3000, 600000.00, 'House', '0.1 acres', 4, 2, 2021),
(118, 18, 'unsold', '118 Maple St', 'Downtown', '60601', 'Chicago', 'IL', 850, 170000.00, 'Apartment', 'N/A', 1, 1, 2022),
(119, 19, 'Rent', '119 Oak Lane', 'Midtown', '94101', 'San Francisco', 'CA', 3200, 640000.00, 'House', '0.15 acres', 5, 3, 2020),
(120, 20, 'unsold', '120 Pine Ave', 'Downtown', '10001', 'New York', 'NY', 900, 180000.00, 'Apartment', 'N/A', 2, 1, 2023),
(121, 21, 'sold', '121 Maple St', 'Suburb', '90001', 'Los Angeles', 'CA', 2500, 500000.00, 'House', '0.2 acres', 3, 2, 2021),
(122, 22, 'unsold', '122 Oak Ave', 'Downtown', '60601', 'Chicago', 'IL', 950, 190000.00, 'Apartment', 'N/A', 2, 2, 2022),
(123, 23, 'sold', '123 Pine Lane', 'Midtown', '94101', 'San Francisco', 'CA', 3500, 700000.00, 'House', '0.25 acres', 5, 4, 2020),
(124, 24, 'unsold', '2323 Willow St', 'Southside', '46201', 'Indianapolis', 'IN', 3200, 490000.00, 'House', '0.3 acres', 4, 2, 1998),
(125, 25, 'sold', '2424 Hickory St', 'Northside', '28201', 'Charlotte', 'NC', 12000, 3100000.00, 'Industrial', '3 acres', 0, 0, 1970),
(126, 26, 'Rent', '2525 Spruce St', 'Westside', '32201', 'Jacksonville', 'FL', 900, 350000.00, 'Apartment', 'N/A', 2, 2, 2021),
(127, 27, 'unsold', '2626 Fir St', 'Eastside', '37201', 'Nashville', 'TN', 2800, 460000.00, 'House', '0.4 acres', 3, 3, 2010),
(101, 28, 'sold', '2727 Elm St', 'City Center', '10001', 'New York', 'NY', 7000, 2000000.00, 'Commercial', '1.5 acres', 0, 0, 1950),
(102, 29, 'Rent', '2828 Birch St', 'Suburb', '33101', 'Miami', 'FL', 1100, 420000.00, 'Apartment', 'N/A', 3, 2, 2018),
(103, 30, 'unsold', '2929 Cedar St', 'Downtown', '97201', 'Portland', 'OR', 3000, 480000.00, 'House', '0.2 acres', 3, 2, 1996),
(104, 31, 'sold', '3131 Maple St', 'Downtown', '64101', 'Kansas City', 'MO', 1100, 220000.00, 'Apartment', 'N/A', 1, 1, 2018),
(105, 32, 'unsold', '3232 Oak St', 'Midtown', '80201', 'Denver', 'CO', 2700, 540000.00, 'House', '0.3 acres', 4, 3, 1992),
(106, 33, 'Rent', '3333 Pine St', 'Uptown', '37201', 'Nashville', 'TN', 1600, 320000.00, 'Apartment', 'N/A', 2, 2, 2005),
(107, 34, 'unsold', '3434 Birch St', 'Suburb', '43201', 'Columbus', 'OH', 2000, 400000.00, 'House', '0.25 acres', 3, 2, 1988),
(108, 35, 'sold', '3535 Cedar St', 'Downtown', '48201', 'Detroit', 'MI', 4500, 900000.00, 'Commercial', '1 acre', 0, 0, 1970),
(109, 36, 'Rent', '3636 Elm St', 'City Center', '73101', 'Oklahoma City', 'OK', 3500, 700000.00, 'Retail', '0.5 acres', 0, 0, 1985),
(110, 37, 'unsold', '3737 Fir St', 'Eastside', '33101', 'Miami', 'FL', 2800, 560000.00, 'House', '0.2 acres', 4, 3, 1999),
(111, 38, 'sold', '3838 Spruce St', 'Westside', '89101', 'Las Vegas', 'NV', 6000, 1200000.00, 'Industrial', '2 acres', 0, 0, 1965),
(112, 39, 'Rent', '3939 Hickory St', 'Northside', '30301', 'Atlanta', 'GA', 1400, 280000.00, 'Apartment', 'N/A', 2, 1, 2015),
(113, 40, 'unsold', '4040 Willow St', 'Southside', '98101', 'Seattle', 'WA', 3100, 620000.00, 'House', '0.4 acres', 3, 2, 2002),
(114, 41, 'Rent', '4141 Maple St', 'Downtown', '20001', 'Washington DC', 'DC', 750, 150000.00, 'Apartment', 'N/A', 1, 1, 2022),
(115, 42, 'Rent', '4242 Oak St', 'Midtown', '10001', 'New York', 'NY', 5000, 1000000.00, 'Retail', '0.3 acres', 0, 0, 1975),
(116, 43, 'Rent', '4343 Pine St', 'Uptown', '90001', 'Los Angeles', 'CA', 2400, 480000.00, 'House', '0.15 acres', 3, 3, 2003),
(117, 44, 'sold', '4444 Birch St', 'Suburb', '60601', 'Chicago', 'IL', 11000, 2200000.00, 'Mixed use', '1.5 acres', 0, 0, 1980),
(118, 45, 'Rent', '4545 Cedar St', 'Downtown', '94101', 'San Francisco', 'CA', 850, 170000.00, 'Apartment', 'N/A', 1, 1, 2021),
(119, 46, 'unsold', '4646 Elm St', 'City Center', '33101', 'Miami', 'FL', 3200, 640000.00, 'House', '0.25 acres', 4, 2, 1987),
(120, 47, 'sold', '4747 Fir St', 'Eastside', '02101', 'Boston', 'MA', 12000, 2400000.00, 'Industrial', '2.5 acres', 0, 0, 1960),
(121, 48, 'Rent', '4848 Spruce St', 'Westside', '30301', 'Atlanta', 'GA', 950, 190000.00, 'Apartment', 'N/A', 2, 2, 2023),
(122, 49, 'unsold', '4949 Hickory St', 'Northside', '98101', 'Seattle', 'WA', 2900, 580000.00, 'House', '0.3 acres', 3, 3, 1995),
(123, 50, 'sold', '5050 Willow St', 'Southside', '10001', 'New York', 'NY', 7000, 1400000.00, 'Commercial', '1 acre', 0, 0, 1955),
(124, 51, 'Rent', '5151 Maple St', 'Downtown', '94101', 'San Francisco', 'CA', 1200, 240000.00, 'Apartment', 'N/A', 2, 2, 2019),
(125, 52, 'unsold', '5252 Oak St', 'Midtown', '33101', 'Miami', 'FL', 2600, 520000.00, 'House', '0.2 acres', 3, 2, 1989),
(126, 53, 'sold', '5353 Pine St', 'Uptown', '90001', 'Los Angeles', 'CA', 4800, 960000.00, 'Industrial', '1.2 acres', 0, 0, 1972),
(127, 54, 'Rent', '5454 Birch St', 'Suburb', '60601', 'Chicago', 'IL', 1300, 260000.00, 'Apartment', 'N/A', 1, 1, 2024),
(101, 55, 'unsold', '5555 Cedar St', 'Downtown', '20001', 'Washington DC', 'DC', 3100, 620000.00, 'House', '0.35 acres', 4, 3, 1998),
(102, 56, 'sold', '5656 Elm St', 'City Center', '37201', 'Nashville', 'TN', 6500, 1300000.00, 'Commercial', '0.75 acres', 0, 0, 1968),
(103, 57, 'Rent', '5757 Fir St', 'Eastside', '48201', 'Detroit', 'MI', 900, 180000.00, 'Apartment', 'N/A', 2, 1, 2017),
(104, 58, 'unsold', '5858 Spruce St', 'Westside', '80201', 'Denver', 'CO', 2800, 560000.00, 'House', '0.2 acres', 3, 2, 2001),
(105, 59, 'Rent', '5959 Hickory St', 'Northside', '73101', 'Oklahoma City', 'OK', 8000, 1600000.00, 'Industrial', '2 acres', 0, 0, 1958),
(106, 60, 'Rent', '6060 Willow St', 'Southside', '30301', 'Atlanta', 'GA', 1100, 220000.00, 'Apartment', 'N/A', 2, 2, 2020);
;




