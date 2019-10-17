#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  FA60FIL ³ Autor ³ Claudio Diniz  ³ Data ³ 30/06/05 ³       ±±            
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Filtro titulos no Bordero de Cobranca                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Della Via Pneus                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
 
User Function FA60FIL()        


Local cFiltro
Local lRet		:= .T.
Local cTipo1	:= Criavar("E1_TIPO",.T.)
Local cTipo2 	:= Criavar("E1_TIPO",.T.)
Local cPtd   	:= Criavar("E1_PORTADO",.T.)
Local aArea		:= GetArea()          
Local cAlias,aCampos:={}

cFil060 := ".T."
cTipo1 := "NF "
cTipo2 := "DP "
cPtd   := CPORT060       
//oMark := MsSelect():New(cAlias,"E1_OK","!E1_SALDO",aCampos,@lInverte,@cMarca,{35,1,143,315})
//PUBLIC oMark := .T.

//oMark:oBrowse:lhasMark = .t.

DEFINE MSDIALOG oDlg FROM 000,000 TO 150,250 TITLE OemtoAnsi("Dados Adicionais da selecao") PIXEL
@ 004,005 TO 070,123 OF oDlg PIXEL

@ 010,010 SAY "Tipo     :" OF oDlg PIXEL
@ 010,040 MSGET cTipo1 PICTURE PesqPict("SE1","E1_TIPO") OF oDlg  SIZE 030,006 PIXEL

@ 020,010 SAY "Tipo     :" OF oDlg PIXEL
@ 020,040 MSGET cTipo2 PICTURE PesqPict("SE1","E1_TIPO") OF oDlg  SIZE 030,006 PIXEL

@ 030,010 SAY "Portador :" OF oDlg PIXEL
@ 030,040 MSGET cPtd  PICTURE PesqPict("SE1","E1_PORTADO") OF oDlg  SIZE 015,002 PIXEL

DEFINE SBUTTON FROM 050,050 TYPE 1  ENABLE OF oDlg ACTION (oDlg:End())
ACTIVATE MSDIALOG oDlg CENTERED


cFiltro := '    (SE1->E1_BCO1=="' +cPtd   +  '" .and.   '
cFiltro += '    (SE1->E1_TIPO=="' +cTipo1 +  '" .or.    '
cFiltro += '     SE1->E1_TIPO=="' +cTipo2 +  '"))       '


/*
cFiltro := 'SE1->E1_BCO1=="'  +cPtd  + '" .and. '
cFiltro += 'SE1->E1_TIPO$"' +cTipo1 + '/'+cTipo2 + '"' 
*/

//oMark:oBrowse:Refresh(.T.)
RestArea(aArea)
Return(cFiltro)
//Return(.T.)

