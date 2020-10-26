
Public Sub patient_parser(search_str)
    
    p_filter = "[" & isys_interface.uprop_patientlabel & "] <> 'nonpatient'"
    Set p_res = Application.GetNamespace("MAPI").GetDefaultFolder(10).Items.Restrict(p_filter)
                  
    subnames = Split(isys_interface.workSheet.Trim(search_str), " ")
    
    If UBound(subnames) = 1 Then
    
        subname0_filter_sn = "@SQL=" & Chr(34) & "urn:schemas:contacts:sn" & Chr(34) & " like '%" & isys_interface.workSheet.Trim(subnames(0)) & "%'" 'subname could be "a", if block name is "a b"
        Set subname0_res_sn = p_res.Restrict(subname0_filter_sn)
    
        subname1_filter_gn = "@SQL=" & Chr(34) & "urn:schemas:contacts:givenName" & Chr(34) & " like '%" & isys_interface.workSheet.Trim(subnames(1)) & "%'" 'subname could be "b", if block name is "a b".
        Set subname1_res_gn = p_res.Restrict(subname1_filter_gn)
    
        
        i = 0
        Dim res_items() As Object
        
        If subname0_res_sn.Count > 0 And subname1_res_gn.Count > 0 Then
            For Each item_sn In subname0_res_sn
                For Each item_gn In subname1_res_gn
                    If item_sn.EntryID = item_gn.EntryID Then
                        ReDim Preserve res_items(i) As Object
                        Set res_items(i) = item_gn
                        i = i + 1
                    End If
                Next
            Next
        End If
                    
                    
        If i = 0 Then
            subname1_filter_sn = "@SQL=" & Chr(34) & "urn:schemas:contacts:sn" & Chr(34) & " like '%" & isys_interface.workSheet.Trim(subnames(1)) & "%'" 'subname could be "b", if block name is "a b".
            Set subname1_res_sn = p_res.Restrict(subname1_filter_sn)
    
            subname0_filter_gn = "@SQL=" & Chr(34) & "urn:schemas:contacts:givenName" & Chr(34) & " like '%" & isys_interface.workSheet.Trim(subnames(0)) & "%'" 'subname could be "a", if block name is "a b"
            Set subname0_res_gn = p_res.Restrict(subname0_filter_gn)
    
            
            If subname1_res_sn.Count > 0 And subname0_res_gn.Count > 0 Then
                For Each item_sn In subname1_res_sn
                    For Each item_gn In subname0_res_gn
                        If item_sn.EntryID = item_gn.EntryID Then
                            ReDim Preserve res_items(i) As Object
                            Set res_items(i) = item_gn
                            i = i + 1
                        End If
                    Next
                Next
            End If
        End If
        
        If i > 0 Then
            For j = 0 To i - 1
                MsgBox res_items(j)
                form_add.SearchListBox.AddItem
                form_add.SearchListBox.List(j, 0) = res_items(j).LastName
                form_add.SearchListBox.List(j, 1) = res_items(j).FirstName
                form_add.SearchListBox.List(j, 2) = res_items(j).Birthday
            Next j
        End If
            
        
    ElseIf UBound(subnames) = 0 Then
    
        blockname_filter_sn = "@SQL=" & Chr(34) & "urn:schemas:contacts:sn" & Chr(34) & " like '%" & search_str & "%'" 'block name could be only "a"
        Set blockname_res_sn = p_res.Restrict(blockname_filter_sn)
    
        blockname_filter_gn = "@SQL=" & Chr(34) & "urn:schemas:contacts:givenName" & Chr(34) & " like '%" & search_str & "%'" 'block name could be only "a"
        Set blockname_res_gn = p_res.Restrict(blockname_filter_gn)
    
        j = 0
        If blockname_res_sn.Count > 0 Then
            For Each item_sn In blockname_res_sn
                form_add.SearchListBox.AddItem
                form_add.SearchListBox.List(j, 0) = item_sn.LastName
                form_add.SearchListBox.List(j, 1) = item_sn.FirstName
                form_add.SearchListBox.List(j, 2) = item_sn.Birthday
                j = j + 1
            Next
        End If
        
        If blockname_res_gn.Count > 0 Then
            For Each item_gn In blockname_res_gn
                form_add.SearchListBox.AddItem
                form_add.SearchListBox.List(j, 0) = item_gn.LastName
                form_add.SearchListBox.List(j, 1) = item_gn.FirstName
                form_add.SearchListBox.List(j, 2) = item_gn.Birthday
                j = j + 1
            Next
        End If
    End If
    
    

End Sub

Public Function patient_matcher(rp)

    patient_matcher = False
    If rp.Resolved Then  'Item(1) is alway default to Account Email. NOT TESTED for Multiple Email Accounts!!!!!!!! BUG!!!!!!!!
        Set ct = rp.AddressEntry.GetContact
        If Not ct Is Nothing Then
            Set p_label = ct.UserProperties.Find(isys_interface.uprop_patientlabel)
            If Not p_label Is Nothing Then
                patient_matcher = True
                MsgBox ct.LastName + ct.FirstName
            End If
        End If
    End If

End Function
