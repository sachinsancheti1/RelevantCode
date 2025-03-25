Attribute VB_Name = "Module1"
Sub FixAttendance()
Attribute FixAttendance.VB_ProcData.VB_Invoke_Func = " \n14"
'
' FixAttendance Macro
'

'
    Cells.Select
    Range("C9").Activate
    With Selection
        .HorizontalAlignment = xlGeneral
        .VerticalAlignment = xlCenter
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    With Selection
        .HorizontalAlignment = xlGeneral
        .VerticalAlignment = xlBottom
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    Selection.UnMerge
    Range("E6").Select
    dd = ActiveSheet.Name
    ActiveCell.FormulaR1C1 = "1" & dd
    Range("F6").Select
    ActiveCell.FormulaR1C1 = "2" & dd
    Range("E6:F6").Select
    ActiveCell.Offset(0, 1).Range("A1").Select
 
    
     Range("E6:F6").Select
    Selection.AutoFill Destination:=Range("E6:AI6"), Type:=xlFillDefault
   
    Range("B4").Select
    Cells.Find(What:="staff attendance", After:=ActiveCell, LookIn:= _
        xlFormulas, LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:= _
        xlNext, MatchCase:=False, SearchFormat:=False).Activate
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Selection.EntireRow.Delete
    Range("A1:C1").Select
    Range("C1").Activate
    Selection.Copy
    Range("A2").Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Range("B1").Select
    Selection.EntireRow.Delete
End Sub

Sub Macro2()
   
'first del col
    Cells.Find(What:="Working Houres", After:=ActiveCell, LookIn:=xlFormulas _
        , LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, _
        MatchCase:=False, SearchFormat:=False).Activate
    Selection.EntireColumn.Delete

'first del col
    Cells.Find(What:="No.of days worked", After:=ActiveCell, LookIn:= _
        xlFormulas, LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:= _
        xlNext, MatchCase:=False, SearchFormat:=False).Activate
    Selection.EntireColumn.Delete

    
'first del col
    Cells.Find(What:="Remarks", After:=ActiveCell, LookIn:=xlFormulas, _
        LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, _
        MatchCase:=False, SearchFormat:=False).Activate
    Selection.EntireColumn.Delete
End Sub
