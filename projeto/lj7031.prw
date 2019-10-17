#INCLUDE "RWMAKE.CH"

User Function LJ7031

Local _nI
Local _nBKP
Local _aArea 		:= GetArea()
Local _cCond		
Local nPosVrUnit	:=	aScan(aHeader	,{|x| AllTrim(x[2]) == "LR_VRUNIT" })
Local nPosProd		:=	aScan(aHeader	,{|x| AllTrim(x[2]) == "LR_PRODUTO" })
Local _cTmpCond     := Iif(ALTERA.OR.nRotina==2,Left(SL1->L1_VEIPESQ,3),Space(3))

_nBKP := n

If Empty(M->LQ_CONDPG) .AND. nRotina==4 
	M->LQ_CONDPG := SL1->L1_CONDPG   
ElseIf Empty(M->LQ_CONDPG)  .and. nRotina==3 .AND. !Empty(_cD020CPG)
	M->LQ_CONDPG := _cD020CPG
ElseIf nRotina==2
	M->LQ_CONDPG:=_cTmpCond
Endif

_cCond := M->LQ_CONDPG

If Empty(_cCond) .and. !Empty(_cTmpCond)
	_cCond := GetAdvFVal("PAF","PAF_CONDPG",xFilial("PAF")+cFilAnt+M->LQ_TIPOVND,1,"")
ElseIf  Alltrim(_cCond)=="CN" 
	If ALTERA .and. _lCPGCN
		If !Empty(_cTmpCond) 
			_cCond := _cTmpCond
			_cD020CPG := _cTmpCond
		Else
			_cCond := GetAdvFVal("PAF","PAF_CONDPG",xFilial("PAF")+cFilAnt+M->LQ_TIPOVND,1,"")
		Endif
	ElseIf !Empty(_cD020CPG)
		_cCond := _cD020CPG
	Endif
EndIf

Lj7T_Total( 2, Lj7T_Subtotal(2) - Lj7T_DescV(2) )

If len(acols)>0 .and. !Empty(Alltrim(aCols[1][nPosProd]))
	For _nI := 1 to len(aCols)
		n := _nI
		aCols[N][nPosVrUnit] := P_Dela015A(,.F.,Iif(ALTERA,_cd020CPG,_cCond))
	Next
Endif

n := _nBKP

RestArea(_aArea)

