from tabulate import tabulate
import mysql.connector
from decimal import *

# Declaring variables to use
connector = mysql.connector.connect(host="localhost", user="root", password="ROOFacademy1!", database="RealEstate_Final_Final")
run = True
if connector:
    print("Connected\n")
else: print("Connection error")

# Declaring functions to use

def getDataTables():
    res = connector.cursor()
    sqlCommand = "SELECT DISTINCT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME IN ('users', 'agents', 'properties')"
    res.execute(sqlCommand)
    output = res.fetchall()
    print(tabulate(output, headers= [ "Table Names\n "]))

# PROPERTIES DATA ONLY

def checkForAgent(AgentID):
    res = connector.cursor()
    try:
        checkIngQuery = "SELECT COUNT(*) FROM Agents WHERE AgentID = %s"
        props = (AgentID,)
        res.execute(checkIngQuery, props)
        result = res.fetchone()
        agent_exists = result[0] > 0
        return agent_exists
    except mysql.connector.Error as err:
        return False


def createPropertiesData( AgentID, Status, Address,  ZipCode,City, State, SquareFeet, Price, Type,LotSize,Beds,Baths):
    res = connector.cursor()

    if checkForAgent(AgentID):
        insert_query = "INSERT INTO Properties ( AgentID, Status, Address,  ZipCode,City, State, SquareFeet, Price, Type,LotSize,Beds,Baths) VALUES ( %(AgentID)s, %(Status)s, %(Address)s, %(ZipCode)s, %(City)s, %(State)s, %(SquareFeet)s, %(Price)s, %(Type)s, %(LotSize)s, %(Beds)s, %(Baths)s)"
        new_property = {
            "AgentID": AgentID,
            "Status": Status,
            "Address": Address,
            "ZipCode": ZipCode,
            "City": City,
            "State": State,
            "SquareFeet": SquareFeet,
            "Price": Price,
            "Type": Type,
            "LotSize": LotSize,
            "Beds": Beds,
            "Baths": Baths
        }
        res.execute(insert_query, new_property)
        connector.commit()
        print("Inserted successfully!")
    else:
        print("Agent not found")


def updatePropertiesData(PropertyID, AgentID, Status, Address,  ZipCode,City, State, SquareFeet, Price, Type,LotSize,Beds,Baths):
    res = connector.cursor()
    if checkForAgent(AgentID):
        update_query = "UPDATE Properties SET AgentID=%s, Status=%s, Address=%s, ZipCode=%s, City=%s, State=%s, SquareFeet=%s, Price=%s, Type=%s, LotSize=%s, Beds=%s, Baths=%s WHERE PropertyID=%s"
        new_property = (
        AgentID, Status, Address, ZipCode, City, State, SquareFeet, Price, Type, LotSize, Beds, Baths, PropertyID)
        res.execute(update_query, new_property)
        connector.commit()
        print("Updated successfully!")
    else:
        print("Agent not found!")


def outputPropertiesData():
    res = connector.cursor()
    output_query = "SELECT * FROM Properties"
    res.execute(output_query)
    print(tabulate(res.fetchall(), headers= ["PropertyID", "AgentID", "Status", "Address",  "ZipCode","City", "State", "SquareFeet", "Price", "Type","LotSize","Beds","Baths"]))

def deletePropertiesData(PropertyID):
    res = connector.cursor()
    delete_query = "DELETE FROM Properties WHERE PropertyID=%s"
    new_property = (PropertyID,) # Don't forget comma here, if it is not there, code won't work
    res.execute(delete_query, new_property)
    connector.commit()
    print("Deleted successfully!")

#---------------------------------------------------------

# USERS ONLY
def createUsersData(Name, Email, MobileNumber, BuyerSellerAgent, Address):
    res = connector.cursor()
    new_property = {
        "Name": Name,
        "Email": Email,
        "MobileNumber": MobileNumber,
        "BuyerSellerAgent": BuyerSellerAgent,
        "Address": Address
    }
    create_query= "INSERT INTO Users (Name, Email, MobileNumber, BuyerSellerAgent, Address) VALUES (%(Name)s, %(Email)s, %(MobileNumber)s, %(BuyerSellerAgent)s, %(Address)s) "
    res.execute(create_query, new_property)
    connector.commit()
    print("Inserted successfully!")
def updateUserData(UserID, Name, Email, MobileNumber, BuyerSellerAgent, Address):
    res = connector.cursor()
    new_property = (Name, Email, MobileNumber, BuyerSellerAgent , Address, UserID)
    update_query = "UPDATE Users SET Name=%s, Email=%s, MobileNumber=%s, BuyerSellerAgent=%s, Address=%s WHERE UserID= %s"
    res.execute(update_query, new_property)
    connector.commit()
    print("Updated successfully!")
def deleteUserData(UserID):
    res = connector.cursor()
    if checkForUser(UserID):
        if checkForUserIsAgent(UserID):
            getAgentIDQuery = "SELECT AgentID FROM Agents WHERE UserID = %s"
            props = (UserID,)
            res.execute(getAgentIDQuery, props)
            agentID = res.fetchone()[0]
            updateAgentData(agentID, None, None, None, None)

    delete_query = "DELETE FROM Users WHERE UserID=%s "
    new_property = (UserID, ) # Don't forget comma here, if it is not there, code won't work
    res.execute(delete_query, new_property)
    connector.commit()
    print("Deleted Successfully!")
def printUserData():
    res = connector.cursor()
    print_query = "SELECT * FROM Users"
    res.execute(print_query)
    output = res.fetchall()
    print(tabulate(output, headers=["UserID", "Name", "Email", "MobileNumber", "BuyerSellerAgent", "Address"]))


#------------------------------------------------------------

# AGENTS ONLY
def checkForUser(user_id):
    try:
        cursor = connector.cursor()
        query = "SELECT COUNT(*) FROM users WHERE UserID = %s AND BuyerSellerAgent = 'Agent'"
        cursor.execute(query, (user_id,))
        result = cursor.fetchone()
        user_exists = result[0] > 0
        return user_exists
    except mysql.connector.Error as err:
        return False

def checkForUserIsAgent(user_id):
    try:
        res = connector.cursor()
        query = "SELECT COUNT(*) FROM Agents WHERE UserID = %s NOT IN (  SELECT UserID = %s FROM Users);"
        res.execute(query, (user_id))
        print(res.fetchone())
        result = res.fetchone()
        userIsAgent = result[0] > 0
        return userIsAgent
    except mysql.connector.Error as err:
        return False


def getUserIDBasedOnName(AgentName):
    res = connector.cursor()
    getIDquery= "SELECT Users.UserID FROM Users WHERE Name = %s"
    res.execute(getIDquery, (AgentName,))
    return res.fetchone()[0]

def createAgentData(AgentCompany, Agent_Name, Experience, Location, Languages):

    createUsersData(Agent_Name, None, None, 'Agent', None)
    userID = getUserIDBasedOnName(Agent_Name)
    res = connector.cursor()
    new_properties = {
        "UserID": userID,
        "AgentCompany": AgentCompany,
        "Agent_Name": Agent_Name,
        "Experience": Experience,
        "Location": Location,
        "Languages": Languages
    }

    create_query = "INSERT INTO Agents (  UserID, AgentCompany, Agent_Name, Experience, Location, Languages) VALUES (%(UserID)s, %(AgentCompany)s, %(Agent_Name)s, %(Experience)s, %(Location)s, %(Languages)s)"
    res.execute(create_query, new_properties)
    connector.commit()
    print("Insert successfully!")

def updateAgentData(AgentID, AgentCompany, Experience, Location, Languages):
    res = connector.cursor()
    getUserIdQuery = "SELECT UserID FROM Agents WHERE AgentID = %s"
    getUserProps = (AgentID,)
    res.execute(getUserIdQuery, getUserProps)
    userId = res.fetchone()[0]
    if checkForUser(userId):
        update_query = "UPDATE Agents SET AgentCompany = %s, Experience= %s, Location= %s, Languages= %s WHERE AgentID = %s"
        props = (AgentCompany, Experience, Location, Languages, AgentID)
        res.execute(update_query, props)
        connector.commit()
        print("Updated successfully!")

def deleteAgentData(AgentID):
    res = connector.cursor()
    def checkForProperties(AgentID):
        try:
            checkQuery = "SELECT COUNT(*) FROM Properties WHERE AgentID = %s"
            props = (AgentID,)
            res.execute(checkQuery, props)
            result = res.fetchone()
            property_exists = result[0] > 0
            return property_exists
        except mysql.connector.Error as err:
            return False
    if checkForProperties(AgentID):
        update_property = "UPDATE Properties SET AgentID = null WHERE AgentID = %s"
        props = (AgentID,)
        res.execute(update_property, props)
        connector.commit()
        print("Deleting Agent from property...")

    deleteUserQuery = "DELETE FROM Agents WHERE AgentID = %s"
    props = (AgentID,)
    res.execute(deleteUserQuery, props)
    connector.commit()
    print("Deleted successfully!")


def printAgentData():
    res = connector.cursor()
    outputQuery = "SELECT * FROM Agents"
    res.execute(outputQuery)
    output = res.fetchall()
    print(tabulate(output, headers=["AgentID", "UserID", "AgentCompany",  "Agent_Name", "Experience", "Location", "Languages"]))

# Main code
while run:
    getDataTables()
    datatable = input("Choose the database : ").lower()

    if datatable != "properties" and datatable != "users" and datatable != "agents":
        print("Could not find Data Table.")
        # break # remove if want to keep loop
    else:
        while True:
            print("-"*15)
            print("1. Create data")
            print("2. Update data")
            print("3. Delete data")
            print("4. Output data")
            print("5. Exit")
            try:
             choice = int(input("Enter your choice: "))
            except:
                print("Invalid Input\n")
                break

            # Adding data to properties table
            if datatable == "properties":
                if choice == 1:
                    property_agentID = int(input("Provide AgentID: "))
                    # checkForAgent(property_agentID)
                    status = input("Provide status:old/Unsold/Rent: ")
                    adress = input("Provide address: ")
                    zipCode = input("Provide zip code: ")
                    city = input("Provide City: ")
                    state = input("Provide state state ( Ex. IL for Illinois ): ")
                    square_feet = int(input("Provide square feet: "))
                    price = float(input("Provide the price: "))
                    type = input("Provide property type: ")
                    lotSize = float(input("Provide lot size of the property: "))
                    beds = int(input("Provide number of beds: "))
                    baths = int(input("Provide number of baths: "))
                    createPropertiesData( property_agentID, status, adress, zipCode, city, state,
                                         square_feet,
                                         price,
                                         type, lotSize, beds, baths)
                elif choice == 2:
                    propertyID = int(input("Provide PropertyID that you want to change: "))
                    agentID = int(input("Provide AgentID: "))
                    status = input("Provide status: Sold/Unsold/Rent: ")
                    adress = input("Provide address: ")
                    zipCode = input("Provide zip code: ")
                    city = input("Provide City: ")
                    state = input("Provide state state ( Ex. IL for Illinois ): ")
                    square_feet = int(input("Provide square feet: "))
                    price = float(input("Provide the price: "))
                    type = input("Provide property type: ")
                    lotSize = float(input("Provide lot size of the property: "))
                    beds = int(input("Provide number of beds: "))
                    baths = int(input("Provide number of baths: "))
                    updatePropertiesData(propertyID, agentID, status, adress, zipCode, city, state, square_feet,
                                         price,
                                         type, lotSize, beds, baths)
                elif choice == 3:
                    propertyID = int(input("Provide PropertyID that you want to delete: "))
                    deletePropertiesData(propertyID)
                elif choice == 4:
                    outputPropertiesData()
                elif choice == 5:
                    break;
                else:
                    print("Invalid input")
                    break;
            if datatable == "users":
                if choice == 1:
                    name = input("Provide Name to add: ")
                    email = input("Provide Email to add: ")
                    mobileNumber = input("Provide mobile number to add: ")
                    buyerSellerAgent = input("Is it buyer, seller or agent? ")
                    user_address = input("Provide Address to add: ")
                    createUsersData(name, email, mobileNumber, buyerSellerAgent, user_address)
                elif choice == 2:
                    userID = int(input("Provide UserID to update: "))
                    name = input("Provide Name ")
                    email = input("Provide Email ")
                    mobileNumber = input("Provide mobile number ")
                    buyerSellerAgent = input("Is it buyer, seller or agent? ")
                    user_address = input("Provide Address ")
                    updateUserData(userID, name, email, mobileNumber, buyerSellerAgent, user_address)
                elif choice == 3:
                    userID = int(input("Provide UserID to delete: "))
                    deleteUserData(userID)
                elif choice == 4:
                    printUserData()
                elif choice == 5:
                    break
            if datatable == "agents":
                if choice == 1:
                    agentCompany = input("Provide company to add: ")
                    agentName = input("Provide Agent Name: ")
                    experience = int(input("Provide agent's experience: "))
                    location = input("Provide location: ")
                    languages = input("Provide languages: ")
                    createAgentData( agentCompany, agentName, experience, location, languages)
                elif choice == 2:
                    agentID = int(input("Provide AgentID to update:  "))
                    agentCompany = input("Provide company to update: ")
                    experience = int(input("Provide agent's experience: "))
                    location = input("Provide location: ")
                    languages = input("Provide languages: ")
                    updateAgentData(agentID, agentCompany, experience, location, languages)
                elif choice == 3:
                    agentID = int(input("Provide AgentID to delete: "))
                    deleteAgentData(agentID)
                elif choice == 4:
                    printAgentData()
                elif choice == 5:
                    break








