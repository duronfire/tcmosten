  
Public WithEvents myAPItems As Outlook.Items
Public WithEvents APFolder As Outlook.folder
Public WithEvents myCTItems As Outlook.Items
Public WithEvents CTFolder As Outlook.folder
 
 
 
Private Sub Application_Startup()
    isys_interface.Auto_Run
    isys_interface.init
    Initialize_handler
    isys_interface.get_sync APFolder, CTFolder
End Sub
 
 
 
Public Sub Initialize_handler()
    Set myAPItems = Application.GetNamespace("MAPI").GetDefaultFolder(9).Items
    Set APFolder = Application.GetNamespace("MAPI").GetDefaultFolder(9)
    Set myCTItems = Application.GetNamespace("MAPI").GetDefaultFolder(10).Items
    Set CTFolder = Application.GetNamespace("MAPI").GetDefaultFolder(10)
    
    isys_interface.set_userproperties APFolder, CTFolder
    
    
    
End Sub
 
 
 
Private Sub myAPItems_ItemAdd(ByVal Item As Object)
    MsgBox "add detected"
    ap_event_handler.add_AP Item
    Dim str_state$, str_pid$, str_name As String
    str_state = "add"
    str_pid = Item.GlobalAppointmentID
    str_name = Item.Subject
    str_start = Item.start
    str_end = Item.End
    'isys_interface.http_post str_state, str_pid, str_name, str_start, str_end
    
    
End Sub
Private Sub myAPItems_ItemChange(ByVal Item As Object)
    MsgBox Item.name
    Dim str_state$, str_pid$, str_name As String
    str_state = "change"
    str_pid = Item.GlobalAppointmentID
    str_name = Item.Subject
    str_start = Item.start
    str_end = Item.End
    'isys_interface.http_post str_state, str_pid, str_name, str_start, str_end
 
    
End Sub
Private Sub APfolder_BeforeItemMove(ByVal Item As Object, ByVal MoveTo As MAPIFolder, Cancel As Boolean)
    
    Dim str_state$, str_pid$, str_name As String
    str_state = "move"
    str_pid = Item.GlobalAppointmentID
    str_name = Item.Subject
    str_start = Item.start
    str_end = Item.End
    'isys_interface.http_post str_state, str_pid, str_name, str_start, str_end
End Sub
Private Sub myCTItems_ItemAdd(ByVal Item As Object)
    
    ct_event_handler.add_CT Item
    
    
End Sub
Private Sub myCTItems_ItemChange(ByVal Item As Object)
    
    ct_event_handler.change_CT Item
    
    'isys_interface.http_post str_state, str_pid, str_name, str_start, str_end
 
    
End Sub
Private Sub CTfolder_BeforeItemMove(ByVal Item As Object, ByVal MoveTo As MAPIFolder, Cancel As Boolean)
    
    ct_event_handler.delete_CT Item, Cancel
    'isys_interface.http_post str_state, str_pid, str_name, str_start, str_end
End Sub
 

