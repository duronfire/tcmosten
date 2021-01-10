VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} form_addpatient 
   Caption         =   "Patient anlegen"
   ClientHeight    =   1905
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   6810
   OleObjectBlob   =   "form_addpatient.frx":0000
   StartUpPosition =   1  'Fenstermitte
End
Attribute VB_Name = "form_addpatient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub cmd_addcontact_Click()
    ct_event_handler.IS_PATIENT = False
    Unload Me
End Sub

Private Sub cmd_addpatient_Click()
    ct_event_handler.IS_PATIENT = True
    Unload Me
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    If CloseMode = 0 Then
        MsgBox "Ohne Auswahl vom Kontakttyp wird die Kontakt nicht gespeichert!"
        ct_event_handler.DELETELABEL = True
    End If
End Sub
