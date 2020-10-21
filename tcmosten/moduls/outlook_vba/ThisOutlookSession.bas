Public WithEvents myOlItems As Outlook.Items
Public WithEvents folder As Outlook.folder


Private Sub Application_Startup()

    isys_interface.Auto_Run
    isys_interface.init
    Initialize_handler
    

End Sub




Public Sub Initialize_handler()
    Set myOlItems = Application.GetNamespace("MAPI").GetDefaultFolder(9).Items
    Set folder = Application.GetNamespace("MAPI").GetDefaultFolder(9)
End Sub

Private Sub myOlItems_ItemAdd(ByVal Item As Object)

    Dim str_state, str_pid, str_name As String
    str_state = "add"
    str_pid = Item.GlobalAppointmentID
    str_name = Item.Subject

    str_start = Item.start
    str_end = Item.End
    isys_interface.http_post str_state, str_pid, str_name, str_start, str_end

    
    
End Sub

Private Sub myOlItems_ItemChange(ByVal Item As Object)

    Dim str_state, str_pid, str_name As String
    str_state = "change"
    str_pid = Item.GlobalAppointmentID
    str_name = Item.Subject

    str_start = Item.start
    str_end = Item.End
    isys_interface.http_post str_state, str_pid, str_name, str_start, str_end


    
End Sub

Private Sub folder_BeforeItemMove(ByVal Item As Object, ByVal MoveTo As MAPIFolder, Cancel As Boolean)
    
    Dim str_state, str_pid, str_name As String
    str_state = "move"
    str_pid = Item.GlobalAppointmentID
    str_name = Item.Subject

    str_start = Item.start
    str_end = Item.End
    isys_interface.http_post str_state, str_pid, str_name, str_start, str_end

End Sub





