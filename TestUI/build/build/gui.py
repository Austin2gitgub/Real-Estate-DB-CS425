
# This file was generated by the Tkinter Designer by Parth Jadhav
# https://github.com/ParthJadhav/Tkinter-Designer


from pathlib import Path

# from tkinter import *
# Explicit imports to satisfy Flake8
from tkinter import Tk, Canvas, Entry, Text, Button, PhotoImage


OUTPUT_PATH = Path(__file__).parent
ASSETS_PATH = OUTPUT_PATH / Path(r"C:\Users\omara\Documents\GitHub\Real-Estate-DB-CS425\TestUI\build\build\assets\frame0")


def relative_to_assets(path: str) -> Path:
    return ASSETS_PATH / Path(path)


window = Tk()

window.geometry("916x528")
window.configure(bg = "#FFFFFF")


canvas = Canvas(
    window,
    bg = "#FFFFFF",
    height = 528,
    width = 916,
    bd = 0,
    highlightthickness = 0,
    relief = "ridge"
)

canvas.place(x = 0, y = 0)
canvas.create_rectangle(
    0.0,
    1.0,
    916.0,
    528.0,
    fill="#FFFFFF",
    outline="")

canvas.create_text(
    10.0,
    10.0,
    anchor="nw",
    text="Welcome to Real Estate Database Manager!",
    fill="#000000",
    font=("ArchivoRoman Regular", 32 * -1)
)

canvas.create_text(
    10.0,
    306.0,
    anchor="nw",
    text="App for a Real Estate ( change this one )",
    fill="#000000",
    font=("ArchivoRoman Regular", 32 * -1)
)

canvas.create_rectangle(
    -1.0,
    263.0,
    916.0,
    264.0,
    fill="#FFFFFF",
    outline="")

canvas.create_rectangle(
    43.0,
    103.0,
    179.0,
    239.0,
    fill="#000000",
    outline="")

canvas.create_rectangle(
    190.0,
    103.0,
    326.0,
    239.0,
    fill="#000000",
    outline="")

canvas.create_rectangle(
    348.0,
    103.0,
    484.0,
    239.0,
    fill="#000000",
    outline="")

canvas.create_rectangle(
    518.0,
    103.0,
    654.0,
    239.0,
    fill="#000000",
    outline="")

canvas.create_text(
    10.0,
    52.0,
    anchor="nw",
    text="Made by:",
    fill="#000000",
    font=("ArchivoRoman Regular", 32 * -1)
)

button_image_1 = PhotoImage(
    file=relative_to_assets("button_1.png"))
button_1 = Button(
    image=button_image_1,
    borderwidth=0,
    highlightthickness=0,
    command=lambda: print("button_1 clicked"),
    relief="flat"
)
button_1.place(
    x=226.0,
    y=381.0,
    width=464.0,
    height=62.0
)
window.resizable(False, False)
window.mainloop()
