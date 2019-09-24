Attribute VB_Name = "ModuleDuplicates"
Sub insertRowBelowSlots()
' repeat based on the columns
For j = 1 To 69
slots = ActiveCell.Offset(0, 1).Value - 1
For i = 0 To slots
    ActiveCell.Offset(0, 2).Value = i + 1
    If i < slots Then
        ActiveCell.Offset(1).EntireRow.Insert Shift:=xlDown, CopyOrigin:=xlFormatFromRightOrAbove
    End If
    ActiveCell.Offset(1, 0).Select
Next
Next
End Sub
