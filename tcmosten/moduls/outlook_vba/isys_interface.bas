Public winHttp, workSheet As Object
Const additemURL = "http://localhost:8000/isys/http_test/add"
Const changeitemURL = "http://localhost:8000/isys/http_test/change"
Const moveitemURL = "http://localhost:8000/isys/http_test/move"
'signal for install ol macro
Public Const UPROP_ISYS = "ISYS"
'ol read only:
Public Const UPROP_LASTSYNC = "lastsync"
Public Const UPROP_STARTSYNC = "startsync"
Public Const UPROP_BILLSTATE = "billstate" 'nobill, open, settled,  ap only prop
Public Const UPROP_BILLPID = "billpid" '-1 = nopid, 1 to xxxxx bill pid in sql,  ap only prop
Public Const UPROP_LASTBILL = "lastbill" 'last timestamp of open bill,  ap only prop
Public Const UPROP_ARCHIEVRUN = "archievrun" 'idle, run, error for permission archiev ap,  ap only prop
Public Const UPROP_SYNCRUN = "syncrun" 'idle, run, error,  for permission save changes
Public Const UPROP_SYNCSTATE= "syncstate" 'wait,gotsignal,restricted,gotform,gotsqlupdated,saved
Public Const UPROP_TPPID = "tppid" ' therapeut has own table, ap only prop
'ol sql interact:
Public Const UPROP_ITEMSTATE = "itemstate" 'created, changed, changed_aft_timeout, changed_aft_error, onserver for identify change states, interact with start/last sync stamp
Public Const UPROP_PTLABEL = "ptlabel" 'patient,therapeut, ct only prop, patient label from ol and therapeut label from sql
 
'sql read only:
Public Const UPROP_PATIENTSTATE = "patientstate" 'created,new,old,oldnew, ct only prop
Public Const UPROP_APLABEL = "aplabel" 'kickoffnew,kickoffold,followup,  ap only prop
Public Const UPROP_PTEID = "pentryid" ' ap only prop
Public Const UPROP_TPFULLNAME = "tpfullname" ' ap only prop
Public Const UPROP_APCATEGORY = "apcategory" 'present, absent, canceled, notreatment according to category value, ap only prop
 
'ol categories:
Public CATEGORY_STRS() As String
 
Public CATEGORY_COLORS() As Variant
 
Public TP_CTITEMS As Object
 
 
 
 
 
 
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
 
    Dim CATEGORY_COLORS(4) as String
    Dim CATEGORY_COLORS(4) as Variant
 
    CATEGORY_STRS(0) ="present"
    CATEGORY_STRS(1) ="absent"
    CATEGORY_STRS(2) ="canceled"
    CATEGORY_STRS(3) ="notreatment"
    CATEGORY_STRS(4) ="sick" 
    
    CATEGORY_COLORS(0) =olCategoryColorGreen
    CATEGORY_COLORS(1) =olCategoryColorRed
    CATEGORY_COLORS(2) =olCategoryColorOrange
    CATEGORY_COLORS(3) =olCategoryColorYellow
    CATEGORY_COLORS(4) =olCategoryColorBlue
 
    
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
 
    If APFolder.UserDefinedProperties.Find(UPROP_ISYS) Is Nothing Then
    
        APFolder.UserDefinedProperties.Add UPROP_ISYS, olText
        CTFolder.UserDefinedProperties.Add UPROP_PTLABEL, olText
 
        APFolder.UserDefinedProperties.Add UPROP_APLABEL, olText
 
        APFolder.UserDefinedProperties.Add UPROP_PATIENTSTATE, olText
        CTFolder.UserDefinedProperties.Add UPROP_PATIENTSTATE, olText
        
        APFolder.UserDefinedProperties.Add UPROP_LASTSYNC, olDateTime, olFormatDateTimeShortDateTime
        
        CTFolder.UserDefinedProperties.Add UPROP_LASTSYNC, olDateTime, olFormatDateTimeShortDateTime
        APFolder.UserDefinedProperties.Add UPROP_STARTSYNC, olDateTime, olFormatDateTimeShortDateTime
        CTFolder.UserDefinedProperties.Add UPROP_STARTSYNC, olDateTime, olFormatDateTimeShortDateTime
        
        APFolder.UserDefinedProperties.Add UPROP_SYNCSTATE, olText
        CTFolder.UserDefinedProperties.Add UPROP_SYNCSTATE, olText
        
        APFolder.UserDefinedProperties.Add UPROP_ITEMSTATE, olText
        CTFolder.UserDefinedProperties.Add UPROP_ITEMSTATE, olText
        APFolder.UserDefinedProperties.Add UPROP_SYNCRUN, olText
        CTFolder.UserDefinedProperties.Add UPROP_SYNCRUN, olText
        
        APFolder.UserDefinedProperties.Add UPROP_PTEID, olText 'protect change of patient after appointment is added
        
        CTFolder.UserDefinedProperties.Add UPROP_TPFULLNAME, olText 'protect change of therapeut after contact is added
        CTFolder.UserDefinedProperties.Add UPROP_TPPID, olText 'protect delete of therapeut after contact is added
        APFolder.UserDefinedProperties.Add UPROP_TPPID, olText 'protect change of therapeut after appointment is added
        APFolder.UserDefinedProperties.Add UPROP_APCATEGORY, olText 'protect change of category after appointment is added
    End If
    
 
End Sub
Public Sub create_categories()
    Set cates = Application.GetNamespace("MAPI").Categories
    For i = 0 To UBound(CATEGORY_STRS)
        matched = False
        For j = 1 To cates.Count
            If CATEGORY_STR(i) = cates.Item(j).name Then
                matched = True
                Exit For
            End If
        Next j
        If Not matched Then
            cates.Add CATEGORY_STR(i), CATEGORY_COLORS(i)
        End If
    Next i
End Sub
Private Sub get_sync(APFolder As folder, CTFolder As folder)
    'check sync state firstly
    check_syncstate APFolder, CTFolder

    'get all therapeut pids from sql and create local therapeut in outlook - TO DO
    'run sync proc once at start outlook - TODO
    'after retrieve therapeut save it in mem
    Set TP_CTITEMS = myCTItems.Restrict("[" & isys_interface.UPROP_TPPID & "] = 'therapeut'")
    
 
End Sub

Private Sub check_syncstate(APFolder As folder, CTFolder As folder)
    Set ap_items = APFolder.Items.Restrict("[syncrun] = 'run'")
    Set ct_items = CTFolder.Items.Restrict("[syncrun] = 'run'")
    if ap_items.Count > 0 Then
        For Each ap_item in ap_items
            if DateDiff("s", ap_item.UserProperties.Find(UPROP_STARTSYNC).Value, DateTime.Now) > ct_event_handler.MAX_SYNC_TIMEOUT Then
                ap_item.UserProperties.Find(UPROP_SYNCRUN).Value = "error"
            End if
        Next
    End if
    if ct_items.Count > 0 Then
        For Each ct_item in ap_items
            if DateDiff("s", ct_item.UserProperties.Find(UPROP_STARTSYNC).Value, DateTime.Now) > ct_event_handler.MAX_SYNC_TIMEOUT Then
                ct_item.UserProperties.Find(UPROP_SYNCRUN).Value = "error"
            End if
        Next
    End if
    Set ap_items = APFolder.Items.Restrict("[syncrun] = 'error'")
    Set ct_items = CTFolder.Items.Restrict("[syncrun] = 'error'")
    For Each ap_item in ap_items
        logger.logger "ap_item " & ap_item.EntryId  &  " [syncrun] = error " & "[startsync] = " & ap_item.UserProperties.Find(UPROP_STARTSYNC) & " [lastsync] = " & ap_item.UserProperties.Find(UPROP_LASTSYNC) & " [syncstate] = " & ap_item.UserProperties.Find(UPROP_SYNCSTATE)
    Next
    
    For Each ct_item in ct_items
        logger.logger "ct_item " & ct_item.EntryId  &  " [syncrun] = error" & "[startsync] = " & ap_item.UserProperties.Find(UPROP_STARTSYNC) & " [lastsync] = " & ap_item.UserProperties.Find(UPROP_LASTSYNC) & " [syncstate] = " & ap_item.UserProperties.Find(UPROP_SYNCSTATE)
    Next
End Sub