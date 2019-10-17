#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DESTR10     º Autor ³ Microsiga        º Data ³  27/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio PNEUS ESTOQUE FINAL                              º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION DESTR10

LOCAL cDesc1         := "Este programa tem como objetivo imprimir relatorio "
LOCAL cDesc2         := "de acordo com os parametros informados pelo usuario."
LOCAL cDesc3         := "Movimentação de pneus"
LOCAL cPict          := ""
LOCAL titulo         := "Movimentação de pneus"
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
PRIVATE nomeprog     := "DESTR10"
PRIVATE nTipo        := 15
PRIVATE aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
PRIVATE nLastKey     := 0
PRIVATE cPerg        := "ESTR10"
PRIVATE cbtxt        := Space(10)
PRIVATE cbcont       := 00
PRIVATE CONTFL       := 01
PRIVATE m_pag        := 01
PRIVATE wnrel        := "DESTR10"
PRIVATE cString      := "SC2"

dbSelectArea("SC2")
dbSetOrder(1)

// mv_par01 Lista Por ? Emissao/Previsao/Producao Real
// mv_par02 Da Data ?
// mv_par03 Ate Data ?
// mv_par04 Do Cliente ?
// mv_par05 Ate Cliente ?

AAdd(aPergunta,{cPerg,"01","Lista Por?"          ,"Lista Por"      ,"Lista Por"      ,"mv_ch1","N", 1,0,0,"C","","mv_par01","Emissao",""   ,""   ,"","","Previsao","","","","","Producao Real","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"02","Da  Data ?"          ,"Da  Data"       ,"Da  Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"03","Ate Data ?"          ,"Ate Data"       ,"Ate Data"       ,"mv_ch3","D", 8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"04","Do  Cliente?"        ,"Do Cliente"     ,"Da  Cliente"    ,"mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CLI"})
AAdd(aPergunta,{cPerg,"05","Ate Cliente?"        ,"Ate Cliente"    ,"Ate Cliente"    ,"mv_ch5","C", 6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CLI"})
AAdd(aPergunta,{cPerg,"06","Da Carcac/Medida?"   ,""                ,""              ,"mv_ch6","C", 15,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
AAdd(aPergunta,{cPerg,"07","Ate Carcac/Medida?"  ,""                ,""              ,"mv_ch7","C", 15,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})


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

LOCAL aArqTrab := {}
LOCAL cArqTrab := ''
LOCAL cIndTrab := ''
LOCAL nTotGerProduzido := 0, nTotGerRecusado := 0, nTotCliProduzido := 0, nTotCliRecusado := 0
LOCAL cQuerySC2 := '', cQueryDt := ''
LOCAL cServico  := ''

Cabec1 := 'Cliente                                  Entrada  Previsao Producao Coleta         Ficha OP  Medida                          Serie      Fogo        Qtd.Prod Qtd.Recus'
Cabec2 := ''

If Select("TRB") > 0 
   dbCloseArea("TRB")
EndIf   

If Select("TRBSC2") > 0 
   dbCloseArea("TRBSC2")
EndIf   

/*
Entrada  Previsao Producao Coleta Servico Ficha OP  Medida          Marca           Serie      Fogo        Qtd.Prod Qtd.Recus
99/99/99 99/99/99 99/99/99 999999 9999999 999999-99 999999999999999 999999999999999 9999999999 9999999999     99999     99999
*/

//-- CRIA ARQUIVO DE TRABALHO PARA PROCESSAMENTO DA LEITURA DE ITENS NOTAS FISCAIS
AAdd(aArqTrab,{"CLIENTE","C",40,0}) // CLIENTE
AAdd(aArqTrab,{"EMISSAO","D",8,0}) // Data de Entrada (Dt.Nf Entrada ou Dt.OP)
AAdd(aArqTrab,{"PREVISAO","D",8,0}) // Data Previsao Inicio
AAdd(aArqTrab,{"PRODUCAO","D",8,0}) // Data Producao Real
AAdd(aArqTrab,{"COLETA","C",6,0}) // Numero da Nota Fiscal Entrada
AAdd(aArqTrab,{"SERVICO","C",5,0}) // Codigo do Servico Original (ex.recapagem)
AAdd(aArqTrab,{"FICHAOP" ,"C",8,0}) // Numero e Item da OP
AAdd(aArqTrab,{"MEDIDA","C",15,0}) // Codigo do Produto da OP (Carcaca)
AAdd(aArqTrab,{"MARCA","C",15,0}) // Marca do Pneu
AAdd(aArqTrab,{"SERIE","C",10,0}) // Acumulado do Custo
AAdd(aArqTrab,{"FOGO","C",10,0}) // Acumulado da Margem
AAdd(aArqTrab,{"QTDPROD","N",6,0}) // Margem Contribuicao
AAdd(aArqTrab,{"QTDRECU","N",6,0})  // Quantidade Pneus

cArqTrab := CriaTrab(aArqTrab,.T.)
dbUseArea(.t.,,cArqTrab,"TRB")

cIndTrab := 'CLIENTE'
If Mv_Par01 == 1
	Titulo   := AllTrim(Titulo) + " Por Emissao de " + DtoC(Mv_Par02) + " a " + DtoC(Mv_Par03)
	cIndTrab := cIndTrab + "+DTOS(EMISSAO)"
	cQueryDt := "and C2_EMISSAO >= '" + DtoS(mv_par02) + "' and C2_EMISSAO <= '" + DtoS(mv_par03) + "' "
ElseIf Mv_Par01 == 2
	Titulo   := AllTrim(Titulo) + " Por Previsao de " + DtoC(Mv_Par02) + " a " + DtoC(Mv_Par03)
	cIndTrab := cIndTrab + "+DTOS(PREVISAO)"
	cQueryDt := "and C2_DATPRI >= '" + DtoS(mv_par02) + "' and C2_DATPRI <= '" + DtoS(mv_par03) + "' "
ElseIf Mv_Par01 == 3
	Titulo   := AllTrim(Titulo) + " Por Producao Real de " + DtoC(Mv_Par02) + " a " + DtoC(Mv_Par03)
	cIndTrab := cIndTrab + "+DTOS(PRODUCAO)"
	cQueryDt := "and C2_DATRF >= '" + DtoS(mv_par02) + "' and C2_DATRF <= '" + DtoS(mv_par03) + "' "
EndIf

dbSelectArea("TRB")
IndRegua("TRB",cArqTrab,cIndTrab,,,"Criando Arquivo de Trabalho...")

//-------------------
//-- MONTA QUERY PARA TRAZER APENAS AS NOTAS FISCAIS CABECALHO DO MES PROCESSADO NOS PARAMETROS
//-- FAZ ISTO, POIS PRECISA BUSCAR AS NCC´S A PARTIR DO CABECALHO DAS NOTAS E NAO A PARTIR DOS ITENS DA NOTA
cQuerySC2 := "SELECT C2_NUM ,C2_ITEM, C2_SERIEPN, C2_NUMFOGO, C2_EMISSAO, C2_DATRF, C2_DATPRF,C2_DATPRI, C2_MARCAPN, C2_PRODUTO, C2_QUANT, C2_PERDA FROM " + RetSqlName("SC2") + " SC2"
cQuerySC2 += " where SC2.D_E_L_E_T_ = ' ' "
cQuerySC2 += " and C2_FILIAL = '" + xFilial("SC2") + "' "
cQuerySC2 += " and C2_PRODUTO >= '" + mv_par06 + "' and C2_PRODUTO <= '" + mv_par07 + "' "
cQuerySC2 += " and C2_DATRF <> '' "
cQuerySC2 += cQueryDt
cQuerySC2 := ChangeQuery(cQuerySC2)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuerySC2),"TRBSC2",.F.,.T.)
TcSetField("TRBSC2", "C2_EMISSAO", "D")
TcSetField("TRBSC2", "C2_DATRF"  , "D")
TcSetField("TRBSC2", "C2_DATPRI" , "D")
TcSetField("TRBSC2", "C2_DATPRF" , "D")
//-------------------

SD1->( dbSetOrder(2) ) // PRODUTO + NOTAFISCAL
SB1->( dbSetOrder(1) )

dbSelectArea("TRBSC2")
dbGotop()
SetRegua(RecCount())

While !EOF()
	
	IncRegua()
	
	If ! ( SF1->( dbSeek(xFilial("SF1") + TRBSC2->C2_NUM,.F.) ) .Or. SF1->F1_TIPO != 'B' )
		TRBSC2->( dbSkip() )
		Loop
	EndIf
	
	SA1->( dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,.F.) )
	
	If SA1->A1_COD < Mv_Par04 .Or. SA1->A1_COD > Mv_Par05
		TRBSC2->( dbSkip() )
		Loop
	EndIf

	SB1->( dbSeek(xFilial("SB1") + SC2->C2_PRODUTO,.F.) )                              
	
	cServico := ''
	dbSelectArea("SD1")
	dbSeek( xFilial("SD1")+TRBSC2->C2_PRODUTO+TRBSC2->C2_NUM,.F.) 
	While !Eof() .And. xFilial("SD1") == SD1->D1_FILIAL .And. SD1->D1_COD+SD1->D1_DOC == TRBSC2->C2_PRODUTO+TRBSC2->C2_NUM
		If SD1->D1_ITEM == TRBSC2->C2_ITEM
			cServico := SD1->D1_SERVICO
			Exit
		EnDif
		SD1->( dbSkip() )
	EndDo
	
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
		TRB->CLIENTE  := SA1->A1_NOME
		TRB->EMISSAO  := TRBSC2->C2_EMISSAO
		//TRB->PREVISAO := TRBSC2->C2_DATPRI
		TRB->PREVISAO := TRBSC2->C2_DATPRF
		TRB->PRODUCAO := TRBSC2->C2_DATRF
		TRB->COLETA   := SF1->F1_DOC
		TRB->SERVICO  := cServico
		TRB->FICHAOP  := TRBSC2->C2_NUM+TRBSC2->C2_ITEM
		TRB->MEDIDA   := TRBSC2->C2_PRODUTO
		TRB->MARCA    := TRBSC2->C2_MARCAPN
		TRB->SERIE    := TRBSC2->C2_SERIEPN
		TRB->FOGO     := TRBSC2->C2_NUMFOGO
		TRB->QTDPROD  := TRBSC2->C2_QUANT
		TRB->QTDRECU  := TRBSC2->C2_PERDA
	MsUnlock()
	
	dbSelectArea("TRBSC2")
	TRBSC2->( dbSkip() )
	
EndDo

//-- IMPRIME O ARQUIVO DE TRABALHO
dbSelectArea("TRB")
dbGotop()
SetRegua( RecCount() )

While !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin += 2
	Endif
	
	@nLin, 000 PSAY Substr(TRB->CLIENTE,1,40)
	cQuebraCliente := TRB->CLIENTE
	
	While !Eof() .And. TRB->CLIENTE == cQuebraCliente
/*
Cliente                                  Entrada  Previsao Producao Coleta Servico Ficha OP  Medida          Marca           Serie      Fogo        Qtd.Prod Qtd.Recus
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99/99/99 99/99/99 99/99/99 999999 9999999 999999-99 999999999999999 999999999999999 9999999999 9999999999    999999    999999
0                                        41       50       59       68     75      83        93              109             125        136           150       160
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16       
*/
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@nLin,041 PSAY TRB->EMISSAO
		@nLin,050 PSAY TRB->PREVISAO
		@nLin,059 PSAY TRB->PRODUCAO
		@nLin,068 PSAY TRB->COLETA
		//@nLin,075 PSAY TRB->SERVICO
		@nLin,083 PSAY Substr(TRB->FICHAOP,1,6)+'-'+Substr(TRB->FICHAOP,7,2)
		@nLin,093 PSAY TRB->MEDIDA
		//@nLin,109 PSAY TRB->MARCA
		@nLin,125 PSAY TRB->SERIE
		@nLin,136 PSAY TRB->FOGO		
		@nLin,150 PSAY IIF(TRB->QTDRECU = 0,TRB->QTDPROD,0) PICTURE "999999"
		@nLin,160 PSAY TRB->QTDRECU PICTURE "999999"

		nTotCliProduzido:= nTotCliProduzido + TRB->QTDPROD
		nTotCliRecusado := nTotCliRecusado  + TRB->QTDRECU

        nLin++
		
		TRB->( dbSkip() )
		
	EndDo

	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@nLin,000 PSAY "Total"
	@nLin,150 PSAY nTotCliProduzido PICTURE "999999"
	@nLin,160 PSAY nTotCliRecusado  PICTURE "999999"
	
	nLin+=2
	cQuebraCliente  := ''      
	nTotGerProduzido:= nTotGerProduzido + nTotCliProduzido
	nTotGerRecusado := nTotGerRecusado  + nTotCliRecusado	
	nTotCliProduzido:= 0
	nTotCliRecusado := 0
	
EndDo

nLin++

If nLin > 55
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

@nLin,000 PSAY Replicate("-",166)

nLin++

@nLin,000 PSAY "Total Geral....:"  
@nLin,150 PSAY nTotGerProduzido PICTURE "999999"
@nLin,160 PSAY nTotGerRecusado  PICTURE "999999"

dbSelectArea("TRB")
dbCloseArea("TRB")
FErase(cArqTRAB+OrdBagExt())

dbSelectArea("TRBSC2")
dbCloseArea("TRBSC2")

dbSelectArea("SC2")
dbSetOrder(1)

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return