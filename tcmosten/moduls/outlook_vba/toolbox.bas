 
Public RESULTS_ITEMS() As Object
 
 
Public Sub patient_parser(search_str)
    
 
    p_filter = "[" & isys_interface.UPROP_pntlabel & "] = 'patient'"
    Set p_res = Application.GetNamespace("MAPI").GetDefaultFolder(10).Items.Restrict(p_filter) 'restrict and find works only with =  or >  or < not work with <>
    'https://docs.microsoft.com/de-de/office/client-developer/outlook/mapi/commonly-used-property-sets
                  
    subnames = Split(isys_interface.workSheet.Trim(search_str), " ")
    
    If UBound(subnames) = 1 Then
    
        subname0_filter_sn = "@SQL=" & Chr(34) & "urn:schemas:contacts:sn" & Chr(34) & " like '%" & isys_interface.workSheet.Trim(subnames(0)) & "%'" 'subname could be "a", if block name is "a b"
        Set subname0_res_sn = p_res.Restrict(subname0_filter_sn)
    
        subname1_filter_gn = "@SQL=" & Chr(34) & "urn:schemas:contacts:givenName" & Chr(34) & " like '%" & isys_interface.workSheet.Trim(subnames(1)) & "%'" 'subname could be "b", if block name is "a b".
        Set subname1_res_gn = p_res.Restrict(subname1_filter_gn)
    
        
        i = 0
        
        If subname0_res_sn.Count > 0 And subname1_res_gn.Count > 0 Then
            For Each item_sn In subname0_res_sn
                For Each item_gn In subname1_res_gn
                    If item_sn.EntryID = item_gn.EntryID Then
                        ReDim Preserve RESULTS_ITEMS(i) As Object
                        Set RESULTS_ITEMS(i) = item_gn
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
                            ReDim Preserve RESULTS_ITEMS(i) As Object
                            Set RESULTS_ITEMS(i) = item_gn
                            i = i + 1
                        End If
                    Next
                Next
            End If
        End If
        
 
            
        
    ElseIf UBound(subnames) = 0 Then
    
        blockname_filter_sn = "@SQL=" & Chr(34) & "urn:schemas:contacts:sn" & Chr(34) & " like '%" & search_str & "%'" 'block name could be only "a"
        Set blockname_res_sn = p_res.Restrict(blockname_filter_sn)
    
        blockname_filter_gn = "@SQL=" & Chr(34) & "urn:schemas:contacts:givenName" & Chr(34) & " like '%" & search_str & "%'" 'block name could be only "a"
        Set blockname_res_gn = p_res.Restrict(blockname_filter_gn)
    
 
        If blockname_res_sn.Count > 0 Then
            For i = 1 To UBound(blockname_res_sn)
                ReDim Preserve RESULTS_ITEMS(i - 1) As Object
                Set RESULTS_ITEMS(i - 1) = blockname_res_sn.Item(i)
            Next i
        End If
        
        If blockname_res_gn.Count > 0 Then
            For i = 1 To UBound(blockname_res_gn)
                ReDim Preserve RESULTS_ITEMS(i - 1) As Object
                Set RESULTS_ITEMS(i - 1) = blockname_res_gn.Item(i)
            Next i
        End If
    End If
    
    
 
End Sub
Public Function patient_matcher(rp)
    patient_matcher = Nothing
    If rp.Resolved Then  'Item(1) is alway default to Account Email. NOT TESTED for Multiple Email Accounts!!!!!!!! BUG!!!!!!!!
        Set ct = rp.AddressEntry.GetContact
        If Not ct Is Nothing Then
            Set p_label = ct.UserProperties.Find(isys_interface.UPROP_PTLABEL)
            If p_label <> "NA" Then
                patient_matcher = ct
                MsgBox ct.LastName + ct.FirstName
            End If
        End If
    End If
End Function
Public Sub init_APLABELs(ap_item As Object, ap_type As Boolean, p_ct_item As Object, tp_ct_item As Object)
    Set last_sync = ap_item.UserProperties.Add(isys_interface.UPROP_LASTSYNC, olDateTime, olFormatDateTimeShortDateTime)
    Set start_sync = ap_item.UserProperties.Add(isys_interface.UPROP_STARTSYNC, olDateTime, olFormatDateTimeShortDateTime)
    Set bill_state = ap_item.UserProperties.Add(isys_interface.UPROP_BILLSTATE, olText)
    Set bill_pid = ap_item.UserProperties.Add(isys_interface.UPROP_BILLPID, olText)
    Set last_bill = ap_item.UserProperties.Add(isys_interface.UPROP_LASTBILL, olDateTime, olFormatDateTimeShortDateTime)
    Set archiev_run = ap_item.UserProperties.Add(isys_interface.UPROP_ARCHIEVRUN, olText)
    Set sync_run = ap_item.UserProperties.Add(isys_interface.UPROP_SYNCRUN, olText)
    Set sync_state = ap_item.UserProperties.Add(isys_interface.UPROP_SYNCSTATE, olText)
    Set item_state = ap_item.UserProperties.Add(isys_interface.UPROP_ITEMSTATE, olText)
    Set ap_label = ap_item.UserProperties.Add(isys_interface.UPROP_APLABEL, olText)
    Set p_entryid = ap_item.UserProperties.Add(isys_interface.UPROP_PTEID, olText)
    Set tp_fullname = ap_item.UserProperties.Add(isys_interface.UPROP_TPFULLNAME, olText)
    Set tp_pid = ap_item.UserProperties.Add(isys_interface.UPROP_TPPID, olText)
    Set ap_category = ap_item.UserProperties.Add(isys_interface.UPROP_APCATEGORY, olText)
    If ap_type = True Then
        bill_state.Value = "nobill"
        bill_pid.Value = "nopid"
        archiev_run.Value = "idle"
        sync_run.Value = "idle"
        sync_state.Value = "wait"
        item_state.Value = "created"
 
        peid = p_ct_item.EntryID
        Set res = Application.GetNamespace("MAPI").GetDefaultFolder(9).Items.Restrict("[" & isys_interface.UPROP_PTEID & "]='" & peid & "'").Restrict("[Categories]='present'")
        If res.Count = 1 Then
            ap_label.Value = "kickoffnew"
            p_ct_item.UserProperties.Find(isys_interface.UPROP_PATIENTSTATE).Value = "new"
            ap_item.Location = "NEU: " & bill_res.Count & ". Behandlung"   
        ElseIf res.Count > 1 Then
            Set bill_res = res.Restrict("[" & isys_interface.UPROP_BILLSTATE & "]='" & "nobill" & "'")
            If bill_res > 1 Then
                ap_label.Value = "followup"
                p_ct_item.UserProperties.Find(isys_interface.UPROP_PATIENTSTATE).Value = "old"
                ap_item.Location = bill_res.Count & ". Behandlung"
            Else
                ap_label.Value = "kickoffold"
                p_ct_item.UserProperties.Find(isys_interface.UPROP_PATIENTSTATE).Value = "oldnew"
                ap_item.Location = "STAMM: " & bill_res.Count & ". Behandlung"   
            End If
        End If
        p_entryid.Value = peid
        
        tp_fullname.Value = tp_ct_item.LastName & "_" & tp_ct_item.FirstName
        tp_pid.Value = tp_ct_item.UserProperties.Find(isys_interface.UPROP_TPPID).Value
        ap_category.Value = isys_interface.CATEGORY_STRS(0)
        ap_item.Categories = isys_interface.CATEGORY_STRS(0)
 
 
        ap_item.Subject = "Patient: " & p_ct_item.LastName & " " & p_ct_item.FirstName
 
    Else
        bill_state.Value = "NA"
        bill_pid.Value = "NA"
        archiev_run.Value = "NA"
        sync_run.Value = "NA"
        sync_state.Value = "NA"
        item_state.Value = "NA"
        ap_label.Value = "NA"
 
        p_entryid.Value = "NA"
        tp_fullname.Value = "NA"
        tp_pid.Value = "NA"
        ap_category.Value = "NA"
    
    End If
 
 
 
End Sub

