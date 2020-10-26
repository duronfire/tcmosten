'therapeut add logic
'complete autofill listbox

Public Sub add_AP(Item As Object)
    If Item.Subject <> "" Then
        subj_str = Split(Item.Subject, ":")
        If subj_str(0) = "p" And UBound(subj_str) = 1 Then
            If subj_str(1) <> "" Then 'moderate case that user find patient over userform and keywords
                Set rp = Item.Recipients.Add(subj_str(1))
                rp.Resolve
                If Not toolbox.patient_matcher(rp) Then
                    For i = 1 To Item.Recipients.Count
                        Item.Recipients.Remove 1 'delete all recipients before add use userform
                    Next i
                    toolbox.patient_parser subj_str(1)
                    form_add.Show
                End If
            Else                            'worst case that user don't use outlook function to create
                Item.Subject = "Patient: Unbekannter Name"
                Item.Save
                MsgBox "Bitte Nachname oder/und Vorname zum Suchen bzw. Anlegen eingeben!"
                form_add.SearchListBox.AddItem
                form_add.SearchListBox.List(0, 0) = "Kein Ergebnis"
                form_add.Show
            End If
        End If
    End If
    


    If Item.Recipients.Count = 3 And Item.Resources <> "" Then 'best case in which user create appointment without search in userform
        Set ct = Item.Recipients.Item(3).AddressEntry.GetContact
        If Not ct Is Nothing Then
            Set therapeut_pid = ct.UserProperties.Find(isys_interface.uprop_therapeut_pid)
            If Not therapeut_pid Is Nothing Then
                        
                Set rp = Item.Recipients.Item(2)  'patient recipient index is alway 2 because outlook set resource index alway to last index
                If Not toolbox.patient_matcher(rp) Then
                    MsgBox "add something to do if not match, i.e search patient again"
                    form_add.Show
                Else
                    MsgBox "add patient and set labels"
                    form_add.Show
                    
                End If
            End If
        End If
    End If
    

                
            
        
    
    
End Sub

