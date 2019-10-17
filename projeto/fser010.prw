#INCLUDE "FSER010.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³FSER010   º Autor ³ Ernani Forastieri  º Data ³  30/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relotios de erros de importacao de pacotes                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FSER010
Local   cDesc1      := STR0001 //"Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := STR0002 //"de acordo com os parametros informados pelo usuario."
Local   cDesc3      := STR0003 //"RELACAO DE ERROS NA IMPORTACAO DE PACOTES"
Local   cPict       := ""
Local   Imprime     := .T.
Local   aOrd        := {}
Private Titulo      := STR0003 //"RELACAO DE ERROS NA IMPORTACAO DE PACOTES"
Private Cabec1      := STR0004 //"Pct. Data      Hora      Campo      Ord. Chave                                                        Conteudo                                                     Validacao"
Private Cabec2      := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private Limite      := 220
Private Tamanho     := "G"
Private NomeProg    := "FSER010"
Private nTipo       := 18
Private aReturn     := { STR0005, 1, STR0006, 2, 1, 1, "", 1} //"Zebrado"###"Administracao"
Private nLastKey    := 0
Private cPerg       := "FER010"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private ContFl      := 01
Private m_Pag       := 01
Private WnRel       := "FSER010"

dbSelectArea("UA6")
dbSetOrder(1)

CriaSX1(cPerg)
Pergunte(cPerg, .F.)

WnRel := SetPrint("UA6", NomeProg, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F., aOrd, .F., Tamanho, , .T.)

If nLastKey == 27
	Return NIL
EndIf

SetDefault(aReturn, "UA6")

If nLastKey == 27
	Return NIL
EndIf

nTipo := If(aReturn[4]==1, 15, 18)

RptStatus({|| RunReport(Cabec1, Cabec2, Titulo) }, Titulo)

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Ernani Forastieri  º Data ³  30/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunReport(Cabec1, Cabec2, Titulo)
Local cArqAnt     := ""
Local cPacote     := ""
Local cEmpOrig    := ""
Local cEmpDest    := ""
Local lPrimVez    := .T.
Local cFilterUser := aReturn[7]

/*///////////////////////////////////////////////////////////////////////////
Lay Out                                                                                             1                                                                                                   2
0....:....1....:....2....:....3....:....4....:....5....:....6....:....7....:....8....:....9....:....0....:....1....:....2....:....3....:....4....:....5....:....6....:....7....:....8....:....9....:....0....:....1....:....2
-----------
Pct. Data      Hora      Campo      Ord. Chave                                                        Conteudo                                                     Validacao
-----------
Arquivo  1234567890123456789012345678  Tabela 123 123456789012345678901234567890  Origem  123456789012345/123456789012345  Destino  123456789012345/123456789012345
123  99/99/99  99:99:99  1234567890  12  123456789012345678901234567890123456789012345678901234567890 123456789012345678901234567890123456789012345678901234567890 123456789012345678901234567890123456789012345678901234567890

//////////////////////////////////////////////////////////////////////////*/

dbSelectArea("UA6")
dbSetOrder(1)
cIndex     := Criatrab(Nil, .F.)
cIndexKey  := IndexKey()
cFilter    := "UA6->UA6_FILIAL == xFilial('UA6') .and. UA6->UA6_ARQUIV >= mv_par01 .and. UA6->UA6_ARQUIV <= mv_par02"
cFilter    += " .and. SubStr(UA6->UA6_ARQUIV, 1, 3) >= mv_par03 .and. SubStr(UA6->UA6_ARQUIV, 1, 3) <= mv_par04"
cFilter    += " .and. SubStr(UA6->UA6_ARQUIV,12, 3) >= mv_par05 .and. SubStr(UA6->UA6_ARQUIV,12, 3) <= mv_par06"
cFilter    += " .and. SubStr(UA6->UA6_ARQUIV, 4, 4) >= (mv_par07+mv_par09) .and. SubStr(UA6->UA6_ARQUIV, 4, 4) <= (mv_par08+mv_par10)"
cFilter    += " .and. SubStr(UA6->UA6_ARQUIV,10, 4) >= (mv_par11+mv_par13) .and. SubStr(UA6->UA6_ARQUIV, 4, 4) <= (mv_par12+mv_par14)"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Considera filtro do usuario                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cFilterUser)
	cFilter    += " .and. ("+cFilterUser+")"
Endif

IndRegua("UA6", cIndex , cIndexKey, , cFilter, STR0007) //"Aguarde selecionando registros...."
nIndex := RetIndex("UA6")
#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)

dbGoTop()

SetRegua(RecCount())
SetPrc(80,0)

While !UA6->(Eof()) .and. !lAbortPrint
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSay para saida na impressora. Por exemplo:
	
	cArqAnt  := UA6->UA6_ARQUIV
	cPacote  := SubStr(cArqAnt, 1, 3)
	cTabela  := SubStr(cArqAnt,12, 3)
	cEmpOrig := SubStr(cArqAnt, 4, 4)
	cEmpDest := SubStr(cArqAnt, 8, 4)
	
	lPrimVez := .T.
	
	CabecEsp(cPacote, cTabela, cEmpOrig, cEmpDest)
	
	While !UA6->(Eof()) .and. !lAbortPrint .and. cArqAnt == UA6->UA6_ARQUIV
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Trata Filtro do Usuario                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@PRow(), 00 PSay cCancel
			Exit
		EndIf
		
		If PRow() > 55
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		EndIf
		
		@PRow()+1,0 PSay ""
		@PRow(),000 Psay SubStr(cArqAnt, 1, 3)
		@PRow(),005 Psay UA6->UA6_DTGER
		@PRow(),015 Psay UA6->UA6_HRGER
		@PRow(),025 Psay UA6->UA6_CAMPO
		@PRow(),037 Psay Transform(UA6->UA6_ORDEM,"99")
		@PRow(),041 Psay SubStr(UA6->UA6_CHAVE , 1, 60)
		@PRow(),102 Psay SubStr(UA6->UA6_CONTED, 1, 60)
		@PRow(),163 Psay SubStr(UA6->UA6_VALID , 1, 60)
		
		dbSelectArea("UA6")
		UA6->(dbSkip())
	End
	
	@PRow()+1, 00 PSay __PrtThinLine()
	
End

dbSelectArea("UA6")
dbSetOrder(1)
FErase(cIndex)

Set Device To Screen

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	Set Printer To
	OurSpool(WnRel)
EndIf

MS_Flush()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ CRIASX1  º Autor ³ Ernani Forastieri  º Data ³  30/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Criacao das perguntas                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSX1(cPerg)

PutSx1(cPerg,"01","Do Arquivo            ?","Do Arquivo            ?","Do Arquivo            ?","mv_ch1","C",28,0,0,"G","",   "","","","mv_par01")
PutSx1(cPerg,"02","Ate o Arquivo         ?","Ate o Arquivo         ?","Ate o Arquivo         ?","mv_ch2","C",28,0,0,"G","",   "","","","mv_par02",,,,Replicate("Z",28))
PutSx1(cPerg,"03","Do Pacote             ?","Do Pacote             ?","Do Pacote             ?","mv_ch3","C", 3,0,0,"G","",   "","","","mv_par03")
PutSx1(cPerg,"04","Ate a Pacote          ?","Ate a Pacote          ?","Ate a Pacote          ?","mv_ch4","C", 3,0,0,"G","",   "","","","mv_par04",,,,"ZZZ")
PutSx1(cPerg,"05","Da Tabela             ?","Da Tabela             ?","Da Tabela             ?","mv_ch5","C", 3,0,0,"G","","TAB","","","mv_par05")
PutSx1(cPerg,"06","Ate a Tabela          ?","Ate a Tabela          ?","Ate a Tabela          ?","mv_ch6","C", 3,0,0,"G","","TAB","","","mv_par06",,,,"ZZZ")
PutSx1(cPerg,"07","Da Empresa Origem     ?","Da Empresa Origem     ?","Da Empresa Origem     ?","mv_ch7","C", 2,0,0,"G","",   "","","","mv_par07")
PutSx1(cPerg,"08","Ate a Empresa Origem  ?","Ate a Empresa Origem  ?","Ate a Empresa Origem  ?","mv_ch8","C", 2,0,0,"G","",   "","","","mv_par08",,,,"ZZ")
PutSx1(cPerg,"09","Da Filial Origem      ?","Da Filial Origem      ?","Da Filial Origem      ?","mv_ch9","C", 2,0,0,"G","","SM0","","","mv_par09")
PutSx1(cPerg,"10","Ate a Filial Origem   ?","Ate a Filial Origem   ?","Ate a Filial Origem   ?","mv_chA","C", 2,0,0,"G","","SM0","","","mv_par10",,,,"ZZ")
PutSx1(cPerg,"11","Da Empresa Destino    ?","Da Empresa Destino    ?","Da Empresa Destino    ?","mv_chB","C", 2,0,0,"G","",   "","","","mv_par11")
PutSx1(cPerg,"12","Ate a Empresa Destino ?","Ate a Empresa Destino ?","Ate a Empresa Destino ?","mv_chC","C", 2,0,0,"G","",   "","","","mv_par12",,,,"ZZ")
PutSx1(cPerg,"13","Da Filial Destino     ?","Da Filial Destino     ?","Da Filial Destino     ?","mv_chD","C", 2,0,0,"G","","SM0","","","mv_par13")
PutSx1(cPerg,"14","Ate a Filial Destino  ?","Ate a Filial Destino  ?","Ate a Filial Destino  ?","mv_chE","C", 2,0,0,"G","","SM0","","","mv_par14",,,,"ZZ")

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ CABECESP º Autor ³ Ernani Forastieri  º Data ³  30/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao de cabecalho especifico                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CabecEsp(cPacote, cTabela, cEmpOrig, cEmpDest)
Local Area       := GetArea()
Local AreaSM0    := SM0->(GetArea())
Local cEmpFilOri := ""
Local cEmpFilDes := ""

dbSelectArea("SM0")
dbSeek(cEmpOrig)
cEmpFilOri := AllTrim(SM0->M0_NOME)+" / "+AllTrim(SM0->M0_FILIAL)

dbSelectArea("SM0")
dbSeek(cEmpDest)
cEmpFilDes := AllTrim(SM0->M0_NOME)+" / "+AllTrim(SM0->M0_FILIAL)

If PRow() > 55
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
EndIf

@PRow()+1,0 PSay ""         
@PRow(),000 PSay STR0008 + UA6->UA6_ARQUIV //"ARQUIVO  "
@PRow(),039 PSay STR0009 + cTabela+" "+u_InfoSX2(cTabela,3) //"TABELA  "
@PRow(),082 PSay STR0010 + cEmpFilOri      //"ORIGEM  "
@PRow(),123 PSay STR0011 + cEmpFilDest     //"DESTINO  "
@PRow()+1,0 PSay ""

RestArea(AreaSM0)
RestArea(Area   )

Return NIL

/////////////////////////////////////////////////////////////////////////////