#INCLUDE "rwmake.ch"
/*ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбддддддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё DFINR04  Ё Autor Ё Jader                    Ё Data Ё 27.08.05 Ё╠╠
╠╠ЁFun┤┘o    Ё MATR540  Ё Autor Ё Claudinei M. Benzi       Ё Data Ё 13.04.92 Ё╠╠
╠╠цддддддддддеддддддддддадддддддаддддддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Relatorio de Comissoes.                                       Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё MATR540(void)                                                 Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё Generico                                                      Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠ 
╠╠зддддддддбддддддбддддддддддбддддддддддддддддддддддддддддддддддддддддддддддд©╠╠
╠╠Ё DATA   Ё BOPS ЁProgramad.ЁALTERACAO                                      Ё╠╠
╠╠цддддддддеддддддеддддддддддеддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё05.02.03ЁXXXXXXЁEduardo JuЁInclusao de Queries para filtros em TOPCONNECT.Ё╠╠
╠╠Ё27.08.05ЁXXXXXXЁJader     ЁAlterado para DFINR04 para Durapol             Ё╠╠
╠╠юддддддддаддддддаддддддддддаддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/

User Function DFINR04()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local wnrel
Local titulo    := "Relatorio de Comissoes"
Local cDesc1    := "Emissao do relatorio de Comissoes."
Local tamanho   := "G"
Local limite    := 220
Local cString   := "SE3"
Local cAliasAnt := Alias()
Local cOrdemAnt := IndexOrd()
Local nRegAnt   := Recno()
Local cDescVend := " "

Private aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }
Private nomeprog:= "DFINR04"
Private aLinha  := { },nLastKey := 0
Private cPerg   := "MTR540"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica as perguntas selecionadas                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Pergunte("MTR540",.F.)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para parametros                         Ё
//Ё mv_par01        	// Pela <E>missao,<B>aixa ou <A>mbos        Ё
//Ё mv_par02        	// A partir da data                         Ё
//Ё mv_par03        	// Ate a Data                               Ё
//Ё mv_par04 	    	// Do Vendedor                              Ё
//Ё mv_par05	     	// Ao Vendedor                              Ё
//Ё mv_par06	     	// Quais (a Pagar/Pagas/Ambas)              Ё
//Ё mv_par07	     	// Incluir Devolucao ?                      Ё
//Ё mv_par08	     	// Qual moeda                               Ё
//Ё mv_par09	     	// Comissao Zerada ?                        Ё
//Ё mv_par10	     	// Abate IR Comiss                          Ё
//Ё mv_par11	     	// Quebra pag.p/Vendedor                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia controle para a funcao SETPRINT                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
wnrel := "DFINR04"
wnrel := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,"","",.F.,"",.F.,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey ==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C540Imp(@lEnd,wnRel,cString)},Titulo)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Retorna para area anterior, indice anterior e registro ant.  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea(caliasAnt)
DbSetOrder(cOrdemAnt)
DbGoto(nRegAnt)
Return

/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё C540IMP  Ё Autor Ё Rosane Luciane Chene  Ё Data Ё 09.11.95 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Chamada do Relatorio                                       Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё MATR540			                                            Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Static Function C540Imp(lEnd,WnRel,cString)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local CbCont,cabec1,cabec2
Local tamanho  := "G"
Local limite   := 220
Local nomeprog := "DFINR04"
Local imprime  := .T.
Local cPict    := ""
Local cTexto,j :=0,nTipo:=0
Local cCodAnt,nCol:=0
Local nAc1:=0,nAc2:=0,nAg1:=0,nAg2:=0,nAc3:=0,nAg3:=0,lFirstV:=.T.
Local nTregs,nMult,nAnt,nAtu,nCnt,cSav20,cSav7
Local lContinua:= .T.
Local cNFiscal :=""
Local aCampos  :={}
Local lImpDev  := .F.
Local cBase    := ""
Local cNomArq, cCondicao, cFilialSE1, cFilialSE3, cChave, cFiltroUsu
Local nDecs    := GetMv("MV_CENT"+(IIF(mv_par08 > 1 , STR(mv_par08,1),"")))
Local	nBasePrt :=0, nComPrt:=0 
Local aStru    := SE3->(dbStruct()), ni

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para Impressao do Cabecalho e Rodape    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
imprime  := .T.

nTipo := IIF(aReturn[4]==1,15,18)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Definicao dos cabecalhos                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If mv_par01 == 1
	titulo := OemToAnsi("RELATORIO DE COMISSOES ")+OemToAnsi("(PGTO PELA EMISSAO)")+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1)) 
Elseif mv_par01 == 2
	titulo := OemToAnsi("RELATORIO DE COMISSOES ")+OemToAnsi("(PGTO PELA BAIXA)")+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1)) 
Else
	titulo := OemToAnsi("RELATORIO DE COMISSOES")+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))
Endif

cabec1:=OemToAnsi("PRF NUMERO   PARC. CODIGO     EMISSAO         NOME                                 DT.BASE     DATA        DATA        DATA       NUMERO          VALOR           VALOR      %           VALOR    TIPO")
cabec2:=OemToAnsi("    TITULO         CLIENTE                                                         COMISSAO    VENCTO      BAIXA       PAGTO      PEDIDO         TITULO            BASE               COMISSAO   COMISSAO")
									// XXX XXXXXXxxxxxx X XXXXXXxxxxxxxxxxxxxx   XX  012345678901234567890123456789012345 XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx XXXXXX 12345678901,23  12345678901,23  99.99  12345678901,23     X       AJUSTE
									// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
									// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta condicao para filtro do arquivo de trabalho            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

DbSelectArea("SE3")	// Posiciona no arquivo de comissoes
DbSetOrder(2)			// Por Vendedor
cFilialSE3 := xFilial()
cNomArq :=CriaTrab("",.F.)

cCondicao := "SE3->E3_FILIAL=='" + cFilialSE3 + "'"
cCondicao += ".And.SE3->E3_VEND>='" + mv_par04 + "'"
cCondicao += ".And.SE3->E3_VEND<='" + mv_par05 + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)>='" + DtoS(mv_par02) + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)<='" + DtoS(mv_par03) + "'" 

If mv_par01 == 1
	cCondicao += ".And.SE3->E3_BAIEMI!='B'"  // Baseado pela emissao da NF
Elseif mv_par01 == 2
	cCondicao += " .And.SE3->E3_BAIEMI=='B'"  // Baseado pela baixa do titulo
Endif 

If mv_par06 == 1 		// Comissoes a pagar
	cCondicao += ".And.Dtos(SE3->E3_DATA)=='"+Dtos(Ctod(""))+"'"
ElseIf mv_par06 == 2 // Comissoes pagas
	cCondicao += ".And.Dtos(SE3->E3_DATA)!='"+Dtos(Ctod(""))+"'"
Endif

If mv_par09 == 2 		// Nao Inclui Comissoes Zeradas
   cCondicao += ".And.SE3->E3_COMIS<>0"
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria expressao de filtro do usuario                          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If ( ! Empty(aReturn[7]) )
	cFiltroUsu := &("{ || " + aReturn[7] +  " }")
Else
	cFiltroUsu := { || .t. }
Endif

nAg1 := nAg2 := 0

#IFDEF TOP
	If TcSrvType() != "AS/400"
		cOrder := SqlOrder(SE3->(IndexKey()))
		
		cQuery := "SELECT * "
		cQuery += "  FROM "+	RetSqlName("SE3")
		cQuery += " WHERE E3_FILIAL = '" + xFilial("SE3") + "' AND "
	  	cQuery += "	E3_VEND >= '"  + mv_par04 + "' AND E3_VEND <= '"  + mv_par05 + "' AND " 
		cQuery += "	E3_EMISSAO >= '" + Dtos(mv_par02) + "' AND E3_EMISSAO <= '"  + Dtos(mv_par03) + "' AND " 
		
		If mv_par01 == 1
			cQuery += "E3_BAIEMI <> 'B' AND "  //Baseado pela emissao da NF
		Elseif mv_par01 == 2
			cQuery += "E3_BAIEMI =  'B' AND "  //Baseado pela baixa do titulo  
		EndIf	
		
		If mv_par06 == 1 		//Comissoes a pagar
			cQuery += "E3_DATA = '" + Dtos(Ctod("")) + "' AND "
		ElseIf mv_par06 == 2 //Comissoes pagas
  			cQuery += "E3_DATA <> '" + Dtos(Ctod("")) + "' AND "
		Endif 
		
		If mv_par09 == 2 		//Nao Inclui Comissoes Zeradas
   		cQuery+= "E3_COMIS <> 0 AND "
		EndIf  
		
		cQuery += "D_E_L_E_T_ <> '*' "   

		cQuery += " ORDER BY "+ cOrder

		cQuery := ChangeQuery(cQuery)
											
		dbSelectArea("SE3")
		dbCloseArea()
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE3', .F., .T.)
			
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE3', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next 
	Else
	
#ENDIF	
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cria arquivo de trabalho                                     Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cChave := IndexKey()
		cNomArq :=CriaTrab("",.F.)
		IndRegua("SE3",cNomArq,cChave,,cCondicao, OemToAnsi("Selecionando Registros..."))
		nIndex := RetIndex("SE3")
		DbSelectArea("SE3") 
		#IFNDEF TOP
			DbSetIndex(cNomArq+OrdBagExT())
		#ENDIF
		DbSetOrder(nIndex+1)

#IFDEF TOP
	EndIf
#ENDIF	

SetRegua(RecCount())		// Total de Elementos da regua 
DbGotop()
While !Eof()
	IF lEnd
		@Prow()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		lContinua := .F.
		Exit
	EndIF
	IncRegua()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Processa condicao do filtro do usuario                       Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If ! Eval(cFiltroUsu)
		Dbskip()
		Loop
	Endif
	
	nAc1   := nAc2 := nAc3 := 0
	lFirstV:= .T.
	cVend  := SE3->E3_VEND
	
	While !Eof() .AND. SE3->E3_VEND == cVend
		IncRegua()
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Processa condicao do filtro do usuario                       Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If ! Eval(cFiltroUsu)
			Dbskip()
			Loop
		Endif  
		
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Seleciona o Codigo do Vendedor e Imprime o seu Nome          Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		IF lFirstV
			dbSelectArea("SA3")
			dbSeek(xFilial()+SE3->E3_VEND)
			cDescVend := SE3->E3_VEND + " " + A3_NOME 
			@li, 00 PSAY OemToAnsi("Vendedor : ") + cDescVend
			li+=2
			dbSelectArea("SE3")
			lFirstV := .F.
		EndIF
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO)
		nVlrTitulo := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
		dVencto    := SE1->E1_VENCTO  

		@li, 00 PSAY SE3->E3_PREFIXO
		@li, 04 PSAY SE3->E3_NUM
		@li, 17 PSAY SE3->E3_PARCELA
		@li, 19 PSAY SE3->E3_CODCLI+"-"+SE3->E3_LOJA
		//@li, 26 PSAY SE3->E3_LOJA
		@li, 30 PSAY SE1->E1_EMISSAO
		//@li, 42 PSAY SE3->E3_LOJA
		
		dbSelectArea("SA1")
		dbSeek(xFilial()+SE3->E3_CODCLI+SE3->E3_LOJA)
		@li, 46 PSAY Substr(A1_NOME,1,35)
		
		dbSelectArea("SE3")
		@li, 83 PSAY SE3->E3_EMISSAO
		
		/*
		Nas comissoes geradas por baixa pego a data da emissao da comissao que eh igual a data da baixa do titulo.
		Isto somente dara diferenca nas baixas parciais
		*/	 
		
      If SE3->E3_BAIEMI == "B"
			dBaixa     := SE3->E3_EMISSAO
    	Else
			dBaixa     := SE1->E1_BAIXA
		Endif
		
		If Eof()
			dbSelectArea("SF2")
			dbSetorder(1)
			dbSeek(xFilial()+SE3->E3_NUM+SE3->E3_PREFIXO) 
			nVlrTitulo := Round(xMoeda(F2_VALFAT,SF2->F2_MOEDA,mv_par08,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA),nDecs)
			
			dVencto    := " "
			dBaixa     := " "
			
			If Eof()
				nVlrTitulo := 0
				dbSelectArea("SE1")
				dbSetOrder(1)
				cFilialSE1 := xFilial()
				dbSeek(cFilialSE1+SE3->E3_PREFIXO+SE3->E3_NUM)
				While ( !Eof() .And. SE3->E3_PREFIXO == SE1->E1_PREFIXO .And.;
						SE3->E3_NUM == SE1->E1_NUM .And.;
						SE3->E3_FILIAL == cFilialSE1 )
					If ( SE1->E1_TIPO == SE3->E3_TIPO  .And. ;
						SE1->E1_CLIENTE == SE3->E3_CODCLI .And. ;
						SE1->E1_LOJA == SE3->E3_LOJA )
						nVlrTitulo += Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
						dVencto    := " "
						dBaixa     := " "
					EndIf
					dbSelectArea("SE1")
					dbSkip()
				EndDo
			EndIf
		Endif

		//Preciso destes valores para pasar como parametro na funcao TM(), e como 
		//usando a xmoeda direto na impressao afetaria a performance (deveria executar
		//duas vezes, uma para imprimir e outra para pasar para a picture), elas devem]
		//ser inicializadas aqui. Bruno.

		nBasePrt	:=	Round(xMoeda(SE3->E3_BASE ,1,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
		nComPrt	:=	Round(xMoeda(SE3->E3_COMIS,1,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)

		@ li, 95 PSAY dVencto
		@ li,107 PSAY dBaixa      
		
		If nBasePrt < 0 .And. nComPrt < 0
			nVlrTitulo := nVlrTitulo * -1
		Endif	
		
		dbSelectArea("SE3")
		@ li,119 PSAY SE3->E3_DATA
		@ li,130 PSAY SE3->E3_PEDIDO	Picture "@!"
		@ li,137 PSAY nVlrTitulo		Picture tm(nVlrTitulo,14,nDecs)
		@ li,153 PSAY nBasePrt 			Picture tm(nBasePrt,14,nDecs)
		@ li,169 PSAY SE3->E3_PORC		Picture tm(SE3->E3_PORC,6)
		@ li,176 PSAY nComPrt			Picture tm(nComPrt,14,nDecs)
		@ li,195 PSAY SE3->E3_BAIEMI

		If ( SE3->E3_AJUSTE == "S" .And. MV_PAR07==1)
			@ li,203 PSAY "AJUSTE "
		EndIf

		nAc1 += nBasePrt
		nAc2 += nComPrt
		nAc3 += nVlrTitulo
		li++
		dbSkip()
	EndDo
	
	If (nAc1+nAc2+nAc3) != 0
		li++
		
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		@ li, 00  PSAY OemToAnsi("TOTAL DO VENDEDOR --> ")+cDescVend 
		@ li,136  PSAY nAc3 	PicTure tm(nAc3,15,nDecs)
		@ li,152  PSAY nAc1 	PicTure tm(nAc1,15,nDecs)
		
		If nAc1 != 0
			@ li, 169 PSAY (nAc2/nAc1)*100   PicTure "999.99"
		Endif
		
		@ li, 175  PSAY nAc2 PicTure tm(nAc2,15,nDecs)
		li++
		
		If mv_par10 > 0 .And. (nAc2 * mv_par10 / 100) > GetMV("MV_VLRETIR") //IR
			@ li, 00  PSAY OemToAnsi("TOTAL DO IR       --> ")
			@ li, 175  PSAY (nAc2 * mv_par10 / 100) PicTure tm(nAc2 * mv_par10 / 100,15,nDecs)
			li ++
			@ li, 00  PSAY OemToAnsi("TOTAL (-) IR      --> ")
			@ li, 175 PSAY nAc2 - (nAc2 * mv_par10 / 100) PicTure tm(nAc2,15,nDecs)
			li ++
		EndIf
		
		@ li, 00  PSAY __PrtThinLine()

		If mv_par11 == 1  // Quebra pagina por vendedor (padrao)
			li := 60  
		Else
		   li+= 2
		Endif
	EndIF
	
	dbSelectArea("SE3")
	nAg1 += nAc1
	nAg2 += nAc2
 	nAg3 += nAc3
EndDo

IF (nAg1+nAg2+nAg3) != 0

	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif

	@li,  00 PSAY OemToAnsi("TOTAL  GERAL      --> ")
	@li, 136 PSAY nAg3	Picture tm(nAg3,15,nDecs)
	@li, 152 PSAY nAg1	Picture tm(nAg1,15,nDecs)
	@li, 169 PSAY (nAg2/nAg1)*100														Picture "999.99"
	@li, 175 PSAY nAg2 Picture tm(nAg2,15,nDecs)
	
	If mv_par10 > 0 .And. (nAg2 * mv_par10 / 100) > GetMV("MV_VLRETIR")//IR
		li ++
		@ li, 00  PSAY OemToAnsi("TOTAL DO IR       --> ")
		@ li, 175  PSAY (nAg2 * mv_par10 / 100) PicTure tm((nAg2 * mv_par10 / 100),15,nDecs)
		li ++
		@ li, 00  PSAY OemToAnsi("TOTAL (-) IR       --> ")
		@ li, 175  PSAY nAg2 - (nAg2 * mv_par10 / 100) Picture tm(nAg2,15,nDecs)
	EndIf
	roda(cbcont,cbtxt,"G")
EndIF
    
#IFDEF TOP
	If TcSrvType() != "AS/400"
  		dbSelectArea("SE3")
		DbCloseArea()
		chkfile("SE3")
	Else	
#ENDIF
		fErase(cNomArq+OrdBagExt())
#IFDEF TOP
	Endif
#ENDIF

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Restaura a integridade dos dados                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("SE3")
RetIndex("SE3")
DbSetOrder(2)
dbClearFilter()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Se em disco, desvia para Spool                               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
