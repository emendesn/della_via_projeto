#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidCnpj �Autor  �Microsiga           � Data �  05/09/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ValidCnpj()
Local aCodCli := {}
Local cNomArqA := CriaTrab("",.F.)
Local cIndTrb := "TRB->CODORI+TRB->LOJAORI"
Local nProc   := 0
Local nProc2  := 0

Local aCampos := {}

AADD(aCampos,{"CODORI"   ,"C",06,0})
AADD(aCampos,{"LOJAORI"  ,"C",02,0})
AADD(aCampos,{"CODGER"   ,"C",06,0})
AADD(aCampos,{"LOJAGER"  ,"C",02,0})

cNomArqA:=CriaTrab(aCampos,.T.)
DbUseArea(.T.,,cNomArqA,"TRB",.F.,.F. )
DbSelectArea("TRB")
IndRegua("TRB",cNomArqA,cIndTrb,,,"Criando Trabalho")


DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbGoTop())

While !SA1->(EOF())
	
	ProcRegua(1000)
	
	nProc  := 0
	nProc2 := 0
	
	IncProc("Registros processados "+Alltrim(Str(nProc2)))
	nProc ++
	nProc2 ++
	If nProc > 1000
		ProcRegua(1000)
		nProc := 0
	Endif
	aCodCli := P_CNPJCPF(SA1->A1_CGC,"XX")
	
	__cCODCLI	:= aCodCli[1]
	__cLOJA		:= aCodCli[2]
	
	If SA1->(A1_COD+A1_LOJA) == __cCODCLI+__cLOJA
		DbSelectArea("SA1")
		RecLock("TRB",.T.)
		TRB->CODORI		:= SA1->A1_COD
		TRB->LOJAORI	:= SA1->A1_LOJA
		TRB->CODGER		:= __cCODCLI
		TRB->LOJAGER	:= __cLOJA
		MsUnlock()
	EndIf
	SA1->(DbSkip())
EndDo

U_PrintDiverg()

Return




/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO8     � Autor � AP6 IDE            � Data �  29/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PrintDiverg()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Divrgencia de Codigos de Cliente"
Local cPict          := ""
Local titulo       := "Divrgencia de Codigos de Cliente"
Local nLin         := 80

Local Cabec1       := "Cod.Original   Loja   Cod.Gerado   Loja Gerado"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "CODORI"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "TRB"

dbSelectArea("TRB")
dbSetOrder(1)


pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  29/08/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())
dbGoTop()
While !EOF()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

    @nLin,00 PSAY TRB->CODORI + "   "+ TRB->LOJAORI + "   " + TRB->CODGER + "   " + TRB->LOJAGER

   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
