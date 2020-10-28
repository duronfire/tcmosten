Public winHttp, workSheet As Object
Const additemURL = "http://localhost:8000/isys/http_test/add"
Const changeitemURL = "http://localhost:8000/isys/http_test/change"
Const moveitemURL = "http://localhost:8000/isys/http_test/move"
 
'signal for install ol macro
Public Const uprop_ISYS = "ISYS"
 
'ol read only:
Public Const uprop_lastsync = "lastsync"
Public Const uprop_startsync = "startsync"
Public Const uprop_billstate = "billstate" 'nobill, open, settled,  ap only prop
Public Const uprop_billpid = "billpid" '-1 = nopid, 1 to xxxxx bill pid in sql,  ap only prop
Public Const uprop_lastbill = "lastbill" 'last timestamp of open bill,  ap only prop
Public Const uprop_archievrun = "archievrun" 'idle, run, error for permission archiev ap,  ap only prop
Public Const uprop_syncrun = "syncrun" 'idle, run, error,  for permission save changes
Public Const uprop_syncstate = "syncstate" 'wait,gotsignal,restricted,gotform,gotsqlupdated,saved
Public Const uprop_therapeut_pid = "tppid" ' therapeut has own table, ap only prop
<<<<<<< HEAD
 
=======

>>>>>>> dff281abd7062ec749537a5ebcb985ac9a5c0d7e
'ol sql interact:
Public Const uprop_itemstate = "itemstate" 'created, changed, changed_aft_error, onserver for identify change states, interact with start/last sync stamp
Public Const uprop_ptlabel = "ptlabel" 'patient,therapeut, ct only prop, patient label from ol and therapeut label from sql

'sql read only:
Public Const uprop_patientstate = "patientstate" 'created,new,old,oldnew, ct only prop
Public Const uprop_aplabel = "aplabel" 'kickoffnew,kickoffold,followup,  ap only prop
Public Const uprop_patient_entryid = "pentryid" ' ap only prop
Public Const uprop_therapeut_fullname = "tpfullname" ' ap only prop
Public Const uprop_apcategory = "apcategory" 'present, absent, canceled, notreatment according to category value, ap only prop
 
 
'ol categories:
Public cate_strs
Public cate_colors

Public tp_items


 
 
 
 
 
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
    'MsgBox Monday
    'MsgBox Sunday
    
End Sub
Public Sub init()
    Set winHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
    Set workSheet = CreateObject("Excel.Application").WorksheetFunction

    Set cate_strs = Array("present", "absent", "canceled", "notreatment", "sick") 'all category item names
    Set cate_colors = Array(olCategoryColorGreen, olCategoryColorRed, olCategoryColorOrange, olCategoryColorYellow, olCategoryColorBlue)
    
    get_sync
End Sub
 
Public Function http_post(ByVal state As String, ByVal pid As String, ByVal name As String, ByVal st As Date, ByVal ed As Date) As String
 
    If state = "add" Then
        URL = additemURL
    ElseIf state = "change" Then
        URL = changeitemURL
    ElseIf state = "move" Then
        URL = moveitemURL
    End If
    
    
    
 
    winHttp.Open "GET", URL, False
    winHttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"
    winHttp.Send ""
    headers = winHttp.GetALLResponseHeaders
    cookie = winHttp.GetResponseHeader("Set-Cookie")
    token = Split(Split(winHttp.GetResponseHeader("Set-Cookie"), ";")(0), "=")(1)
    winHttp.Send ""
    
 
    winHttp.Open "POST", URL, False
    winHttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"
    winHttp.SetRequestHeader "Set-Cookie", cookie
    winHttp.SetRequestHeader "X-CSRFToken", token
    nameurl = workSheet.EncodeURL(name)
 
    MsgBox Format(st, "yyyy/MM/dd HH:mm:ss")
    MsgBox Format(ed, "yyyy/MM/dd HH:mm:ss")
 
    winHttp.Send "csrfmiddlewaretoken=" + token + "&" + "state=" + state + "&" + "pid=" + pid + "&" + "name=" + nameurl + "&" + "start=" + Format(st, "yyyy/MM/dd HH:mm:ss") + "&" + "end=" + Format(ed, "yyyy/MM/dd HH:mm:ss")
    
    MsgBox winHttp.ResponseText
    
    response = Replace(Replace(Replace(winHttp.ResponseText, "[", ""), "]", ""), "'", "")
 
    parse_response (response)
    
End Function
 
Public Function parse_response(ByVal response As String) As String
    
    Code = Split(response, "&")(0)
    If Code = 2 Then
        nachnames = Split(Split(response, "&")(1), ",")
        vornames = Split(Split(response, "&")(2), ",")
        For i = 0 To UBound(vornames)
            form_select.NameListBox.AddItem (Trim(nachnames(i)))
            form_select.NameListBox.List(i, 1) = Trim(vornames(i))
        Next i
        
        isys_interface.Select_patient
    End If
End Function
 
 
 
Public Sub Add_new_patient()
    MsgBox "call add_new_patient"
    form_add.Show
End Sub
 
Public Sub Select_patient()
    form_select.Show
    
End Sub
 
Public Sub set_userproperties(APFolder As folder, CTFolder As folder)
 
 
    If APFolder.UserDefinedProperties.Find(uprop_ISYS) Is Nothing Then
    
        APFolder.UserDefinedProperties.Add uprop_ISYS, olText
 
        CTFolder.UserDefinedProperties.Add uprop_ptlabel, olText

        APFolder.UserDefinedProperties.Add uprop_patientstate, olText
 
        CTFolder.UserDefinedProperties.Add uprop_patientstate, olText
        
        APFolder.UserDefinedProperties.Add uprop_lastsync, olDateTime, olFormatDateTimeShortDateTime
        
        CTFolder.UserDefinedProperties.Add uprop_lastsync, olDateTime, olFormatDateTimeShortDateTime
 
        APFolder.UserDefinedProperties.Add uprop_startsync, olDateTime, olFormatDateTimeShortDateTime
 
        CTFolder.UserDefinedProperties.Add uprop_startsync, olDateTime, olFormatDateTimeShortDateTime
        
        APFolder.UserDefinedProperties.Add uprop_syncstate, olText
 
        CTFolder.UserDefinedProperties.Add uprop_syncstate, olText
        
        APFolder.UserDefinedProperties.Add uprop_itemstate, olText
 
        CTFolder.UserDefinedProperties.Add uprop_itemstate, olText
 
        APFolder.UserDefinedProperties.Add uprop_syncrun, olText
 
        CTFolder.UserDefinedProperties.Add uprop_syncrun, olText
        
        APFolder.UserDefinedProperties.Add uprop_patient_entryid, olText 'protect change of patient after appointment is added
        
        CTFolder.UserDefinedProperties.Add uprop_therapeut_fullname, olText 'protect change of therapeut after contact is added
 
        CTFolder.UserDefinedProperties.Add uprop_therapeut_pid, olText 'protect delete of therapeut after contact is added
 
        APFolder.UserDefinedProperties.Add uprop_therapeut_pid, olText 'protect change of therapeut after appointment is added
 
        APFolder.UserDefinedProperties.Add uprop_apcategory, olText 'protect change of category after appointment is added
<<<<<<< HEAD
 
=======

>>>>>>> dff281abd7062ec749537a5ebcb985ac9a5c0d7e
    End If
    
 
End Sub
 
Public Sub create_categories()
    Set cates = Application.GetNamespace("MAPI").Categories
    For i = 0 To UBound(cate_strs)
        matched = False
        For j = 1 To cates.Count
            If cate_str(i) = cates.Item(j).name Then
                matched = True
                Exit For
            End If
        Next j
        If Not matched Then
            cates.Add cate_str(i), cate_colors(i)
        End If
    Next i
End Sub
 
Public Sub get_sync()
    'get all therapeut pids from sql and create local therapeut in outlook - TO DO
    'run sync proc once at start outlook - TODO
    'after retrieve therapeut save it in mem
    Set tp_items = myCTItems.Restrict("[" & isys_interface.uprop_therapeut_pid & "] = 'therapeut'")
    
 
End Sub

