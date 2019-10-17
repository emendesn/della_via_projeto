#include "rwmake.ch"
#include "topconn.ch"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммммкмммммммямммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁDFATR03      ╨Autor  Ё Jairo Oliveira  ╨ Data Ё  02/08/05   ╨╠╠
╠╠лммммммммммьмммммммммммммймммммммомммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     Ё Imprime os itens sem OP correspondente no SC2              ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Durapol                                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function DFATR03()
Local _aArea  := GetArea()
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Local cPerg          := ""
cDesc1         := "Este programa tem como objetivo imprimir relatorio "
cDesc2         := "de Itens sem OP "
cDesc3         := ""
cPict          := ""
titulo         := "Itens de P.Venda Repetidos"

Cabec2         := " " // "xxxxxx   xx   xxxxxxxxxxxxxx  "
Cabec1         := " NUM.PV NUM.OP IT  DT.PED      PRODUTO"
imprime        := .T.
aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "DFATR03"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "DFATR03"

//Pergunte(cPerg,.F.)               // Pergunta no SX1

Private cString := "SC6"

dbSelectArea("SC6")
dbSetOrder(1)


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta a interface padrao com o usuario...                           Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
Local nLin := 80
Local _aPedido := {}

dbSelectArea(cString)
dbGotop()


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё SETREGUA -> Indica quantos registros serao processados para a regua Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SetRegua(RecCount())

DbSelectArea("SC6")
IF Select("C6TMP") > 0
	dbSelectArea("C6TMP")
	dbCloseArea()
EndIF
_cQry:= "SELECT SC6.*, SC5.* "
_cQry+= " FROM " + RetSqlName("SC6") + " SC6 ," + RetSqlName("SC5") + " SC5 "
_cQry+= " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND "
_cQry+= " C6_NOTA = '     ' AND "
_cQry+= " C6_NUMOP <> '      ' AND "
_cQry+= " SC6.D_E_L_E_T_ = ' ' AND "
_cQry+= " C5_FILIAL = C6_FILIAL AND "
_cQry+= " C5_NUM = C6_NUM AND "
_cQry+= "  (SELECT COUNT(*) FROM " + RETSQLNAME("SC2") + " SC2 "
_cQry+= "  WHERE C2_FILIAL = C6_FILIAL AND "
_cQry+= "  C2_NUM = C6_NUMOP AND "
_cQry+= "  C2_ITEM = C6_ITEMOP AND "
_cQry+= "  SC2.D_E_L_E_T_ = ' ') = 0"
_cQry+= " ORDER BY C5_EMISSAO,C5_NUM"
//_cQry+= " HAVING COUNT(*) > 1"

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
	@ nLin,008 PSAY C6TMP->C6_NUMOP
    @ nLin,015 PSAY C6TMP->C6_ITEMOP
    @ nLin,019 PSAY SUBSTR(C6TMP->C5_EMISSAO,7,2)+"/"+SUBSTR(C6TMP->C5_EMISSAO,5,2)+"/"+SUBSTR(C6TMP->C5_EMISSAO,3,2)
	@ nLin,031 PSAY C6TMP->C6_PRODUTO
	//@ nLIN,060 PSAY C6TMP->C5_EMISSAO
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