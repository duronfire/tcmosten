Const maxSyncTimeOut = 60
 
Public patient_or_contact As Boolean
 
 
Public Sub add_CT(Item As Object)
 
 
    form_addpatient.Show
    Set last_sync = Item.UserProperties.Add(isys_interface.uprop_lastsync, olDateTime, olFormatDateTimeShortDateTime)
    Set start_sync = Item.UserProperties.Add(isys_interface.uprop_startsync, olDateTime, olFormatDateTimeShortDateTime)
    Set sync_run = Item.UserProperties.Add(isys_interface.uprop_syncrun, olText)
    Set sync_state = Item.UserProperties.Add(isys_interface.uprop_syncstate, olText)
 
    Set item_state = Item.UserProperties.Add(isys_interface.uprop_itemstate, olText)
 
    Set p_label = Item.UserProperties.Add(isys_interface.uprop_ptlabel, olText)
    Set p_state = Item.UserProperties.Add(isys_interface.uprop_patientstate, olText)
 
 
 
 
    
    If patient_or_contact Then
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
 
    If Item.UserProperties.Find(isys_interface.uprop_ptlabel) <> "NA" Then
        If Item.UserProperties.Find(isys_interface.uprop_syncrun).Value = "idle" And DateDiff("s", Item.UserProperties.Find(isys_interface.uprop_lastsync).Value, DateTime.Now) > 1 Then
            Item.UserProperties.Find(isys_interface.uprop_itemstate).Value = "changed"
            MsgBox "Patientdaten geÃ¤ndert!"
        End If
        If Item.UserProperties.Find(isys_interface.uprop_syncrun).Value = "run" And DateDiff("s", Item.UserProperties.Find(isys_interface.uprop_startsync).Value, DateTime.Now) > maxSyncTimeOut Then
            Item.UserProperties.Find(isys_interface.uprop_itemstate).Value = "changed_aft_error"
            MsgBox "Patientdaten geändert!" + vbNewLine + "Die letzte Synchronisierung hat nicht erfolgreich abgeschlossen. Diese Änderung könnte ggf. nicht auf ISYS synchronisiert werden. Funktionen in Outlook werden allerdings nicht beeinträchtigt."
            MsgBox "Achtung: ISYS Datenbank ist nicht mehr aktuell! Informieren Sie bitte Administrator", vbExclamation
        End If
    End If
    
End Sub
 
Public Sub delete_CT(Item As Object, Cancel As Boolean)
    Set p_state = Item.UserProperties.Find(isys_interface.uprop_patientstate)
 
    If Not p_state = "created" Then
        Cancel = True
        MsgBox "Achtung: Löschen dieses Patients ist nicht gestattet, weil ihm noch Termine gehören!", vbExclamation
    End If
 
End Sub


