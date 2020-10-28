'send and get name prefix hr. fr. dr.
 
Public SEL_PATIENT_ITEM
Public SEL_TP_ITEM
Public TP_EID
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
                    ReDim Preserve toolbox.RESULTS_ITEMS(0) As Object
                    Set toolbox.RESULTS_ITEMS(0) = ct_item
                End If
            End If
            form_add.Show
        End If
    End If
    
 
 
    If Item.Recipients.Count = 3 And Item.Resources <> "" Then 'best case in which user create appointment without search in userform
        Set ct = Item.Recipients.Item(3).AddressEntry.GetContact
        If Not ct Is Nothing Then
            Set therapeut_pid = ct.UserProperties.Find(isys_interface.UPROP_TPPID)
            If therapeut_pid.Value <> "NA" Then
                TP_EID = ct.EntryID
                patient_meeting = True
                Set rp = Item.Recipients.Item(2)  'patient recipient index is alway 2 because outlook set resource index alway to last index
                Set ct_item = toolbox.patient_matcher(rp)
                If ct_item Is Nothing Then
                    MsgBox "add something to do if not match, i.e search patient again"
                    form_add.Show
                Else
                    ReDim Preserve toolbox.RESULTS_ITEMS(0) As Object
                    Set toolbox.RESULTS_ITEMS(0) = ct_item
                    form_add.Show
                    
                End If
            End If
        End If
    End If
    
 
    If patient_meeting Then
        toolbox.init_APLABELs Item, patient_meeting, SEL_PATIENT_ITEM, SEL_PATIENT_ITEM
    End If
    
End Sub
 
Public Sub change_AP(Item As Object)

    'if a patient or therapeut
    If Item.UserProperties.Find(isys_interface.UPROP_APLABEL) <> "NA" Then
        'if changed by human?
        If Item.UserProperties.Find(isys_interface.UPROP_SYNCRUN).Value = "idle" Then
            if DateDiff("s", Item.UserProperties.Find(isys_interface.UPROP_LASTSYNC).Value, DateTime.Now) > 1 Then 
                Item.UserProperties.Find(isys_interface.UPROP_ITEMSTATE).Value = "changed"
                MsgBox "Patientendaten geändert und in Outlook gespeichert!"
            End If
        'if changed by human?
        Elseif Item.UserProperties.Find(isys_interface.UPROP_SYNCRUN).Value = "run" then 
            If DateDiff("s", Item.UserProperties.Find(isys_interface.UPROP_STARTSYNC).Value, DateTime.Now) > MAX_SYNC_TIMEOUT Then
                Item.UserProperties.Find(isys_interface.UPROP_ITEMSTATE).Value = "changed_aft_timeout"
                Item.UserProperties.Find(isys_interface.UPROP_SYNCRUN).Value = "error"
                MsgBox "Patientendaten geändert und in Outlook gespeichert!" + vbNewLine + "Die letzte Synchronisierung hat nicht erfolgreich abgeschlossen. Diese Änderung könnte ggf. nicht auf ISYS synchronisiert werden. Funktionen in Outlook werden allerdings nicht beeinträchtigt."
                MsgBox "Achtung: ISYS Datenbank ist nicht mehr aktuell! Informieren Sie bitte Administrator", vbExclamation
            End If
        Else 
                Item.UserProperties.Find(isys_interface.UPROP_ITEMSTATE).Value = "changed_aft_error"
                MsgBox "Patientendaten geändert und in Outlook gespeichert!" & vbNewLine & "Achtung: Die letzten Synchronisierungen waren fehlerhaft! Informieren Sie bitte Administrator", vbExclamation
        End If
    End If

    'check unpermitted changes
    If Item.Recipients.Count = 3 Then 
        'resources name match therapeut name
        if Item.recipients.Item(2).Resolved
        if Item.recipients.Item(3).Resolved
        'patient eid match patienteid in userproperties
        if Item.UserProperties.Find(isys_interface.UPROP_PTEID).Value <> Item.Recipients.Item(2).AddressEntry.GetContact.UserProperties.Find(isys_interface.UPROP_PTEID).Value

        'check therapeut pid in recipients
        if Item.UserProperties.Find(isys_interface.UPROP_TPPID).Value <> Item.Recipients.Item(3).AddressEntry.GetContact.UserProperties.Find(isys_interface.UPROP_TPPID).Value
    Else
        'set back therapeut per pid
        'set back patient per eid
        'set back subject
    End if


    'set apcategory value read from app - TODO
End sub
 

