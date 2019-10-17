#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELR202  ºAutor  ³ Stanko             º Data ³ 24/01/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Vendas - Sintetico						      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao se aplica                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Executado via menu.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObsercacao³ Este fonte substitui o DELR200.PRW.                        º±±
±±º          ³ Com o intuito de melhorar a perfomance de execucao do      º±±
±±º          ³ relatorio de Vendas - Sintetico, o fonte DELR200 foi       º±±
±±º          ³ reescrito no DELR202.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DELR202()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório de Vendas - Sintético"
Local cPict          := ""
Local titulo  		 := "Relatório de Vendas - Sintético""
Local nLin           := 80

Local cabec1         := "          Vendedor                                          Valor               Valor               Total           Quant.                  Valor         Carro(s)"//               Valor"
Local cabec2         := "                                                       Mercadoria             Servico           Merc+Serv           Seguro                 Seguro      Atendido(s)"//           Devolucao"

Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "G"
Private nomeprog         := "DELR200" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn      	 := { "Zebrado", 1, "Administracao", 2, 1, 1,"", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "DLR202" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	   := "DLR202"
Private cString := "SF2"
Private nRecCount	:= 0
Private  cArqTRB := ""

dbSelectArea("SF2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montao Pergunte													    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()
Pergunte(cPerg,.F.)


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

Processa({|| MontaQuery()},,"Selecionando registros...")
Processa({|| MontaTRB()},,"Analisando registros...")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaQueryºAutor  ³ Stanko             º Data ³ 24/01/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Monta a query com os dados para processamento do relatorio  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao se aplica                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Logico (.T.)                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Executado pela rotina principal                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaQuery()
Local cQuery := ""
Local cEnter := Chr(13)


cQuery := "SELECT F2_DOC, F2_SERIE, F2_TIPVND, ' ' FUNCAO, F2_VEND1 VEND,  "+cEnter
cQuery += "D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, D1_TOTAL, B1_GRUPO, B1_DEPTODV, B1_GRUPODV, B1_ESPECDV, SD2.R_E_C_N_O_, 0 QTD_ALIN, 0 QTD_MONT  "+cEnter
cQuery += "FROM "+RetSQLName("SD2")+" SD2 "+cEnter
cQuery += "LEFT OUTER JOIN "+RetSQLName("SD1")+" SD1 ON (SD1.D1_FILIAL = SD2.D2_FILIAL  "+cEnter
cQuery += "AND SD1.D_E_L_E_T_ = ' ' AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE  "+cEnter
cQuery += "AND SD1.D1_ITEMORI = SD2.D2_ITEM), "+cEnter
cQuery += RetSQLName("SF2")+" SF2, "+RetSQLName("SB1")+" SB1, "+RetSQLName("SF4")+" SF4 "+cEnter
cQuery += "WHERE D2_FILIAL = '"+xFilial("SF2")+"'  AND SD2.D_E_L_E_T_ = ' ' "+cEnter
//cQuery += "WHERE D2_FILIAL = '11'  AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += "AND D2_EMISSAO BETWEEN '"+DtoS(MV_PAR02)+"' AND '"+DToS(MV_PAR03)+"' "+cEnter
cQuery += "AND B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ = ' ' "+cEnter
cQuery += "AND B1_COD = D2_COD "+cEnter
cQuery += "AND F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.D_E_L_E_T_ = ' '  "+cEnter
cQuery += "AND F4_CODIGO = SD2.D2_TES  "+cEnter
cQuery += "AND F4_DUPLIC = 'S' "+cEnter
cQuery += "AND F2_FILIAL = D2_FILIAL "+cEnter
cQuery += "AND SF2.D_E_L_E_T_ = ' '  "+cEnter
cQuery += "AND F2_DOC = D2_DOC "+cEnter
cQuery += "AND F2_SERIE = D2_SERIE "+cEnter
cQuery += "AND F2_TIPVND IN ("+Parse_Tipo(MV_PAR01)+") "+cEnter
cQuery += "AND F2_VEND1 BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "+cEnter
//cQuery += "AND F2_DOC = '021176'
cQuery += "UNION"+cEnter

cQuery += "SELECT F2_DOC, F2_SERIE, F2_TIPVND, PAB_FUNCAO FUNCAO, PAB_CODTEC VEND,  "+cEnter
cQuery += "D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, D1_TOTAL, B1_GRUPO, B1_DEPTODV, B1_GRUPODV, B1_ESPECDV, SD2.R_E_C_N_O_,  "+cEnter

cQuery += "COALESCE((SELECT COUNT(*) QTD "+cEnter
cQuery += "FROM "+RetSQLName("PAB")+" PAB "+cEnter
cQuery += "WHERE PAB.PAB_FILIAL = SL1.L1_FILIAL AND PAB.D_E_L_E_T_  = ' ' "+cEnter
cQuery += "AND PAB.PAB_FUNCAO = '1' "+cEnter
cQuery += "AND PAB.PAB_ORC = SL1.L1_NUM "+cEnter
cQuery += "GROUP BY PAB_FILIAL, PAB_ORC "+cEnter
cQuery += "),0) QTD_ALIN, "+cEnter

cQuery += "COALESCE((SELECT COUNT(*) QTD "+cEnter
cQuery += "FROM "+RetSQLName("PAB")+" PAB "+cEnter
cQuery += "WHERE PAB.PAB_FILIAL = SL1.L1_FILIAL AND PAB.D_E_L_E_T_  = ' ' "+cEnter
cQuery += "AND PAB.PAB_FUNCAO = '2' "+cEnter
cQuery += "AND PAB.PAB_ORC = SL1.L1_NUM "+cEnter
cQuery += "GROUP BY PAB_FILIAL, PAB_ORC "+cEnter
cQuery += "),0) QTD_MONT "+cEnter

cQuery += "FROM "+RetSQLName("SD2")+" SD2 "+cEnter
cQuery += "LEFT OUTER JOIN "+RetSQLName("SD1")+" SD1 ON (SD1.D1_FILIAL = SD2.D2_FILIAL  "+cEnter
cQuery += "AND SD1.D_E_L_E_T_ = ' ' AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE  "+cEnter
cQuery += "AND SD1.D1_ITEMORI = SD2.D2_ITEM), "+cEnter
cQuery += RetSQLName("SF2")+" SF2, "+RetSQLName("SB1")+" SB1, "+RetSQLName("SF4")+" SF4, "+RetSQLName("SL1")+" SL1, "+RetSQLName("PAB")+" PAB "+cEnter
cQuery += "WHERE D2_FILIAL = '"+xFilial("SF2")+"'  AND SD2.D_E_L_E_T_ = ' ' "+cEnter
//cQuery += "WHERE D2_FILIAL = '11'  AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += "AND D2_EMISSAO BETWEEN '"+DtoS(MV_PAR02)+"' AND '"+DToS(MV_PAR03)+"' "+cEnter
cQuery += "AND B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ = ' ' "+cEnter
cQuery += "AND B1_COD = D2_COD "+cEnter
cQuery += "AND F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.D_E_L_E_T_ = ' '  "+cEnter
cQuery += "AND F4_CODIGO = SD2.D2_TES  "+cEnter
cQuery += "AND F4_DUPLIC = 'S' "+cEnter
cQuery += "AND F2_FILIAL = D2_FILIAL "+cEnter
cQuery += "AND SF2.D_E_L_E_T_ = ' '  "+cEnter
cQuery += "AND F2_DOC = D2_DOC "+cEnter
cQuery += "AND F2_SERIE = D2_SERIE "+cEnter
cQuery += "AND F2_TIPVND IN ("+Parse_Tipo(MV_PAR01)+") "+cEnter
cQuery += "AND SL1.L1_FILIAL = SF2.F2_FILIAL AND SL1.D_E_L_E_T_ = ' ' "+cEnter
cQuery += "AND SL1.L1_DOC = SF2.F2_DOC  "+cEnter
cQuery += "AND SL1.L1_SERIE = SF2.F2_SERIE "+cEnter
cQuery += "AND PAB.PAB_FILIAL = SF2.F2_FILIAL AND PAB.D_E_L_E_T_ = ' ' "+cEnter
cQuery += "AND PAB.PAB_ORC = SL1.L1_NUM "+cEnter
cQuery += "AND PAB.PAB_CODTEC BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "+cEnter`
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPQRY",.T.,.T.)
dbEval({||nRecCount++})
dbGotop()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaTRB  ºAutor  ³ Stanko             º Data ³ 24/01/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Monta area de trabalho                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao se aplica                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Logico (.T.)                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Executado pela rotina principal                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaTRB()
Local  aEstrut  := {{"DOC" 		   ,"C", 06, 00},;
					{"SERIE" 	   ,"C", 03, 00},;
					{"FUNCAO"      ,"C", 01, 00},;
					{"VEND"   	   ,"C", 06, 00},;
					{"TIPVND" 	   ,"C", 01, 00},;
					{"VLMERC"      ,"N", 14, 02},;
					{"VLSERV"      ,"N", 14, 02},;
					{"VLTOT"       ,"N", 14, 02},;
					{"QTSEG"       ,"N", 06, 00},;
					{"VLSEG"       ,"N", 14, 02},;
					{"QTCAR"       ,"N", 06, 00},;
					{"VLDEV"       ,"N", 14, 02}}

Local aPB4		   := {}
Local cGrupoSeg    := GETMV("FS_DEL001")
Local cGrupoCar    := GETMV("FS_DEL037")
Local cDGE		   := ""
Local aCarro	   := {}
Local nFunc		   := 0
	
ProcRegua(nRecCount)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cola todos os registros da PB4 em array para facilitar busca ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("PB4")
dbGotop()
While !EOF()
	aAdd(aPB4,{PB4->PB4_FUNCAO,PB4->PB4_META,PB4->PB4_DEPINI,PB4->PB4_GRUINI,PB4->PB4_ESPINI,PB4->PB4_DEPFIM,PB4->PB4_GRUFIM,PB4->PB4_ESPFIM,PB4->PB4_PERC})
	dbSkip()
End


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o TRB				                					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTRB := CriaTrab( aEstrut, .T.)
dbUseArea(.T.,,cArqTRB,"TRB",.F.,.F.)

cIndA := Left(cArqTRB,7)+"A"
cIndB := Left(cArqTRB,7)+"B"

IndRegua("TRB",  cIndA, "DOC+SERIE+FUNCAO+VEND",,, "Criando Indice..." )
IndRegua("TRB",  cIndB, "TIPVND+FUNCAO+VEND",,, "Criando Indice..." )

dbClearIndex()
dbSetIndex(cIndA+OrdBagExt())
dbSetIndex(cIndB+OrdBagExt())


dbSelectArea("TMPQRY")
While !EOF()
	
	IncProc()
	                
	dbSelectArea("TRB")
	dbSetOrder(1)
	If !dbSeek(TMPQRY->F2_DOC+TMPQRY->F2_SERIE+TMPQRY->FUNCAO+TMPQRY->VEND)
		Reclock("TRB",.T.)
		TRB->DOC    := TMPQRY->F2_DOC
		TRB->SERIE	:= TMPQRY->F2_SERIE
		TRB->FUNCAO := TMPQRY->FUNCAO
		TRB->VEND   := TMPQRY->VEND
		TRB->TIPVND := TMPQRY->F2_TIPVND
		TRB->VLMERC := 0
		TRB->VLSERV := 0
		TRB->VLTOT  := 0
		TRB->QTSEG  := 0
		TRB->VLSEG	:= 0
		TRB->QTCAR  := 0
		TRB->VLDEV  := 0
	Else
		Reclock("TRB",.F.)
	EndIf
	
	nFunc := 1
	IF TMPQRY->FUNCAO == "1"
		nFunc := TMPQRY->QTD_ALIN
	ElseIf 	TMPQRY->FUNCAO == "2"
		nFunc := TMPQRY->QTD_MONT
	EndIF	
	

	cDGE := TMPQRY->B1_DEPTODV+TMPQRY->B1_GRUPODV+TMPQRY->B1_ESPECDV
	cAux := IF(Empty(TMPQRY->FUNCAO),"3",TMPQRY->FUNCAO)
	
	nPosS := aScan(aPB4, {|aPB4| aPB4[1] == cAux .And. aPB4[2] == "4" .And.	cDGE >= aPB4[3]+aPB4[4]+aPB4[5]   .And. cDGE <= aPB4[6]+aPB4[7]+aPB4[8]})
	nPosP := aScan(aPB4, {|aPB4| aPB4[1] == cAux .And. aPB4[2] == "1" .And.	cDGE >= aPB4[3]+aPB4[4]+aPB4[5]   .And. cDGE <= aPB4[6]+aPB4[7]+aPB4[8]})	
	nPosA := aScan(aPB4, {|aPB4| aPB4[1] == cAux .And. aPB4[2] == "3" .And.	cDGE >= aPB4[3]+aPB4[4]+aPB4[5]   .And. cDGE <= aPB4[6]+aPB4[7]+aPB4[8]})	
	
	If nPosS > 0
		//Vl de Servico
		nAux := (((TMPQRY->D2_TOTAL-TMPQRY->D1_TOTAL) * aPB4[nPosS][9] / 100) / nFunc)
		nAux := iif(nAux < 0,0,nAux)
		TRB->VLSERV += nAux
	ElseIf nPosP > 0
 		//vl de mercadoria (pneu)
		nAux := (((TMPQRY->D2_TOTAL-TMPQRY->D1_TOTAL) * aPB4[nPosP][9] / 100) / nFunc)
		nAux := iif(nAux < 0,0,nAux)
		TRB->VLMERC += nAux
	ElseIf nPosA > 0 
		//vl de mercadoria (acessorio)
		nAux := (((TMPQRY->D2_TOTAL-TMPQRY->D1_TOTAL) * aPB4[nPosA][9] / 100) / nFunc)
		nAux := iif(nAux < 0,0,nAux)
		TRB->VLMERC += nAux
	EndIf	
		
	
	
	//ElseIf TMPQRY->B1_DEPTODV <> 'TAC'  .And. !(TMPQRY->B1_GRUPO $ cGrupoSeg)
		//Vl de Mercadoria
	
	
	//Vl de Seguro
	If TMPQRY->B1_GRUPO $ cGrupoSeg
		TRB->QTSEG  += (TMPQRY->D2_QUANT / nFunc)
		TRB->VLSEG  += ((TMPQRY->D2_TOTAL-TMPQRY->D1_TOTAL) / nFunc)
	EndIf
	
	//Valor de devolucao
	TRB->VLDEV += TMPQRY->D1_TOTAL / nFunc
	
	
	//Numero de carros antedidos
	If Empty(TMPQRY->FUNCAO) .And. TMPQRY->B1_GRUPO $ cGrupoCar
		If aScan(aCarro,TMPQRY->F2_DOC+TMPQRY->F2_SERIE) == 0
			TRB->QTCAR++
			aAdd(aCarro,TMPQRY->F2_DOC+TMPQRY->F2_SERIE)
		EndIf
	EndIf
	

	//Vl de Servico referente ao alinhador vai para o 
	//montador quando nao tiver alinhador na equipe
	If TMPQRY->FUNCAO == "2" .And. TMPQRY->QTD_ALIN == 0
		cDGE := TMPQRY->B1_DEPTODV+TMPQRY->B1_GRUPODV+TMPQRY->B1_ESPECDV
		cAux := "1"
		nPos := aScan(aPB4, {|aPB4| aPB4[1] == cAux .And. aPB4[2] == "4" .And.	cDGE >= aPB4[3]+aPB4[4]+aPB4[5]   .And. cDGE <= aPB4[6]+aPB4[7]+aPB4[8]})
		If nPos > 0 
			TRB->VLSERV += (((TMPQRY->D2_TOTAL-TMPQRY->D1_TOTAL) * aPB4[nPos][9] / 100) / TMPQRY->QTD_MONT)
	    EndIF   	
	EndIf
	
	MsUnlock()
	
	dbSelectArea("TMPQRY")
	dbSkip()
	
	//If TRB->DOC <> TMPQRY->F2_DOC
	 // MsgInfo("Doc: "+TRB->DOC+" Merc."+Str(TRB->VLMERC))
	//EndIf                                    
End
dBSelectArea("TMPQRY")
dbCloseArea()
	
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RUNREPORT ºAutor  ³ Stanko             º Data ³ 24/01/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao se aplica                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao se aplica                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Executado pela rotina principal                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cTipVnd := ""
Local cFuncao := ""
Local cVend	  := ""

Local nMerc  := 0
Local nServ  := 0
Local nQtSeg := 0
Local nVlSeg := 0
Local nCarro := 0
Local nDev   := 0

Local nMercF  := 0
Local nServF  := 0
Local nQtSegF := 0
Local nVlSegF := 0
Local nCarroF := 0
Local nDevF   := 0

Local nMercT  := 0
Local nServT  := 0
Local nQtSegT := 0
Local nVlSegT := 0
Local nCarroT := 0
Local nDevT   := 0

Titulo := "Relatorio de Vendas - Sintetico - Loja "+xFilial("SF2")+" - Periodo de "+DToC(MV_PAR02)+" à "+ DToC(MV_PAR03)

dbSelectArea("TRB")
dbSetOrder(2)
dbGotop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())

While !EOF()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	cTipVnd := TRB->TIPVND
	
	@nLin,000 PSAY "Tipo de Venda: " + cTipVnd + ""
	nLin+=2
	
	nMercT  := 0
	nServT  := 0
	nQtSegT := 0
	nVlSegT := 0
	nCarroT := 0
	nDevT   := 0
	
	While !EOF() .And. TRB->TIPVND == cTipVnd
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		
		cFuncao := TRB->FUNCAO
		
		If Empty(cFuncao)
			@nLin,005 PSAY "Funcao: Vendedor"
		ElseIf	cFuncao == "1"
			@nLin,005 PSAY "Funcao: Alinhador"
		ElseIf	cFuncao == "2"
			@nLin,005 PSAY "Funcao: Montador"
		EndIf
		nLin+=2
		
		
		nMercF  := 0
		nServF  := 0
		nQtSegF := 0
		nVlSegF := 0
		nCarroF := 0
		nDevF   := 0
		
		While !EOF() .And. TRB->TIPVND == cTipVnd .And. TRB->FUNCAO == cFuncao

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			cVend := TRB->VEND
			
			nMerc  := 0
			nServ  := 0
			nQtSeg := 0
			nVlSeg := 0
			nCarro := 0
			nDev   := 0
			
			While !EOF() .And. TRB->TIPVND == cTipVnd .And. TRB->FUNCAO == cFuncao .And. TRB->VEND == cVend
			
				IncRegua()	

				nMerc  += TRB->VLMERC
				nServ  += TRB->VLSERV
				nQtSeg += TRB->QTSEG
				nVlSeg += TRB->VLSEG
				nCarro += TRB->QTCAR
				nDev   += TRB->VLDEV
			
				dbSelectArea("TRB")
				dbSkip() 
			EndDo //fim do vendedor
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			@nLin,010 PSAY cVend
			@nLin,017 PSAY PadR(Posicione("SA3",1,xFilial("SA3")+cVend,"A3_NOME"),25)
			If Empty(cFuncao)
				@nLin,051 PSAY nMerc   Picture PesqPict("SD2","D2_TOTAL")
				@nLin,071 PSAY nServ   Picture PesqPict("SD2","D2_TOTAL")
				@nLin,091 PSAY nMerc+nServ   Picture PesqPict("SD2","D2_TOTAL")
				@nLin,111 PSAY nQtSeg  Picture '@E 99,999,999' //PesqPict("SD2","D2_QUANT")
				@nLin,131 PSAY nVlSeg  Picture PesqPict("SD2","D2_TOTAL")
				@nLin,151 PSAY nCarro  Picture '@E 99,999,999' //PesqPict("SD2","D2_QUANT")
			ElseIf cFuncao == "2"	
				@nLin,051 PSAY nMerc   Picture PesqPict("SD2","D2_TOTAL")
				@nLin,071 PSAY nServ   Picture PesqPict("SD2","D2_TOTAL")
				@nLin,091 PSAY nMerc+nServ   Picture PesqPict("SD2","D2_TOTAL")
			Else
				@nLin,071 PSAY nServ   Picture PesqPict("SD2","D2_TOTAL")				
			EndIF

				
			nLin := nLin + 1 // Avanca a linha de impressao
			
			nMercF  += nMerc
			nServF  += nServ
			nQtSegF += nQtSeg
			nVlSegF += nVlSeg
			nCarroF += nCarro
			nDevF   += nDev
				
				
		EndDo //fim da funcao
		
		If Empty(cFuncao)
			nMercT  += nMercF
			nServT  += nServF
			nQtSegT += nQtSegF
			nVlSegT += nVlSegF
			nCarroT += nCarroF
			nDevT   += nDevF
		EndIf
			
		nLin := nLin + 1
		@nLin,005 PSAY "Total da Funcao:"
		
		If Empty(cFuncao)
			@nLin,051 PSAY nMercF          Picture PesqPict("SD2","D2_TOTAL")
			@nLin,071 PSAY nServF         Picture PesqPict("SD2","D2_TOTAL")
			@nLin,091 PSAY nMercF+nServF  Picture PesqPict("SD2","D2_TOTAL")
			@nLin,111 PSAY nQtSegF        Picture '@E 99,999,999' // PesqPict("SD2","D2_QUANT")
			@nLin,131 PSAY nVlSegF        Picture PesqPict("SD2","D2_TOTAL")
			@nLin,151 PSAY nCarroF        Picture '@E 99,999,999' //PesqPict("SD2","D2_QUANT")
		ElseIf cFuncao == "2"
			@nLin,051 PSAY nMercF          Picture PesqPict("SD2","D2_TOTAL")
			@nLin,071 PSAY nServF         Picture PesqPict("SD2","D2_TOTAL")
			@nLin,091 PSAY nMercF+nServF  Picture PesqPict("SD2","D2_TOTAL")
		Else
			@nLin,071 PSAY nServF         Picture PesqPict("SD2","D2_TOTAL")		
		EndIF	
		nLin := nLin + 2
		
	EndDo //fim do tipo
	
	
	@nLin,000 PSAY "Total do Tipo de Venda:"
	@nLin,051 PSAY nMercT   Picture PesqPict("SD2","D2_TOTAL")
	@nLin,071 PSAY nServT   Picture PesqPict("SD2","D2_TOTAL")
	@nLin,091 PSAY nMercT+nServT   Picture PesqPict("SD2","D2_TOTAL")
	@nLin,111 PSAY nQtSegT  Picture '@E 99,999,999' //PesqPict("SD2","D2_QUANT")
	@nLin,131 PSAY nVlSegT  Picture PesqPict("SD2","D2_TOTAL")
	@nLin,151 PSAY nCarroT  Picture '@E 99,999,999' //PesqPict("SD2","D2_QUANT")
	nLin := nLin + 3

	
	
EndDo
dbCloseArea()
FErase(cArqTRB + ".DBF")
FErase(cArqTRB + OrdBagExt() )


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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Parse_TipoºAutor  ³ Stanko             º Data ³ 24/01/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Compoe a clausula IN da query                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³cVar - String com os valores a serem processados            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³cRet - String processsada                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Executado pela rotina principal                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Parse_Tipo(cVar)
Local cRet := ""
Local nXa := 0
Local cPref := "'"

If !Empty(cVar)
	For nXa := 1 to len(Alltrim(cVar))
		cRet += cPref + Substr(cVar,nXa,1)
		cPref := "','"
	Next nXa
	cRet += "'"
Else
	cRet := "'/'"
EndIf
Return(cRet)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³ Stanko             º Data ³ 24/01/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³Cria as perguntas do relatorio no SX1                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nao ha                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao ha                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Executado pela rotina principal                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

local j      := 0
local i      := 0
ssAlias      := Alias()
cPerg        := PADR(cPerg,len(sx1->x1_grupo))
aRegs        := {}

dbSelectArea("SX1")
dbSetOrder(1)

AADD(aRegs,{cPerg,"01","Tipo de Venda ?", "Tipo de Venda?","Tipo de Venda?","mv_ch1","C",05,0,0,"G","","mv_par01", "","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data de       ?", "Data  de     ?","Data      de ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Data ate      ?", "Data ate     ?","Data     ate ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Vendedor de   ?", "Vendedor de  ?","Vendedor de ?"  ,"mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","",""})
AADD(aRegs,{cPerg,"05","Vendedor ate  ?", "Vendedor ate ?","Vendedor ate?"  ,"mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","",""})

For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(ssAlias)

Return .T.