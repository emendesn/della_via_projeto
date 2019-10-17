/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DFATR11   ºAutor  ³ Reinaldo Caldas    º Data ³  09/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Resumo de vendas por periodo                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol Renovadora de Pneus LTDA.                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DFATR11()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cString
	Private aOrd 		:= {"Valor","Cliente"}
	Private CbTxt       := ""
	Private cDesc1      := "Este relatorio tem a finalidade de demonstrar o total faturado dos clientes "
	Private cDesc2      := "atendidos por seus motoristas, vendedores, indicadores em um periodo."
	Private cDesc3      := "Resumo de Vendas por periodo"
	Private cPict       := ""
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private limite      := 132
	Private tamanho     := "G"
	Private nomeprog    := "DFATR11"
	Private nTipo       := 15
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey    := 0
	Private titulo      := "Resumo de Vendas Geral"
	Private nLin        := 80
	Private nPag		:= 0
	Private Cabec1      := ""
	Private Cabec2      := ""
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private imprime     := .T.
	Private wnrel      	:= "DFATR11"
	Private _cPerg     	:= "DFAT11"
	Private cString 	:= "SF2"

	dbSelectArea("SF2")
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aRegs:={}
	AAdd(_aRegs,{_cPerg,"01","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"02","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

	ValidPerg(_aRegs,_cPerg)

	Pergunte(_cPerg,.F.)

	wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,Tamanho)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	Processa( {|| ImpRel() } )
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpRel   ºAutor  ³ Reinaldo Caldas    º Data ³  09/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para impressao do relatorio                         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpRel()
	LOCAL _cQry := ""
	LOCAL _aTam    := _aEstrutura := {}
	LOCAL nTotVlr  := nTtPneu  := nTotRec := nTtAsTec := nTotNovo := nTtRecap := nTtCons := 0

	Cabec1 := " Periodo de " + DtoC(mv_par01) + " a " + DtoC(mv_par02)
	Cabec2 := " Cliente   Nome Cliente                                              Vlr.Recap     Vlr.Conserto    Ref.    Rec.     Vlr.Ass.Tec.    Vlr.Mercantil        Vlr.Total"
	*           xxxxxx    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   999.999.999.99   999.999.999.99   9.999   9.999   999.999.999.99   999.999.999.99   999.999.999.99
	*           12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	*                    1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17

	ProcRegua(100)

	_aTam := TamSX3("F2_CLIENTE")
	aAdd(_aEstrutura,{"TMP_CLI"     ,"C",_aTam[1],_aTam[2]})

	_aTam := TamSX3("F2_LOJA")
	aAdd(_aEstrutura,{"TMP_LOJA"    ,"C",_aTam[1],_aTam[2]})

	_aTam := TamSX3("A1_NOME")
	aAdd(_aEstrutura,{"TMP_NOME"    ,"C",_aTam[1],_aTam[2]})

	_aTam := TamSX3("F2_VALFAT")
	aAdd(_aEstrutura,{"TMP_VLFAT"   ,"N",_aTam[1],_aTam[2]})

	aAdd(_aEstrutura,{"TMP_VLSRV"   ,"N",_aTam[1],_aTam[2]})
	aAdd(_aEstrutura,{"TMP_VLCON"   ,"N",_aTam[1],_aTam[2]})
	aAdd(_aEstrutura,{"TMP_VLASS"   ,"N",_aTam[1],_aTam[2]})
	aAdd(_aEstrutura,{"TMP_NOVO"    ,"N",_aTam[1],_aTam[2]})
	aAdd(_aEstrutura,{"TMP_REF"     ,"N",4,0})
	aAdd(_aEstrutura,{"TMP_REC"     ,"N",4,0})

	cNomArq := CriaTrab(_aEstrutura,.T.)
	dbUseArea(.T.,,cNomArq,"TMP")

	dbSelectArea("TMP")
	if aReturn[8] = 1
		IndRegua("TMP",cNomArq,"Descend(Strzero(TMP_VLFAT,11,2))",,,"Selecionando Registros")
	Else
		IndRegua("TMP",cNomArq,"TMP_CLI",,,"Selecionando Registros")
	Endif

	dbSetIndex(cNomArq+OrdbagExt())

	GeraTRB()

	dbSelectArea("TMP")
	dbGotop()

	While ! Eof()
		IF lEnd
			@Prow()+1, 001 Psay "Cancelado pelo operador"
			Exit
		EndIF

		IncProc()

		IF nLin > 60
			nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
			nLin += 2
		EndIF

		@ nLin, 001 Psay TMP->TMP_CLI
		@ nLin, 010 Psay Substr(TMP->TMP_NOME,1,40)
		@ nLin, 060 Psay TMP->TMP_VLSRV Picture "@E 999,999,999.99"
		@ nLin, 078 Psay TMP->TMP_VLCON Picture "@E 999,999,999.99"
		@ nLin, 094	Psay TMP->TMP_REF   Picture "@E 9999"
		@ nLin, 100	Psay TMP->TMP_REC   Picture "@E 9999"
		@ nLin, 107	Psay TMP->TMP_VLASS Picture "@E 999,999,999.99"
		@ nLin, 123 Psay TMP->TMP_NOVO  Picture "@E 999,999,999.99"
		@ nLin, 135 Psay TMP->TMP_VLFAT Picture "@E 999,999,999.99"
		nLin ++

		nTotVlr  += TMP->TMP_VLFAT
		nTtCons  += TMP->TMP_VLCON
		nTtPneu  += TMP->TMP_REF
		nTotRec  += TMP->TMP_REC 
		nTtAsTec += TMP->TMP_VLASS
		nTotNovo += TMP->TMP_NOVO
		nTtRecap += TMP->TMP_VLSRV

		dbSelectArea("TMP")
		TMP->(dbSkip())
	EndDo	

	IF nLin != 80
		IF nLin > 50
			nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
			nLin += 2
		EndIF
		nLin++
		@ nLin, 001 Psay "Total : "
		@ nLin, 060 Psay nTtRecap Picture "@E 999,999,999.99"
		@ nLin, 078 Psay nTtCons Picture "@E 999,999,999.99"
		@ nLin, 094	Psay nTtPneu  Picture "@E 9999"
		@ nLin, 100	Psay nTotRec  Picture "@E 9999"
		@ nLin, 107	Psay nTtAsTec Picture "@E 999,999,999.99"
		@ nLin, 123 Psay nTotNovo Picture "@E 999,999,999.99"
		@ nLin, 135 Psay nTotVlr  Picture "@E 999,999,999.99"

		// Roda(cbcont,cbtxt,"M")
	EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomArq+GetDBExtension())
	fErase(cNomArq+OrdbagExt())

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	EndiF

	MS_FLUSH()
Return


Static Function GeraTRB()
	LOCAL _cQry    := ""
	LOCAL nTotVlr  := nTtPneu  := nTotRec := nTtAsTec := nTotNovo := nTtRecap := nTtCons := 0

	IF Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIF

	_cQry := "select F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_VEND3, F2_VEND4, F2_VEND5 "
	_cQry += " from " + RetSqlName("SF2")+ " SF2 "
	_cQry += " where SF2.D_E_L_E_T_ = ' ' "
	_cQry += " and F2_FILIAL = '" + xFilial("SF2") + "' "
	_cQry += " and F2_EMISSAO >= '" + DtoS(mv_par01) + "' and F2_EMISSAO <= '" + DtoS(mv_par02) + "' "
	_cQry += " and F2_TIPO = 'N' "
	_cQry += " order by F2_CLIENTE "
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRB",.F.,.T.)

	dbSelectArea("TRB")
	dbGoTop()

	While ! Eof()
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+TRB->F2_DOC+TRB->F2_SERIE)
	
		While !Eof() .and. TRB->F2_FILIAL+TRB->F2_DOC+TRB->F2_SERIE == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE
			IF SD2->D2_TES $ '594/902' //Nao considero os itens nao agregados
				/*
				IF SD2->D2_TES == '594
					SC6->(dbSetOrder(1))
					SC6->(dbSeek(xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV) )
				
					SC2->(dbSetOrder(1))
					SC2->(dbSeek(xFilial("SC2") + SC6->C6_NFORI + Substr(SC6->C6_ITEMORI,3,2) ) )
					//--Qtd.Reforma
					IF SC2->C2_PERDA = 0
						nTtPneu += SD2->D2_QUANT
					EndIF
				EndIF
				*/
				SD2->(dbSkip())
				Loop
			EndIF

			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
		
			SB1->(dbSetOrder(1))
			SB1->( dbSeek(xFilial("SB1") + SD2->D2_COD,.F.) )
			cGrupo  := AllTrim( Upper(SB1->B1_GRUPO) )

			//--Vlr.Recapagem		
			IF SF4->F4_DUPLIC = 'S' .and. Alltrim(cGrupo) $ "SERV" //Vlr.Recapagem
				nTtRecap += SD2->D2_TOTAL
			EndIF

			//--Vlr.Conserto
			IF SF4->F4_DUPLIC = 'S' .and. Alltrim(cGrupo) $ "CI/SC" //Vlr.Conserto
				nTtCons  += SD2->D2_TOTAL
			EndIF		

			IF SF4->F4_DUPLIC = 'S' .and. Alltrim(cGrupo) == "SERV" //Total de reformas
				nTtPneu += SD2->D2_QUANT
			EndIF		

			//--Qtd.Recusado
			IF SF4->F4_DUPLIC = 'N' .and. Alltrim(cGrupo) == "SERV" //Total de reformas
				nTotRec += SD2->D2_QUANT
			EndIF		

			//--Vlr.Assitencia Tecnica
			IF SF4->F4_DUPLIC = 'S' .and. Alltrim(cGrupo) == "ATEC" 
				nTtAsTec += SD2->D2_TOTAL
			EndIF

			//--Vlr.Mercantil (Pneus novos)
			IF SF4->F4_DUPLIC = 'S' .and. (cGrupo $ "0001" .or. SD2->D2_TES = '503' .or. SD2->D2_TES = '506') // Grupo de Pneus novos by Golo
				nTotNovo += SD2->D2_TOTAL
			EndIF

			//--Vlr.Total Faturado
			IF SF4->F4_DUPLIC = 'S' .and. ! cGrupo $ "CARC" //Total Faturado
				nTotVlr += SD2->D2_TOTAL
			EndIF

			dbSelectArea("SD2")
			dbSkip()
		EndDo

		cCodCli := TRB->F2_CLIENTE+TRB->F2_LOJA

		dbSelectArea("TRB")
		TRB->(dbSkip())

		IF cCodCli != TRB->F2_CLIENTE+TRB->F2_LOJA
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial()+cCodCli))

			dbSelectArea("TMP")
			if Reclock("TMP",.T.)
				TMP->TMP_CLI     := Substr( cCodCli,1,6)
				TMP->TMP_NOME    := Alltrim(SA1->A1_NOME)
				TMP->TMP_VLSRV   := nTtRecap
				TMP->TMP_VLCON   := nTtCons
				TMP->TMP_REF     := nTtPneu
				TMP->TMP_REC     := nTotRec
				TMP->TMP_VLASS   := nTtAsTec
				TMP->TMP_NOVO    := nTotNovo
				TMP->TMP_VLFAT   := nTotVlr
				MsUnlock()
			Endif

			nTotVlr  := nTtPneu  := nTotRec := nTtAsTec := nTotNovo := nTtRecap := nTtCons := 0		
		EndIF
	EndDo

	dbSelectArea("TRB")
	dbCloseArea()
Return