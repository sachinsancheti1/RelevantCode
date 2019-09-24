Attribute VB_Name = "ModuleDuplicates"
Sub ImportandSortDuplicates()
'
' ImportandSortDuplicates Macro
'

'
    ActiveWorkbook.Queries.Add Name:="duplicatefiles3", Formula:= _
        "let" & Chr(13) & "" & Chr(10) & "    Source = Csv.Document(File.Contents(""C:\DuplicatesRemoval\duplicatefiles3.txt""),[Delimiter=""   "", Columns=8, Encoding=1252, QuoteStyle=QuoteStyle.None])," & Chr(13) & "" & Chr(10) & "    #""Changed Type"" = Table.TransformColumnTypes(Source,{{""Column1"", type text}, {""Column2"", type text}, {""Column3"", type text}, {""Column4"", type text}, {""Column5"", type text}, {""Column6""," & _
        " type text}, {""Column7"", type text}, {""Column8"", Int64.Type}})" & Chr(13) & "" & Chr(10) & "in" & Chr(13) & "" & Chr(10) & "    #""Changed Type"""
    ActiveWorkbook.Worksheets.Add
    With ActiveSheet.ListObjects.Add(SourceType:=0, Source:= _
        "OLEDB;Provider=Microsoft.Mashup.OleDb.1;Data Source=$Workbook$;Location=duplicatefiles3;Extended Properties=""""" _
        , Destination:=Range("$A$1")).QueryTable
        .CommandType = xlCmdSql
        .CommandText = Array("SELECT * FROM [duplicatefiles3]")
        .RowNumbers = False
        .FillAdjacentFormulas = False
        .PreserveFormatting = True
        .RefreshOnFileOpen = False
        .BackgroundQuery = True
        .RefreshStyle = xlInsertDeleteCells
        .SavePassword = False
        .SaveData = True
        .AdjustColumnWidth = True
        .RefreshPeriod = 0
        .PreserveColumnInfo = True
        .ListObject.DisplayName = "duplicatefiles3"
        .Refresh BackgroundQuery:=False
    End With
    Range("A2").Select
    Range(Selection, ActiveCell.SpecialCells(xlLastCell)).Select
    Selection.Copy
    Sheets("Sheet1").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Range("A1").Select
    Range(Selection, Selection.End(xlToRight)).Select
    Application.CutCopyMode = False
    Selection.Cut
    Range("B1").Select
    ActiveSheet.Paste
    Selection.End(xlToLeft).Select
    ActiveCell.FormulaR1C1 = "Sno"
    Range("A2").Select
    Application.CutCopyMode = False
    ActiveSheet.ListObjects.Add(xlSrcRange, Range("$A$1:$H$11020"), , xlYes).Name _
        = "Table2"
    Range("Table2[#All]").Select
    ActiveSheet.ListObjects("Table2").TableStyle = "TableStyleLight8"
    ActiveSheet.ListObjects("Table2").Range.AutoFilter Field:=4, Criteria1:= _
        Array("avi", "BMP", "doc", "jpeg", "jpg", "m3u", "MOV", "mp3", "mp4", "MPG", "pdf", "png", _
        "pptx", "thm", "tif", "zip"), Operator:=xlFilterValues
    Selection.Copy
    Sheets.Add After:=ActiveSheet
    ActiveSheet.Paste
    Application.CutCopyMode = False
    ActiveSheet.ListObjects.Add(xlSrcRange, Range("$A$1:$H$10956"), , xlYes).Name _
        = "Table3"
    Range("Table3[#All]").Select
    ActiveSheet.ListObjects("Table3").TableStyle = "TableStyleLight8"
    ActiveWorkbook.Worksheets("Sheet3").ListObjects("Table3").Sort.SortFields.Clear
    ActiveWorkbook.Worksheets("Sheet3").ListObjects("Table3").Sort.SortFields.Add2 _
        Key:=Range("Table3[V3]"), SortOn:=xlSortOnValues, Order:=xlDescending, _
        DataOption:=xlSortTextAsNumbers
    ActiveWorkbook.Worksheets("Sheet3").ListObjects("Table3").Sort.SortFields.Add2 _
        Key:=Range("Table3[V2]"), SortOn:=xlSortOnValues, Order:=xlDescending, _
        DataOption:=xlSortNormal
    ActiveWorkbook.Worksheets("Sheet3").ListObjects("Table3").Sort.SortFields.Add2 _
        Key:=Range("Table3[ext]"), SortOn:=xlSortOnValues, Order:=xlDescending, _
        DataOption:=xlSortNormal
    ActiveWorkbook.Worksheets("Sheet3").ListObjects("Table3").Sort.SortFields.Add2 _
        Key:=Range("Table3[len]"), SortOn:=xlSortOnValues, Order:=xlAscending, _
        DataOption:=xlSortNormal
    With ActiveWorkbook.Worksheets("Sheet3").ListObjects("Table3").Sort
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
End Sub


Sub checkduplicate()
    it = ActiveCell.Row
    colc = InputBox("Select the columns which have possible duplicates", "Duplicates")
    For d = it To 10956
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



