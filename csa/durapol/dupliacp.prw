
User Function DupliACP
	Processa({|| RunProc()})
Return


Static Function RunProc

LOCAL _aArea := GetArea()
LOCAL NITEM  := ""


_cQry := "select B1_COD, ACP_CODREG,ACP_PERDES, ACP_PERACR, ACP_FAIXA, ACP_CFAIXA, ACP_GRUPO "
_cQry += "from " + RetSqlName("SB1")+ " SB1, " + RetSqlName("ACP")+ " ACP "
_cQry += "where B1_TIPO = 'MO' AND B1_GRUPO IN ('CI','SC') AND "
_cQry += "B1_COD = ACP_CODPRO AND "
_cQry += "SB1.D_E_L_E_T_ = '' AND "
_cQry += "ACP.D_E_L_E_T_ = ''
_cQry += "ORDER BY B1_COD, ACP_CODREG "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRB",.F.,.T.)

dbSelectArea("TRB")
dbGoTop()
ProcRegua(RecCount())

While ! Eof()
	IF Substr(TRB->B1_COD,4,1) = 'V' 	
			IncProc('Nao incluisao do Produto ' + Substr(TRB->B1_COD,1,3)+'V' )
  		TRB->( dbSkip() )
   		Loop
   	EndIF
   		  		
   	SB1->(dbSetOrder(1))
   	IF SB1->(dbSeek(xFilial("SB1") + Substr(TRB->B1_COD,1,3)+'V' ) )
   		
   		IncProc('Incluindo Produto ' + Substr(TRB->B1_COD,1,3)+'V' + ' na regra de desconto ' + TRB->ACP_CODREG)
   			
   		_cQry1 := "select ACP_ITEM "
		_cQry1 += "from " + RetSqlName("ACP")+ " ACP " 
		_cQry1 += "where ACP_CODREG = '" + TRB->ACP_CODREG + "' and ACP.D_E_L_E_T_ = '' "
		_cQry1 += "order by ACP_ITEM "			
		_cQry1 := ChangeQuery(_cQry1)

		dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry1),"TRBA",.F.,.T.)
		dbSelectArea("TRBA")
		dbGoTop()
        While ! Eof()            
         	NITEM := TRBA->ACP_ITEM
            dbSelectArea("TRBA")	
     		TRBA->( dbSkip() )
     	EndDo
            
		TRBA->(dbCloseArea())
		
		ACP->(dbSetOrder(2))
	   	IF ! ACP->(dbSeek(xFilial("ACP") + TRB->ACP_CODREG+ TRB->ACP_GRUPO + Substr(TRB->B1_COD,1,3)+'V' ) ) 
			RecLock("ACP",.T.)
				ACP->ACP_ITEM   := Soma1(NITEM)
	   			ACP->ACP_CODREG := TRB->ACP_CODREG
				ACP->ACP_CODPRO := Substr(TRB->B1_COD,1,3)+'V'
	   			ACP->ACP_PERDES := TRB->ACP_PERDES
	   			ACP->ACP_PERACR := TRB->ACP_PERACR
	   			ACP->ACP_FAIXA  := TRB->ACP_FAIXA
	   			ACP->ACP_CFAIXA := TRB->ACP_CFAIXA
	   		Msunlock()
	   		EndIF
   	EndIF
   	
	TRB->( dbSkip() )	
	
Enddo

RestArea(_aArea)

Return