
Public Sub Logger(byval message as string)
    logger_num = FreeFile 
    log_file= "C:\ISYS\" & "debug_" & Format(Date.Now, "yyyy_mm_dd" & ".log"
    Open log_file For Append As #logger_num
    Print #logger_num, message
    Close #logger_num
End Sub

