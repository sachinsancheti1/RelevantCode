Attribute VB_Name = "Module1"
Sub Macro1()
Attribute Macro1.VB_ProcData.VB_Invoke_Func = " \n14"
'
' Macro1 Macro
'

'
For j = 1 To 5
    ActiveSheet.Range("D8").Select
    For i = 1 To 200
    If ActiveCell.Value = "" And ActiveCell.Offset(0, 1).Value = "" And ActiveCell.Offset(0, 2).Value = "" And ActiveCell.Offset(0, 3).Value = "" Then
    ActiveCell.Rows("1:1").EntireRow.Select
    Selection.Delete Shift:=xlUp
    ActiveCell.Offset(0, 3).Select
    Else
    ActiveCell.Offset(1, 0).Select
    End If
    Next
Next
End Sub
