Attribute VB_Name = "Module2"
Sub SplitSheettoNewFile()
Attribute SplitSheettoNewFile.VB_ProcData.VB_Invoke_Func = " \n14"
'
' Macro1 Macro
'

'

    ActiveSheet.Select
    ActiveSheet.Copy
    ChDir "F:\Google Drive\Projects in Progress\Nirmala Reddy\Bill of Quantities"
    tt = InputBox("Give name for the document", "Name")
    filnam = "F:\Google Drive\Projects in Progress\Nirmala Reddy\Bill of Quantities\" & tt & ".xlsx"
    ActiveWorkbook.SaveAs Filename:= _
        filnam _
        , FileFormat:=xlOpenXMLWorkbook, CreateBackup:=False
End Sub
