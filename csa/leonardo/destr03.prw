#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DESTR03c   � Autor � Leonardo           � Data �  10/01/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Emissao de Ficha de Produ��o - Processo Revisado           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Duparol                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function DESTR03


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Emissao de Fichas de Produ��o "
Local cPict          := ""
Local titulo         := "Emissao de Fichas de Producao "
Local cPerg          := "ESTR01"
Local Cabec1         := "Este programa ira emitir fichas de producao de acordo com
Local Cabec2         := "os parametros selecionados"
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "DESTR03"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "DESTR01"

Pergunte(cPerg,.F.)               // Pergunta no SX1

Private cString := "SC2"


dbSelectArea("SC2")
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
VerImp()

RptStatus({||RunReport()})
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

Static Function RunReport

Local nOrdem
Local nLin := 0

IF Select("SC2TMP") > 0
	dbSelectArea("SC2TMP")
	dbCloseArea()
EndIF

_cQry:= "SELECT * "
_cQry+= " FROM " + RetSqlName("SC2") + " SC2 "
_cQry+= " WHERE C2_NUM||C2_ITEM||C2_SEQUEN >= '"+mv_par01+"' AND C2_NUM||C2_ITEM||C2_SEQUEN <= '"+ mv_par02 +"' "
_cQry+= " AND  D_E_L_E_T_ = '' "
	
_cQry := ChangeQuery(_cQry)
				
dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQry), 'SC2TMP', .F., .T.)
dbGoTop()
@ nLin,000 PSAY chr(18)
While !Eof()
//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

	IF SC2TMP->C2_EMISSAO < DTOS(mv_par03) .OR. SC2TMP->C2_EMISSAO > DTOS(mv_par04)
		dbSelectArea("SC2TMP")
		dbSkip()
		Loop
	EndIF	

   	nLin := nLin + 1
   		
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
		
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial("SD1")+SC2TMP->C2_NUM)
			
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
		
	@ nLin,010 PSAY Alltrim(SA1->A1_NOME)    //Cliente
	@ nLin,050 PSAY SA1->A1_COD              //Cod.Cliente
	nLin:= nLin + 1
	_cMedida := SC2TMP->C2_PRODUTO
	@ nLin,010 PSAY SD1->D1_DOC            //Coleta
	@ nLin,030 PSAY STOD(SC2TMP->C2_EMISSAO)         //Data Emissao

	
	nLin:= nLin + 1
	
	@ nLin,010 PSAY SC2TMP->C2_PRODUTO           //Medida
	@ nLin,035 PSAY IIF(Empty(SC2TMP->C2_SERIEPN),SC2TMP->C2_NUMFOGO,SC2TMP->C2_SERIEPN) //Num.Serie/Numero Fogo 
	
	nLin:= nLin + 1
	@ nLin,009 PSAY chr(255)+ Chr(14)+ (SC2TMP->C2_NUM)+" "+(SC2TMP->C2_ITEM) //Numero da Ficha
		
	nLin:= nLin + 17   //17
	
	@ nLin,012 PSAY SC2TMP->C2_OBS            //Obs
	@ nLin,070 PSAY SC2TMP->C2_X_DESEN
	
	
	nLin:=nLin+ 3 //22
	//Alert(nLin)
   	@ nLin,010 PSAY Substr(Alltrim(SA1->A1_NOME),1,20)  //Cliente
	@ nLin,039 PSAY SC2TMP->C2_X_DESEN          //Banda
	
	nLin:= nLin + 1
	
	@ nLin,010 PSAY SD1->D1_DOC            //Coleta
	@ nLin,036 PSAY STOD(SC2TMP->C2_EMISSAO) //Data Emissao
	@ nLin,058 PSAY SC2TMP->C2_PRODUTO       //Medida chr(255)+Chr(14) +
	nLin:= nLin + 1
	
	@ nLin,010 PSAY  _cMedida                //Medida
	@ nLin,042 PSAY  IIF(Empty(SC2TMP->C2_SERIEPN),SC2TMP->C2_NUMFOGO,SC2TMP->C2_SERIEPN) //Num.Serie/Numero Fogo
	
    nlin := nLin + 1
    @ nLin,010 PSAY  SC2TMP->C2_NUM+SC2TMP->C2_ITEM       //Numero da Ficha+Item da Ficha
    
	nlin := nLin + 1
	
	@ nLin,018 PSAY SC2TMP->C2_X_DESEN          //Banda        
	nlin := nLin + 2				

	nLin := nLin+6  //11

	dbSelectArea("SC2TMP")
	dbSkip()
EndDO
//EndIf
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

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � VERIMP   � Autor �   Microsiga       � Data � 11/04/55     ���
��+----------+------------------------------------------------------------���
���Descri��o � Verifica posicionamento de papel na Impressora             ���
��+----------+------------------------------------------------------------���
���Uso       � Durapol                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
IF aReturn[5]== 2

	nOpc       := 1
	While .T.

    	SetPrc(0,0)
    	dbCommitAll()

	    @ nLin ,000 PSAY " "
    	@ nLin ,004 PSAY "*"
	    @ nLin ,022 PSAY "."
		IF MsgYesNo("Fomulario esta posicionado ? ")
			nOpc := 1
		ElseIF MsgYesNo("Tenta Novamente ? ")
			nOpc := 2
		Else
			nOpc := 3
		Endif

    	Do Case
    		Case nOpc == 1
     			lContinua:=.T.
 	    		Exit
        	Case nOpc == 2
            	Loop
	        Case nOpc==3
    	        lContinua:=.F.
        		Return
		    EndCase
	EndDo
Endif

Return