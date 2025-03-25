Attribute VB_Name = "Module1"
Sub Macro3()
'
' Macro3 Macro
'

'
    Dim d As String
    d = ActiveCell.Value
    Selection.EntireColumn.Insert , CopyOrigin:=xlFormatFromLeftOrAbove
    ActiveCell.Offset(1, 0).Select
    ActiveCell.FormulaR1C1 = _
        "=STANDARDIZE([@[" & d & "]],SUBTOTAL(1,[" & d & "]),SUBTOTAL(8,[" & d & "]))"
    ActiveCell.Offset(-1, 0).Value = d & "-standardize"
End Sub

