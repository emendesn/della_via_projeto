#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFinr03   � Autor � Fabio Henrique �      Data �  09/08/05  ���
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
Local nLin           := 60
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

Pergunte(cPerg,.F.)               

Private cString := "SE1"


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
Local nFilial := "01"     

dbSelectArea("SE1")
//dbSetOrder(6)
//dbSeek(nFilial+ DTOS(mv_par01),.T.)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

@ nLin,000 PSAY CHR(15)	


While !Eof()                                                           
	
	// Looping necess�rio para a mudan�a de filial (nFilial
	dbSelectArea("SE1")
	dbSetOrder(6)
	dbSeek(nFilial+ DTOS(mv_par01),.T.)

	While !Eof() .and. E1_EMISSAO <= mv_par02 
	                                                           
 		If lAbortPrint
  			 @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	   		 Exit
		Endif                        
	
		If nLin > 55  	
	 	 	 nLin := 1
		 	 @ nLin,002 PSAY REPL("-",130)      
		 	 nLin := nLin + 2
		 	 @ nLin,070 PSAY	"Rela��o de T�tulos por Emiss�o"
	         nLin := nLin + 1 
	 	 	 @ nLin,115 PSAY dDatabase
			 nLin := nLin + 1
		 	 @ nLin,002 PSAY REPL("-",130)      	 	
		     nLin := nLin + 1
    	     @ nLin,002 PSAY "FILIAL"
	         @ nLin,009 PSAY "TITULO"
	         @ nLin,018 PSAY "VALOR"     
	         @ nLin,032 PSAY "EMISSAO"
	         @ nLin,042 Psay "VENCIMENTO" 
	         @ nLin,053 PSAY "CLIENTE"
	         @ nLin,072 PSAY "ENDERE�O"
	         @ nLin,104 PSAY "CEP"
	         @ nLin,114 PSAY "MUNICIPIO"   	           	           	           	           	           	        
	         @ nLin,130 PSAY "ESTADO"   	        
	         nLin := nLin + 1 
	 	 	 @ nLin,002 PSAY REPL("-",130)      
	         nLin := nLin + 1 
	    Endif	

		If E1_BAIXA == CTOD(' ')
			@ nLin,002 PSAY SE1->E1_FILIAL
			@ nLin,009 PSAY SE1->E1_NUM
			@ nLin,016 PSAY SE1->E1_VALOR Picture"@E@Z 999,999.99"
			@ nLin,032 PSAY SE1->E1_EMISSAO 
			@ nLin,042 PSAY SE1->E1_VENCTO
			@ nLin,053 PSAY SUBS(SE1->E1_NOMCLI,1,18) 

		    // CASO N�O EXISTA ENDERE�O DE COBRAN�A CADASTRADO SELECIONA ENDERE�O PADR�O

			dbselectarea("SA1")
			dbsetorder(1)
			dbseek(SE1->("  " + E1_CLIENTE + E1_LOJA))

			IF EMPTY(SA1->A1_ENDCOB)        
				@ nLin,072 PSAY SUBS(SA1->A1_END,1,30)				
				@ nLin,103 PSAY SUBS(SA1->A1_CEP,1,5)+"-"+SUBS(SA1->A1_CEP,5,3)
				@ nLin,114 PSAY SA1->A1_MUN		
				@ nLin,130 PSAY SA1->A1_EST		
			Else
				@ nLin,072 PSAY SUBS(SA1->A1_ENDCOB,1,30)				
				@ nLin,103 PSAY SUBS(SA1->A1_CEPC,1,5)+"-"+SUBS(SA1->A1_CEPC,5,3)
				@ nLin,114 PSAY SA1->A1_MUNC		
				@ nLin,130 PSAY SA1->A1_ESTC
			EndIf	                                   
							
			nLin := nLin + 1

		EndIf

		dbselectarea("SE1")
		dbskip()		
	EndDo        

    nFilial := val(nFilial)  
	nFilial := nFilial + 1
	nFilial := STRZERO(nFilial,2,0)  

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