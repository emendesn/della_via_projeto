#include "rwmake.ch"
User Function AjOrdem

Local _aArea  := GetArea()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Emissao Pedidos nao faturados com OP encerrada "
Local cPict          := ""
Local titulo         := "Emissao Pedidos nao faturados com OP encerrada "
Local cPerg          := "FATR02"
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "AJORDEM"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "AJORDEM"

Pergunte(cPerg,.F.)               // Pergunta no SX1

Private cString := "SC6"

dbSelectArea("SC6")
dbSetOrder(1)


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Monta a interface padrao com o usuario...                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

RptStatus({||RunReport()})
Return


Static Function RunReport

Local nOrdem
Local nLin := 1
Local _aPedido := {}

dbSelectArea(cString)
dbGotop()


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetRegua(RecCount())


@ nLin,000 PSAY chr(255)+Chr(15)                // Compressao de Impressao
	
While !Eof() .and. xFilial("SC6") == SC6->C6_FILIAL
	IF Empty(SC6->C6_NOTA) .and. Alltrim(SC6->C6_UM) != "HR"	
		SC2->(dbSetOrder(1))
		dbSeek(xFilial("SC2")+SC6->C6_NUMOP+SC6->C6_ITEM+"001")
		
		SD4->(dbSetOrder(2))
		dbSeek(xFiliaL("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)		
		
		While !Eof() .and. xFilial("SD4") == SD4->D4_FILIAL .and. SD4->D4_OP == SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
			IF !Empty(SD4->D4_COD) 
				SB1->(dbSetOrder(1))			
				SB1->(dbSeek(xFilial()+SD4->D4_COD))
				IF Alltrim(SB1->B1_GRUPO) $ "CI/SC"
					aAdd(_aPedido,SC6->C6_NUM,SD4->D4_COD)
				EndIF
			Else
				SB1->(dbSetOrder(1))			
				SB1->(dbSeek(xFilial()+SD4->D4_PRODUTO))
				IF Alltrim(SB1->B1_GRUPO) $ "CI/SC"
					aAdd(_aPedido,SC6->C6_NUM,SD4->D4_PRODUTO)
				EndIF
			EndIF
			dbSelectArea("SD4")
			dbSkip()
		EndDo	
	EndIF
	dbSelectArea("SC6")
	dbSkip()
EndDo

For _i := 1 To Len(_aPedido)
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
				
	@ nLin,028 PSAY _aPedido[_i,1]
	@ nLin,110 PSAY _aPedido[_i,2]
	nLin:= nLin + 1
	IF nLin > 80
		SetPrc(0,0) // (Zera o Formulario)
		nLin:=5
	EndIF
Next i

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Finaliza a execucao do relatorio...                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SET DEVICE TO SCREEN

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Se impressao em disco, chama o gerenciador de impressao...          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

