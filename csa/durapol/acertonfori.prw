User Function AcertoNFOri

	Processa({|| RunProc()})

Return

Static Function RunProc


LOCAL _aArea := GetArea()

IF Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIF	

cQry := "SELECT C6_NUM, C6_ITEM, C5_EMISSAO "
cQry += "FROM "+RetSqlName("SC5") +" SC5,"+ RetSqlName("SC6")+" SC6, "+RetSqlName("SF4")+ " SF4, "+RetSqlName("SB1")+" SB1 "
cQry += "WHERE C5_NUM = C6_NUM AND "
cQry += "C6_PRODUTO = B1_COD  AND "
cQry += "B1_GRUPO = 'CARC' AND "
cQry += "C6_TES = F4_CODIGO AND "
cQry += "F4_PODER3 = 'D' AND "
cQry += "(C6_NFORI = '' OR C6_ITEMORI = '') AND "
cQry += "SC5.D_E_L_E_T_ = '' AND "
cQry += "SC6.D_E_L_E_T_= '' AND "
cQry += "SB1.D_E_L_E_T_= '' AND "
cQry += "SF4.D_E_L_E_T_= '' " 
cQry += "ORDER BY C5_EMISSAO, C6_NUM, C6_ITEM "

cQry := ChangeQuery(cQry)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TRB",.F.,.T.)

dbSelectArea("TRB")
dbGoTop()

ProcRegua(RecCount())

While !eof() //.and. TRB->C6_NUM = '074737'
	
	IncProc('Pedido '+TRB->C6_NUM)
	
	SC6->( dbSetOrder(1) )
	SC6->( dbSeek(xFilial("SC6")+TRB->C6_NUM+Soma1(TRB->C6_ITEM) ) )
	
	cNFori   := SC6->C6_NUMOP
	cItemori := SC6->C6_ITEMOP
	
	SC6->( dbSeek(xFilial("SC6")+TRB->C6_NUM+TRB->C6_ITEM) )
	RecLock("SC6",.F.)
		SC6->C6_NFORI   := cNFori
		SC6->C6_NUMOP   := cNFori
		SC6->C6_ITEMORI := Strzero(Val(cItemori),4)
		SC6->C6_ITEMOP  := cItemori 
	MsUnlock()
	
	dbSelectArea("TRB")
	TRB->( dbSkip() )
	
EndDo

TRB->( dbCloseArea() )

Return

