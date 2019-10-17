#include "rwmake.ch"

User Function DCOMG01(_cCampo)

Local _aArea      := GetArea()
Local _nPosServ   := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_SERVICO"})
Local _nPosCod    := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_COD"})
Local _nPosMedid  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_X_MEDID"})
Local _nPosUM     := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_UM"})
Local _nPosQtd    := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_QUANT"})
Local _nPosVUnit  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_VUNIT"})
Local _nPosVTot   := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_TOTAL"})
Local _nPosQtSeg  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_QTSEGUM"})
Local _nPosLocal  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_LOCAL"})
Local _nPosTES    := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_TES"})
Local _nPosCF     := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_CF"})

IF _cCampo == 'D1_SERVICO' .and. cTipo == "B"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+aCols[n][_nPosServ])
	
	IF !Empty(SB1->B1_PRODUTO)
		
		aCols[n][_nPosCod]   := SB1->B1_PRODUTO
		aCols[n][_nPosCod]   := IF(A103Trigger("D1_COD"),aCols[n][_nPosCod],"  ")
		
		aCols[n][_nPosMedid] := SB1->B1_PRODUTO
//		aCols[n][_nPosMedid] := IF(A103Trigger("D1_X_MEDID"),aCols[n][_nPosMedid],"  ")
		
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+SB1->B1_PRODUTO))
		
		aCols[n][_nPosUM]    := SB1->B1_UM
		aCols[n][_nPosUM]    := IF(A103Trigger("D1_UM"),aCols[n][_nPosUM],"  ")
		
		aCols[n][_nPosLocal] := SB1->B1_LOCPAD
		aCols[n][_nPosLocal] :=IF(A103Trigger("D1_LOCAL"),aCols[n][_nPosLocal],"  ")
		
		aCols[n][_nPosQtd]   := 1
		aCols[n][_nPosQtd]   := IF(A103Trigger("D1_QUANT"),aCols[n][_nPosQtd],"  ")
		

		aCols[n][_nPosVUnit] := aCols[n][_nPosVUnit]
		aCols[n][_nPosVUnit] := IF(A103Trigger("D1_VUNIT"),aCols[n][_nPosVUnit],"  ")


		aCols[n][_nPosVTot]  := aCols[n][_nPosVUnit] * aCols[n][_nPosQtd]
		aCols[n][_nPosVTot]  := IF(A103Trigger("D1_TOTAL"),aCols[n][_nPosVTot],"  ")
		
		aCols[n][_nPosQtSeg] := IIF(SB1->B1_X_CONV1 == 0,0,IIF(SB1->B1_X_TPCV1 == "M",NoRound(aCols[n][_nPosQtd]*SB1->B1_X_CONV1,2),NoRound(aCols[n,_nPosQtd]/SB1->B1_X_CONV1,2)))
		aCols[n][_nPosQtSeg] := IF(A103Trigger("D1_QTSEGUM"),aCols[n][_nPosQtSeg],"  ")
		
		aCols[n][_nPosTES]   := "121"
		
		aCols[n][_nPosCF]    := Posicione("SF4",1,xFilial()+aCols[n][_nPosTES],"SF4->F4_CF")
		//aCols[n][_nPosCF]    := IF(A103Trigger("D1_CF"),aCols[n][_nPosCF],"  ")
		
		MaColsToFis(aHeader,aCols,Len(aCols),"MT100",.T.)
		
	Else
		MsgAlert("A carcaca nao esta cadastrada para este servico","Atencao!")		
	EndIF
//	MsgAlert("nao entrou nem no if do produto")
	_cCod := aCols[n][_nPosCod]
Else
	_cCod := ""	
EndIF

RestArea(_aArea)
Return(_cCod)