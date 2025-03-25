Attribute VB_Name = "Module11"
Sub ReplicateHeading()
Attribute ReplicateHeading.VB_ProcData.VB_Invoke_Func = " \n14"
'
' Macro1 Macro
'

'
c = InputBox("Please enter column that needs duplication", "Copy Column")
p = InputBox("Enter the Row number", "Row number")
cp = c + p
    nrows = ActiveSheet.UsedRange.Rows.Count
    
    Range(cp).Select
    Selection.Copy
    
    For i = p To nrows
        ActiveCell.Select
        Selection.End(xlDown).Select
        ActiveCell.Offset(-1, 0).Range("A1").Select
        
        If ActiveCell.Row > nrows Then
            Exit For
        End If
        
        Range(Selection, Selection.End(xlUp)).Select
        ActiveSheet.Paste
        Selection.End(xlDown).Select
        Application.CutCopyMode = False
        Selection.Copy
        i = ActiveCell.Row
    Next
End Sub


Sub QuickCull()
cu = InputBox("Please enter row to remove all empty values", "Delete Rows")
    On Error Resume Next
    Columns(cu).SpecialCells(xlBlanks).EntireRow.Delete
End Sub

Sub ReplicateHeadingReverse()
'
' Macro1 Macro
'

'
c = InputBox("Please enter column that needs duplication", "Copy Column")
p = InputBox("Enter the Row number", "Row number")
cp = c + p
    nrows = ActiveSheet.UsedRange.Rows.Count
    
    Range(cp).Select
    Selection.Copy
    
    For i = p To 2 Step -1
        ActiveCell.Select
        Selection.End(xlUp).Select
        ActiveCell.Offset(1, 0).Range("A1").Select
        
        If ActiveCell.Row > nrows Then
            Exit For
        End If
        
        Range(Selection, Selection.End(xlDown)).Select
        ActiveSheet.Paste
        Selection.End(xlUp).Select
        Application.CutCopyMode = False
        Selection.Copy
        i = ActiveCell.Row
    Next
End Sub
