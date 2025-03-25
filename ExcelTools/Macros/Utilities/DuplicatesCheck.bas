Attribute VB_Name = "ModuleDuplicates"
Sub checkduplicate()
    it = ActiveCell.Row
    colc = InputBox("Select the columns which have possible duplicates", "Duplicates")
    For d = it To 10000
     chcol = "" & colc & d
     chcol1 = "" & colc & (d - 1)
     'MsgBox "Are they equal? " & chcol1 & " & " & chcol
     dt = Range(chcol).Value
     dt1 = Range(chcol1).Value
     If dt = dt1 Then
         ActiveCell.Value = "del"
     End If
     ActiveCell.Offset(1, 0).Select
    Next
End Sub
