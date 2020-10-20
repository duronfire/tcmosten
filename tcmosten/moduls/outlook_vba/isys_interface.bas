Public Sub Auto_Run()

    'Dim myolApp As Outlook.Application
    Dim myNamespace As Outlook.NameSpace
    Dim Calendar As Outlook.MAPIFolder
    
    'Set myolApp = CreateObject("Outlook.Application")
    Set myNamespace = Application.GetNamespace("MAPI")

    Set Calendar = myNamespace.GetDefaultFolder(9)
    
    Dim Today As Date
    Today = Date

    Dim Monday, Sunday As Date
    Monday = Today - Weekday(Date, vbMonday) + 1
    Sunday = DateAdd("d", 6, Monday)
'    MsgBox Monday
'    MsgBox Sunday
    
End Sub

Public Sub add_new_patient()
    form_add.Show
End Sub

Public Sub select_patient()
    form_select.Show
End Sub
