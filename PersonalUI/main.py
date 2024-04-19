import tkinter as tk
from tabulate import tabulate
import mysql.connector
from decimal import *
from tkinter import messagebox

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
    table_names = [row[0] for row in output]  # Extract table names from rows
    print(table_names)
    return table_names
def printUserData():
    res = connector.cursor()
    print_query = "SELECT * FROM Users"
    res.execute(print_query)
    output = res.fetchall()
    text = tabulate(output, headers=["UserID", "Name", "Email", "MobileNumber", "BuyerSellerAgent", "Address"])
    return  text

# GENERAL FUNCTIONS
def success_message(): # Check in future
        messagebox.showinfo("Success", "Operation successful!")
def create_user_data(): # Creating user data frame
    EditDataFrame.destroy()
    CreateUserFrame = tk.Frame(root)
    CreateUserFrame.pack()

    label = tk.Label(CreateUserFrame, text="Provide name to add : ", font=("Helvetica", 12, "bold"))
    label.pack( )

    input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    # input_box.grid(row = 0, column= 2)
    input_box.pack()

    label = tk.Label(CreateUserFrame, text="Provide email to add : ", font=("Helvetica", 12, "bold"))
    label.pack(  )

    input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreateUserFrame, text="Provide mobile number to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()

    label = tk.Label(CreateUserFrame, text="Is it buyer, seller, or agent?  ", font=("Helvetica", 12, "bold"))
    label.pack()

    options = {"Buyer", "Seller", "Agent"}
    clicked = tk.StringVar()
    clicked.set("Buyer")

    dropbox = tk.OptionMenu(CreateUserFrame, clicked, *options )
    dropbox.pack()

    label = tk.Label(CreateUserFrame, text="Provide address to add : ", font=("Helvetica", 12, "bold"))
    label.pack()

    input_box = tk.Entry(CreateUserFrame, font=("Helvetica", 12, "bold"))
    input_box.pack()



    button = tk.Button(CreateUserFrame, font=("Helvetica", 14, "bold"), text="Add", command=success_message )
    button.pack()
def update_user_data():
  EditDataFrame.destroy()

  UpdateUserFrame = tk.Frame(root, padx=10, pady=10)
  UpdateUserFrame.pack()

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

  entry_name = tk.Entry(UpdateUserFrame, font=("Helvetica", 12))
  entry_name.grid(row=1, column=1, padx=5, pady=5)

  entry_email = tk.Entry(UpdateUserFrame, font=("Helvetica", 12))
  entry_email.grid(row=2, column=1, padx=5, pady=5)

  entry_mobile_number = tk.Entry(UpdateUserFrame, font=("Helvetica", 12))
  entry_mobile_number.grid(row=3, column=1, padx=5, pady=5)

  entry_status = tk.Entry(UpdateUserFrame, font=("Helvetica", 12))
  entry_status.grid(row=4, column=1, padx=5, pady=5)

  text_address = tk.Entry(UpdateUserFrame, font=("Helvetica", 12))
  text_address.grid(row=5, column=1, padx=5, pady=5)

  button = tk.Button(UpdateUserFrame, font=("Helvetica", 12), text="Update", command=success_message)
  button.grid(row= 6, column= 1, padx=5, pady=5)
def delete_user_data():
    EditDataFrame.destroy()
    DeleteUserFrame = tk.Frame(root, padx=10, pady=10)

    DeleteUserFrame.pack()

    label_user_id = tk.Label(DeleteUserFrame, text="Delete user by UserID", font=("Helvetica", 12, "bold"))
    label_user_id.grid(row=0, column=1, sticky="W")

    label_user_id = tk.Label(DeleteUserFrame, text="User ID:", font=("Helvetica", 12))
    label_user_id.grid(row=1, column=0, sticky="W")

    entry_status = tk.Entry(DeleteUserFrame, font=("Helvetica", 12))
    entry_status.grid(row=1, column=1, padx=5, pady=5)

    button = tk.Button(DeleteUserFrame, text="Delete", font=("Helvetica", 12), command=success_message)
    button.grid(row = 2, column=1)
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
    """Creates the second page with listbox to display table names."""
    root.title("Database Selection")
    label = tk.Label(DatabaseFrame, text="Choose the database to edit", font=("Helvetica", 18, "bold"))
    label.pack()
    table_names_listbox = tk.Listbox(DatabaseFrame, font=("Helvetica", 14), selectmode=tk.SINGLE)

    table_names_listbox.pack(pady=20, padx=20, fill="both", expand=False)


    label = tk.Label(DatabaseFrame, text= "Choosen database: ", font=("Helvetica", 12))
    label.pack(side=tk.LEFT)

    labelToChoose = tk.Label(DatabaseFrame, text="users", font=("Helvetica", 12))
    labelToChoose.pack(side=tk.LEFT)
    table_names = getDataTables()

    def update_selected_label(event):
      selected_table = table_names_listbox.get(tk.ANCHOR)
      print(selected_table)
      labelToChoose.config(text=selected_table)

    table_names_listbox.bind('<<ListboxSelect>>', update_selected_label)
    for table_name in table_names:
      table_names_listbox.insert(tk.END, table_name)
    function = edit_data_frame
    button = tk.Button(DatabaseFrame, text="Submit", command=function)
    button.pack(pady=20, padx=20)
    DatabaseFrame.pack()

def edit_data_frame():
  selected = 3
  DatabaseFrame.destroy()

  root.title("Real Estate Database Manager")

  # Create buttons for CRUD operations

  # Will change later
  create_command = create_user_data
  update_command = update_user_data
  delete_command = delete_user_data
  output_command = output_user_data

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
EditDataFrame = tk.Frame (root)

selected = 1
welcome_page()

root.mainloop()


# 1 - root, 2 - databases, 3 - edit databases




# # Entry field for user input (replace with actual functionality if needed)
# entry = tk.Entry(root)
# entry.pack(pady=10, padx=20)