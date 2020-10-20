Dim winHttp, workSheet As Object
Const URL = "http://localhost:8000/isys/http_test"
Public WithEvents myOlItems As Outlook.Items
Public WithEvents folder As Outlook.folder


Private Sub Application_Startup()

    Call isys_interface.Auto_Run
    Initialize_handler
    

End Sub




Public Sub Initialize_handler()
    Set myOlItems = Application.GetNamespace("MAPI").GetDefaultFolder(9).Items
    Set folder = Application.GetNamespace("MAPI").GetDefaultFolder(9)
    Set winHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
    Set workSheet = CreateObject("Excel.Application").WorksheetFunction
    
End Sub

Private Sub myOlItems_ItemAdd(ByVal Item As Object)


    Dim str_state As String
    str_state = "add"
    str_pid = Item.GlobalAppointmentID
    str_name = Item.Subject
    str_anrede = Split(str_name, ".")(0)
    str_vorname = Split(Split(str_name, ".")(1), " ")(1)
    str_nachname = Split(Split(str_name, ".")(1), " ")(0)
    MsgBox str_state, str_pid, str_anrede, str_vorname, str_nachname
    http_post str_state, str_pid, str_anrede, str_vorname, str_nachname
    
    
    
    
    
    MsgBox "New Patient added"
End Sub

Private Sub myOlItems_ItemChange(ByVal Item As Object)
    MsgBox "New Patient changed"
    MsgBox Item.GlobalAppointmentID

End Sub

Private Sub folder_BeforeItemMove(ByVal Item As Object, ByVal MoveTo As MAPIFolder, Cancel As Boolean)
    MsgBox "New Patient deleted"
End Sub



Public Sub http_post(state As String, pid As String, anrede As String, vorname As String, nachname As String)
    winHttp.Open "GET", URL, False
    winHttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"
    winHttp.Send ""
    headers = winHttp.GetALLResponseHeaders
    cookie = winHttp.GetResponseHeader("Set-Cookie")
    token = Split(Split(winHttp.GetResponseHeader("Set-Cookie"), ";")(0), "=")(1)
    MsgBox DefaultFilePath
    winHttp.Send ""
    

    winHttp.Open "POST", URL, False
    winHttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"
    winHttp.SetRequestHeader "Set-Cookie", cookie
    winHttp.SetRequestHeader "X-CSRFToken", token
    vornameurl = workSheet.EncodeURL(vorname)
    nachnameurl = workSheet.EncodeURL(nachname)
    winHttp.Send "state=" + state + "&" + "pid=" + pid + "&" + "anrede=" + anrede + "&" + "vorname=" + vornameurl + "&" + "nachname=" + nachnameurl
    MsgBox winHttp.ResponseText
    
    
End Sub

