#include "rwmake.ch"
#include "topconn.ch"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммммкмммммммямммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁcompC6D7     ╨Autor  Ё Jairo Oliveira  ╨ Data Ё  19/07/05   ╨╠╠
╠╠лммммммммммьмммммммммммммймммммммомммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁCompara o SC6 com o SD7 para os casos que C6_NUMOP esta     ╨╠╠
╠╠╨          Ёvazio.                                                      ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Durapol                                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function ImpC6xD7()
Local _aArea  := GetArea()
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Local cPerg          := ""
/*
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de Itens de Pedido de Venda sem Relacionamente com  "
Local cDesc3         := "o Empenhado.                                        "
Local cPict          := ""
Local titulo         := "Itens de Pedido de Venda Sem Empenho"

Local Cabec1         := " " // "xxxxxx   xx   xxxxxxxxxxxxxx  "
Local Cabec2         := "Numero  Item  Produto         "
Local imprime        := .T.
Local aOrd := {}
*/
cDesc1         := "Este programa tem como objetivo imprimir relatorio "
cDesc2         := "de Itens de Pedido de Venda sem Empenho "
cDesc3         := "Itens de Pedido de Venda Sem Empenhado"
cPict          := ""
titulo         := "Itens de Pedido de Venda Sem Empenhado"

Cabec2         := " " // "xxxxxx   xx   xxxxxxxxxxxxxx  "
Cabec1         := "Numero  Item  Produto         "
imprime        := .T.
aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "EstFun"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "EstFun"

//Pergunte(cPerg,.F.)               // Pergunta no SX1

Private cString := "SC6"

dbSelectArea("SC6")
dbSetOrder(1)


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta a interface padrao com o usuario...                           Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processamento. RPTSTATUS monta janela com a regua de processamento. Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

RptStatus({||RunReport()})
Return


Static Function RunReport

Local nOrdem
Local nLin := 60
Local _aPedido := {}

dbSelectArea(cString)
dbGotop()


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё SETREGUA -> Indica quantos registros serao processados para a regua Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SetRegua(RecCount())

IF Select("C6TMP") > 0
	dbSelectArea("C6TMP")
	dbCloseArea()
EndIF
_cQry:= "SELECT * "
_cQry+= " FROM " + RetSqlName("SC6") + " SC6 "
_cQry+= " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND "
_cQry+= " (C6_NUMOP = '      ' OR C6_NUM <> C6_NUMOP) AND "
_cQry+= " D_E_L_E_T_ = ' '"

_cQry := ChangeQuery(_cQry)

dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQry), 'C6TMP', .F., .T.)
dbGotop()

@ nLin,000 PSAY chr(255)+Chr(15)                // Compressao de Impressao
	
While !Eof() 
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
				
	@ nLin,001 PSAY C6TMP->C6_NUM
	@ nLin,010 PSAY C6TMP->C6_ITEM
	@ nLin,015 PSAY C6TMP->C6_PRODUTO
	nLin:= nLin + 1
	IF nLin > 55
	    // SetPrc(0,0) // (Zera o Formulario)
	    Cabec(Titulo,Cabec1,cabec2,NomeProg,Tamanho,nTipo)
		nLin:=8
	EndIF
	
	dbSelectArea("C6TMP")
	dbSkip()
EndDo

IF Select("C6TMP") > 0
	dbSelectArea("C6TMP")
	dbCloseArea()
EndIF

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Finaliza a execucao do relatorio...                                 Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SET DEVICE TO SCREEN

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Se impressao em disco, chama o gerenciador de impressao...          Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return