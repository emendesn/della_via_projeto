#include "rwmake.ch"

User Function DCOMG02 ()

Local _aArea        := GetArea()
Local _nPosQtd      := aScan(aHeader,{|x| Upper (alltrim(x[2])) == "D1_QUANT"})
Local _nPosVunit    := aScan(aHeader,{|x| Upper (alltrim(x[2])) == "D1_VUNIT"})
Local _nPosTotal    := aScan(aHeader,{|x| Upper (alltrim(x[2])) == "D1_TOTAL"})

aCols[n][_nPosQtd] := If(A103Trigger("D1_QUANT"),aCols[n] [_nPosQtd], " ")
aCols[n][_nPosVunit] := If(A103Trigger("D1_VUNIT"),aCols[n] [_nPosVunit], " ")
aCols[n][_nPosTotal] := If(A103Trigger("D1_TOTAL"),aCols[n][_nPosQtd]*aCols[n][_nPosVunit],aCols[n][n_PosQtd]*aCols[n][n_PosVunit])

MaColsToFis (aHeader,aCols,Len(aCols),"MT100",.T.)

RestArea (_aArea)

Return(aCols[n] [_nPosTotal])