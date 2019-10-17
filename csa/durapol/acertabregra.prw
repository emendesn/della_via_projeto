/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACERTABREGRAºAutor  ³Reinaldo Caldas     º Data ³  26/09/05 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AcerTabRegra
	Processa({|| RunProc()})
Return

Static Function RunProc

LOCAL _aArea := GetArea()
LOCAL _nRet  := 0

IF Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIF	


cQry := "SELECT ACP_CODPRO, ACO_CODCLI, DA1_PRCVEN, ACP_CODREG, ACP_ITEM, ACP_PRCVEN "
cQry += "FROM "+RetSqlName("ACP") +" ACP, "+RetSqlName("DA1") +" DA1,"+RetSqlName("ACO") +" ACO, "+RetSqlName("DA0")+ " DA0 "
cQry += "WHERE  DA0_CODTAB = '001' AND "
cQry += "ACP_CODPRO = DA1_CODPRO AND "
cQry += "DA0_CODTAB = DA1_CODTAB AND "
cQry += "ACP_PRCTAB <> DA1_PRCVEN AND "
cQry += "ACO_CODREG = ACP_CODREG AND "
cQry += "ACP.D_E_L_E_T_= '' AND "
cQry += "DA1.D_E_L_E_T_= '' AND " 
cQry += "DA0.D_E_L_E_T_= '' "
cQry += "ORDER  BY ACP_CODPRO, ACP_CODREG "

cQry := ChangeQuery(cQry)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TRB",.F.,.T.)

dbSelectArea("TRB")
dbGoTop()

ProcRegua(RecCount())

While !eof()// .and. TRB->ACP_CODREG = '0XQYOO' .and. TRB->ACP_ITEM = '001'
	
	IncProc('Codigo regra ' + TRB->ACP_CODREG + ' Produto '+TRB->ACP_CODPRO)
	
	ACP->( dbSetOrder(1))
	ACP->( dbSeek(xFilial("ACP")+TRB->ACP_CODREG+TRB->ACP_ITEM ) )
	
	_nRet := ((TRB->ACP_PRCVEN/TRB->DA1_PRCVEN)-1)*100
	dbSelectArea("ACP")
	Reclock("ACP",.F.)
		ACP->ACP_PRCTAB := TRB->DA1_PRCVEN
		ACP->ACP_PERDES := IIF( _nRet < 0 , _nRet * (-1), 0)
		ACP->ACP_PERACR := IIF( _nRet > 0 ,	_nRet , 0 )
	MsUnlock()	
	
	dbSelectArea("TRB")
	TRB->( dbSkip() )
	
EndDo

TRB->( dbCloseArea() )

Return