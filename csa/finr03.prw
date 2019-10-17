#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFinr03   � Autor � Fabio Henrique �      Data �  09/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Relat�rio de T�tulos a Receber por Emiss�o                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Durapol Renovadora de Pneus                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CFinr03


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Titulos por Emiss�o Durapol"
Local cPict          := ""
Local titulo         := "Titulos por Emiss�o"
Local nLin           := 2
Local cPerg          := "FINR03"
Local Cabec1         := "Este programa ira imprimir dados dos t�tulos conforme"
Local Cabec2         := "os parametros selecionados"
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "CFinr03"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CFinr03"

Pergunte (cPerg,.F.)               // PERGUNTA NO SX1

Private cString := "SE1"

//dbSelectArea("SE1")
//dbSetOrder(6)


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

RptStatus({|| CRFIN03(Cabec1,Cabec2,Titulo,nLin) },Titulo)
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

Static Function CRFIN03(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea("SE1")
dbSetOrder(6)
dbSeek(xFilial()+ dtoc(mv_par01),.T.)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

@ nLin,000 PSAY CHR(15)	

While !Eof() .and. E1_EMISSAO >= mv_par01 .and. E1_EMISSAO <= mv_par02 
	                                                           
 	If lAbortPrint
   		 @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
   		 Exit
	Endif                        
	
	If nLin > 55  	
  	  	 SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
     	 nLin := 8
         @ nLin,002 PSAY "FILIAL"
         @ nLin,007 PSAY "TITULO"
         @ nLin,015 PSAY "VALOR"
         @ nLin,023 PSAY "CLIENTE"
         @ nLin,038 PSAY "ENDERE�O"
         @ nLin,058 PSAY "CEP"
         @ nLin,068 PSAY "MUNICIPIO"   	           	           	           	           	           	        
         @ nLin,085 PSAY "ESTADO"   	        
    Endif	

	If e1_baixa == CTOD(' ')

		@ nLin,002 PSAY SE1->E1_FILIAL
		@ nLin,007 PSAY SE1->E1_NUM
		@ nLin,015 PSAY SE1->E1_VALOR Picture"@E@Z 999,999.99"
		@ nLin,023 PSAY SE1->E1_NOMCLI

	    // CASO N�O EXISTA ENDERE�O DE COBRAN�A CADASTRADO SELECIONA ENDERE�O PADR�O

		dbselectarea("sa1")
		dbsetorder(1)
		dbseek(se1->(e1_filial+e1_cliente+e1_loja))

		IF SA1->A1_ENDCOB := ' '
			@ nLin,038 PSAY SA1->A1_END				
			@ nLin,058 PSAY SA1->A1_CEP
			@ nLin,068 PSAY SA1->A1_MUN		
			@ nLin,085 PSAY SA1->A1_EST		
		Else
			@ nLin,038 PSAY SA1->A1_ENDCOB						
			@ nLin,058 PSAY SA1->A1_CEPC
			@ nLin,068 PSAY SA1->A1_MUNC		
			@ nLin,085 PSAY SA1->A1_ESTC
		EndIf	                                   
							
		nLin := mLin + 1

	EndIf

	
	dbselectarea("se1")
	dbskip()		
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