Attribute VB_Name = "Module5"
Sub Macro2()
Attribute Macro2.VB_ProcData.VB_Invoke_Func = " \n14"
'
' Macro2 Macro
'

'
Dim wb As Workbook
Dim ws As Worksheet
Dim aCell As String
Dim dRang As Range

    aCell = ActiveCell.Value
    
    Windows("Inventory.xlsx").Activate
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Stock Locations")
    ws.Select
    Range("A1").Select
    
    With ws
    Set dRang = .Columns(1).Find(What:=aCell, After:=ActiveCell, LookIn:=xlFormulas, _
        LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, _
        MatchCase:=False, SearchFormat:=False)
        If Not dRang Is Nothing Then
        dRang.Activate
        tt = MsgBox("Item found in Stock", vbOKOnly)
        Else
        MsgBox "Not found"
        End If
        End With
        
End Sub
