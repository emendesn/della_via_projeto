/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA650GRPV ºAutor  ³Microsiga           º Data ³  07/31/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION Ma650Grpv

LOCAL _aArea    := GetArea()
LOCAL aAreaSav := {}
LOCAL i:=0

// Salva todos os Alias que serão tratados no ponto de entrada
aAreaSav := {{"SC6",0,0},{"SC2",0,0},{"SA1",0,0},{"SD1",0,0}}
For i:= 1 To Len(aAreaSav)
      dbSelectArea(aAreaSav[i][1])
      aAreaSav[i][2] := IndexOrd()
      aAreaSav[i][3] := Recno()
Next

IF SM0->M0_CODIGO == "03"
	
	dbSelectArea("SC6")
	Reclock("SC6",.F.)  
		Replace C6_NUMOP   with SC6->C6_NUM
		Replace C6_ITEMOP  with Substr(SC6->C6_ITEMORI,3,2)		
	MsUnlock()

	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA))
	
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(xFilial("SD1")+SC6->C6_NFORI+SC6->C6_SERIORI+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO+SC6->C6_ITEMORI))

	dbSelectArea("SC2")
	Reclock("SC2",.F.)  
	    Replace C2_NUM     with SC6->C6_NUM
	 	Replace C2_ITEM    with Substr(SC6->C6_ITEMORI,3,2)		
	    Replace C2_XNREDUZ with SA1->A1_NOME
		Replace C2_SERIEPN with SD1->D1_SERIEPN
		Replace C2_NUMFOGO with SD1->D1_NUMFOGO
		Replace C2_MARCAPN with SD1->D1_MARCAPN
		Replace C2_CARCACA with SD1->D1_CARCACA
		Replace C2_SERVPCP with SD1->D1_SERVICO
		Replace C2_X_DESEN with SD1->D1_X_DESEN
		Replace C2_OBS     with SD1->D1_X_OBS
		Replace C2_X_STATU with "1" 
	MsUnlock()   

EndIF

// Recupera todos os alias
For i:= 1 To Len(aAreaSav)
     dbSelectArea(aAreaSav[i][1])
     dbSetOrder(aAreaSav[i][2])
     dbGoTo(aAreaSav[i][3])
Next

RestArea(_aArea)

Return