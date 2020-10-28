Public Const MAX_SYNC_TIMEOUT = 60
Public IS_PATIENT As Boolean
 
Public Sub add_CT(Item As Object)
 
    form_addpatient.Show
    Set last_sync = Item.UserProperties.Add(isys_interface.UPROP_LASTSYNC, olDateTime, olFormatDateTimeShortDateTime)
    Set start_sync = Item.UserProperties.Add(isys_interface.UPROP_STARTSYNC, olDateTime, olFormatDateTimeShortDateTime)
    Set sync_run = Item.UserProperties.Add(isys_interface.UPROP_SYNCRUN, olText)
    Set sync_state = Item.UserProperties.Add(isys_interface.UPROP_SYNCSTATE, olText)
    Set item_state = Item.UserProperties.Add(isys_interface.UPROP_ITEMSTATE, olText)
    Set p_label = Item.UserProperties.Add(isys_interface.UPROP_PTLABEL, olText)
    Set p_state = Item.UserProperties.Add(isys_interface.UPROP_PATIENTSTATE, olText)
 
 
    
    If IS_PATIENT Then
        sync_run.Value = "idle"
        sync_state.Value = "wait"
        item_state.Value = "created"
        p_label.Value = "patient"
        p_state.Value = "created"
        Item.Email3Address = Item.FirstName & "." & Item.LastName & "@dummy.dummy"
    Else
        sync_run.Value = "NA"
        sync_state.Value = "NA"
        item_state.Value = "NA"
        p_label.Value = "NA"
        p_state.Value = "NA"
    End If
    
    Item.Save
End Sub
 
Public Sub change_CT(Item As Object)
    'if a patient or therapeut
    If Item.UserProperties.Find(isys_interface.UPROP_PTLABEL) <> "NA" Then
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

    'check therapeut full name
    if Item.UserProperties.Find(isys_interface.UPROP_TPFULLNAME).Value <> (Item.Recipients.Item(3).AddressEntry.GetContact.LastName & "_" & Item.Recipients.Item(3).AddressEntry.GetContact.FirstName)
End Sub
Public Sub delete_CT(Item As Object, Cancel As Boolean)
 
    Set p_state = Item.UserProperties.Find(isys_interface.UPROP_PATIENTSTATE)
    If Not p_state = "created" OR not p_state = "NA" Then
        Cancel = True
        MsgBox "Achtung: Löschen dieses Patients ist nicht gestattet, weil ihm noch Termine gehören!", vbExclamation
    End If
End Sub

