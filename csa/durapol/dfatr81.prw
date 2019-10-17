/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DFATR81     º Autor ³ Microsiga        º Data ³  27/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Margem de Contribuicao Mensal                    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
01/02/06 - Denis Tofoli - Incluir o campo D2_DESCON na soma da coluna faturados
07/02/06 - Denis Tofoli - Incluida a coluna de descontos e total do SEPU
/*/
USER FUNCTION DFATR81
	LOCAL cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	LOCAL cDesc2         := "de acordo com os parametros informados pelo usuario."
	LOCAL cDesc3         := "Margem de Contribuicao por Vendedor"
	LOCAL cPict          := ""
	LOCAL titulo         := "Margem de Contribuicao por Vendedor"
	LOCAL nLin           := 80
	LOCAL Cabec1         := ""
	LOCAL Cabec2         := ""
	LOCAL imprime        := .T.
	LOCAL aOrd           := {}
	LOCAL aPergunta         :={}
	PRIVATE lEnd         := .F.
	PRIVATE lAbortPrint  := .F.
	PRIVATE CbTxt        := ""
	PRIVATE limite       := 220
	PRIVATE tamanho      := "G"
	PRIVATE nomeprog     := "DFATR81"
	PRIVATE nTipo        := 15
	PRIVATE aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	PRIVATE nLastKey     := 0
	PRIVATE cPerg        := "FATR81"
	PRIVATE cbtxt        := Space(10)
	PRIVATE cbcont       := 00
	PRIVATE CONTFL       := 01
	PRIVATE m_pag        := 01
	PRIVATE wnrel        := "DFATR81"
	PRIVATE cString      := "SD2"

	dbSelectArea("SD2")
	dbSetOrder(5)

	// mv_par01 Da Data ?
	// mv_par02 Ate Data ?

	AAdd(aPergunta,{cPerg,"01","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aPergunta,{cPerg,"02","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aPergunta,{cPerg,"03","Coeficiente Liq.?" ,"Coeficiente Liq","Coeficiente Liq","mv_ch3","N", 6,4,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aPergunta,{cPerg,"04","Custo Fixo ?"      ,"Custo Fixo?"    ,"Coeficiente Liq","mv_ch4","N",17,2,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aPergunta,{cPerg,"05","Separar?"          ,"Separar"        ,"Separar"        ,"mv_ch5","N", 1,0,0,"C","","mv_par05","Motorista","","","","","Vendendor","","","","","Indicador","","","","","Todos","","","","","","","","",""})
	AAdd(aPergunta,{cPerg,"06","Do vendedor ?"     ,"Do vendedor ?"  ,"Do vendedor ?"  ,"mv_ch6","C", 6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(aPergunta,{cPerg,"07","Até o vendedor ?"  ,"Até vendedor ?" ,"Até vendedor ?" ,"mv_ch7","C", 6,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})

	ValidPerg(aPergunta,cPerg)

	pergunte(cPerg,.F.)

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Microsiga          º Data ³  27/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION RunReport(Cabec1,Cabec2,Titulo,nLin)
	LOCAL nOrdem
	LOCAL aArqTrab        := {}
	LOCAL aResumoPneus    := {}
	LOCAL aResumoSepu     := {}
	LOCAL cArqTrab        := ""
	LOCAL cGrupo          := ""
	LOCAL lRecapa         := .F.
	LOCAL lServic         := .F.
	LOCAL lNovo           := .F.
	LOCAL lAssTec         := .F.
	LOCAL lOutros         := .F.
	LOCAL nCustoGerencial := 0
	LOCAL nPneus          := 0
	LOCAL nTotFatura      := 0
	LOCAL nTotDescon      := 0
	LOCAL nTotRecapa      := 0
	LOCAL nTotServic      := 0
	LOCAL nTotAssTec      := 0
	LOCAL nTotNovo        := 0
	LOCAL nTotCusto       := 0
	LOCAL nTotMargCon     := 0
	LOCAL nTotPneus       := 0
	LOCAL nTotOutros      := 0
	LOCAL nAcuFatur       := 0
	LOCAL nAcuCusto       := 0
	LOCAL nTotServ        := 0

	Titulo := AllTrim(Titulo) + " de " + DtoC(mv_par01) + " a " + DtoC(mv_par02)
	Cabec1 := " Data     Faturamento   Descontos   Recapagem    Servicos  Ass.Tecnica  Vlr.Mercantil        Custo    %Margem     Acumulado    Acum.Custo  %Margem  Marg.Contr  Pneus           Outros"
	Cabec2 := "                                                                                                                  Recapagem"

	//-- CRIA ARQUIVO DE TRABALHO PARA PROCESSAMENTO DA LEITURA DE ITENS NOTAS FISCAIS
	AAdd(aArqTrab,{"TIPOV","C",1,0}) // Tipo de vendedor (3 = Motorista ; 4 = Vendedor ; 5 = Indicador)
	AAdd(aArqTrab,{"VEND","C",6,0}) // Vendedor
	AAdd(aArqTrab,{"DATAE","D",8,0}) // Emissao
	AAdd(aArqTrab,{"FATURA","N",17,2}) // Faturamento
	AAdd(aArqTrab,{"DESCON","N",17,2}) // Descontos da Nota
	AAdd(aArqTrab,{"RECAPA","N",17,2}) // Recapagem
	AAdd(aArqTrab,{"SERVIC","N",17,2}) // Servico
	AAdd(aArqTrab,{"ASSTEC","N",17,2}) // Assistencia Tecnica
	AAdd(aArqTrab,{"NOVO"  ,"N",17,2}) // Venda de produtos Novos
	AAdd(aArqTrab,{"OUTROS","N",17,2}) // Assistencia Tecnica
	AAdd(aArqTrab,{"CUSTO" ,"N",17,2}) // Custo
	AAdd(aArqTrab,{"FATMARGE","N",17,2}) // % Margem
	AAdd(aArqTrab,{"MARCONT","N",17,2}) // Margem Contribuicao
	AAdd(aArqTrab,{"PNEUS"  ,"N",6,0})  // Quantidade Pneus

	cArqTrab := CriaTrab(aArqTrab,.T.)
	dbUseArea(.t.,,cArqTrab,"TRB",)

	dbSelectArea("TRB")
	IndRegua("TRB",cArqTrab,"TIPOV+VEND+DTOS(TRB->DATAE)",,,"Criando Arquivo de Trabalho...")
	//-------------------

	//-- MONTA QUERY PARA TRAZER APENAS AS NOTAS FISCAIS CABECALHO DO MES PROCESSADO NOS PARAMETROS
	//-- FAZ ISTO, POIS PRECISA BUSCAR AS NCC´S A PARTIR DO CABECALHO DAS NOTAS E NAO A PARTIR DOS ITENS DA NOTA
	cQuerySF2 := "SELECT F2_DOC ,F2_SERIE, F2_EMISSAO, F2_VEND3, F2_VEND4, F2_VEND5 FROM " + RetSqlName("SF2") + " SF2"
	cQuerySF2 += " where SF2.D_E_L_E_T_ = ' ' "
	cQuerySF2 += " and F2_FILIAL = '" + xFilial("SF2") + "' "
	cQuerySF2 += " and F2_EMISSAO >= '" + DtoS(mv_par01) + "' and F2_EMISSAO <= '" + DtoS(mv_par02) + "' "
	cQuerySF2 += " and F2_TIPO = 'N' "
	If mv_par05 = 1
		cQuerySF2 += " and F2_VEND3 BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	Elseif mv_par05 = 2
		cQuerySF2 += " and F2_VEND4 BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	Elseif mv_par05 = 3
		cQuerySF2 += " and F2_VEND5 BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	Elseif mv_par05 = 4
		cQuerySF2 += " and (F2_VEND3 BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
		cQuerySF2 += " or   F2_VEND4 BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
		cQuerySF2 += " or   F2_VEND5 BETWEEN '"+mv_par06+"' AND '"+mv_par07+"')"
	Endif
	cQuerySF2 := ChangeQuery(cQuerySF2)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuerySF2),"TRBSF2",.F.,.T.)
	TcSetField("TRBSF2", "F2_EMISSAO", "D")
	//-------------------

	SF2->( dbSetOrder(1) )
	SF4->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SC6->( dbSetOrder(1) )
	SC2->( dbSetOrder(1) )
	SG1->( dbSetOrder(1) )
	SD3->( dbSetOrder(1) )

	dbSelectArea("SD2")
	dbSetOrder(5)
	dbSeek(xFilial("SD2")+DtoS(Mv_par01),.T.)

	SetRegua(LastRec())

	While !EOF() .And. xFilial("SD2") == SD2->D2_FILIAL .And. SD2->D2_EMISSAO <= Mv_Par02
		IncRegua()

		If ! SF4->( dbSeek(xFilial("SF4") + SD2->D2_TES,.F.) )
			SD2->( dbSkip() )
			Loop                                                 
		EndIf

		dbSelectArea("SF2")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE)

		lSkip := .T.
		If (mv_par05 = 1 .or. mv_par05 = 4) .and. lSkip
			If !(F2_VEND3 >= mv_par06 .and. F2_VEND3 <= mv_par07)
				lSkip := .T.
			Else
				lSkip := .F.
			Endif
		Endif

		If (mv_par05 = 2 .or. mv_par05 = 4) .and. lSkip
			If !(F2_VEND4 >= mv_par06 .and. F2_VEND4 <= mv_par07)
				lSkip := .T.
			Else
				lSkip := .F.
			Endif
		Endif

		If (mv_par05 = 3 .or. mv_par05 = 4) .and. lSkip
			If !(F2_VEND5 >= mv_par06 .and. F2_VEND5 <= mv_par07)
				lSkip := .T.
			Else
				lSkip := .F.
			Endif
		Endif

		dbSelectArea("SD2")
		If lSkip
			dbskip()
			Loop
		Endif


		SB1->( dbSeek(xFilial("SB1") + SD2->D2_COD,.F.) )
		cGrupo          := AllTrim( Upper(SB1->B1_GRUPO) )
		//nPneus          := Iif ( cGrupo == "SERV" .and. SD2->D2_TES == "901", SD2->D2_QUANT, 0 )
		nPneus          := Iif ( cGrupo == "CARC", SD2->D2_QUANT, 0 )

		If cGrupo == "CARC"
			SC6->( dbSeek(xFilial("SC6") + SD2->D2_PEDIDO+SD2->D2_ITEMPV,.F.) )
			SC2->( dbSeek(xFilial("SC2") + SC6->C6_NFORI+Substr(SC6->C6_ITEMORI,3,2),.F.) )
			cOP := SC2->C2_NUM+SC2->C2_ITEM

			nServico := 0
			While !Eof() .And. xFilial("SC6")==SC6->C6_FILIAL .And. SD2->D2_PEDIDO == SC6->C6_NUM
				SB1->( dbSeek(xFilial("SB1") + SC6->C6_PRODUTO,.F.) )		
				If Alltrim(Upper(SB1->B1_GRUPO)) == "SERV" .AND. SC6->C6_NUMOP+SC6->C6_ITEMOP == cOP				
					SF4->( dbSeek(xFilial("SF4") + SC6->C6_TES,.F.) )
					If SF4->F4_DUPLIC == "S" .and. SF4->F4_ESTOQUE = 'N'
						nServico := SC6->C6_VALOR 
					EndIf				
					Exit
				Endif
				SC6->(dbSkip())
			EndDo

			SB1->( dbSeek(xFilial("SB1") + SD2->D2_COD,.F.) )

			SC6->( dbSeek(xFilial("SC6") + SD2->D2_PEDIDO+Strzero(Val(SD2->D2_ITEMPV)+1,2),.F.) )
			IF nServico == 0 .OR. SC6->C6_TES == "903"
				nPneus := 0
			EndIF
		EndIf

		SC6->( dbSeek(xFilial("SC6") + SD2->D2_PEDIDO+SD2->D2_ITEMPV,.F.) )
		SC2->( dbSeek(xFilial("SC2") + SC6->C6_NUMOP+SC6->C6_ITEMOP+"001",.F.) )

		lFatura         := ( ! cGrupo $ "CARC" .and. SF4->F4_DUPLIC = 'S' ) //Total Faturado
		lRecapa         := ( cGrupo $ "SERV" .And. SF4->F4_DUPLIC == "S" .and. SF4->F4_ESTOQUE = 'N' )
		lServic         := ( cGrupo $ GetMv("MV_X_GRPRO") .And. SF4->F4_DUPLIC == "S" .and. SF4->F4_ESTOQUE = 'N' )
		lAssTec         := ( cGrupo $ "ATEC" .And. SF4->F4_DUPLIC == "S"  )
		lNovo           := ( cGrupo $ "0001/0002/0003" .or. SD2->D2_TES = '503'  )  // Grupo de Pneus novos( cGrupo $ "0001" .or. SD2->D2_TES = '503'  )
		lOutros         := ( ( !lRecapa .And. !lServic .And. !lAssTec .And. !lNovo .And.!lOutros ) .And. SF4->F4_DUPLIC == "S" )
		nCustoGerencial := 0

		If lRecapa
			dbSelectArea("SD3")
			dbSetOrder(1)
			SD3->( dbSeek(xFilial("SD3") + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN, .f. ) )
			lEntrou := .F.
			While !Eof() .And. xFilial("SD3") == SD3->D3_FILIAL .And. Alltrim(SD3->D3_OP) == Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
				If SD3->D3_ESTORNO == "S" .OR. Alltrim(SD3->D3_GRUPO) != "BAND" 
					SD3->( dbSkip() )
					Loop
				EndIf  
			                                         
				SB1->( dbSeek(xFilial("SB1") + SD3->D3_COD, .F. ) )
				If SG1->( dbSeek(xFilial("SG1") +  SC2->C2_PRODUTO                   + SD3->D3_COD,.F.) )     
					Do while .not.eof("SG1") .and. SC2->C2_PRODUTO = SG1->G1_COD .AND. SD3->D3_COD = SG1->G1_COMP 
   						IF SD3->D3_EMISSAO >= SG1->G1_INI .AND. SD3->D3_EMISSAO <= SG1->G1_FIM 
							nCustoGerencial := nCustoGerencial + SG1->G1_XCSBI
							EXIT
						ENDIF
						SG1->( dbSkip() )
					Enddo   
				EndIf                          
				SD3->( dbSkip() )
				lEntrou := .T.
			EndDo             
			If !lEntrou
				dbSelectArea("SD4")            
				dbSetOrder(2)
				SD4->( dbSeek(xFilial("SD4") + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN, .f. ) )
				While !Eof() .And. xFilial("SD4") == SD4->D4_FILIAL .And. Alltrim(SD4->D4_OP) == Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
					If SD4->D4_QUANT == SD4->D4_QTDEORI
						SD4->( dbSkip() )
						Loop
					EndIf                                              
					SB1->( dbSeek(xFilial("SB1") + SD4->D4_COD, .F. ) )				
					If Upper(Alltrim(SB1->B1_GRUPO)) != "BAND"
						SD4->( dbSkip() )
						Loop
					EndIf                                              
					If "BANDA" $ Upper ( AllTrim ( SB1->B1_DESC ) )
						If SG1->( dbSeek(xFilial("SG1") +  SC2->C2_PRODUTO                   + SD4->D4_COD,.F.) )
							Do while .not.eof("SG1") .and. SC2->C2_PRODUTO = SG1->G1_COD .AND. SD4->D4_COD = SG1->G1_COMP 
                            	IF SD4->D4_DATA >= SG1->G1_INI .AND. SD4->D4_DATA <= SG1->G1_FIM 
									nCustoGerencial := nCustoGerencial + ( SD4->D4_QTDEORI * SG1->G1_XCSBI )
									EXIT
						    	ENDIF
						    	SG1->( dbSkip() )
							Enddo	
						EndIf                          
					Else
						nCustoGerencial := nCustoGerencial + ( SD4->D4_QTDEORI * SB1->B1_CUSTD )
					EndIf
					SD4->( dbSkip() )
				EndDo             		
			EndIf
		Else 
			nCustoGerencial :=0
			SB1->( dbSetOrder(1) )	
			SB1->( dbSeek(xFilial("SB1") + SD2->D2_COD,.F.) )
			SB1->( dbSeek(xFilial("SB1") + SB1->B1_PRODUTO,.F.) )                                                 
			SF4->( dbSeek(xFilial("SF4") + SD2->D2_TES,.F.) )
			IF SF4->F4_DUPLIC == 'S'
				//nCustoGerencial := nCustoGerencial + SB1->B1_CUSTD
			EndIF
		EndIf    

		SB1->( dbSeek(xFilial("SB1") + SD2->D2_COD,.F.) )

		IF SF2->F2_VEND3 <> Space(6) .AND. (mv_par05 = 1 .or. mv_par05 = 4)
			If cGrupo == "CARC"
				nPosPneu := 0
				For k=1 to Len(aResumoPneus)
					If aResumoPneus[k,4] = "1" .and. aResumoPneus[k,5] = SF2->F2_VEND3 .AND. aResumoPneus[k,1] = SB1->B1_X_ESPEC
						nPosPneu := k
						exit
					Endif
				Next

				If nPosPneu <= 0
					AAdd(aResumoPneus,{SB1->B1_X_ESPEC,nPneus,nServico,"1",SF2->F2_VEND3})
				Else			
					aResumoPneus[nPosPneu][2] := aResumoPneus[nPosPneu][2] + nPneus
					aResumoPneus[nPosPneu][3] := aResumoPneus[nPosPneu][3] + nServico
				EndIf
			Endif

			dbSelectArea("TRB")
			lAppend := .F.
			If ! ( dbSeek( "1"+SF2->F2_VEND3+DtoS(SD2->D2_EMISSAO) ) )
				lAppend := .T.
			EndIf

			If RecLock("TRB",lAppend)
				If lAppend
					TRB->DATAE := SD2->D2_EMISSAO
					TRB->TIPOV := "1"
					TRB->VEND  := SF2->F2_VEND3
				Endif
				TRB->FATURA   := TRB->FATURA + IIf( lFatura,  SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Faturamento
				TRB->DESCON   := TRB->DESCON + SD2->D2_DESCON //--Faturamento
				TRB->RECAPA   := TRB->RECAPA + IIf( lRecapa , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Recapagem
				TRB->SERVIC   := TRB->SERVIC + IIf( lServic , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Servicos
				TRB->ASSTEC   := TRB->ASSTEC + IIf( lAssTec , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Ass.Tecnica
				TRB->NOVO     := TRB->NOVO   + IIf( lNovo   , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Novos
				TRB->OUTROS   := TRB->OUTROS + IIf( lOutros , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Outros	
				TRB->CUSTO    := TRB->CUSTO  + nCustoGerencial //--Custo
				TRB->FATMARGE := (TRB->RECAPA * mv_par03 ) / TRB->CUSTO //--%Margem
				TRB->PNEUS    := TRB->PNEUS  + nPneus //--Pneus
				MsUnlock()
			Endif
		Endif

		IF SF2->F2_VEND4 <> Space(6) .AND. (mv_par05 = 2 .or. mv_par05 = 4)
			If cGrupo == "CARC"
				nPosPneu := 0
				For k=1 to Len(aResumoPneus)
					If aResumoPneus[k,4] = "2" .and. aResumoPneus[k,5] = SF2->F2_VEND4 .AND. aResumoPneus[k,1] = SB1->B1_X_ESPEC
						nPosPneu := k
						exit
					Endif
				Next

				If nPosPneu <= 0			
					AAdd(aResumoPneus,{SB1->B1_X_ESPEC,nPneus,nServico,"2",SF2->F2_VEND4})
				Else			
					aResumoPneus[nPosPneu][2] := aResumoPneus[nPosPneu][2] + nPneus
					aResumoPneus[nPosPneu][3] := aResumoPneus[nPosPneu][3] + nServico
				EndIf
			Endif

			dbSelectArea("TRB")
			lAppend := .F.
			If ! ( dbSeek( "2"+SF2->F2_VEND4+DtoS(SD2->D2_EMISSAO) ) )
				lAppend := .T.
			EndIf

			If RecLock("TRB",lAppend)
				If lAppend
					TRB->DATAE := SD2->D2_EMISSAO
					TRB->TIPOV := "2"
					TRB->VEND  := SF2->F2_VEND4
				Endif
				TRB->FATURA   := TRB->FATURA + IIf( lFatura,  SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Faturamento
				TRB->DESCON   := TRB->DESCON + SD2->D2_DESCON //--Faturamento
				TRB->RECAPA   := TRB->RECAPA + IIf( lRecapa , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Recapagem
				TRB->SERVIC   := TRB->SERVIC + IIf( lServic , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Servicos
				TRB->ASSTEC   := TRB->ASSTEC + IIf( lAssTec , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Ass.Tecnica
				TRB->NOVO     := TRB->NOVO   + IIf( lNovo   , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Novos
				TRB->OUTROS   := TRB->OUTROS + IIf( lOutros , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Outros	
				TRB->CUSTO    := TRB->CUSTO  + nCustoGerencial //--Custo
				TRB->FATMARGE := (TRB->RECAPA * mv_par03 ) / TRB->CUSTO //--%Margem
				TRB->PNEUS    := TRB->PNEUS  + nPneus //--Pneus
				MsUnlock()
			Endif
		Endif

		IF SF2->F2_VEND5 <> Space(6) .AND. (mv_par05 = 3 .or. mv_par05 = 4)
			If cGrupo == "CARC"
				nPosPneu := 0
				For k=1 to Len(aResumoPneus)
					If aResumoPneus[k,4] = "3" .and. aResumoPneus[k,5] = SF2->F2_VEND5 .AND. aResumoPneus[k,1] = SB1->B1_X_ESPEC
						nPosPneu := k
						exit
					Endif
				Next

				If nPosPneu <= 0			
					AAdd(aResumoPneus,{SB1->B1_X_ESPEC,nPneus,nServico,"3",SF2->F2_VEND5})
				Else			
					aResumoPneus[nPosPneu][2] := aResumoPneus[nPosPneu][2] + nPneus
					aResumoPneus[nPosPneu][3] := aResumoPneus[nPosPneu][3] + nServico
				EndIf
			Endif

			dbSelectArea("TRB")
			lAppend := .F.
			If ! ( dbSeek( "3"+SF2->F2_VEND5+DtoS(SD2->D2_EMISSAO) ) )
				lAppend := .T.
			EndIf

			If RecLock("TRB",lAppend)
				If lAppend
					TRB->DATAE := SD2->D2_EMISSAO
					TRB->TIPOV := "3"
					TRB->VEND  := SF2->F2_VEND5
				Endif
				TRB->FATURA   := TRB->FATURA + IIf( lFatura,  SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Faturamento
				TRB->DESCON   := TRB->DESCON + SD2->D2_DESCON //--Faturamento
				TRB->RECAPA   := TRB->RECAPA + IIf( lRecapa , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Recapagem
				TRB->SERVIC   := TRB->SERVIC + IIf( lServic , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Servicos
				TRB->ASSTEC   := TRB->ASSTEC + IIf( lAssTec , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Ass.Tecnica
				TRB->NOVO     := TRB->NOVO   + IIf( lNovo   , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Novos
				TRB->OUTROS   := TRB->OUTROS + IIf( lOutros , SD2->D2_TOTAL+SD2->D2_DESCON , 0 ) //--Outros	
				TRB->CUSTO    := TRB->CUSTO  + nCustoGerencial //--Custo
				TRB->FATMARGE := (TRB->RECAPA * mv_par03 ) / TRB->CUSTO //--%Margem
				TRB->PNEUS    := TRB->PNEUS  + nPneus //--Pneus
				MsUnlock()
			Endif
		Endif

		dbSelectArea("SD2")
		SD2->( dbSkip() )
	EndDo

	//-- VERIFICA SE EXISTEM DESCONTOS COMERCIAIS DO SEPU APLICADOS NESTE PERIODO A PARTIR DO CABECALHO DAS NOTAS
	SE1->( dbSetOrder(1) )

	dbSelectArea("TRBSF2")
	dbGotop()

	While !Eof()
		dbSelectArea("SE5")
		dbSetOrder(1)
		//-- busca registro de baixa do uma NCC com prefixo SEP
		//-- busca emissao + banco (SEP) + agencia (00001) + conta (0000000001) + numero do cheque ( serie + nota )
		dbSeek(xFilial("SE5")+DtoS(TRBSF2->F2_EMISSAO)+"SEP000010000000001"+Alltrim(TRBSF2->F2_SERIE)+Alltrim(TRBSF2->F2_DOC),.F.)

		While !Eof() .And. SE5->(E5_FILIAL+DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA+Alltrim(E5_NUMCHEQ)) == ;
			xFilial("SE5")+DtoS(TRBSF2->F2_EMISSAO)+"SEP000010000000001"+Alltrim(TRBSF2->F2_SERIE)+Alltrim(TRBSF2->F2_DOC)

			SE1->( dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO,.F.) )

			If TRBSF2->F2_VEND3 <> Space(6) .AND. (mv_par05 = 1 .or. mv_par05 = 4)
				nPosSepu := 0
				For k=1 to Len(aResumoSepu)
					If aResumoSepu[k,3] = "1" .and. aResumoSepu[k,4] = TRBSF2->F2_VEND3 .AND. aResumoSepu[k,1] = SE1->E1_MOTDESC
						nPosSepu := k
					Endif
				Next
				If nPosSepu <= 0
					AAdd(aResumoSepu,{SE1->E1_MOTDESC,SE5->E5_VALOR,"1",TRBSF2->F2_VEND3})
				Else
					aResumoSepu[nPosSepu][2] := aResumoSepu[nPosSepu][2] + SE5->E5_VALOR
				EndIf
			Endif

			If TRBSF2->F2_VEND4 <> Space(6) .AND. (mv_par05 = 2 .or. mv_par05 = 4)
				nPosSepu := 0
				For k=1 to Len(aResumoSepu)
					If aResumoSepu[k,3] = "2" .and. aResumoSepu[k,4] = TRBSF2->F2_VEND4 .AND. aResumoSepu[k,1] = SE1->E1_MOTDESC
						nPosSepu := k
					Endif
				Next
				If nPosSepu <= 0
					AAdd(aResumoSepu,{SE1->E1_MOTDESC,SE5->E5_VALOR,"2",TRBSF2->F2_VEND4})
				Else
					aResumoSepu[nPosSepu][2] := aResumoSepu[nPosSepu][2] + SE5->E5_VALOR
				EndIf
			Endif

			If TRBSF2->F2_VEND5 <> Space(6) .AND. (mv_par05 = 3 .or. mv_par05 = 4)
				nPosSepu := 0
				For k=1 to Len(aResumoSepu)
					If aResumoSepu[k,3] = "3" .and. aResumoSepu[k,4] = TRBSF2->F2_VEND5 .AND. aResumoSepu[k,1] = SE1->E1_MOTDESC
						nPosSepu := k
					Endif
				Next
				If nPosSepu <= 0
					AAdd(aResumoSepu,{SE1->E1_MOTDESC,SE5->E5_VALOR,"3",TRBSF2->F2_VEND5})
				Else
					aResumoSepu[nPosSepu][2] := aResumoSepu[nPosSepu][2] + SE5->E5_VALOR
				EndIf
			Endif

			dbSelectArea("SE5")
			SE5->( dbSkip() )
		Enddo                         

		dbSelectArea("TRBSF2")
		TRBSF2->( dbSkip() )
	EndDo	

	dbSelectArea("TRBSF2")
	dbCloseArea("TRBSF2")

	//-- IMPRIME O ARQUIVO DE TRABALHO
	dbSelectArea("TRB")
	dbGotop()

	nAcuFatur := 0
	nAcuCusto := 0


	While !EOF()
		If VEND < mv_par06 .or. VEND > mv_par07
			dbskip()
			Loop
		Endif
		nTotFatura := nTotRecapa := nTotServic := nTotAssTec := 0
		nTotNovo := nTotCusto := nTotMargCon :=	nTotPneus := 0
		nAcuFatur := 0
		nAcuCusto := 0

		cChaveT := TIPOV
		cChaveV := VEND

		nLin := 99
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif

		@ nLin,000 PSAY iif(TIPOV="1","Motorista: ",iif(TIPOV="2","Vendedor: ","Indicador: "))+VEND+" - "+Posicione("SA3",1,xFilial("SA3")+TRB->VEND,"SA3->A3_NOME")
		nLin+=2

		nTotDescon      := 0
		Do while !eof() .and. TIPOV+VEND = cChaveT+cChaveV
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
	
			If nLin > 55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
	
			/*
			Data     Faturamento   Descontos   Recapagem    Servicos  Ass.Tecnica  Vlr.Mercantil        Custo    %Margem     Acumulado    Acum.Custo  %Margem  Marg.Contr  Pneus           Outros
			99/99/99  999,999.99  999,999.99  999,999.99  999,999.99   999,999.99     999,999.99   999,999.99     999.99  9,999,999.99  9,999,999.99   999.99  999,999.99  99999    99,999,999.99
			1         11          23          35          47           60             75           88             103     111           125            140     148         160      169
			12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17
			*/
	
			//(TRB->RECAPA * mv_par03 ) / TRB->CUSTO //--%Margem	

			@nLin,001 PSAY TRB->DATAE
			@nLin,011 PSAY TRB->FATURA    			PICTURE "@E 999,999.99"
			@nlin,023 PSAY TRB->DESCON              PICTURE "@E 999,999.99"
			@nLin,035 PSAY TRB->RECAPA    			PICTURE "@E 999,999.99"
			@nLin,047 PSAY TRB->SERVIC    			PICTURE "@E 999,999.99"
			@nLin,060 PSAY TRB->ASSTEC    			PICTURE "@E 999,999.99"
			@nLin,075 PSAY TRB->NOVO    			PICTURE "@E 999,999.99"
			@nLin,088 PSAY TRB->CUSTO     			PICTURE "@E 999,999.99"
			@nLin,103 PSAY TRB->FATMARGE  			PICTURE "@E 999.99"
			@nLin,111 PSAY TRB->RECAPA + nAcuFatur  PICTURE "@E 9,999,999.99"
			@nLin,125 PSAY TRB->CUSTO + nAcuCusto   PICTURE "@E 9,999,999.99"
			@nLin,140 PSAY (TRB->RECAPA + nAcuFatur)* mv_par03 / (TRB->CUSTO + nAcuCusto)	PICTURE "@E 999.99"
			@nLin,148 PSAY (TRB->RECAPA * mv_par03 ) - TRB->CUSTO PICTURE "@E 999,999.99"
			@nLin,160 PSAY TRB->PNEUS     			PICTURE "9999"
	
			nTotFatura := nTotFatura  + TRB->FATURA
			nTotDescon := nTotDescon  + TRB->DESCON
			nTotRecapa := nTotRecapa  + TRB->RECAPA
			nTotServic := nTotServic  + TRB->SERVIC
			nTotAssTec := nTotAssTec  + TRB->ASSTEC
			nTotNovo   := nTotNovo    + TRB->NOVO 
			nTotCusto  := nTotCusto   + TRB->CUSTO
			nTotPneus  := nTotPneus   + TRB->PNEUS
			nTotOutros := nTotOutros  + TRB->OUTROS
	
			nAcuFatur := nAcuFatur + TRB->RECAPA
			nAcuCusto := nAcuCusto + TRB->CUSTO
	
			nLin ++ 
	
			TRB->( dbSkip() )
		Enddo

		nLin++
	
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
	
		@nLin,001 PSAY Replicate("-",132)
	
		nLin++             
	
		nTotMargCon := ( nTotRecapa * mv_par03 ) - nTotCusto
	
		@nLin,011 PSAY nTotFatura    PICTURE "@E 999,999.99"
		@nLin,023 PSAY nTotDescon    PICTURE "@E 999,999.99"
		@nLin,035 PSAY nTotRecapa    PICTURE "@E 999,999.99"
		@nLin,047 PSAY nTotServic    PICTURE "@E 999,999.99"
		@nLin,060 PSAY nTotAssTec    PICTURE "@E 999,999.99"
		@nLin,075 PSAY nTotNovo      PICTURE "@E 999,999.99"
		@nLin,088 PSAY nTotCusto     PICTURE "@E 999,999.99"
		@nLin,148 PSAY nTotMargCon   PICTURE "@E 999,999.99"
		@nLin,160 PSAY nTotPneus     PICTURE "99999"
	
		nLin:=nLin+2
	
		@nLin,001 PSAY "CF"
		@nLin,004 PSAY mv_par04  PICTURE "@E 9,999,999.99"
		@nLin,018 PSAY "MC LIQ:"
		@nLin,026 PSAY nTotMargCon PICTURE "@E 9999,999.99"
		@nLin,039 PSAY "PRECO MEDIO:"
		@nLin,052 PSAY nTotRecapa / nTotPneus PICTURE "@E 9999.99"
		@nLin,063 PSAY "MARGEM MEDIA:"
		@nLin,077 PSAY nTotMargCon / nTotPneus PICTURE "@E 9999.99"
	
		/*
		CF 9999,999.99   MC LIQ: 9999,999.99  PRECO MEDIO: 9999.99    MARGEM MEDIA: 9999.99
		1  4             18      26           39           52         63            77
		*/
	
		//-- Imprime Resumo por tipo de pneu
		nLin:=nLin+3
	
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
	
		@nLin  ,001 PSAY "Distribuicao de Pneus"
		@nLin+1,001 PSAY "---------------------"
		nLin:=nLin+2
	
		/*
		Pequeno        186  999,999,999,99  9999,99
		1              16   21              37
		*/
	
		For i:=1 To Len(aResumoPneus)
			If nLin > 55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			If aResumoPneus[i][4] = cChaveT .and. aResumoPneus[i][5] = cChaveV
				@nLin,001 PSAY IIF( Empty(aResumoPneus[i][1]) , "Indefinido" , Substr(aResumoPneus[i][1],1,15) ) 
				@nLin,016 PSAY aResumoPneus[i][2] PICTURE "99999"
				@nLin,023 PSAY aResumoPneus[i][3] PICTURE "@E 999,999,999.99"
				@nLin,045 PSAY aResumoPneus[i][3] / aResumoPneus[i][2] PICTURE "@E 9999.99"
				nLin++
			Endif
		Next

		//------------------- FIM RESUMO PNEUS ----------
	
		//-- Imprime Resumo de Ajustes SEPU
		nLin:=nLin+3
	
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
	
		@nLin  ,001 PSAY "SEPU"
		@nLin+1,001 PSAY "---------------------"
		nLin:=nLin+2
	
		/*
		Motivo                                                         Valor
		99-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx           999,999,999,99
		1                                                     55
		*/
	
		nTotSepu := 0
		For i:=1 To Len(aResumoSepu)
			If nLin > 55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			if aResumoSepu[i][3] = cChaveT .AND. aResumoSepu[i][4] = cChaveV
				SZS->( dbSetOrder(1) )
				SZS->( dbSeek(xFilial("SZS")+aResumoSepu[i][1],.F.) )
				@nLin,001 PSAY aResumoSepu[i][1]+'-'+Subst(SZS->ZS_DESCR,1,50)
				@nLin,055 PSAY aResumoSepu[i][2] PICTURE "@E 999,999,999.99"
				nTotSepu += aResumoSepu[i][2]
				nLin++
			Endif
		Next
		nLin++
		@nLin,001 PSAY "Total Sepu"
		@nLin,055 PSAY nTotSepu PICTURE "@E 999,999,999.99"
	EndDo

	dbSelectArea("TRB")
	dbCloseArea("TRB")
	FErase(cArqTRAB+OrdBagExt())

	dbSelectArea("SD2")
	dbSetOrder(1)

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif

	MS_FLUSH()
Return