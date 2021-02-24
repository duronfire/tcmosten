VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} form_add 
   Caption         =   "Terminassistent"
   ClientHeight    =   5760
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   10575
   OleObjectBlob   =   "form_add.frx":0000
   StartUpPosition =   1  'Fenstermitte
End
Attribute VB_Name = "form_add"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim P_FOUND As Boolean


Private Sub cmd_add_Click()
    Dim patient_gender As String
    Dim row_index As Integer
    
    row_index = therapistComboBox.ListIndex
    
    If Not bt_hr.Value And Not bt_fr.Value Then
        MsgBox "Bitte die Anrede auswählen!"
    Else
        If bt_hr.Value Then
            patient_gender = "Hr."
        Else
            patient_gender = "Fr."
        End If
        form_add.Hide
        toolbox.add_new_patient patient_gender, row_index
        Unload Me
    End If

End Sub

Private Sub cmd_find_Click()
    SearchListBox.Clear
    search_txt = Trim(txt_nachname.Text) & " " & Trim(txt_vorname.Text)
    P_FOUND = toolbox.patient_parser(search_txt)
    If Not P_FOUND Then
        SearchListBox.AddItem
        SearchListBox.List(0, 0) = ""
        SearchListBox.List(0, 1) = "Keinen"
        SearchListBox.List(0, 2) = "Patientenname"
        SearchListBox.List(0, 3) = "getroffen!"
    Else
        fill_listbox
    End If
End Sub

Private Sub cmd_sel_Click()
    If SearchListBox.ListCount > 0 Then
        If P_FOUND Then
            row_index1 = SearchListBox.ListIndex
            row_index2 = therapistComboBox.ListIndex
        

            Set ap_event_handler.SEL_PATIENT_ITEM = toolbox.RESULTS_ITEMS(row_index1)
            Set ap_event_handler.SEL_TP_ITEM = isys_interface.INIT_TP_CTITEMS.item(row_index2 + 1)
            ap_event_handler.RETRY_LABEL = False
            ap_event_handler.PATIENT_MEETING = True
            Unload Me
        End If
    End If
End Sub




Private Sub UserForm_Initialize()
    P_FOUND = False
    SearchListBox.ColumnCount = 4
    therapistComboBox.ColumnCount = 2
    therapistComboBox.TextColumn = 2
    therapistComboBox.ColumnWidths = "58;175;175;97"
    
    
    For i = 1 To isys_interface.INIT_TP_CTITEMS.Count
        therapistComboBox.AddItem
        therapistComboBox.List(i - 1, 0) = isys_interface.INIT_TP_CTITEMS.item(i).UserProperties.Find(isys_interface.UPROP_STAFFPID).Value
        therapistComboBox.List(i - 1, 1) = isys_interface.INIT_TP_CTITEMS.item(i).UserProperties.Find(isys_interface.UPROP_STAFFNAME).Value
        If Not ap_event_handler.TP_EID = "" Then
            If isys_interface.INIT_TP_CTITEMS.item(i).EntryID = ap_event_handler.TP_EID Then
                therapistComboBox.ListIndex = i - 1
            End If
        End If
    Next i
    If therapistComboBox.ListIndex = -1 Then
        therapistComboBox.ListIndex = 0
    End If

    fill_listbox
    If toolbox.LASTNAME_KEYWORD <> "" Or toolbox.FIRSTNAME_KEYWORD <> "" Then
        txt_nachname.Text = toolbox.LASTNAME_KEYWORD
        txt_vorname.Text = toolbox.FIRSTNAME_KEYWORD
    Else
        txt_nachname.Text = toolbox.LASTNAME_KEYWORD
        txt_vorname.Text = toolbox.FIRSTNAME_KEYWORD
    End If
    

End Sub





Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    If CloseMode = 0 Then
        ap_event_handler.PATIENT_MEETING = False
        form_retry.Show
    End If
End Sub

Private Sub fill_listbox()

    If IsArray(toolbox.RESULTS_ITEMS) And UBound(toolbox.RESULTS_ITEMS) >= 0 Then
        P_FOUND = True
        For i = 0 To UBound(toolbox.RESULTS_ITEMS)
            SearchListBox.AddItem
            SearchListBox.List(i, 0) = toolbox.RESULTS_ITEMS(i).Title
            SearchListBox.List(i, 1) = toolbox.RESULTS_ITEMS(i).LastName
            SearchListBox.List(i, 2) = toolbox.RESULTS_ITEMS(i).FirstName
            SearchListBox.List(i, 3) = toolbox.RESULTS_ITEMS(i).Birthday
    
        Next i
    Else:
        SearchListBox.AddItem
        SearchListBox.List(0, 0) = ""
        SearchListBox.List(0, 1) = "Keinen"
        SearchListBox.List(0, 2) = "Patientenname"
        SearchListBox.List(0, 3) = "getroffen!"
    End If
    
    
    If SearchListBox.ListCount > 0 Then
        SearchListBox.ListIndex = 0
    End If
End Sub


