from tabulate import tabulate
import mysql.connector
from decimal import *

# Declaring variables to use
connector = mysql.connector.connect(host="localhost", user="root", password="ROOFacademy1!", database="RealEstate_Final")
run = True
if connector:
    print("Connected\n")
else: print("Connection error")

# Declaring functions to use

def getDataTables():
    res = connector.cursor()
    sqlCommand = "SELECT DISTINCT object_name FROM sys.schema_tables_with_full_table_scans"
    res.execute(sqlCommand)
    output = res.fetchall()
    print(tabulate(output, headers= [ "Table Names "]))

# PROPERTIES DATA ONLY

def createPropertiesData(PropertyID, AgentID, Status, Address,  ZipCode,City, State, SquareFeet, Price, Type,LotSize,Beds,Baths):
    res = connector.cursor()
    insert_query="INSERT INTO Properties (PropertyID, AgentID, Status, Address,  ZipCode,City, State, SquareFeet, Price, Type,LotSize,Beds,Baths) VALUES (%(PropertyID)s, %(AgentID)s, %(Status)s, %(Address)s, %(ZipCode)s, %(City)s, %(State)s, %(SquareFeet)s, %(Price)s, %(Type)s, %(LotSize)s, %(Beds)s, %(Baths)s)"
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

def updatePropertiesData(PropertyID, AgentID, Status, Address,  ZipCode,City, State, SquareFeet, Price, Type,LotSize,Beds,Baths):
    res = connector.cursor()
    update_query = "UPDATE Properties SET AgentID=%s, Status=%s, Address=%s, ZipCode=%s, City=%s, State=%s, SquareFeet=%s, Price=%s, Type=%s, LotSize=%s, Beds=%s, Baths=%s WHERE PropertyID=%s"
    new_property = (AgentID, Status, Address, ZipCode, City, State, SquareFeet, Price, Type, LotSize, Beds, Baths, PropertyID)
    res.execute(update_query, new_property)
    connector.commit()
    print("Updated successfully!")

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

# Main code
while run:
    getDataTables()
    datatable = input("Choose the database : ").lower()

    if datatable != "properties" and datatable != "users" and datatable != "agents":
        print("Could not find Data Table.")
        break
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
                print("Not the right format\n")
                break
            print("\n")
            # Adding data to properties table
            if datatable == "properties":
                if choice == 1:
                    propertyID = int(input("Provide PropertyID: "))
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
                    createPropertiesData(propertyID, agentID, status, adress, zipCode, city, state, square_feet, price,
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
                    updatePropertiesData(propertyID, agentID, status, adress, zipCode, city, state, square_feet, price,
                                         type, lotSize, beds, baths)
                elif choice == 3:
                    propertyID = int(input("Provide PropertyID that you want to delete: "))
                    deletePropertiesData(propertyID)
                elif choice == 4:
                    outputPropertiesData()






