
'subject autochange
'location (x treatment) autochange

Public sel_patient_item
Public sel_tp_item
Public tp_eid
 
Public Sub add_AP(Item As Object)
    patient_meeting = False
 
    If Item.Subject <> "" Then
        subj_str = Split(Item.Subject, ":")
        If subj_str(0) = "p" And UBound(subj_str) = 1 Then
            patient_meeting = True
            
            If subj_str(1) <> "" Then 'moderate case that user find patient over userform and keywords
                Set rp = Item.Recipients.Add(subj_str(1))
                rp.Resolve
                Set ct_item = toolbox.patient_matcher(rp)
                If ct_item Is Nothing Then
                    For i = 1 To Item.Recipients.Count
                        Item.Recipients.Remove 1 'delete all recipients before add use userform
                    Next i
                    toolbox.patient_parser subj_str(1)
                Else
                    ReDim Preserve toolbox.results_items(0) As Object
                    Set toolbox.results_items(0) = ct_item
                End If
            End If
            form_add.Show
        End If
    End If
    
 
 
    If Item.Recipients.Count = 3 And Item.Resources <> "" Then 'best case in which user create appointment without search in userform
        Set ct = Item.Recipients.Item(3).AddressEntry.GetContact
        If Not ct Is Nothing Then
            Set therapeut_pid = ct.UserProperties.Find(isys_interface.uprop_therapeut_pid)
            If therapeut_pid.Value <> "NA" Then
                tp_eid = ct.EntryID
                patient_meeting = True
 
                Set rp = Item.Recipients.Item(2)  'patient recipient index is alway 2 because outlook set resource index alway to last index
                Set ct_item = toolbox.patient_matcher(rp)
                If ct_item Is Nothing Then
                    MsgBox "add something to do if not match, i.e search patient again"
                    form_add.Show
                Else
                    ReDim Preserve toolbox.results_items(0) As Object
                    Set toolbox.results_items(0) = ct_item
                    form_add.Show
                    
                End If
            End If
        End If
    End If
    
<<<<<<< HEAD
    ct_item = sel_patient_item
    If patient_meeting Then
        init_aplabels Item, patient_meeting, ct_item
    End If
 
=======
    ct_item = 'in work
    init_aplabels Item,ap_type,ct_item

                
            
        
    
>>>>>>> dff281abd7062ec749537a5ebcb985ac9a5c0d7e
    
End Sub


