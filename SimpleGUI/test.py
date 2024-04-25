import PySimpleGUI as psg
names = []
lst = psg.Listbox(names, size=(20, 4), font=('Arial Bold', 14), expand_y=True, enable_events=True, key='-LIST-')
layout = [[psg.Input(size=(20, 1), font=('Arial Bold', 14), expand_x=True, key='-INPUT-'),
   psg.Button('Add'),
   psg.Button('Remove'),
   psg.Button('Exit')],
   [lst],
   [psg.Text("", key='-MSG-', font=('Arial Bold', 14), justification='center')]
]
window = psg.Window('Listbox Example', layout, size=(600, 200))
while True:
   event, values = window.read()
   print(event, values)
   if event in (psg.WIN_CLOSED, 'Exit'):
      break
   if event == 'Add':
      names.append(values['-INPUT-'])
      window['-LIST-'].update(names)
      msg = "A new item added : {}".format(values['-INPUT-'])
      window['-MSG-'].update(msg)
   if event == 'Remove':
      val = lst.get()[0]
      names.remove(val)
      window['-LIST-'].update(names)
      msg = "A new item removed : {}".format(val)
      window['-MSG-'].update(msg)
window.close()