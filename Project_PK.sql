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


select * from users;

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

