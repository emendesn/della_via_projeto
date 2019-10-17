USER FUNCTION LJ020TES
Local _aArea		:= GetArea()
//Local _cGrTrib		:=""

// Posiciona produto e Pega o Grupo de Triburacao
//_cGrTrib:=  AllTrim(Posicione("SB1",1,xFilial("SB1") + SL2->L2_PRODUTO,"B1_GRTRIB"))
//If (_cGrTrib $ GetMV("MV_GRTRIBV"))  // Se o Produto estiver no parametro especificado nao carrega o acols
	aCols[n,Len(Acols[n])]:= .F.
//EndIf

RestArea(_aArea)
Return

