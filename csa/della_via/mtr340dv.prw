#INCLUDE "MATR340.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR340  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consumos mes a mes                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function MTR340DV
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL Tamanho  := "G"
	LOCAL titulo   := STR0001	//"Consumos/Vendas mes a mes de Materiais"
	LOCAL cDesc1   := STR0002	//"Este programa exibira' o consumo dos ultimos 12 meses de cada material"
	LOCAL cDesc2   := STR0003	//"ou produto acabado. No caso dos produtos ele estara' listando o  total"
	LOCAL cDesc3   := STR0004	//"das vendas."
	LOCAL cString  := "SB1"
	LOCAL aOrd     := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008)}	//" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "
	LOCAL wnrel := "MTR340DV"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis tipo Private padrao de todos os relatorios         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE aReturn:= {STR0009, 1,STR0010, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
	PRIVATE nLastKey := 0 ,cPerg := "R340DV", aRegs := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01     // codigo de                                    ³
	//³ mv_par02	  // codigo ate                                   ³ 
	//³ mv_par03     // tipo de                                      ³
	//³ mv_par04     // tipo ate                                     ³
	//³ mv_par05     // grupo de                                     ³
	//³ mv_par06     // grupo ate                                    ³
	//³ mv_par07     // descricao de                                 ³
	//³ mv_par08     // descricao ate                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aRegs,{cPerg,"01","Do Codigo          ?"," "," ","mv_ch1","C", 15,0,0,"G","","mv_par01",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","SB1","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate o Codigo       ?"," "," ","mv_ch2","C", 15,0,0,"G","","mv_par02",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","SB1","","","",""          })
	aAdd(aRegs,{cPerg,"03","Do Tipo            ?"," "," ","mv_ch3","C", 02,0,0,"G","","mv_par03",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","02 ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate o Tipo         ?"," "," ","mv_ch4","C", 02,0,0,"G","","mv_par04",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","02 ","","","",""          })
	aAdd(aRegs,{cPerg,"05","Do Grupo           ?"," "," ","mv_ch5","C", 04,0,0,"G","","mv_par05",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","SBM","","","",""          })
	aAdd(aRegs,{cPerg,"06","Ate o Grupo        ?"," "," ","mv_ch6","C", 04,0,0,"G","","mv_par06",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","SBM","","","",""          })
	aAdd(aRegs,{cPerg,"07","Da Descricao       ?"," "," ","mv_ch7","C", 30,0,0,"G","","mv_par07",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"08","Ate a Descricao    ?"," "," ","mv_ch8","C", 30,0,0,"G","","mv_par08",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"09","Da Filial          ?"," "," ","mv_ch9","C", 02,0,0,"G","","mv_par09",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"10","Ate a Filial       ?"," "," ","mv_cha","C", 02,0,0,"G","","mv_par10",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","   ","","","",""          })

	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao Setprint                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

	If nLastKey = 27
		Set Filter to
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey = 27
		Set Filter to
		Return
	Endif

	RptStatus({|lEnd| C340Imp(@lEnd,aOrd,wnRel,cString,tamanho,titulo)},titulo)
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C340IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 13.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR340			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C340Imp(lEnd,aOrd,WnRel,cString,tamanho,titulo)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis locais exclusivas deste programa                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL aMeses:= {STR0011,STR0012,STR0013,STR0014,STR0015,STR0016,STR0017,STR0018,STR0019,STR0020,STR0021,STR0022}	//"JAN"###"FEV"###"MAR"###"ABR"###"MAI"###"JUN"###"JUL"###"AGO"###"SET"###"OUT"###"NOV"###"DEZ"
	LOCAL nX ,nAno := 0 ,nMes := 0 ,aSub[14] ,aTot[14] ,aTotFil[14] ,lPassou ,nCol ,nMesAux
	Local cPictQuant := ""
	Local aArea := GetArea()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis privadas exclusivas deste programa                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE cMes ,cCondicao ,lContinua := .T. ,cCondSec ,cAnt

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt    := SPACE(10)
	cbcont   := 0
	li       := 80
	m_pag    := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTipo  := IIF(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pega a Picture da quantidade (maximo de 10 posicoes)         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("B3_Q01")
	If X3_TAMANHO >= 10
		For nX := 1 To 10
			If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
				cPictQuant := cPictQuant+"."
			Else
				cPictQuant := cPictQuant+"9"
			EndIf
		Next nX
	Else
		For nX := 1 To 10
			If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
				cPictQuant := "."+cPictQuant
			Else
				cPictQuant := "9"+cPictQuant
			EndIf
		Next nX
	EndIf
	RestArea(aArea)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Soma a ordem escolhida ao titulo do relatorio                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Type("NewHead")#"U"
		NewHead += " ("+AllTrim(aOrd[aReturn[8]])+")"
	Else
		Titulo += " ("+AllTrim(aOrd[aReturn[8]])+")"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem Dos Dados do cabecalho do relatorio                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nAno := Year(dDataBase)
	If month(dDatabase) < 12
		nAno--
	Endif

	nMes := MONTH(dDataBase)+1
	IF nMes = 13 
		nMes := 1
	Endif

	cMes := StrZero(nMes,2)

	cabec2 := STR0023	//"CODIGO          TP GRUP DESCRICAO                      UM"
	*****      123456789012345 12 1234 123456789012345678901234567890 12 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 999,999,999.99 A
	*****      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
	*****      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	FOR nX := 1 TO 12
		IF aMeses[nMes] == STR0011 .And. nX != 1	//"JAN"
			nAno++
		EndIF
		cabec2 += Space(3)+aMeses[nMes]+"/"+StrZero(nAno,4)
		nMes++
		IF nMes > 12
			nMes := 1
		ENDIF
	NEXT nX
	cabec2 += STR0024	//"      MEDIA          VALOR CL"
	cabec1 := "Da Filial: ("+mv_par09+") até ("+mv_par10+")     Do Grupo: ("+mv_par05+") até ("+mv_par06+")"

	cSql := "SELECT B3_FILIAL,B3_Q01,B3_Q02,B3_Q03,B3_Q04,B3_Q05,B3_Q06,B3_Q07,B3_Q08,B3_Q09,B3_Q10,B3_Q11,B3_Q12"
	cSql += " ,     B3_MEDIA,B3_TOTAL,B3_CLASSE"
	cSql += " ,     B1_COD,B1_DESC,B1_TIPO,B1_GRUPO,B1_UM"
	cSql += " FROM "+RetSqlName("SB3")+" SB3"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = ''"
	cSql += " AND  B1_COD = B3_COD"
	cSql += " AND  B1_DESC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cSql += " AND  B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND  B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"

	cSql += " WHERE SB3.D_E_L_E_T_ = ''"
	cSql += " AND   B3_FILIAL BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	cSql += " AND   B3_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"

	If aReturn[8] = 1
		cSql += " ORDER BY B3_FILIAL,B3_COD"
	Elseif aReturn[8] = 2
		cSql += " ORDER BY B3_FILIAL,B1_TIPO"
	Elseif aReturn[8] = 3
		cSql += " ORDER BY B3_FILIAL,B1_DESC"
	Elseif aReturn[8] = 4
		cSql += " ORDER BY B3_FILIAL,B1_GRUPO"
	Endif

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","B3_Q01","N",14,2)
	TcSetField("ARQ_SQL","B3_Q02","N",14,2)
	TcSetField("ARQ_SQL","B3_Q03","N",14,2)
	TcSetField("ARQ_SQL","B3_Q04","N",14,2)
	TcSetField("ARQ_SQL","B3_Q05","N",14,2)
	TcSetField("ARQ_SQL","B3_Q06","N",14,2)
	TcSetField("ARQ_SQL","B3_Q07","N",14,2)
	TcSetField("ARQ_SQL","B3_Q08","N",14,2)
	TcSetField("ARQ_SQL","B3_Q09","N",14,2)
	TcSetField("ARQ_SQL","B3_Q10","N",14,2)
	TcSetField("ARQ_SQL","B3_Q11","N",14,2)
	TcSetField("ARQ_SQL","B3_Q12","N",14,2)
	TcSetField("ARQ_SQL","B3_MEDIA","N",14,2)
	TcSetField("ARQ_SQL","B3_TOTAL","N",14,2)

	aFill(aTot,0)
	SetRegua(0)
	While !eof()
		Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		cFil := B3_FILIAL
		aFill(aTotFil,0)
		@ li,000 PSAY "Filial: " + cFil
		li+=2
		
		Do While !eof() .and. B3_FILIAL = cFil
			If aReturn[8] == 2
				cAnt := B1_TIPO
				cCondSec := "B1_TIPO == cAnt"
				cLinhaSub := STR0025+cAnt+" .........."	//"Total do tipo "
			ElseIf aReturn[8] == 4
				cAnt := B1_GRUPO
				cCondSec := "B1_GRUPO == cAnt"
				cLinhaSub := STR0026+cAnt+" ......." //"Total do grupo "
			Else
				cCondSec := ".T."
			EndIf

			aFill(aSub,0)
			While !eof() .and. B3_FILIAL = cFil .AND. &cCondSec
				IncRegua()

				If li > 55
					Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf

				dbSelectArea("SB2")
				dbSetOrder(1)
				dbGoTop()
				dbSeek(cFil+ARQ_SQL->B1_COD)
				if Found()
					nSldAtu := SaldoSB2()
				Else
					nSldAtu := 0
				Endif
				dbSelectArea("ARQ_SQL")

				@ li,000 PSay B1_COD
				@ li,016 PSay B1_TIPO
				@ li,019 PSay B1_GRUPO
				@ li,024 PSay Substr(B1_DESC,1,30)
				@ li,055 PSay B1_UM
				@ li,058 PSay nSldAtu Picture cPictQuant

				nCol    := 58+11
				nMesAux := nMes
				ntotal  := 0
				For nX := 1 To 12
					cCampo := "B3_Q&cMes"
					@ li,nCol PSay &(cCampo) Picture cPictQuant
					aSub[nX] += &(cCampo)
					nTotal += &(cCampo)
					nMesAux++
					If nMesAux > 12
						nMesAux := 1
					EndIf
					cMes := StrZero(nMesAux,2)
					nCol += 11
				Next nX
				@ li,200 PSay nTotal/12 PicTure cPictQuant
				@ li,210 PSay nTotal PicTure cPictQuant
				/*
				@ li,190 PSay B3_MEDIA PicTure cPictQuant
				@ li,201 PSay B3_TOTAL PicTure TM(B3_TOTAL,14)
				@ li,216 PSay B3_CLASSE
				*/
				li++

				aSub[13] += nSldAtu

				//aSub[13] += B3_MEDIA
				//aSub[14] += B3_TOTAL

				dbSkip()
			EndDo

			If (aReturn[8] == 2 .Or. aReturn[8] == 4)
				@ li,030 PSay cLinhaSub
				@ li,058 PSay aSub[13] PicTure cPictQuant
				nCol := 58+11
				ntotal  := 0
				For nX := 1 To 12
					@ li,nCol PSay aSub[nX] Picture cPictQuant
					nTotal += aSub[nX]
					nCol += 11
				Next nX
				@ li,200 PSay nTotal/12 PicTure cPictQuant
				@ li,210 PSay nTotal PicTure cPictQuant
				/*
				@ li,190 PSay aSub[13] PicTure cPictQuant
				@ li,201 PSay aSub[14] PicTure TM(aSub[14],14)
				*/
				li += 2
			EndIf
	
			For nX := 1 To Len(aTot)
				aTot[nX] += aSub[nX]
				aTotFil[nX] += aSub[nX]
			Next nX
		Enddo

		li ++
		@ li,010 PSay "Total Filial"+Replicate(".",35)
		@ li,058 PSay aTotFil[13] PicTure cPictQuant
		nCol := 58 +11
		nTotal := 0
		For nX := 1 To 12
			@ li,nCol PSay aTotFil[nX] Picture cPictQuant
			nTotal += aTotFil[nX]
			nCol += 11
		Next nX
		@ li,200 PSay nTotal/12 PicTure cPictQuant
		@ li,210 PSay nTotal PicTure cPictQuant
		/*
		@ li,190 PSay aTotFil[13] PicTure cPictQuant
		@ li,201 PSay aTotFil[14] PicTure TM(aTot[14],14)
		*/
		li += 2

	EndDo

	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	If li != 80
		If aReturn[8] == 2 .Or. aReturn[8] == 4
			@ li,005 PSay STR0028+Replicate(".",41)		//"Total geral"
			@ li,058 PSay aTot[13] PicTure cPictQuant
			nCol := 58 + 11
			nTotal := 0
			For nX := 1 To 12
				@ li,nCol PSay aTot[nX] Picture cPictQuant
				nTotal += aTot[nX]
				nCol += 11
			Next nX
			@ li,200 PSay nTotal/12 PicTure cPictQuant
			@ li,210 PSay nTotal PicTure cPictQuant
			/*
			@ li,190 PSay aTot[13] PicTure cPictQuant
			@ li,201 PSay aTot[14] PicTure TM(aTot[14],14)
			*/
			li += 2
		EndIf
		Roda(cbcont,cbtxt,Tamanho)
	EndIf

	If aReturn[5] = 1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil