Attribute VB_Name = "Module2"
Sub FormatLBH()
Attribute FormatLBH.VB_ProcData.VB_Invoke_Func = " \n14"
'
' Macro1 Macro
'

'
    ActiveCell.Columns("A:H").EntireColumn.Select
    Selection.Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    ActiveCell.Offset(1, 0).Range("A1").Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = "=RC[-4]*RC[-5]"
    ActiveCell.Offset(0, 1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "=ROUNDDOWN(RC[-4],0)"
    ActiveCell.Offset(0, 1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "=ROUND(MOD(RC[-5],1)*12,0)"
    ActiveCell.Offset(0, 1).Range("A1").Select
    
    ActiveCell.FormulaR1C1 = "=ROUNDDOWN(RC[-5],0)"
    ActiveCell.Offset(0, 1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "=ROUND(MOD(RC[-6],1)*12,0)"
    ActiveCell.Offset(0, 1).Range("A1").Select
    
    ActiveCell.FormulaR1C1 = "=ROUNDDOWN(RC[-6],0)"
    ActiveCell.Offset(0, 1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "=ROUND(MOD(RC[-7],1)*12,0)"
    ActiveCell.Offset(0, 1).Range("A1").Select
    
    ActiveCell.FormulaR1C1 = _
        "=PRODUCT(RC[-7],IF(SUM(RC[-6],RC[-5]/12)=0,1,SUM(RC[-6],RC[-5]/12)),IF(SUM(RC[-4],RC[-3]/12)=0,1,SUM(RC[-4],RC[-3]/12)),IF(SUM(RC[-2],RC[-1]/12)=0,1,SUM(RC[-2],RC[-1]/12)))"
    ActiveCell.Select
    
End Sub
Sub Macro2()
Attribute Macro2.VB_ProcData.VB_Invoke_Func = " \n14"
'
' Macro2 Macro
'

'
    Selection.Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    ActiveCell.Offset(1, 0).Range("A1").Select
    
End Sub
