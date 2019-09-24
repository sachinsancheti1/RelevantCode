Attribute VB_Name = "Module2"
Sub AllWorkbooks()
   Dim MyFolder As String
   Dim MyFile As String
   Dim wbk As Workbook

On Error Resume Next
Application.ScreenUpdating = False
With Application.FileDialog(msoFileDialogFolderPicker)
.Title = "Please select a folder"
.Show
.AllowMultiSelect = False
   If .SelectedItems.Count = 0 Then
   MsgBox "You did not select a folder"
      Exit Sub
   End If
   MyFolder = .SelectedItems(1) & "\"
End With
MyFile = Dir(MyFolder)

Do While MyFile <> ""
   Set wbk = Workbooks.Open(Filename:=MyFolder & MyFile)
    Application.Run "CleanPage"
   Range("A1:A1").Select
   Selection.EntireRow.Delete
   Range("A1").Offset(0, 0).Value = "Date"
    Range("A1").Offset(0, 1).Value = "fab.rollno"
    Range("A1").Offset(0, 2).Value = "fab.name"
    Range("A1").Offset(0, 3).Value = "fab.rollsize"
    Range("A1").Offset(0, 4).Value = "fab.used"
    Range("A1").Offset(0, 5).Value = "fab.balance"
    Range("A1").Offset(0, 6).Value = "fab.prod.Avg"
wbk.Close savechanges:=True
MyFile = Dir
Loop
Application.ScreenUpdating = True
End Sub

