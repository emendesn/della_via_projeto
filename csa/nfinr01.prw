#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFinr01   � Autor � Reinaldo Caldas    � Data �  26/07/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Emissao de duplicatas                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � NC Games                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Nfinr01


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Emissao de duplicatas NC Games"
Local cPict          := ""
Local titulo       := "Emissao de duplicatas NC Games"
Local nLin         := 7
Local cPerg        :="FINR01"
Local Cabec1       := "Este programa ira emitir duplicatas conforme"
Local Cabec2       := "os parametros selecionados"
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "NFinr01"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NFinr01"

Pergunte(cPerg,.F.)               // Pergunta no SX1

Private cString := "SE1"

dbSelectArea("SE1")
dbSetOrder(1)


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  26/07/04   ���
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
dbSeek(xFilial()+mv_par03+mv_par01)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

If Found()
	
	While !Eof().and. E1_NUM >= mv_par01 .and. E1_NUM <= mv_par02 .And. E1_PREFIXO == mv_par03 
	 	If lAbortPrint
     			 @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
     		 Exit
  		Endif

		//If E1_FATURA == "NOTFAT"			
			@ nLin,062 PSAY E1_EMISSAO	
			nLin:= nLin + 5
			@ nLin,009 PSAY E1_VALOR Picture"@E@Z 999,999.99"
			@ nLin,022 PSAY E1_NUM
		//	dbSetOrder(10)
		//	dbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM)
			
			@ nLin,034 PSAY SE1->E1_VALOR Picture"@E@Z 999,999.99"
			@ nLin,051 PSAY SE1->E1_NUM
			@ nLin,060 PSAY SE1->E1_VENCTO
			nLin:= nLin + 4
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
			@ nLin,038 PSAY A1_COD 
			@ nLin,055 PSAY A1_VEND
			@ nLin,072 PSAY A1_BCO1
			nLin:= nLin + 2
			If found()
				@ nLin,000 PSAY CHR(15)
				@ nLin,045 PSAY A1_NOME
				nLin:= nLin + 1
				@ nLin,045 PSAY A1_END
				nLin:= nLin +1
				@ nLin,045 PSAY A1_MUN
				@ nLin,117 PSAY A1_EST
				@ nLin,127 PSAY A1_CEP
				@ nLin,000 PSAY CHR(15)
				nLin := nLin + 1
				@ nLin,045 PSAY A1_ENDCOB
				nLin := nLin + 1
				@ nLin,045 PSAY A1_CGC
				@ nLin,100 PSAY A1_INSCR
				@ nLin,000 PSAY CHR(18)
				nLin := nLin +2
			Endif	
		
			DbSelectArea("SE1")
			dbSetOrder(1)
			@ nLin,000 PSAY CHR(15)
			@ nLin,045 PSAY Subs(RTRIM(SUBS(EXTENSO(E1_VALOR),1,55)) + REPLICATE("*",69),1,69)
			nLin:= nLin + 1
	      	@ nLin,045 PSAY Subs(RTRIM(SUBS(EXTENSO(E1_VALOR),56,55)) + REPLICATE("*",69),1,69) 
			nLin:= nLin + 1
   	  		@ nLin,045 PSAY Subs(RTRIM(SUBS(EXTENSO(E1_VALOR),112,55)) + REPLICATE("*",69),1,69)
			@ nLin,000 PSAY CHR(18)
			DbSkip()
		//Else
		//	Dbskip()
		//	Loop
		//Endif
		IF nLin > 80
			SetPrc(0,0) // (Zera o Formulario)
			nLin:=17
		Else	
			nLin := nLin+17
		EndIF			
	EndDO
EndIf
//���������������������������������������������������������������������Ŀ

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
