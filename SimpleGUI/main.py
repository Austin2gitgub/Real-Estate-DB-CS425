from tabulate import tabulate
import mysql.connector
import PySimpleGUI as sg
import urllib.request
connector = mysql.connector.connect(host='localhost', user='root', password='', database='RealEstate_Final_Final')
run = True
if connector:
    print("Connected\n")
else: print("Connection error")
dataUser = []
dataAgents = []
dataProperties = []

otherData1 = []
otherData2 = []
otherData3 = []
otherData4 = []
otherData5 = []
otherData6 = []
otherData7 = []
#-------------------------------------------------------------
def getDataTables():
    res = connector.cursor()
    sqlCommand = "SELECT DISTINCT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME IN ('users', 'agents', 'properties')"
    res.execute(sqlCommand)
    output = res.fetchall()
    tables = [rows[0] for rows in output]
    return tables

# ----------------------------- USERS --------------------------------------------
def createUsersData(Name, Email, MobileNumber, BuyerSellerAgent, Address):
    res = connector.cursor()
    new_property = {
        "Name": Name,
        "Email": Email,
        "MobileNumber": MobileNumber,
        "BuyerSellerAgent": BuyerSellerAgent,
        "Address": Address
    }
    create_query = "INSERT INTO Users (Name, Email, MobileNumber, BuyerSellerAgent, Address) VALUES (%(Name)s, %(Email)s, %(MobileNumber)s, %(BuyerSellerAgent)s, %(Address)s) "
    res.execute(create_query, new_property)
    connector.commit()
    print("Inserted successfully!")
    sg.Popup("Inserted successfully!")


def updateUserData(UserID, Name, Email, MobileNumber, BuyerSellerAgent, Address):
    res = connector.cursor()
    new_property = (Name, Email, MobileNumber, BuyerSellerAgent , Address, UserID)
    update_query = "UPDATE Users SET Name=%s, Email=%s, MobileNumber=%s, BuyerSellerAgent=%s, Address=%s WHERE UserID= %s"
    res.execute(update_query, new_property)
    connector.commit()
    print("Updated successfully!")
    sg.Popup("Updated successfully!")

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
    sg.Popup("Deleted successfully!")

def outputUserData():
    res = connector.cursor()
    print_query = "SELECT * FROM Users"
    res.execute(print_query)
    output = res.fetchall()
    # tabulate(output, headers=["UserID", "Name", "Email", "MobileNumber", "BuyerSellerAgent", "Address"])
    return output
for i in outputUserData():
    dataUser.append(i)


#---------------------------------------Agents-------------------------------
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
    sg.Popup("Inserted successfully!")

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
        sg.Popup("Updated successfully!")

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
    sg.Popup("Deleted successfully!")

def printAgentData():
    res = connector.cursor()
    outputQuery = "SELECT * FROM Agents"
    res.execute(outputQuery)
    output = res.fetchall()
    # print(tabulate(output, headers=["AgentID", "UserID", "AgentCompany",  "Agent_Name", "Experience", "Location", "Languages"]))
    return output
for i in printAgentData():
    dataAgents.append(i)


#-------------------------------Properties---------------------------------
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
        sg.Popup("Inserted successfully!")
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
        sg.Popup("Updated successfully!")
    else:
        print("Agent not found!")

def deletePropertiesData(PropertyID):
    res = connector.cursor()
    delete_query = "DELETE FROM Properties WHERE PropertyID=%s"
    new_property = (PropertyID,) # Don't forget comma here, if it is not there, code won't work
    res.execute(delete_query, new_property)
    connector.commit()
    sg.Popup("Deleted successfully!")


def outputPropertiesData():
    res = connector.cursor()
    output_query = "SELECT * FROM Properties"
    res.execute(output_query)
    # print(tabulate(res.fetchall(), headers= ["PropertyID", "AgentID", "Status", "Address",  "ZipCode","City", "State", "SquareFeet", "Price", "Type","LotSize","Beds","Baths"]))
    return res.fetchall()

for i in outputPropertiesData():
    dataProperties.append(i)


#----------------------------Others-------------------------------------------
def set_union_data():

    res = connector.cursor()
    print_query = "SELECT Address AS 'Demographics of our Users' FROM Users UNION SELECT Location FROM Agents;"
    res.execute(print_query)
    output = res.fetchall()
    # text = tabulate(output,
    # headers=["Demographics of our Users"])
    return output
for i in set_union_data():
    otherData1.append(i)


def set_except_data():

    res = connector.cursor()
    print_query = "SELECT PropertyID, Address FROM properties WHERE PropertyID NOT IN (SELECT PropertyID FROM rentproperties);"
    res.execute(print_query)
    output = res.fetchall()
    # text = tabulate(output,
    # # headers=["Find Properties that are not rented out"])
    return output
for i in set_except_data():
    otherData2.append(i)


def set_membership_data():

    res = connector.cursor()
    print_query = "SELECT AgentID, PropertyID, Status, Address FROM properties WHERE AgentID IN (SELECT AgentID FROM Agents WHERE AgentID='1');"
    res.execute(print_query)
    output = res.fetchall()
    # text = tabulate(output,
    # headers=["Show all the properties that AgentID='1' is sold or unsold"])
    return output
for i in set_membership_data():
    otherData3.append(i)


def set_comparision_data():

    res = connector.cursor()
    print_query = "SELECT * FROM properties WHERE Price < ANY(SELECT Price FROM properties WHERE Price<500000);"
    res.execute(print_query)
    output = res.fetchall()
    # text = tabulate(output,
    # headers=["All properties that are less than 500k"])
    return output

for i in set_comparision_data():
    otherData4.append(i)

def set_with_data():

    res = connector.cursor()
    print_query = "WITH tempTable(averageValue) AS (SELECT avg(Price) from properties) SELECT PropertyID, Address, Status, Price FROM properties, tempTable WHERE properties.Price > tempTable.averageValue;"
    res.execute(print_query)
    output = res.fetchall()
    # text = tabulate(output,
    # headers=["Finding properties that are above the average price in market"])
    return output

for i in set_with_data():
    otherData5.append(i)



def set_advanced_data():

    res = connector.cursor()
    print_query = "WITH tempTable(averageValue) AS (SELECT avg(Price) from properties) SELECT PropertyID, Address, Status, Price FROM properties, tempTable WHERE properties.Price > tempTable.averageValue;"
    res.execute(print_query)
    output = res.fetchall()
    # text = tabulate(output,
    # headers=["Minimum price to rent or buy in each city"])
    return output


for i in set_advanced_data():
    otherData6.append(i)

def set_olap_data():

    res = connector.cursor()
    print_query = "SELECT Type, COUNT(propertyID) AS Total_Sold FROM properties WHERE Status = 'sold' GROUP BY Type;"
    res.execute(print_query)
    output = res.fetchall()
    # text = tabulate(output,
    # headers=["Total sold properties based on type on the real-estate website"])
    return output


for i in set_olap_data():
    otherData7.append(i)














































# All the stuff inside your window.


image_url1 = r'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Friendly_stickman.svg/320px-Friendly_stickman.svg.png'
save_name = 'my_image.png' #local name to be saved
urllib.request.urlretrieve(image_url1, save_name)


welcome_page = [[sg.Text("Welcome to Real Estate Database Manager", font=("Monospace", 24))],
            [sg.Push(), sg.Text("App for a managing real estate databases", font=("Monospace", 16)) ,sg.Push()],
                [sg.Image(save_name, expand_x= True, expand_y= True)],
[sg.Push () , sg.Text("Made by: Omar Ashurbayov, Lalith Kothuru, Austin Samuel, Pranav Kuchibhotla") ,sg.Push()],
               [sg.Button("Edit Database", key='-DB-'), sg.Button("Olap/Advanced Queries", key='-OLAP-'), sg.Button("Exit")]]



# Create the Window
welcome_window = sg.Window('Real Estate Database', welcome_page)

def edit_databases_window():
    def edit_user_window():
        create_user_tab = [[sg.Text("Enter Name") , sg.Input("", key ='-NAME_IN-')],
                           [sg.Text("Enter Email"), sg.Input("", key='-EMAIL_IN-')],
                           [sg.Text("Enter Mobile Number"), sg.Input("", key='-MOBILE_IN-')],
                           [sg.Text('', pad=(100,0), key='EXPAND'), sg.OptionMenu(values=['buyer', 'agent', 'seller', 'both'], default_value='buyer', key='-USER-TYPE-')],
                           [sg.Text("Enter Address"), sg.Input("", key='-ADDRESS_IN-')],
                           [sg.Button("Create"), sg.Button("Exit")]]
        update_user_tab = [[sg.Text("Enter UserID") , sg.Input("", key ='-UPD_USER_ID_IN-')],
                           [sg.Text("Enter Name"), sg.Input("", key='-UPD_NAME_IN-')],
                           [sg.Text("Enter Email"), sg.Input("", key='-UPD_EMAIL_IN-')],
                           [sg.Text("Enter Mobile Number"), sg.Input("", key='-UPD_MOB_NUM_IN-')],
                           [sg.Text('', pad=(100,0), key='EXPAND'), sg.OptionMenu(values=['buyer', 'agent', 'seller', 'both'], default_value='buyer', key='-UPD_USER-TYPE-')],
                           [sg.Text("Enter Address"), sg.Input("", key='-UPD_ADDRESS_IN-')],
                           [sg.Button("Update"), sg.Button("Exit")]]
        delete_user_tab = [[sg.Text("Enter UserID") , sg.Input("", key ='-DLT_USER_IN-')],
                           [sg.Button("Delete"), sg.Button("Exit")]]
        output_user_tab = [[sg.Table(values=dataUser,
                                     headings=["UserID", "Name", "Email", "MobileNumber"],
                                     auto_size_columns=True,
                                     justification='right',
                                     num_rows=min(len(dataUser), 10), key='-TABLE-')]]


        edit_users_window = [[sg.TabGroup([
            [sg.Tab('Create User', create_user_tab)],
                             [sg.Tab('Update User', update_user_tab)],[sg.Tab('Delete User', delete_user_tab)],[sg.Tab('Output User', output_user_tab)]])]]

        edit_users_window = sg.Window("Edit User Table", edit_users_window)
        while True:
            event, values = edit_users_window.read()
            print(event, values)
            # if user closes window or clicks cancel
            if event == sg.WIN_CLOSED:
                break
            if event == 'Create':
                user_name = edit_users_window['-NAME_IN-'].get()
                user_email = edit_users_window['-EMAIL_IN-'].get()
                user_mobile = edit_users_window['-MOBILE_IN-'].get()
                user_type = values['-USER-TYPE-']
                user_address = edit_users_window['-ADDRESS_IN-'].get()
                createUsersData(user_name, user_email, user_mobile, user_type, user_address)

            elif event == 'Update':
                user_id = edit_users_window['-UPD_USER_ID_IN-'] .get()
                user_name = edit_users_window['-UPD_NAME_IN-'] .get()
                user_email = edit_users_window['-UPD_EMAIL_IN-'] .get()
                user_mobile= edit_users_window['-UPD_MOB_NUM_IN-'] .get()
                user_type = values['-UPD_USER-TYPE-']
                user_address= edit_users_window['-UPD_ADDRESS_IN-'] .get()
                updateUserData(user_id, user_name, user_email, user_mobile, user_type, user_address)
            elif event == 'Delete':
                user_id = edit_users_window['-DLT_USER_IN-'].get()
                deleteUserData(user_id)

            elif event == 'Exit':
                break
        edit_users_window.close()
    def edit_agents_window():
        create_agent_tab = [[sg.Text("Enter Agent Company"), sg.Input("", key='-COMPANY_IN-')],
                           [sg.Text("Enter Name"), sg.Input("", key='-NAME_IN-')],
                           [sg.Text("Enter Experience"), sg.Input("", key='-EXP_IN-')],
                           [sg.Text("Enter Location"), sg.Input("", key='-LOCATION_IN-')],
                           [sg.Text("Enter Languages"), sg.Input("", key='-LANGUAGES_IN-')],
                           [sg.Button("Create"), sg.Button("Exit")]]
        update_agent_tab = [[sg.Text("Enter AgentID"), sg.Input("", key='-UPD_AGNT_ID-')],
                           [sg.Text("Enter Company"), sg.Input("", key='-UPD_COMPANY-')],
                           [sg.Text("Enter Experience"), sg.Input("", key='-UPD_EXP-')],
                           [sg.Text("Enter Location"), sg.Input("", key='-UPD_LOC-')],
                           [sg.Text("Enter Languages"), sg.Input("", key='-UPD_LANG-')],
                           [sg.Button("Update"), sg.Button("Exit")]]
        delete_agent_tab = [[sg.Text("Enter AgentID"), sg.Input("", key='-DLT_AGENT-')],
                           [sg.Button("Delete"), sg.Button("Exit")]]
        output_agent_tab = [[sg.Table(values=dataAgents,
                                     headings=["AgentID", "UserID", "AgentCompany",  "Agent_Name", "Experience", "Location", "Languages"],
                                     auto_size_columns=True,
                                     justification='right',
                                     num_rows=min(len(dataAgents), 10))]]

        edit_agents_window = [[sg.TabGroup([
            [sg.Tab('Create Agent', create_agent_tab)],
            [sg.Tab('Update Agent', update_agent_tab)], [sg.Tab('Delete Agent', delete_agent_tab)],
            [sg.Tab('Output Agent', output_agent_tab)]])]]

        edit_agents_window = sg.Window("Edit Agent Table", edit_agents_window)
        while True:
            event, values = edit_agents_window.read()
            print(event, values)
            # if user closes window or clicks cancel
            if event == sg.WIN_CLOSED:
                break
            if event == 'Create':
                agent_comp = edit_agents_window['-COMPANY_IN-'].get()
                agent_name = edit_agents_window['-NAME_IN-'].get()
                agent_exp = edit_agents_window['-EXP_IN-'].get()
                agent_location = edit_agents_window['-LOCATION_IN-'].get()
                agent_lang = edit_agents_window['-LANGUAGES_IN-'].get()
                createAgentData(agent_comp, agent_name, agent_exp, agent_location, agent_lang)
            elif event == 'Update':
                agent_id = edit_agents_window['-UPD_AGNT_ID-'].get()
                agent_comp = edit_agents_window['-UPD_COMPANY-'].get()
                agent_exp = edit_agents_window['-UPD_EXP-'].get()
                agent_loc = edit_agents_window['-UPD_LOC-'].get()
                agent_lang = edit_agents_window['-UPD_LANG-'].get()
                updateAgentData(agent_id, agent_comp, agent_exp, agent_loc, agent_lang)
            elif event == 'Delete':
                agent_id = edit_agents_window['-DLT_AGENT-'].get()
                deleteAgentData(agent_id)
            elif event == 'Exit':
                break
        edit_agents_window.close()
    def edit_properties_window():
        create_property_tab = [[sg.Text("Enter Agent ID"), sg.Input("", key='-AGNT_ID_IN-')],
                            [sg.Text("Enter Status"), sg.Input("", key='-STATUS_IN-')],
                            [sg.Text("Enter Address"), sg.Input("", key='-ADR_IN-')],
                            [sg.Text("Enter ZipCode"), sg.Input("", key='-ZIP_IN-')],
                            [sg.Text("Enter City"), sg.Input("", key='-CITY_IN-')],
                            [sg.Text("Enter State"), sg.Input("", key='-STATE_IN-')],
                            [sg.Text("Enter SquareFeet"), sg.Input("", key='-SQR_IN-')],
                            [sg.Text("Enter Price"), sg.Input("", key='-PRICE_IN-')],
                            [sg.Text("Enter Type"), sg.Input("", key='-TYPE_IN-')],
                            [sg.Text("Enter Lot size"), sg.Input("", key='-LOT_IN-')],
                            [sg.Text("Enter № of beds"), sg.Input("", key='-BEDS_IN-')],
                            [sg.Text("Enter № of baths "), sg.Input("", key='-BATHS_IN-')],
                            [sg.Button("Create"), sg.Button("Exit")]]
        update_property_tab = [[sg.Text("Enter PropertyID"), sg.Input("", key='-UPD_PR-')],
                            [sg.Text("Enter AgentID"), sg.Input("", key='-UPD_AGENT_ID-')],
                            [sg.Text("Enter Status"), sg.Input("", key='-UPD_STAT-')],
                            [sg.Text("Enter Address"), sg.Input("", key='-UPD_ADR-')],
                            [sg.Text("Enter ZipCode"), sg.Input("", key='-UPD_ZIP-')],
                            [sg.Text("Enter City"), sg.Input("", key='-UPD_CITY-')],
                            [sg.Text("Enter State"), sg.Input("", key='-UPD_STATE-')],
                            [sg.Text("Enter Square Feet"), sg.Input("", key='-UPD_SQR-')],
                            [sg.Text("Enter Price"), sg.Input("", key='-UPD_PRICE-')],
                            [sg.Text("Enter Type"), sg.Input("", key='-UPD_TYPE-')],
                            [sg.Text("Enter Lot Size"), sg.Input("", key='-UPD_LOT-')],
                            [sg.Text("Enter № of beds"), sg.Input("", key='-UPD_BEDS-')],
                            [sg.Text("Enter № of baths"), sg.Input("", key='-UPD_BATHS-')],
                            [sg.Button("Update"), sg.Button("Exit")]]
        delete_property_tab = [[sg.Text("Enter PropertyID"), sg.Input("", key='-DLT_PROPERTY-')],
                            [sg.Button("Delete"), sg.Button("Exit")]]
        output_property_tab = [[sg.Table(values=dataProperties,
                                      headings=["PropertyID", "AgentID", "Status", "Address",  "ZipCode","City", "State", "SquareFeet", "Price", "Type","LotSize","Beds","Baths"],
                                      auto_size_columns=True,
                                      justification='right',
                                      num_rows=min(len(dataProperties), 10))]]

        edit_properties_window = [[sg.TabGroup([
            [sg.Tab('Create Agent', create_property_tab)],
            [sg.Tab('Update Agent', update_property_tab)], [sg.Tab('Delete Agent', delete_property_tab)],
            [sg.Tab('Output Agent', output_property_tab)]])]]

        edit_properties_window = sg.Window("Edit Agent Table", edit_properties_window)
        while True:
            event, values = edit_properties_window.read()
            print(event, values)
            # if user closes window or clicks cancel
            if event == sg.WIN_CLOSED:
                break
            if event == 'Create':
                agent_id = edit_properties_window['-AGNT_ID_IN-'].get()
                property_status = edit_properties_window['-STATUS_IN-'].get()
                property_adress = edit_properties_window['-ADR_IN-'].get()
                property_zip = edit_properties_window['-ZIP_IN-'].get()
                property_city = edit_properties_window['-CITY_IN-'].get()
                property_state = edit_properties_window['-STATE_IN-'].get()
                property_sqr = edit_properties_window['-SQR_IN-'].get()
                property_price = edit_properties_window['-PRICE_IN-'].get()
                property_type = edit_properties_window['-TYPE_IN-'].get()
                property_lot = edit_properties_window['-LOT_IN-'].get()
                property_beds = edit_properties_window['-BEDS_IN-'].get()
                property_baths = edit_properties_window['-BATHS_IN-'].get()
                createPropertiesData(agent_id, property_status, property_adress, property_zip, property_city, property_state, property_sqr, property_price,property_type,
                                property_lot,property_beds,property_baths)
            elif event == 'Update':
                property_id = edit_properties_window['-UPD_PR-'].get()
                agent_id = edit_properties_window['-UPD_AGENT_ID-'].get()
                property_status = edit_properties_window['-UPD_STAT-'].get()
                property_address = edit_properties_window['-UPD_ADR-'].get()
                property_zip = edit_properties_window['-UPD_ZIP-'].get()
                property_city = edit_properties_window['-UPD_CITY-'].get()
                property_state = edit_properties_window['-UPD_STATE-'].get()
                property_sqr = edit_properties_window['-UPD_SQR-'].get()
                property_price = edit_properties_window['-UPD_PRICE-'].get()
                property_type = edit_properties_window['-UPD_TYPE-'].get()
                property_lot = edit_properties_window['-UPD_LOT-'].get()
                property_beds = edit_properties_window['-UPD_BEDS-'].get()
                property_baths = edit_properties_window['-UPD_BATHS-'].get()
                updatePropertiesData(property_id, agent_id, property_status, property_address, property_zip,
                                property_city,property_state,property_sqr,property_price,property_type,
                                property_lot, property_beds, property_baths)
            elif event == 'Delete':
                property_id = edit_properties_window['-DLT_PROPERTY-'].get()
                deletePropertiesData(property_id)
            elif event == 'Exit':
                break
        edit_properties_window.close()

    list = [sg.Listbox(getDataTables(),size=(100,5), enable_events=True, key='-LIST-')]
    selected_db_text = sg.Text(f"Selected database: - ", key='-SELECTED_DB-')
    edit_database_page = [list ,[ selected_db_text, sg.Button("Edit", key='-EDIT_DB-'), sg.Button("Exit")]]
    edit_database_window = sg.Window('Edit Databases', edit_database_page, size=(300, 200))
    while True:
        event, values = edit_database_window.read()
        print(event, values)
        # if user closes window or clicks cancel
        if event == sg.WIN_CLOSED:
            break
        if event == '-LIST-':
           selected_db = values['-LIST-'][0]
           selected_db_text.update(f"Selected database: {selected_db}")
        if event == '-EDIT_DB-':
            if edit_database_window['-LIST-'].get()[0] == 'users':
                edit_user_window()
            elif edit_database_window['-LIST-'].get()[0] == 'agents':
                 edit_agents_window()
            elif edit_database_window['-LIST-'].get()[0] == 'properties':
                edit_properties_window()
        elif event == 'Exit':
            break


    edit_database_window.close()
def olap_window():
    set_union_tab = [[sg.Table(values=otherData1,
                                 headings=["Demographics of our Users"],
                                 auto_size_columns=True,
                                 justification='center',
                                 num_rows=min(len(otherData1), 10))]]
    set_except_tab = [[sg.Table(values=otherData2,
                               headings=["PropertyID", "Address"],
                               auto_size_columns=True,
                               justification='center',
                               num_rows=min(len(otherData2), 10))]]
    set_membership_tab = [[sg.Table(values=otherData3,
                               headings=["AgentID", "PropertyID", "Status", "Address"],
                               auto_size_columns=True,
                               justification='center',
                               num_rows=min(len(otherData3), 10))]]
    set_comparision_tab = [[sg.Table(values=otherData4,
                               headings=["PropertyID", "AgentID", "Status", "Address", "ZipCode", "City", "State", "SquareFeet", "Price", "Type", "LotSize", "Beds", "Baths"],
                               auto_size_columns=True,
                               justification='center',
                               num_rows=min(len(otherData4), 10))]]
    set_with_tab = [[sg.Table(values=otherData5,
                               headings=["PropertyID", "Address", "Status", "Price"],
                               auto_size_columns=True,
                               justification='center',
                               num_rows=min(len(otherData5), 10))]]
    set_advanced_tab = [[sg.Table(values=otherData6,
                               headings=["PropertyID", "Address", "Status", "Price"],
                               auto_size_columns=True,
                               justification='center',
                               num_rows=min(len(otherData6), 10))]]
    set_olap_tab = [[sg.Table(values=otherData7,
                               headings=["Type", "Total_Sold"],
                               auto_size_columns=True,
                               justification='center',
                               num_rows=min(len(otherData7), 10))]]

    edit_users_window = [[sg.TabGroup([
        [sg.Tab('Set Union Data', set_union_tab)],
        [sg.Tab('Set Except Data', set_except_tab)], [sg.Tab('Set Membership Data', set_membership_tab)],
        [sg.Tab('Set Comparison Data', set_comparision_tab)], [sg.Tab('Data using WITH', set_with_tab)],
        [sg.Tab('Set Advanced Data', set_advanced_tab)],[sg.Tab('OLAP', set_olap_tab)]])]]

    edit_users_window = sg.Window("Edit User Table", edit_users_window)
    while True:
        event, values = edit_users_window.read()
        print(event, values)
        # if user closes window or clicks cancel
        if event == sg.WIN_CLOSED:
            break
        if event == 'Create':
            user_name = edit_users_window['-NAME_IN-'].get()
            user_email = edit_users_window['-EMAIL_IN-'].get()
            user_mobile = edit_users_window['-MOBILE_IN-'].get()
            user_type = values['-USER-TYPE-']
            user_address = edit_users_window['-ADDRESS_IN-'].get()
            createUsersData(user_name, user_email, user_mobile, user_type, user_address)
        elif event == 'Update':
            user_id = edit_users_window['-UPD_USER_ID_IN-'].get()
            user_name = edit_users_window['-UPD_NAME_IN-'].get()
            user_email = edit_users_window['-UPD_EMAIL_IN-'].get()
            user_mobile = edit_users_window['-UPD_MOB_NUM_IN-'].get()
            user_type = values['-UPD_USER-TYPE-']
            user_address = edit_users_window['-UPD_ADDRESS_IN-'].get()
            updateUserData(user_id, user_name, user_email, user_mobile, user_type, user_address)
        elif event == 'Delete':
            user_id = edit_users_window['-DLT_USER_IN-'].get()
            deleteUserData(user_id)
        elif event == 'Exit':
            break
    edit_users_window.close()

# Event Loop to process "events" and get the "values" of the inputs
while True:
    event, values = welcome_window.read()
    print(event,values)
    # if user closes window or clicks cancel
    if event == sg.WIN_CLOSED:
        break
    elif event == '-DB-':
        edit_databases_window()
    elif event == '-OLAP-':
        olap_window()
    elif event == 'Exit':
        break

welcome_window.close()