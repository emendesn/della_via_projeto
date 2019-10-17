#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F070OWN   �Autor  � Fabio Henrique      � Data �  10/08/05  ���
�������������������������������������������������������������������������͹��
���Desc.     �Inclusao do filtro na baixa por lote�						   ��
�������������������������������������������������������������������������͹��
���Uso       � Durapol Renovadora de Pneus						          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F070OWN()
//�������������������������������������������������������������������������������Ŀ
//�Declaracao de Variaveis                                                        �
//���������������������������������������������������������������������������������
Local cFiltro
Local lRet		:= .T.
Local cCliDe	:= Criavar("E1_CLIENTE",.T.)
Local cCliAte	:= Criavar("E1_CLIENTE",.T.)
Local cLojaDe	:= Criavar("E1_LOJA",.T.)
Local cLojaAte	:= Criavar("E1_LOJA",.T.)
Local cTipoDe	:= Criavar("E1_TIPO",.T.)
Local cTipoAte	:= Criavar("E1_TIPO",.T.)
Local aArea		:= GetArea()

//��������������������������������������������������������������Ŀ
//� Verifica se deve utilizar a rotina                           �
//����������������������������������������������������������������

cCliAte := "ZZZZZZ"
cLojaAte:= "ZZ"
cTipoAte := "ZZZ"

DEFINE MSDIALOG oDlg FROM 000,000 TO 150,250 TITLE OemtoAnsi("Dados Adicionais da baixa por lote") PIXEL
@ 004,005 TO 070,123 OF oDlg PIXEL

@ 010,010 SAY "Cliente De :" OF oDlg PIXEL
@ 010,040 MSGET cCliDe PICTURE PesqPict("SE1","E1_CLIENTE") OF oDlg F3 "SA1" VALID (Empty(cCliDe) .OR. ExistCpo("SA1",cCliDe)) SIZE 030,006 PIXEL
@ 010,080 SAY "Loja De :" OF oDlg PIXEL
@ 010,105 MSGET cLojaDe PICTURE PesqPict("SE1","E1_LOJA") OF oDlg SIZE 015,006 PIXEL

@ 020,010 SAY "Cliente Ate :" OF oDlg PIXEL
@ 020,040 MSGET cCliAte PICTURE PesqPict("SE1","E1_CLIENTE") OF oDlg F3 "SA1" VALID IIF(cCliAte<>"ZZZZZZ",ExistCpo("SA1",cCliAte),".T.") SIZE 030,006 PIXEL
@ 020,080 SAY "Loja Ate :" OF oDlg PIXEL
@ 020,105 MSGET cLojaAte PICTURE PesqPict("SE1","E1_LOJA") OF oDlg VALID (IIF(!Empty(cCliAte),!Empty(cLojaAte),.t.)) SIZE 015,006 PIXEL

@ 030,010 SAY "Tipo de :" OF oDlg PIXEL
@ 030,040 MSGET cTipoDe  PICTURE PesqPict("SE1","E1_TIPO") OF oDlg  SIZE 015,002 PIXEL
@ 030,070 SAY "Tipo Ate:" OF oDlg PIXEL
@ 030,098 MSGET cTipoAte PICTURE PesqPict("SE1","E1_TIPO") OF oDlg  SIZE 015,002 PIXEL


DEFINE SBUTTON FROM 050,050 TYPE 1  ENABLE OF oDlg ACTION (oDlg:End())
ACTIVATE MSDIALOG oDlg CENTERED

cFiltro := 'E1_SALDO>0.And.'
//cFiltro += 'E1_FILIAL>="'      +cFilDe       + '".And.'
//cFiltro += 'E1_FILIAL<="'      +cFilAte      + '".and.'
//cFiltro += 'E1_PORTADO+E1_AGEDEP+E1_CONTA=="'+cBancoLt+cAgenciaLt+cContaLt+'".And.'
cFiltro += 'DTOS(E1_VENCREA)>="'+DTOS(dVencDe) + '".And.'
cFiltro += 'DTOS(E1_VENCREA)<="'+DTOS(dVencAte)+ '".And.'
cFiltro += 'E1_NATUREZ>="'      +cNatDe       + '".And.'
cFiltro += 'E1_NATUREZ<="'      +cNatAte      + '".and.'
cFiltro += 'E1_CLIENTE>="'      +cCliDe       + '".And.'
cFiltro += 'E1_CLIENTE<="'      +cCliAte      + '".and.'
cFiltro += 'E1_LOJA>="'      	  +cLojaDe      + '".And.'
cFiltro += 'E1_LOJA<="'      	  +cLojaAte     + '".and.'
cFiltro += 'E1_TIPO>="'	+cTipoDe	+ '".And.'
cFiltro += 'E1_TIPO<="'	+cTipoAte	+ '".And.'        
cFiltro += '!(E1_TIPO$"'+MVPROVIS+"/"+MVRECANT+"/"+MVIRABT+"/"+MVINABT+"/"+MV_CRNEG

If mv_par06 == 2
	cFiltro += "/"+MVABATIM+'")'
Else
	cFiltro += '")'
Endif

RestArea(aArea)
Return(cFiltro)