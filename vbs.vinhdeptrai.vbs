' Filename: alert_loop.vbs

Option Explicit

Dim startTime, elapsedTime
startTime = Timer 

Do
    MsgBox "-6'7+''+(':(('('", vbOKOnly + vbExclamation, "VINH"
    
    elapsedTime = Timer - startTime
    If elapsedTime >= 60 Then Exit Do
Loop
