VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} form_retry 
   Caption         =   "UserForm1"
   ClientHeight    =   2220
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   6165
   OleObjectBlob   =   "form_retry.frx":0000
   StartUpPosition =   1  'Fenstermitte
End
Attribute VB_Name = "form_retry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Private Sub bt_conti_Click()
    
    ap_event_handler.RETRY_LABEL = True
    ap_event_handler.DELETE_LABEL = False
    MsgBox "setRetry" & ap_event_handler.RETRY_LABEL
    Unload Me
End Sub

Private Sub bt_delete_Click()
    ap_event_handler.DELETE_LABEL = True
    ap_event_handler.RETRY_LABEL = False
    Unload Me
End Sub



Private Sub UserForm_Initialize()
    Unload form_add
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    If CloseMode = 0 Then
        ap_event_handler.DELETE_LABEL = True
        ap_event_handler.RETRY_LABEL = False
    End If
End Sub

