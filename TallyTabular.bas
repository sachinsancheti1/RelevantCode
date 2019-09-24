Attribute VB_Name = "Module1"
Sub AccountsTallyTabular()
Attribute AccountsTallyTabular.VB_ProcData.VB_Invoke_Func = "u\n14"
'
' Macro1 Macro
'

'
    ActiveCell.Offset(1, 0).Range("A1").Select
    Selection.Cut
    ActiveCell.Offset(-1, 1).Range("A1").Select
    ActiveSheet.Paste
    ActiveCell.Offset(2, -1).Range("A1").Select
    Selection.Cut
    ActiveCell.Offset(-2, 2).Range("A1").Select
    ActiveSheet.Paste
    ActiveCell.Offset(1, 1).Range("A1:B1").Select
    Selection.Cut
    ActiveCell.Offset(-1, 0).Range("A1").Select
    ActiveSheet.Paste
    ActiveCell.Offset(1, -4).Range("A1:A2").Select
    Selection.EntireRow.Delete
    ActiveCell.Offset(0, 1).Range("A1").Select
End Sub
