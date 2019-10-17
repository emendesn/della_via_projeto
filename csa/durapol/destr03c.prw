#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DESTR03C  º Autor ³ Leonardo           º Data ³  15/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emissao de Ficha de Produção - Processo Revisado           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Duparol                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function DESTR03c
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
	Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
	Local   cDesc3      := "Emissao de Fichas de Produção "
	Local   cPict       := ""
	Local   titulo      := "Emissao de Fichas de Producao "
	Local   cPerg       := "ESTR01"
	Local   Cabec1      := "Este programa ira emitir fichas de producao de acordo com
	Local   Cabec2      := "os parametros selecionados"
	Local   imprime     := .T.
	Local   aOrd        := {}
	Private cString     := "SC2"
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 80
	Private tamanho     := "P"
	Private nomeprog    := "DESTR03c"
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt       := Space(10)
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private wnrel       := "DESTR01"

	cPerg    := PADR(cPerg,6)
	aRegs    := {}  
	aAdd(aRegs,{cPerg,"01","Carcaça              ?"," "," ","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""          })
	aAdd(aRegs,{cPerg,"02","Tipo?MO/BN/MP/ME     ?"," "," ","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Grupo?SERV/SC/CI/ATEC?"," "," ","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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
	Pergunte(cPerg,.F.)

	dbSelectArea("SC2")
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Do while .T.
		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

		If nLastKey == 27
			exit
		Endif

		SetDefault(aReturn,cString)

		If nLastKey == 27
			exit
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		VerImp()

		RptStatus({||RunReport()})
	Enddo
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  26/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport
	Local nOrdem
	Local nLin := 0

	IF Select("SC2TMP") > 0
		dbSelectArea("SC2TMP")
		dbCloseArea()
	EndIF

	_cQry:= "SELECT C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_EMISSAO, C2_NUMD1, C2_SERIED1, C2_FORNECE, C2_LOJA, C2_PRODUTO, C2_NUMFOGO, C2_SERIEPN, C2_OBS, C2_X_DESEN "
	_cQry+= " FROM " + RetSqlName("SC2") + " SC2 "
	_cqry+= " WHERE C2_FILIAL  = "       + " '" + xFilial("SC2") + "' "  
	_cQry+= " AND   D_E_L_E_T_ = '' "    

	if !empty(mv_par02)  
		_cQry+= " AND   C2_NUM||C2_ITEM >= " + " '" + mv_par01       + "' " + "AND C2_NUM||C2_ITEM <=" + " '" + mv_par02       + "' "
	endif

	if !empty(mv_par04)
		_cQry+= " AND   C2_EMISSAO >=      " + " '" + DTOS(mv_par03) + "' " + "AND C2_EMISSAO <="      + " '" + DTOS(mv_par04) + "' "
	endif  

	_cQry+= " ORDER BY C2_NUM||C2_ITEM " 	

	dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQry), "SC2TMP", .F., .T.)
	dbSelectArea("SC2TMP")

	@ nLin,000 PSAY chr(18)

	Do While !Eof()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		SetRegua(RecCount())

		/*
		IF SC2TMP->C2_EMISSAO < DTOS(mv_par03) .OR. SC2TMP->C2_EMISSAO > DTOS(mv_par04)
			dbSelectArea("SC2TMP")
			dbSkip()
			Loop
		EndIF
		*/

		nLin := nLin + 1

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		dbSelectArea("SD1")
		dbSetOrder(1)
		//dbSeek(xFilial("SD1")+SC2TMP->C2_NUM) - Denis
		dbSeek(xFilial("SD1")+SC2TMP->(C2_NUMD1+C2_SERIED1+C2_FORNECE+C2_LOJA))

		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)

		@ nLin,010 PSAY Alltrim(SA1->A1_NOME) //Cliente
		@ nLin,050 PSAY SA1->A1_COD           //Cod.Cliente
		nLin:= nLin + 1

		_cMedida := SC2TMP->C2_PRODUTO

		@ nLin,010 PSAY SD1->D1_DOC              //Coleta
		@ nLin,030 PSAY DTOC(STOD(SC2TMP->C2_EMISSAO))+" "+Time() //Data Emissao

		nLin:= nLin + 1

		@ nLin,010 PSAY SC2TMP->C2_PRODUTO //Medida
		//@ nLin,035 PSAY IIF(Empty(SC2TMP->C2_SERIEPN),SC2TMP->C2_NUMFOGO,SC2TMP->C2_SERIEPN) //Num.Serie/Numero Fogo 
		@ nLin,035 PSAY AllTrim(SC2TMP->C2_SERIEPN) + "/" + AllTrim(SC2TMP->C2_NUMFOGO)

		nLin:= nLin + 1
		@ nLin,010 PSAY chr(255)+ Chr(14)+ (SC2TMP->C2_NUM)+" "+(SC2TMP->C2_ITEM) //Numero da Ficha

		nLin:= nLin + 17

		@ nLin,012 PSAY SC2TMP->C2_OBS //Obs
		@ nLin,070 PSAY SC2TMP->C2_X_DESEN

		nLin:=nLin+ 3 //22

		@ nLin,010 PSAY Substr(Alltrim(SA1->A1_NOME),1,20) // Cliente
		@ nLin,039 PSAY SC2TMP->C2_X_DESEN                 // Banda
        @ nLin,058 PSAY SC2TMP->C2_NUM+"/"+SC2TMP->C2_ITEM //Numero da Ficha+Item da Ficha
		nLin:= nLin + 1

		@ nLin,010 PSAY SD1->D1_DOC                               //Coleta
		@ nLin,036 PSAY DTOC(STOD(SC2TMP->C2_EMISSAO))+" "+Time() //Data Emissao
		@ nLin,058 PSAY SC2TMP->C2_PRODUTO                        //Medida chr(255)+Chr(14) +
		nLin:= nLin + 1

		@ nLin,010 PSAY _cMedida //Medida
		//@ nLin,042 PSAY IIF(Empty(SC2TMP->C2_SERIEPN),SC2TMP->C2_NUMFOGO,SC2TMP->C2_SERIEPN) //Num.Serie/Numero Fogo
		@ nLin,042 PSAY  AllTrim(SC2TMP->C2_SERIEPN) + "/" + AllTrim(SC2TMP->C2_NUMFOGO)

		nlin := nLin + 1
		@ nLin,010 PSAY  SC2TMP->C2_NUM+"/"+SC2TMP->C2_ITEM       //Numero da Ficha+Item da Ficha

		nlin := nLin + 1
	
		@ nLin,018 PSAY SC2TMP->C2_X_DESEN          //Banda        
		nlin := nLin + 2				

		nLin := nLin+6  //11

		dbSelectArea("SC2TMP")
		dbSkip()
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif

	MS_FLUSH()
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ VERIMP   ¦ Autor ¦   Microsiga       ¦ Data ¦ 11/04/55     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Verifica posicionamento de papel na Impressora             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Durapol                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function VerImp()
	nLin    := 0 // Contador de Linhas
	nLinIni := 0

	IF aReturn[5]== 2
		nOpc := 1

		Do While .T.
			SetPrc(0,0)
			dbCommitAll()

			@ nLin ,000 PSAY " "
			@ nLin ,004 PSAY "*"
			@ nLin ,022 PSAY "."

			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif

			Do Case
				Case nOpc == 1
					lContinua:=.T.
					Exit
				Case nOpc == 2
					Loop
				Case nOpc==3
					lContinua:=.F.
					Return
			EndCase
		EndDo
	Endif
Return