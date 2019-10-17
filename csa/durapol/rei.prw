


LOCAL _aArea := GetArea()
LOCAL nRet   := 0
dbSelectArea("DA1")
dbSetOrder(1)
dbSeek(xFilial("ACP")+ACO->ACO_CODTAB)+M->ACP_CODPRO)

IF M->ACP_PRCVEN < DA1->DA1_PRCVEN
	nRet :=	NoRound(DA1->DA1_PRCVEN - ( M->ACP_PRCVEN * 100 ) / DA1->DA1_PRCVEN ) )
	NoRound(DA1->DA1_PRCVEN-Round(((ACOTMP->ACP_PERDES/100)*DA1->DA1_PRCVEN),2),2)	
EndIF	

RestArea(_aArea)

Return(nRet)


/*

	nCoefic := ((TRBFAT->D2_PRCVEN+TRBFAT->D2_DESCON)*mv_par19) - TRBFAT->B1_CUSTD
	nPreco :=  TRBFAT->D2_PRCVEN+TRBFAT->D2_DESCON
	
	aAdd(_aTRB,{nCoefic,TRBFAT->D2_COD,TRBFAT->F2_DOC,TRBFAT->F2_CLIENTE,Alltrim(TRBFAT->A1_NOME),;
		Alltrim(TRBFAT->B1_DESC),TRBFAT->B1_PRODUTO,TRBFAT->D2_QUANT,TRBFAT->D2_PEDIDO,;
		nPreco,TRBFAT->F2_VEND3,TRBFAT->F2_VEND4,TRBFAT->F2_VEND5,TRBFAT->A3_NOME,TRBFAT->D2_TES,TRBFAT->B1_CUSTD,TRBFAT->D2_GRUPO,TRBFAT->D2_PRCVEN})	
		
	dbSelectArea("TRBFAT")
	dbSkip()
EndDo
		
dbSelectArea("TRBFAT")
dbCloseArea()

_aTRB := ASort(_aTRB,,,{|x,y| x[1] > y[1] .and. x[11] < y[11]})

_lImp := .F.

For _i := 1 To Len(_aTRB)

	IF lEnd
		@Prow()+1, 001 Psay "Cancelado pelo operador "
		Exit
	EndIF
	
	IncProc()
	
	IF nLin > 60
		Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		nLin := 8
	EndIF
	
	IF nOrdem = 1 .and. _aTRB[_i][2] != cCod
		nLin ++
		@ nLin, 003 Psay 'Faturamento do Produto : '+ _aTRB[_i][2]+' -  '+_aTRB[_i][6]
		cCod := _aTRB[_i][2]
		nLin := nLin + 2
	EndIF
	IF nOrdem = 2 .and. _aTRB[_i][4] != cCodCli
		nLin ++
		@ nLin, 003 Psay 'Faturamento do Cliente : '+ _aTRB[_i][4]+' '+_aTRB[_i][5]
		cCodCli := _aTRB[_i][4]
		nLin := nLin + 2
	EndIF
	IF nOrdem = 3 .and. _aTRB[_i][11] != cCodVen
		nLin ++
		@ nLin, 003 Psay 'Faturamento do Motorista : '+ _aTRB[_i][11]+' '+_aTRB[_i][14]
		cCodVen := cAntCod:= _aTRB[_i][11]
		nLin := nLin + 2
	EndIF
	IF nOrdem = 4 .and. _aTRB[_i][12] != cCodVen4
		nLin ++
		@ nLin, 003 Psay 'Faturamento do Vendedor  : '+ _aTRB[_i][12]+' '+_aTRB[_i][14]
		cCodVen4 := _aTRB[_i][12]
		nLin := nLin + 2
	EndIF
	IF nOrdem = 5 .and. _aTRB[_i][13] != cCodVen5
		nLin ++
		@ nLin, 003 Psay 'Faturamento do Indicador : '+ _aTRB[_i][13]+' '+_aTRB[_i][14]
		cCodVen5 := _aTRB[_i][13]
		nLin := nLin + 2
	EndIF
	
	IF nOrdem = 6 .and. _aTRB[_i][3] != cNota
		nLin ++
		@ nLin, 003 Psay 'Faturamento da Nota : '+ _aTRB[_i][3]
		cNota := _aTRB[_i][3]
		nLin := nLin + 2
	EndIF
	
	IF _aTRB[_i][15] == '594'
		nTtPneu += _aTRB[_i][8]
	EndIF
	
		
	IF _aTRB[_i][15] != '594'
		nTtPneu += _aTRB[_i][8]
		@ nLin, 003 Psay _aTRB[_i][3]
		@ nLin, 013 Psay _aTRB[_i][4]
		@ nLin, 023 Psay _aTRB[_i][5]
		@ nLin, 057 Psay _aTRB[_i][2]
		@ nLin, 077 Psay _aTRB[_i][6]
		@ nLin, 113 Psay _aTRB[_i][7]
		// Banda
		// Largura
		
		IF _aTRB[_i][15] == '903'
			@ nLin, 147 Psay _aTRB[_i][8] Picture "@E 999"
			@ nLin, 158 Psay "RECUSADO"
			@ nLin, 213 Psay _aTRB[_i][9]
			nLin ++
		Else
			nTtPrCus ++
			
			@ nLin, 147 Psay _aTRB[_i][8] Picture "@E 999"
			@ nLin, 157 Psay _aTRB[_i][10] Picture "@Z 99,999.99"
			@ nLin, 168 Psay _aTRB[_i][10]*mv_par19 Picture "@Z 99,999.99" //Coeficiente.
			@ nLin, 178 Psay _aTRB[_i][16] Picture "@Z 99,999.99" //Custo
			@ nLin, 188 Psay (_aTRB[_i][10]*mv_par19) - _aTRB[_i][16] Picture "@Z 99,999.99" //Diferenca
			@ nLin, 203 Psay (_aTRB[_i][10]*mv_par19) / _aTRB[_i][16]   Picture "@Z 999.99"  //Preco/Custo
			@ nLin, 213 Psay _aTRB[_i][9]
			nLin ++
			
			nTotVlr += _aTRB[_i][10]*_aTRB[_i][8]
			nTotCus += _aTRB[_i][16]
			nTotDif += (_aTRB[_i][10]*mv_par19) - _aTRB[_i][16]
			
		EndIF
		
		IF _aTRB[_i][15] == '903'
			nTotRec += _aTRB[_i][8]
		EndIF
		IF Alltrim(_aTRB[_i][17]) $ 'CI/SC'
			nTtCons  += _aTRB[_i][8]
			nVlrCons += _aTRB[_i][8]*_aTRB[_i][18]
		EndIF
	EndIF
	
Next

	IF nOrdem = 1
		//IF _aTRB[_i][2] != cCod  // Totalizadores
			nLin := nLin + 2
			@ nLin, 003 Psay "Pneu(s)        Conserto(s)        Vlr.Conserto(s)         Recusado(s)"
			@ nLin, 150 Psay "Total Venda        Tabela        Custo        Diferença "
			nLin ++
			@ nLin, 005 Psay nTtPneu
			@ nLin, 022 Psay nTtCons
			@ nLin, 039 Psay nVlrCons Picture "@E 99,999,999.99"
			@ nLin, 065 Psay nTotRec
			@ nLin, 147 Psay nTotVlr Picture "@E 99,999,999.99" //Preco de venda
			@ nLin, 162 Psay nTotVlr*mv_par19 Picture "@E 99,999,999.99" //Tabela=Coeficiente
			@ nLin, 175 Psay nTotCus Picture "@E 99,999,999.99" //Custo
			@ nLin, 192 Psay nTotDif Picture "@E 99,999,999.99" //Diferenca
			
			nTotVlr := nTotCus := nTotDif := nTtPneu := nTotRec := nTtCons := nVlrCons := 0
			
			nLin ++
		//EndIF
	ElseIF nOrdem = 2
		//IF _aTRB[_i][4] != cCodCli  // Totalizadores
			nLin := nLin + 2
			@ nLin, 003 Psay "Pneu(s)        Conserto(s)        Vlr.Conserto(s)         Recusado(s)"
			@ nLin, 150 Psay "Total Venda        Tabela        Custo        Diferença "
			nLin ++
			@ nLin, 005 Psay nTtPneu
			@ nLin, 022 Psay nTtCons
			@ nLin, 039 Psay nVlrCons Picture "@E 99,999,999.99"
			@ nLin, 065 Psay nTotRec
			@ nLin, 147 Psay nTotVlr Picture "@E 99,999,999.99"
			@ nLin, 162 Psay nTotVlr*mv_par19 Picture "@E 99,999,999.99"
			@ nLin, 175 Psay nTotCus Picture "@E 99,999,999.99"
			@ nLin, 192 Psay nTotDif Picture "@E 99,999,999.99"
			
			nLin ++
			
			nTotVlr := nTotCus := nTotDif := nTtPneu := nTotRec := nTtCons := nVlrCons := 0
		//EndIF
	ElseIF nOrdem = 3
	//	IF cAntCod != cCodVen
			nLin := nLin + 2
			@ nLin, 003 Psay "Pneu(s)        Conserto(s)        Vlr.Conserto(s)         Recusado(s)"
			@ nLin, 150 Psay "Total Venda        Tabela        Custo        Diferença "
			nLin ++
			@ nLin, 005 Psay nTtPneu
			@ nLin, 022 Psay nTtCons
			@ nLin, 039 Psay nVlrCons Picture "@E 99,999,999.99"
			@ nLin, 065 Psay nTotRec
			@ nLin, 147 Psay nTotVlr Picture "@E 99,999,999.99"
			@ nLin, 162 Psay nTotVlr*mv_par19 Picture "@E 99,999,999.99"
			@ nLin, 175 Psay nTotCus Picture "@E 99,999,999.99"
			@ nLin, 192 Psay nTotDif Picture "@E 99,999,999.99"
			nLin ++
			nTotVlr := nTotCus := nTotDif := nTtPneu := nTotRec := nTtCons := nVlrCons := 0
	  //	EndIF
	ElseIF nOrdem = 4
		//IF _aTRB[_i][11] != cCodVen4
			nLin := nLin + 2
			@ nLin, 003 Psay "Pneu(s)        Conserto(s)        Vlr.Conserto(s)         Recusado(s)"
			@ nLin, 150 Psay "Total Venda        Tabela        Custo        Diferença "
			nLin ++
			@ nLin, 005 Psay nTtPneu
			@ nLin, 022 Psay nTtCons
			@ nLin, 039 Psay nVlrCons Picture "@E 99,999,999.99"
			@ nLin, 065 Psay nTotRec
			@ nLin, 147 Psay nTotVlr Picture "@E 99,999,999.99"
			@ nLin, 162 Psay nTotVlr*mv_par19 Picture "@E 99,999,999.99"
			@ nLin, 175 Psay nTotCus Picture "@E 99,999,999.99"
			@ nLin, 192 Psay nTotDif Picture "@E 99,999,999.99"
			nLin ++
			nTotVlr := nTotCus := nTotDif := nTtPneu := nTotRec := nTtCons := nVlrCons := 0
		//EndIF
	ElseIF nOrdem = 5
		//IF _aTRB[_i][11] != cCodVen5
			nLin := nLin + 2
			@ nLin, 003 Psay "Pneu(s)        Conserto(s)        Vlr.Conserto(s)         Recusado(s)"
			@ nLin, 150 Psay "Total Venda        Tabela        Custo        Diferença "
			nLin ++
			@ nLin, 005 Psay nTtPneu
			@ nLin, 022 Psay nTtCons
			@ nLin, 039 Psay nVlrCons Picture "@E 99,999,999.99"
			@ nLin, 065 Psay nTotRec
			@ nLin, 147 Psay nTotVlr Picture "@E 99,999,999.99"
			@ nLin, 162 Psay nTotVlr*mv_par19 Picture "@E 99,999,999.99"
			@ nLin, 175 Psay nTotCus Picture "@E 99,999,999.99"
			@ nLin, 192 Psay nTotDif Picture "@E 99,999,999.99"
			nLin ++
			nTotVlr := nTotCus := nTotDif := nTtPneu := nTotRec := nTtCons := nVlrCons := 0
		//EndIF	
	Else	
		//IF _aTRB[_i][3] != cNota
			nLin := nLin + 2
			@ nLin, 003 Psay "Pneu(s)        Conserto(s)        Vlr.Conserto(s)         Recusado(s)"
			@ nLin, 150 Psay "Total Venda        Tabela        Custo        Diferença "
			nLin ++
			@ nLin, 005 Psay nTtPneu
			@ nLin, 022 Psay nTtCons
			@ nLin, 039 Psay nVlrCons Picture "@E 99,999,999.99"
			@ nLin, 065 Psay nTotRec
			@ nLin, 147 Psay nTotVlr Picture "@E 99,999,999.99"
			@ nLin, 162 Psay nTotVlr*mv_par19 Picture "@E 99,999,999.99"
			@ nLin, 175 Psay nTotCus Picture "@E 99,999,999.99"
			@ nLin, 192 Psay nTotDif Picture "@E 99,999,999.99"
			nLin ++
			
			nTotVlr := nTotCus := nTotDif := nTtPneu := nTotRec := nTtCons := nVlrCons := 0
		//EndIF
	EndIF


IF nLin != 80
	IF nLin > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	Roda(cbcont,cbtxt,"G")
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPgEject(.F.)

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
*/
