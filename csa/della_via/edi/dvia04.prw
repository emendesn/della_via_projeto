#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DVIA04    º Autor ³ Marcos Augusto Diasº Data ³  15/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório impressão status Importação NFE.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DVIA04()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "STATUS DE IMPORTACAO NFE"
Local cPict          := ""
Local titulo       := "STATUS DE IMPORTACAO NFE"
Local nLin         := 80

Local Cabec1       := "DOC     SERIE  FORNECEDOR/LOJA                   "
Local Cabec2       := "MENSAGEM DE STATUS                                  NOME ARQ. EDI                                       DATA BASE  DATA SISTEMA  HORA   ARQ. LOG ERRO"

//                     999999  999    999999/99 - XXXXXXXXXXXXXXXXXXXX  
//
//                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99   99/99/99      99:99XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//                              1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        20
//                     1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local imprime      := .T.
Private aOrd       := {"Status+Doc+Serie","Status+Fornec+Loja+Doc+Serie"," Status+Data Base+Doc+Serie"," Status+Data Base+Fornec+Loja+Doc+Serie"}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 15
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "DVIA04"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "UA9"

dbSelectArea("UA9")
dbSetOrder(1)
           
/*
APERG := {}

// verifica o pergunte
aAdd( aPerg, {'01','Nota Fiscal De ?  ','Nota Fiscal De ?    ','Nota Fiscal De ?    ','mv_ch1','C',06, 0, 0,'G','','mv_par01','               ','               ','               ',''                    ,'               ','               ','               ','               ','               ','               ','               ','               ','               ','','S','   '  })
aAdd( aPerg, {'02','Nota Fiscal Ate ? ','Nota Fiscal Ate ?   ','Nota Fiscal Ate ?   ','mv_ch2','C',06, 0, 0,'G','','mv_par02','               ','               ','               ',''                    ,'               ','               ','               ','               ','               ','               ','               ','               ','               ','','S','   '  })
aAdd( aPerg, {'03','Serie De ?        ','Serie De ?          ','Serie De ?          ','mv_ch3','C',03, 0, 1,'G','','mv_par03','','','',''                    ,'','','','               ','               ','               ','               ','               ','               ','      ','S','   '  })
aAdd( aPerg, {'04','Serie Ate ?       ','Serie Ate ?         ','Serie Ate ?         ','mv_ch4','C',03, 0, 0,'G','','mv_par04','               ','               ','               ',''                    ,'               ','               ','               ','               ','               ','               ','               ','               ','               ','      ','S','   '  })
aAdd( aPerg, {'05','Fornecedor De ?   ','Fornecedor De ?     ','Fornecedor De ?     ','mv_ch5','C',06, 0, 0,'G','','mv_par05','     ','               ','               ',''                    ,'               ','               ','               ','               ','               ','               ','               ','               ','               ','','S','   '  })
aAdd( aPerg, {'06','Fornecedor Ate ?  ','Fornecedor Ate ?    ','Fornecedor Ate ?    ','mv_ch6','C',06, 0, 0,'G','','mv_par06','               ','               ','               ',''                    ,'               ','               ','               ','               ','               ','               ','               ','               ','               ','','S','   '  })
aAdd( aPerg, {'07','Loja De ?         ','Loja De ?           ','Loja De ?           ','mv_ch7','C',02, 0, 1,'G','','mv_par07','','',' ',''                    ,' ','','     ','               ','               ','               ','               ','               ','               ','      ','S','   '  })
aAdd( aPerg, {'08','Loja De ?         ','Loja De ?           ','Loja De ?           ','mv_ch8','C',02, 0, 0,'G','','mv_par08','               ','               ','               ',''                    ,'               ','               ','               ','               ','               ','               ','               ','               ','               ','      ','S','   '  })
aAdd( aPerg, {'09','Data base De ?    ','Data Base De ?      ','Data Base De ?      ','mv_ch9','D',08, 0, 1,'G','','mv_par09','','',' ',''                    ,' ','','     ','               ','               ','               ','               ','               ','               ','      ','S','   '  })
aAdd( aPerg, {'10','Data base Ate ?   ','Data Base Ate ?     ','Data Base Ate ?     ','mv_chA','D',08, 0, 0,'G','','mv_par10','               ','               ','               ',''                    ,'               ','               ','               ','               ','               ','               ','               ','               ','               ','      ','S','   '  })
aAdd( aPerg, {'11','Status NFE ?      ','Status NFE ?        ','Status NFE ?        ','mv_chB','C',02, 0, 0,'C','','mv_par11','               ','               ','               ',''                    ,'               ','               ','               ','               ','               ','               ','               ','               ','               ','      ','S','   '  })

U_AjustaSX1( cPerg,aPerg )
*/

pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin, nTipo) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  15/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin, nTipo)

Local nOrdem

dbSelectArea(cString)

nOrdem := aReturn[8]
dbSetOrder(nOrdem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Note que o descrito acima deve ser tratado de acordo com as ordens  ³
//³ definidas. Para cada ordem, o indice muda. Portanto a condicao deve ³
//³ ser tratada de acordo com a ordem selecionada. Um modo de fazer isto³
//³ pode ser como a seguir:                                             ³
//³                                                                     ³
//³ nOrdem := aReturn[8]                                                ³
//³ If nOrdem == 1                                                      ³
//³     dbSetOrder(1)                                                   ³
//³     cCond := "A1_COD <= mv_par02"                                   ³
//³ ElseIf nOrdem == 2                                                  ³
//³     dbSetOrder(2)                                                   ³
//³     cCond := "A1_NOME <= mv_par02"                                  ³
//³ ElseIf nOrdem == 3                                                  ³
//³     dbSetOrder(3)                                                   ³
//³     cCond := "A1_CGC <= mv_par02"                                   ³
//³ Endif                                                               ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.)                                      ³
//³ While !EOF() .And. &cCond                                           ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF TOP
	cQuery := ""
	cQuery += " SELECT * FROM " + RetSqlName( "UA9" )
	cQuery += "   WHERE UA9_DOC    BETWEEN '"+mv_par01      +"' AND '"+mv_par02+"' And "
	cQuery += "         UA9_SERIE  BETWEEN '"+mv_par03      +"' AND '"+mv_par04+"' And "
	cQuery += "         UA9_FORNEC BETWEEN '"+mv_par05      +"' AND '"+mv_par06+"' And "
	cQuery += "         UA9_LOJA   BETWEEN '"+mv_par07      +"' AND '"+mv_par08+"' And "
	cQuery += "         UA9_DATA   BETWEEN '"+Dtos(mv_par09)+"' AND '"+Dtos(mv_par10)+"' And "
	cQuery += "         UA9_STATUS =       '"+mv_par11+"' AND "
	cQuery += "         D_E_L_E_T_ = ' ' "
	
	nOrdem := aReturn[8]
	If nOrdem == 1                                                      
		cQuery += " ORDER BY UA9_STATUS, UA9_DOC, UA9_SERIE "            
	ElseIf nOrdem == 2                                                      
		cQuery += " ORDER BY UA9_STATUS, UA9_FORNEC, UA9_LOJA, UA9_DOC, UA9_SERIE "            
	ElseIf nOrdem == 3                                                      
		cQuery += " ORDER BY UA9_STATUS, UA9_DATA, UA9_DOC, UA9_SERIE "            
	Else	
		cQuery += " ORDER BY UA9_STATUS, UA9_DATA, UA9_FORNEC, UA9_LOJA, UA9_DOC, UA9_SERIE "            
		
	EndIf	
		
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TUA9", .F., .T. )

#ELSE

	ChkFile( "UA9",, "TUA9" )
	cIndUA9 := CriaTrab(NIL,.F.)                                  
	
	// Define Filtro
	_cFiltro := " UA9->UA9_DOC    >= '"+mv_par01+"' .AND. UA9->UA9->UA9_DOC   <= '"+mv_par02+"' .And. "
	_cFiltro += " UA9->UA9_SERIE  >= '"+mv_par03+"' .AND. UA9->UA9->UA9_SERIE <= '"+mv_par04+"' .And. "
	_cFiltro += " UA9->UA9_FORNEC >= '"+mv_par05+"' .AND. UA9->UA9_FORNEC<= '"+mv_par06+"' .And. "
	_cFiltro += " UA9->UA9_LOJA   >= '"+mv_par07+"' .AND. UA9->UA9_LOJA  <= '"+mv_par08+"' .And. "
	_cFiltro += " Dtos(UA9->UA9_DATA)   >= '"+Dtos(mv_par09)+"' .AND. Dtos(UA9->UA9_DATA)   <= '"+Dtos(mv_par10)+"' .And. "
	_cFiltro += " UA9->UA9_STATUS == '"+mv_par11+"'"

	nOrdem := aReturn[8]

	If nOrdem == 1                                                      
		IndRegua("TUA9", cIndUA9, "UA9_STATUS+UA9_DOC+UA9_SERIE",,_cFiltro,"Selecionando Registros...")
	ElseIf nOrdem == 2                                                      
		IndRegua("TUA9", cIndUA9, "UA9_STATUS+UA9_FORNEC+UA9_LOJA+UA9_DOC+UA9_SERIE",,_cFiltro,"Selecionando Registros...")
	ElseIf nOrdem == 3       
		IndRegua("TUA9", cIndUA9, "UA9_STATUS+UA9_DATA+UA9_DOC+UA9_SERIE",,_cFiltro,"Selecionando Registros...")         
	Else	
		IndRegua("TUA9", cIndUA9, "UA9_STATUS+UA9_DATA+UA9_FORNEC+UA9_LOJA+UA9_DOC+UA9_SERIE",,_cFiltro,"Selecionando Registros...")         
	EndIf	

	lAbriu  := .T.
	
	cCond += "   WHERE UA9_DOC    BETWEEN '"+mv_par01      +"' AND '"+mv_par02+"' And "
	cQuery += "         UA9_SERIE  BETWEEN '"+mv_par03      +"' AND '"+mv_par04+"' And "
	cQuery += "         UA9_FORNEC BETWEEN '"+mv_par05      +"' AND '"+mv_par06+"' And "
	cQuery += "         UA9_LOJA   BETWEEN '"+mv_par07      +"' AND '"+mv_par08+"' And "
	cQuery += "         UA9_DATA   BETWEEN '"+Dtos(mv_par09)+"' AND '"+Dtos(mv_par10)+"' And "
	cQuery += "         UA9_STATUS =       '"+mv_par11+"' AND "

	
#ENDIF

dbSelectArea( "TUA9" )
dbGoTop()
ProcRegua( RecCount() )

While !TUA9->( Eof() )

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                                 

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 10
   Endif

   @ nLin,001 PSay TUA9->UA9_DOC+"/"+TUA9->UA9_SERIE
   @ nLin,013 PSay TUA9->UA9_FORNEC+"/"+TUA9->UA9_LOJA+" - "+Posicione("SA2",1,xFilial("SA2")+TUA9->UA9_FORNEC+TUA9->UA9_LOJA,"SA2->A2_NREDUZ")
   nLin := nLin + 2 // Avanca a linha de impressao  
   @ nLin,001 PSay Left(TUA9->UA9_MSGERR ,50)
   @ nLin,053 PSay Left(TUA9->UA9_ARQEDI ,50)
   @ nLin,105 PSay Stod(TUA9->UA9_DTBASE)
   @ nLin,116 PSay Stod(TUA9->UA9_DATA )
   @ nLin,130 PSay TUA9->UA9_HORA 
   @ nLin,137 PSay TUA9->UA9_AUTOLG        
   
   nLin += 2

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo                    

dbSelectArea( "TUA9" )
dbCloseArea()

#IFDEF TOP
#ELSE
	FErase( cIndUA9 + OrdBagExt() )
#EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AJUSTASX1ºAutor  ³ Stanko             º Data ³  02/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina Auxiliar para criacao de perguntas no SX1           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mapfre                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AjustaSX1( cPerg, aPerg )
Local aArea     := GetArea()
Local aAreaSx1  := SX1->( GetArea() )
Local nX        := 0
Local nY        := 0
Local aCpoPerg  := {}
                        
aAdd( aCpoPerg, 'X1_ORDEM'   ) // 01
aAdd( aCpoPerg, 'X1_PERGUNT' ) // 02
aAdd( aCpoPerg, 'X1_PERSPA'  ) // 03
aAdd( aCpoPerg, 'X1_PERENG'  ) // 04
aAdd( aCpoPerg, 'X1_VARIAVL' ) // 05
aAdd( aCpoPerg, 'X1_TIPO'    ) // 06
aAdd( aCpoPerg, 'X1_TAMANHO' ) // 07
aAdd( aCpoPerg, 'X1_DECIMAL' ) // 08
aAdd( aCpoPerg, 'X1_PRESEL'  ) // 09
aAdd( aCpoPerg, 'X1_GSC'     ) // 10
aAdd( aCpoPerg, 'X1_VALID'   ) // 11
aAdd( aCpoPerg, 'X1_VAR01'   ) // 12
aAdd( aCpoPerg, 'X1_DEF01'   ) // 13
aAdd( aCpoPerg, 'X1_DEFSPA1' ) // 14
aAdd( aCpoPerg, 'X1_DEFENG1' ) // 15
aAdd( aCpoPerg, 'X1_CNT01'   ) // 16
aAdd( aCpoPerg, 'X1_DEF02'   ) // 17
aAdd( aCpoPerg, 'X1_DEFSPA2' ) // 18
aAdd( aCpoPerg, 'X1_DEFENG2' ) // 19
aAdd( aCpoPerg, 'X1_DEF03'   ) // 20
aAdd( aCpoPerg, 'X1_DEFSPA3' ) // 21
aAdd( aCpoPerg, 'X1_DEFENG3' ) // 22
aAdd( aCpoPerg, 'X1_DEF04'   ) // 23
aAdd( aCpoPerg, 'X1_DEFSPA4' ) // 24
aAdd( aCpoPerg, 'X1_DEFENG4' ) // 25
aAdd( aCpoPerg, 'X1_F3'      ) // 26
aAdd( aCpoPerg, 'X1_PYME'    ) // 27

dbSelectArea( "SX1" )
dbSetOrder( 1 )
For nX := 1 To Len( aPerg )
	If !dbSeek( cPerg + aPerg[nX][1] )
		RecLock( "SX1", .T. )
		For nY := 1 To Len( aCpoPerg )
			SX1->( &( aCpoPerg[nY] ) ) := aPerg[nX][nY]
		Next
		SX1->X1_GRUPO := cPerg
		MsUnlock()
	EndIf
Next

RestArea( aAreaSX1 )
RestArea( aArea )
Return NIL