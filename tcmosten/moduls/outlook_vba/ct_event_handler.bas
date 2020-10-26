Const maxSyncTimeOut = 60

Public patient_or_contact As Boolean


Public Sub add_CT(Item As Object)
    Set p_label = Item.UserProperties.Add(isys_interface.uprop_patientlabel, olText)
    form_addpatient.Show
    If patient_or_contact Then
        Set last_sync = Item.UserProperties.Add(isys_interface.uprop_lastsync, olDateTime, olFormatDateTimeShortDateTime)
        Set sync_state = Item.UserProperties.Add(isys_interface.uprop_syncstate, olText)
        Set sync_run = Item.UserProperties.Add(isys_interface.uprop_syncrun, olText)
        Set item_state = Item.UserProperties.Add(isys_interface.uprop_itemstate, olText)
        Set start_sync = Item.UserProperties.Add(isys_interface.uprop_startsync, olDateTime, olFormatDateTimeShortDateTime)
        p_label.Value = "created"
        sync_state.Value = "wait"
        sync_run.Value = "idle"
        item_state.Value = "onlocal"
        Item.Email3Address = Item.FirstName & "." & Item.LastName & "@dummy.dummy"
    Else
        p_label.Value = "nonpatient"
    End If
    
    Item.Save
End Sub


Public Sub change_CT(Item As Object)

    If Not Item.UserProperties.Find(isys_interface.uprop_patientlabel) Is Nothing Then
        If Item.UserProperties.Find(isys_interface.uprop_syncrun).Value = "idle" And DateDiff("s", Item.UserProperties.Find(isys_interface.uprop_lastsync).Value, DateTime.Now) > 1 Then
            Item.UserProperties.Find(isys_interface.uprop_itemstate).Value = "changed"
            MsgBox "Patientdaten geändert!"
        End If
        If Item.UserProperties.Find(isys_interface.uprop_syncrun).Value = "run" And DateDiff("s", Item.UserProperties.Find(isys_interface.uprop_startsync).Value, DateTime.Now) > maxSyncTimeOut Then
            Item.UserProperties.Find(isys_interface.uprop_itemstate).Value = "changed_aft_error"
            MsgBox "Patientdaten geändert!" + vbNewLine + "Die letzte Synchronisierung hat nicht erfolgreich abgeschlossen. Diese Änderung könnte ggf. nicht auf ISYS synchronisiert werden. Funktionen in Outlook werden allerdings nicht beeinträchtigt."
            MsgBox "Achtung: ISYS Datenbank ist nicht mehr aktuell! Informieren Sie bitte Administrator", vbExclamation
        End If
    End If
    
End Sub

Public Sub delete_CT(Item As Object, Cancel As Boolean)
    Set p_label = Item.UserProperties.Find(isys_interface.uprop_patientlabel)
    If Not p_label Is Nothing Then
        If Not p_label = "created" Then
            Cancel = True
            MsgBox "Achtung: Löschen dieses Patients ist nicht gestattet, weil ihm noch Termine gehören!", vbExclamation
        End If
    End If
End Sub
