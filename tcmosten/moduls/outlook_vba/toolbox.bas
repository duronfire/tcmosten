
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
            If p_label <> "NA" Then
                patient_matcher = True
                MsgBox ct.LastName + ct.FirstName
            End If
        End If
    End If

End Function

Public Sub init_aplabels(ap_item As Object, ap_type As Boolean, p_ct_item,tp_ct_item As Object)
    Set last_sync = ap_item.UserProperties.Add(isys_interface.uprop_lastsync, olDateTime, olFormatDateTimeShortDateTime)
    Set start_sync = ap_item.UserProperties.Add(isys_interface.uprop_startsync, olDateTime, olFormatDateTimeShortDateTime)
    Set bill_state = ap_item.UserProperties.Add(isys_interface.uprop_billstate, olText)
    Set bill_pid = ap_item.UserProperties.Add(isys_interface.uprop_billpid, olText)
    Set last_bill = ap_item.UserProperties.Add(isys_interface.uprop_lastbill, olDateTime, olFormatDateTimeShortDateTime)
    Set archiev_run = ap_item.UserProperties.Add(isys_interface.uprop_archievrun, olText)
    Set sync_run = ap_item.UserProperties.Add(isys_interface.uprop_syncrun, olText)
    Set sync_state = ap_item.UserProperties.Add(isys_interface.uprop_syncstate, olText)

    Set item_state = ap_item.UserProperties.Add(isys_interface.uprop_itemstate, olText)

    Set ap_label = ap_item.UserProperties.Add(isys_interface.uprop_aplabel, olText)
    Set p_entryid = ap_item.UserProperties.Add(isys_interface.uprop_patient_entryid, olText)
    Set tp_fullname = ap_item.UserProperties.Add(isys_interface.uprop_therapeut_fullname, olText)
    Set tp_pid = ap_item.UserProperties.Add(isys_interface.uprop_therapeut_pid, olText)
    Set ap_category = ap_item.UserProperties.Add(isys_interface.uprop_apcategory, olText)

    if ap_type = True Then
        bill_state.Value = "nobill"
        bill_pid.Value = "nopid"
        archiev_run.Value = "idle"
        sync_run.Value = "idle"
        sync_state.Value = "wait"

        item_state.Value = "created"


        peid = p_ct_item.EntryID
        Set res = Application.GetNamespace("MAPI").GetDefaultFolder(9).Items.Restrict("[" & isys_interface.uprop_patient_entryid & "]='" & peid & "'")
        if res.Count = 0 then
            ap_label.value = "kickoff" 
        ElseIf res.Count > 0 then
            ap_label.value = "followup" 
        End if
        p_entryid.Value = peid
        
        tp_fullname.Value = tp_ct_item.LastName & "_" & tp_ct_item.FirstName 
        tp_pid.Value = tp_ct_item.UserProperties.Find(isys_interface.uprop_therapeut_pid).Value
        ap_category.Value  = "present" ' in work pre-set category in Isys and read value and map to defined value

    else 
        bill_state.Value = "NA"
        bill_pid.Value = "NA"
        archiev_run.Value = "NA"
        sync_run.Value = "NA"
        sync_state.Value = "NA"

        item_state.Value = "NA"

        ap_label.value = "NA" 


        p_entryid.Value = "NA"
        tp_fullname.Value = "NA" ' in work
        tp_pid.Value = "NA" ' in work
        ap_category.Value  = "NA" ' in work pre-set category in Isys and read value and map to defined value
    
    End If





End Sub
