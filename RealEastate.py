from tabulate import tabulate
import mysql.connector
from decimal import *

# Establish a connection to the MySQL database
connector = mysql.connector.connect(host='localhost', user='root', password='', database='RealEstate_Final')
run = True
if connector:
    print("Connected\n")
else:
    print("Connection error")

# Function to retrieve distinct table names from the database
def getDataTables():
    res = connector.cursor()
    # SQL query to select distinct table names from the INFORMATION_SCHEMA.TABLES
    sqlCommand = "SELECT DISTINCT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME IN ('users', 'agents', 'properties')"
    res.execute(sqlCommand)
    output = res.fetchall()
    # Display the output in a tabular format
    print(tabulate(output, headers= ["Table Names\n "]))

# Function to check if an agent exists in the database
def checkForAgent(AgentID):
    res = connector.cursor()
    try:
        # SQL query to count agents with the given AgentID
        checkIngQuery = "SELECT COUNT(*) FROM Agents WHERE AgentID = %s"
        props = (AgentID,)
        res.execute(checkIngQuery, props)
        result = res.fetchone()
        # Return True if agent exists, False otherwise
        agent_exists = result[0] > 0
        return agent_exists
    except mysql.connector.Error as err:
        return False

# Function to insert new property data into the database
def createPropertiesData(PropertyID, AgentID, Status, Address, ZipCode,City, State, SquareFeet, Price, Type,LotSize,Beds,Baths):
    res = connector.cursor()
    # Check if the agent exists before inserting the property
    if checkForAgent(AgentID):
        insert_query = "INSERT INTO Properties (PropertyID, AgentID, Status, Address, ZipCode,City, State, SquareFeet, Price, Type,LotSize,Beds,Baths) VALUES (%(PropertyID)s, %(AgentID)s, %(Status)s, %(Address)s, %(ZipCode)s, %(City)s, %(State)s, %(SquareFeet)s, %(Price)s, %(Type)s, %(LotSize)s, %(Beds)s, %(Baths)s)"
        new_property = {
            "PropertyID": PropertyID,
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

# Function to update property data in the database
def updatePropertiesData(PropertyID, AgentID, Status, Address, ZipCode,City, State, SquareFeet, Price, Type,LotSize,Beds,Baths):
    res = connector.cursor()
    update_query = "UPDATE Properties SET AgentID=%s, Status=%s, Address=%s, ZipCode=%s, City=%s, State=%s, SquareFeet=%s, Price=%s, Type=%s, LotSize=%s, Beds=%s, Baths=%s WHERE PropertyID=%s"
    new_property = (AgentID, Status, Address, ZipCode, City, State, SquareFeet, Price, Type, LotSize, Beds, Baths, PropertyID)
    res.execute(update_query, new_property)
    connector.commit()
    print("Updated successfully!")

# Function to display all property data from the database
def outputPropertiesData():
    res = connector.cursor()
    output_query = "SELECT * FROM Properties"
    res.execute(output_query)
    print(tabulate(res.fetchall(), headers= ["PropertyID", "AgentID", "Status", "Address", "ZipCode","City", "State", "SquareFeet", "Price", "Type","LotSize","Beds","Baths"]))

# Function to delete property data from the database
def deletePropertiesData(PropertyID):
    res = connector.cursor()
    delete_query = "DELETE FROM Properties WHERE PropertyID=%s"
    new_property = (PropertyID,) # Ensure a tuple is passed for the query
    res.execute(delete_query, new_property)
    connector.commit()
    print("Deleted successfully!")

# Additional functions for handling users and agents data follow a similar pattern, focusing on CRUD operations.

# Main code loop to interact with the database
while run:
    getDataTables()
    datatable = input("Choose the database : ").lower()
    # Validate the input and proceed based on the choice
    # Code for handling user input and database operations follows
