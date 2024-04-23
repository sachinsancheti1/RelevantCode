Attribute VB_Name = "Module1"


Sub highlightLine()
Attribute highlightLine.VB_ProcData.VB_Invoke_Func = "u\n14"
'
' Macro1 Macro
'

'

ActiveCell.Select
    rr = Selection.Row
Range("Table2").Select
With Selection.Interior
        .Pattern = xlNone
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With

    Range("A" & rr & ":S" & rr).Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent1
        .TintAndShade = 0.599993896298105
        .PatternTintAndShade = 0
    End With
    
    Range("J" & rr & ":J" & rr).Select
    
End Sub
