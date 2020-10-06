'disable show reminder in Option "Erweitert"!
'disable reminder default time in Option "kalendar"!

Public WithEvents myOlItems As Outlook.Items


Private Sub Application_Startup()
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
    MsgBox Monday
    MsgBox Sunday
    Initialize_handler
    

End Sub




Public Sub Initialize_handler()
    Set myOlItems = Application.GetNamespace("MAPI").GetDefaultFolder(9).Items
    
    MsgBox "OK"
End Sub

Private Sub myOlItems_ItemAdd(ByVal Item As Object)
    MsgBox "New Patient added"
    Dim subproc
    subproc = Shell("powershell", 1)
End Sub

Private Sub myOlItems_ItemChange(ByVal Item As Object)
    'Reminder must be deactivated!!! Otherwise will case item change every time by dismiss
    MsgBox "New Patient changed"
    MsgBox Item.ReminderSet

End Sub

Private Sub myOlItems_ItemRemove()
    MsgBox "New Patient deleted"

End Sub