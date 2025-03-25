Attribute VB_Name = "Module1"
Sub CleanPage()
Attribute CleanPage.VB_ProcData.VB_Invoke_Func = " \n14"
'
' Macro1 Macro
'

'
    Cells.Select
    Range("J1").Activate
    With Selection.Font
        .Name = "Calibri"
        .Size = 11
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ColorIndex = xlAutomatic
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    Selection.UnMerge
    With Selection
        .HorizontalAlignment = xlGeneral
        .WrapText = True
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    Cells.EntireColumn.AutoFit
    Cells.EntireRow.AutoFit
    ActiveWindow.SmallScroll Down:=-3
End Sub
