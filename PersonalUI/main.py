import this
import tkinter as tk
from asyncio import wait

from tabulate import tabulate
import mysql.connector
from decimal import *
from tkinter import messagebox

# Declaring variables to use
connector = mysql.connector.connect(host='localhost', user='root', password='', database='RealEstate_Final')
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
    table_names = [row[0] for row in output]  # Extract table names from rows
    print(table_names)
    return table_names



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
    new_property = (UserID,) # Don't forget comma here, if it is not there, code won't work
    res.execute(delete_query, new_property)
    connector.commit()
    print("Deleted Successfully!")
def printUserData():
    res = connector.cursor()
    print_query = "SELECT * FROM Users"
    res.execute(print_query)
    output = res.fetchall()
    text = tabulate(output, headers=["UserID", "Name", "Email", "MobileNumber", "BuyerSellerAgent", "Address"])
    return text

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



















































# GENERAL FUNCTIONS
def success_message(): # Check in future
        messagebox.showinfo("Success", "Operation successful!")
def create_user_data(): # Creating user data frame
    CreateUserFrame = tk.Toplevel(root)

    label = tk.Label(CreateUserFrame, text="Provide name to add : ", font=("Helvetica", 12, "bold"))
    label.pack( )

    input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    # input_box.grid(row = 0, column= 2)
    input_box.pack()
    Name = input_box.get()

    label = tk.Label(CreateUserFrame, text="Provide email to add : ", font=("Helvetica", 12, "bold"))
    label.pack(  )

    input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()
    Email = input_box.get()
    label = tk.Label(CreateUserFrame, text="Provide mobile number to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()
    MobileNumber = input_box.get()
    label = tk.Label(CreateUserFrame, text="Is it buyer, seller, or agent?  ", font=("Helvetica", 12, "bold"))
    label.pack()

    options = {"Buyer", "Seller", "Agent"}
    clicked = tk.StringVar()
    clicked.set("Buyer")

    dropbox = tk.OptionMenu(CreateUserFrame, clicked, *options )
    dropbox.pack()
    BuyerSellerAgent = clicked.get()
    label = tk.Label(CreateUserFrame, text="Provide address to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()
    Address= input_box.get()


    button = tk.Button(CreateUserFrame, font=("Helvetica", 14, "bold"), text="Add", command=lambda : createUsersData(Name, Email, MobileNumber, BuyerSellerAgent, Address) )
    button.pack()
def update_user_data():


  UpdateUserFrame = tk.Toplevel(root, padx=10, pady=10)

  label_user_id = tk.Label(UpdateUserFrame, text="User ID:", font=("Helvetica", 12))
  label_user_id.grid(row=0, column=0, sticky="W")  # Left-align label



  label_name = tk.Label(UpdateUserFrame, text="Name:", font=("Helvetica", 12))
  label_name.grid(row=1, column=0, sticky="W")

  label_email = tk.Label(UpdateUserFrame, text="Email:", font=("Helvetica", 12))
  label_email.grid(row=2, column=0, sticky="W")

  label_mobile_number = tk.Label(UpdateUserFrame, text="Mobile Number:", font=("Helvetica", 12))
  label_mobile_number.grid(row=3, column=0, sticky="W")

  label_status = tk.Label(UpdateUserFrame, text="Status:", font=("Helvetica", 12))
  label_status.grid(row=4, column=0, sticky="W")

  label_address = tk.Label(UpdateUserFrame, text="Address:", font=("Helvetica", 12))
  label_address.grid(row=5, column=0, sticky="W")

  entry_user_id = tk.Entry(UpdateUserFrame, font=("Helvetica", 12))
  entry_user_id.grid(row=0, column=1, padx=5, pady=5)

  userID = entry_user_id.get()

  entry_name = tk.Entry(UpdateUserFrame, font=("Helvetica", 12))
  entry_name.grid(row=1, column=1, padx=5, pady=5)

  user_name = entry_name.get()

  entry_email = tk.Entry(UpdateUserFrame, font=("Helvetica", 12))
  entry_email.grid(row=2, column=1, padx=5, pady=5)

  email = entry_email.get()

  entry_mobile_number = tk.Entry(UpdateUserFrame, font=("Helvetica", 12))
  entry_mobile_number.grid(row=3, column=1, padx=5, pady=5)

  mobile_number = entry_mobile_number.get()

  entry_status = tk.Entry(UpdateUserFrame, font=("Helvetica", 12))
  entry_status.grid(row=4, column=1, padx=5, pady=5)

  status = entry_status.get()

  text_address = tk.Entry(UpdateUserFrame, font=("Helvetica", 12))
  text_address.grid(row=5, column=1, padx=5, pady=5)

  adress = text_address.get()

  button = tk.Button(UpdateUserFrame, font=("Helvetica", 12), text="Update", command=lambda : updateUserData(userID, user_name, email, mobile_number, status, adress))
  button.grid(row= 6, column= 1, padx=5, pady=5)
def delete_user_data():
    selected = 4
    DeleteUserFrame = tk.Toplevel(root)

    label_user_id = tk.Label(DeleteUserFrame, text="Delete user by UserID", font=("Helvetica", 12, "bold"))
    label_user_id.grid(row=0, column=1, sticky="W")

    label_user_id = tk.Label(DeleteUserFrame, text="User ID:", font=("Helvetica", 12))
    label_user_id.grid(row=1, column=0, sticky="W")

    entry_status = tk.Entry(DeleteUserFrame, font=("Helvetica", 12))
    entry_status.grid(row=1, column=1, padx=5, pady=5)

    userid = entry_status.get()
    print(userid)
    button = tk.Button(DeleteUserFrame, text="Delete", font=("Helvetica", 12), command=lambda : deleteUserData(userid))
    button.grid(row = 2, column=1)
    #
    # button = tk.Button(DeleteUserFrame, text="Back", font=("Helvetica", 12), command=)
    # button.grid(row=2, column=2)
def output_user_data():
    EditDataFrame.destroy()

    OutputFrame = tk.Frame(root, padx=10, pady=10)

    OutputFrame.pack()

    text = tk.Text(OutputFrame ,font=("Helvetica", 12))
    text.insert(tk.END, printUserData())
    text.pack(expand=True)

    def resize_text_box():
        # Increase width by 20 characters and height by 5 lines
        text.config(width=text.winfo_width() + 20, height=text.winfo_height() + 5)

    resize_button = tk.Button(root, text="Fix", command=resize_text_box)
    resize_button.pack()
# Property Tables

def printPropertyData():
    res = connector.cursor()
    print_query = "SELECT * FROM Properties"
    res.execute(print_query)
    output = res.fetchall()
    text = tabulate(output, headers=["PropertyID", "AgentID", "Status", "Address", "ZipCode", "City",  "State", "SquareFeet", "Price", "Type", "LotSize", "Beds", "Baths"])
    return text


def create_property_data(): # Creating property data frame
    EditDataFrame.destroy()
    CreatePropertyFrame = tk.Frame(root)
    CreatePropertyFrame.pack()

    # label = tk.Label(CreateUserFrame, text="Provide AgentID to add : ", font=("Helvetica", 12, "bold"))
    # label.pack( )
    #
    # input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    # # input_box.grid(row = 0, column= 2)
    # input_box.pack()
    #
    # label = tk.Label(CreateUserFrame, text="Provide UserID to add : ", font=("Helvetica", 12, "bold"))
    # label.pack(  )
    #
    # input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    # input_box.pack()

    label = tk.Label(CreatePropertyFrame, text="Provide Agent ID to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()



    label = tk.Label(CreatePropertyFrame, text="Provide Status to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreatePropertyFrame, text="Provide Address to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreatePropertyFrame, text="Provide ZipCode to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreatePropertyFrame, text="Provide City to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreatePropertyFrame, text="Provide Sate to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreatePropertyFrame, text="Provide SquareFeet to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreatePropertyFrame, text="Provide Price to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreatePropertyFrame, text="Provide Type to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreatePropertyFrame, text="Provide LotSize to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreatePropertyFrame, text="Provide Beds to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreatePropertyFrame, text="Provide Baths to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreatePropertyFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()


    button = tk.Button(CreatePropertyFrame, font=("Helvetica", 14, "bold"), text="Add", command=success_message )
    button.pack()
def update_property_data():
  EditDataFrame.destroy()

  UpdatePropertyFrame = tk.Frame(root, padx=10, pady=10)
  UpdatePropertyFrame.pack()

  label_property_id = tk.Label(UpdatePropertyFrame, text="PropertyID:", font=("Helvetica", 12))
  label_property_id.grid(row=0, column=0, sticky="W")  # Left-align label

  label_agent_id = tk.Label(UpdatePropertyFrame, text="AgentID:", font=("Helvetica", 12))
  label_agent_id.grid(row=1, column=0, sticky="W")

  label_status = tk.Label(UpdatePropertyFrame, text="Status:", font=("Helvetica", 12))
  label_status.grid(row=2, column=0, sticky="W")

  label_address = tk.Label(UpdatePropertyFrame, text="Address:", font=("Helvetica", 12))
  label_address.grid(row=3, column=0, sticky="W")

  label_zip_code = tk.Label(UpdatePropertyFrame, text="ZipCode:", font=("Helvetica", 12))
  label_zip_code.grid(row=5, column=0, sticky="W")

  label_city = tk.Label(UpdatePropertyFrame, text="City:", font=("Helvetica", 12))
  label_city.grid(row=3, column=0, sticky="W")

  label_state = tk.Label(UpdatePropertyFrame, text="State:", font=("Helvetica", 12))
  label_state.grid(row=5, column=0, sticky="W")

  label_square_Feet = tk.Label(UpdatePropertyFrame, text="Square Feet:", font=("Helvetica", 12))
  label_square_Feet.grid(row=3, column=0, sticky="W")

  label_property_type = tk.Label(UpdatePropertyFrame, text="Property Type:", font=("Helvetica", 12))
  label_property_type.grid(row=5, column=0, sticky="W")

  label_lot_size = tk.Label(UpdatePropertyFrame, text="Lot Size:", font=("Helvetica", 12))
  label_lot_size.grid(row=3, column=0, sticky="W")

  label_beds = tk.Label(UpdatePropertyFrame, text="Beds:", font=("Helvetica", 12))
  label_beds.grid(row=3, column=0, sticky="W")

  label_baths = tk.Label(UpdatePropertyFrame, text="baths:", font=("Helvetica", 12))
  label_baths.grid(row=5, column=0, sticky="W")

  entry_property_id = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_property_id.grid(row=0, column=1, padx=5, pady=5)

  entry_agent_id = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_agent_id.grid(row=1, column=1, padx=5, pady=5)

  entry_status = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_status.grid(row=2, column=1, padx=5, pady=5)

  entry_address = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_address.grid(row=3, column=1, padx=5, pady=5)

  entry_zipcode = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_zipcode.grid(row=3, column=1, padx=5, pady=5)

  entry_city = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_city.grid(row=3, column=1, padx=5, pady=5)

  entry_state = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_state.grid(row=3, column=1, padx=5, pady=5)

  entry_price = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_price.grid(row=3, column=1, padx=5, pady=5)

  entry_property_type = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_property_type.grid(row=3, column=1, padx=5, pady=5)

  entry_lot_size = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_lot_size.grid(row=3, column=1, padx=5, pady=5)

  entry_beds = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_beds.grid(row=3, column=1, padx=5, pady=5)

  entry_baths = tk.Entry(UpdatePropertyFrame, font=("Helvetica", 12))
  entry_baths.grid(row=3, column=1, padx=5, pady=5)

  # entry_status = tk.Entry(UpdateAgentFrame, font=("Helvetica", 12))
  # entry_status.grid(row=4, column=1, padx=5, pady=5)

  button = tk.Button(UpdatePropertyFrame, font=("Helvetica", 12), text="Update", command=success_message)
  button.grid(row= 6, column= 1, padx=5, pady=5)


def delete_property_data():
    EditDataFrame.destroy()
    DeletePropertyFrame = tk.Frame(root, padx=10, pady=10)

    DeletePropertyFrame.pack()

    label_property_id = tk.Label(DeletePropertyFrame, text="Delete property by PropertyID", font=("Helvetica", 12, "bold"))
    label_property_id.grid(row=0, column=1, sticky="W")

    # entry_status = tk.Entry(DeleteAgentFrame, font=("Helvetica", 12))
    # entry_status.grid(row=1, column=1, padx=5, pady=5)

    button = tk.Button(DeletePropertyFrame, text="Delete", font=("Helvetica", 12), command=success_message)
    button.grid(row = 2, column=1)
def output_property_data():
    EditDataFrame.destroy()

    OutputPropertyFrame = tk.Frame(root, padx=10, pady=10)

    OutputPropertyFrame.pack()

    text = tk.Text(OutputPropertyFrame, font=("Helvetica", 12))
    text.insert(tk.END, printPropertyData())
    text.pack(expand=True)

    def resize_text_box():
        # Increase width by 20 characters and height by 5 lines
        text.config(width=text.winfo_width() + 20, height=text.winfo_height() + 5)

    resize_button = tk.Button(root, text="Fix", command=resize_text_box)
    resize_button.pack()



def printAgentData():
    res = connector.cursor()
    print_query = "SELECT * FROM Agents"
    res.execute(print_query)
    output = res.fetchall()
    text = tabulate(output, headers=["AgentID", "UserID","Agent_company" ,"Agent_Name", "Experience", "Location",  "Languages"])
    return  text

# Agent FUNCTIONS
def create_agent_data(): # Creating user data frame
    EditDataFrame.destroy()
    CreateAgentData = tk.Frame(root)
    CreateAgentData.pack()

    # label = tk.Label(CreateUserFrame, text="Provide AgentID to add : ", font=("Helvetica", 12, "bold"))
    # label.pack( )
    #
    # input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    # # input_box.grid(row = 0, column= 2)
    # input_box.pack()
    #
    # label = tk.Label(CreateUserFrame, text="Provide UserID to add : ", font=("Helvetica", 12, "bold"))
    # label.pack(  )
    #
    # input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    # input_box.pack()

    label = tk.Label(CreateAgentData, text="Provide Agent company to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreateAgentData, font=("Helvetica", 12, "bold"))
    input_box.pack()



    label = tk.Label(CreateAgentData, text="Provide Agent Name to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreateAgentData, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreateAgentData, text="Provide Agent's experience to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreateAgentData, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreateAgentData, text="Provide Agent's location to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreateAgentData, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreateAgentData, text="Provide Agent's languages to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreateAgentData, font=("Helvetica", 12, "bold"))
    input_box.pack()


    button = tk.Button(CreateAgentData, font=("Helvetica", 14, "bold"), text="Add", command=success_message )
    button.pack()
def update_agent_data():
  EditDataFrame.destroy()

  UpdateAgentFrame = tk.Frame(root, padx=10, pady=10)
  UpdateAgentFrame.pack()

  label_agent_id = tk.Label(UpdateAgentFrame, text="AgentID:", font=("Helvetica", 12))
  label_agent_id.grid(row=0, column=0, sticky="W")  # Left-align label

  label_company = tk.Label(UpdateAgentFrame, text="Company:", font=("Helvetica", 12))
  label_company.grid(row=1, column=0, sticky="W")

  label_experience = tk.Label(UpdateAgentFrame, text="Experience:", font=("Helvetica", 12))
  label_experience.grid(row=2, column=0, sticky="W")

  label_location = tk.Label(UpdateAgentFrame, text="Location:", font=("Helvetica", 12))
  label_location.grid(row=3, column=0, sticky="W")

  label_language = tk.Label(UpdateAgentFrame, text="Language:", font=("Helvetica", 12))
  label_language.grid(row=5, column=0, sticky="W")

  entry_agent_id = tk.Entry(UpdateAgentFrame, font=("Helvetica", 12))
  entry_agent_id.grid(row=0, column=1, padx=5, pady=5)

  entry_company = tk.Entry(UpdateAgentFrame, font=("Helvetica", 12))
  entry_company.grid(row=1, column=1, padx=5, pady=5)

  entry_experience = tk.Entry(UpdateAgentFrame, font=("Helvetica", 12))
  entry_experience.grid(row=2, column=1, padx=5, pady=5)

  entry_location = tk.Entry(UpdateAgentFrame, font=("Helvetica", 12))
  entry_location.grid(row=3, column=1, padx=5, pady=5)

  # entry_status = tk.Entry(UpdateAgentFrame, font=("Helvetica", 12))
  # entry_status.grid(row=4, column=1, padx=5, pady=5)

  text_language = tk.Entry(UpdateAgentFrame, font=("Helvetica", 12))
  text_language.grid(row=5, column=1, padx=5, pady=5)

  button = tk.Button(UpdateAgentFrame, font=("Helvetica", 12), text="Update", command=success_message)
  button.grid(row= 6, column= 1, padx=5, pady=5)


def delete_agent_data():
    EditDataFrame.destroy()
    DeleteAgentFrame = tk.Frame(root, padx=10, pady=10)

    DeleteAgentFrame.pack()

    label_agent_id = tk.Label(DeleteAgentFrame, text="Delete agent by AgentID", font=("Helvetica", 12, "bold"))
    label_agent_id.grid(row=0, column=1, sticky="W")

    label_agent_id = tk.Label(DeleteAgentFrame, text="Agent ID:", font=("Helvetica", 12))
    label_agent_id.grid(row=1, column=0, sticky="W")

    # entry_status = tk.Entry(DeleteAgentFrame, font=("Helvetica", 12))
    # entry_status.grid(row=1, column=1, padx=5, pady=5)

    button = tk.Button(DeleteAgentFrame, text="Delete", font=("Helvetica", 12), command=success_message)
    button.grid(row = 2, column=1)
def output_agent_data():
    EditDataFrame.destroy()

    OutputAgentFrame = tk.Frame(root, padx=10, pady=10)

    OutputAgentFrame.pack()

    text = tk.Text(OutputAgentFrame ,font=("Helvetica", 12))
    text.insert(tk.END, printAgentData())
    text.pack(expand=True)

    def resize_text_box():
        # Increase width by 20 characters and height by 5 lines
        text.config(width=text.winfo_width() + 20, height=text.winfo_height() + 5)

    resize_button = tk.Button(root, text="Fix", command=resize_text_box)
    resize_button.pack()



# MAIN FRAMES ONLY UNDER THIS

def welcome_page():
  # Title
  getDataTables()
  root.title("Welcome to Real Estate Database Manager")
  # First Label
  label = tk.Label(WelcomeFrame, text="Welcome to Real Estate Database Manager!", font=("Helvetica", 18, "bold"))
  label.place(relwidth=1)
  label.pack()
  label = tk.Label(WelcomeFrame, text="App for Real Estate Professionals", font=("Helvetica", 14))
  label.pack(pady=20, padx=20)

  label = tk.Label(WelcomeFrame, text="Made by:", font=("Helvetica", 12))
  label.pack(pady=10, padx=20)
  # Button is here
  button = tk.Button(WelcomeFrame, text="Enter to have an amazing experience!", font=("Helvetica", 12), command=show_database_page)
  button.pack(pady=20, padx=20)

  WelcomeFrame.pack()


def show_database_page():
    selected= 2

    WelcomeFrame.destroy()
    DatabaseFrame.pack()
    """Creates the second page with listbox to display table names."""
    label = tk.Label(DatabaseFrame, text="Choose the database to edit", font=("Helvetica", 18, "bold"))
    label.pack()
    table_names_listbox = tk.Listbox(DatabaseFrame, font=("Helvetica", 14), selectmode=tk.SINGLE)

    table_names_listbox.pack(pady=20, padx=20, fill="both", expand=False)


    label = tk.Label(DatabaseFrame, text= "Choosen database: ", font=("Helvetica", 12))
    label.pack(side=tk.LEFT)

    labelToChoose = tk.Label(DatabaseFrame, text="", font=("Helvetica", 12))
    labelToChoose.pack(side=tk.LEFT)
    table_names = getDataTables()

    def update_selected_label(event):
      selected_table = table_names_listbox.get(tk.ANCHOR)
      print(labelToChoose.cget("text"))
      if labelToChoose.cget("text") == "users":
          create_command = create_user_data
          update_command = update_user_data
          delete_command = delete_user_data
          output_command = output_user_data
      elif labelToChoose.cget("text") == "agents":
          create_command = create_agent_data
          update_command = update_agent_data
          delete_command = delete_agent_data
          output_command = output_agent_data
      elif labelToChoose.cget("text") == "properties":
          create_command = create_property_data
          update_command = update_property_data
          delete_command = delete_property_data
          output_command = output_property_data
      button.config(command=lambda: edit_data_frame(create_command, update_command, delete_command,
                                                       output_command))
      labelToChoose.config(text=selected_table)



    table_names_listbox.bind('<<ListboxSelect>>', update_selected_label)
    for table_name in table_names:
      table_names_listbox.insert(tk.END, table_name)

    button = tk.Button(DatabaseFrame, text="Submit")
    button.pack(pady=20, padx=20)



def edit_data_frame(create_command, update_command, delete_command, output_command):
  DatabaseFrame.destroy()
  # Create buttons for CRUD operations
  # Will change later

  button_create = tk.Button(EditDataFrame, text="Create Data", font=("Helvetica", 12, "bold"), width=15, command= create_command )
  button_create.pack(pady=10, padx=10)

  button_read = tk.Button(EditDataFrame, text="Update Data", font=("Helvetica", 12, "bold", ), width=15, command= update_command)
  button_read.pack(pady=10, padx=10)

  button_update = tk.Button(EditDataFrame, text="Delete Data", font=("Helvetica", 12, "bold"), width=15, command = delete_command)
  button_update.pack(pady=10, padx=10)

  button_delete = tk.Button(EditDataFrame, text="Output Data", font=("Helvetica", 12, "bold"), width=15, command=output_command)
  button_delete.pack(pady=10, padx=10)

  button_exit = tk.Button(EditDataFrame, text="Exit", font=("Helvetica", 12, "bold"), width=15, command=root.quit)
  button_exit.pack(pady=10, padx=10)


  EditDataFrame.pack()

root = tk.Tk()
root.geometry("700x500")
WelcomeFrame = tk.Frame(root)
DatabaseFrame = tk.Frame(root)
EditDataFrame = tk.Frame(root)
selected = 1
welcome_page()
root.mainloop()


# 1 - root, 2 - databases, 3 - edit databases




# # Entry field for user input (replace with actual functionality if needed)
# entry = tk.Entry(root)
# entry.pack(pady=10, padx=20)















