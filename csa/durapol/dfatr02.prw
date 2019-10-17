#include "rwmake.ch"
#include "topconn.ch"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммммкмммммммямммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁDFATR02      ╨Autor  Ё Jairo Oliveira  ╨ Data Ё  02/08/05   ╨╠╠
╠╠лммммммммммьмммммммммммммймммммммомммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     Ё Imprime os itens de Mao de Obra que estao repedidos no SC6 ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Durapol                                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function DFATR02()
Local _aArea  := GetArea()
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Local cPerg          := ""
cDesc1         := "Este programa tem como objetivo imprimir relatorio "
cDesc2         := "de Itens Mao de Obra Repetidos no Pedido de Vendas  "
cDesc3         := ""
cPict          := ""
titulo         := "Itens de P.Venda Repetidos"

Cabec2         := " " // "xxxxxx   xx   xxxxxxxxxxxxxx  "
Cabec1         := "PEDIDO DT.EMIS.   CLIENTE  QT.EMP.  QT.PED PROD.           TP"
imprime        := .T.
aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "DFATR02"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "DFATR02"

//Pergunte(cPerg,.F.)               // Pergunta no SX1

Private cString := "SC5"

dbSelectArea("SC5")
dbSetOrder(2)


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

DbSelectArea("SC5")
dbGotop()

@ nLin,000 PSAY chr(255)+Chr(15)                // Compressao de Impressao
	
While !Eof() 
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	IF Select("D4TMP") > 0
		dbSelectArea("D4TMP")
		dbCloseArea()
	EndIF
	_cQry:= "SELECT COUNT(*) AS TOTREG,SD4.D4_PRODUTO "
	_cQry+= " FROM " + RetSqlName("SD4") + " SD4 "
	_cQry+= " WHERE D4_FILIAL = '" + xFilial("SD4") + "' AND "
	_cQry+= " SUBSTR(SD4.D4_OP,1,6) = '" + SC5->C5_NUM + "' AND "
	_CQRY+= " D4_PRODUTO <> '               ' AND "
	_cQry+= " SD4.D_E_L_E_T_ = ' ' "
	_cQry+= " GROUP BY SD4.D4_PRODUTO "
	//_cQry+= " HAVING COUNT(*) > 1"
	
	_cQry := ChangeQuery(_cQry)
	dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQry), 'D4TMP', .F., .T.)	
	DbGotop()
	if EOF()
	   DbSelectArea("SC5")
	   DbSkip()
	   Loop
	End
	
	While D4TMP->(!EOF())			
	    DbSelectArea("SB1")
	    DbSetOrder(1)
	    DBSEEK(XFILIAL("SB1")+D4TMP->D4_PRODUTO) 
	    DBSELECTAREA("D4TMP")
	    IF EOF() .OR. SB1->B1_TIPO <> "MO"
	       DbSelectArea("D4TMP")
	       DBSKIP()
	       LOOP
	    END
	    DbSelectArea("SC6")
	    DbSetOrder(1)
	    _nQtde := 0  
		DBSeek(SC5->C5_FILIAL+SC5->C5_NUM)
		While !EOF() .And. SC6->C6_FILIAL = SC5->C5_FILIAL .And. SC6->C6_NUM = SC5->C5_NUM
			IF !EMPTY(SC6->C6_NOTA)
			   DbSkip()
			   LOOP
			ENDIF
			
			If SC6->C6_PRODUTO = D4TMP->D4_PRODUTO
				_nQtde += 1
			End
			SC6->(dbskip())
		EndDo
	    
		DbSelectArea("D4TMP")
		// if _nQtde = D4TMP->TOTREG // PARA CONFERENCIA MAIS CRITICA
		if _nQtde <= D4TMP->TOTREG
			DBSKIP()
			LOOP
		END
//"PEDIDO DT.EMIS.   CLIENTE  QT.EMP.  QT.PED PROD.           TP"
		@ nLin,001 PSAY SC5->C5_NUM    
		@ nLin,008 PSAY SC5->C5_EMISSAO
		@ nLin,019 PSAY SC5->C5_CLIENTE		
		@ nLin,026 PSAY D4TMP->TOTREG PICTURE "@E 999,999"
		@ nLin,035 PSAY _nQtde PICTURE "@E 999,999"
		@ nLin,043 PSAY D4TMP->D4_PRODUTO
		@ nLin,060 PSAY SB1->B1_TIPO + " " + SB1->B1_COD
		nLin:= nLin + 1
		IF nLin > 55
		    // SetPrc(0,0) // (Zera o Formulario)
		    Cabec(Titulo,Cabec1,cabec2,NomeProg,Tamanho,nTipo)
			nLin:=8
		EndIF
		DBSKIP()
	END
	
	dbSelectArea("SC5")
	dbSkip()
EndDo

IF Select("D4TMP") > 0
	dbSelectArea("D4TMP")
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