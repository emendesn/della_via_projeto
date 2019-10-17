#include "rwmake.ch"

User Function Saldo1

LOCAL aSaldoOk := Array(7)
Local nQtd1    := nQtd2    := nResulta1 := nResulta2 :=0
LOCAL cCod     := "200HBRM        "
LOCAL cLocal   := "01"
Local ddata    := Ctod("11/09/05","ddmmyy")

aSaldoOk := CalcEst(cCod,cLocal,ddata)
nQtd1 :=  aSaldoOk[1] 
nQtd2 :=  aSaldoOk[7]
ALERT(nQtd1)
ALERT(nQtd2)
nResulta1 := Abs(93-nQtd1)
nResulta2 := Abs(2.98-nQtd2)
ALERT(nResulta1)
ALERT(nResulta2)
Return