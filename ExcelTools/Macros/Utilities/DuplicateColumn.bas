Attribute VB_Name = "Module1"
Sub Macro1()
Attribute Macro1.VB_ProcData.VB_Invoke_Func = " \n14"
'
' Macro1 Macro
'

'
    ActiveSheet.ListObjects("Table1").Range.AutoFilter Field:=10, Criteria1:= _
        RGB(255, 199, 206), Operator:=xlFilterCellColor
End Sub
