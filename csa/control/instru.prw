/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DFinr03   º Autor ³ MICROSIGA º      Data ³  09/01/06       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emissao de duplicata                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TRATAR INSTRUCAO BANCÁRIA                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER FUNCTION INSTRU()
LOCAL _cRet	    := SPACE(2)
LOCAL _cTipCli  := SPACE(1)
LOCAL _cInstPad := SPACE(2)

IF SE1->E1_MSFIL == "39" .AND. SE1->E1_PORTADO == "001"

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
	_cTipCli := SA1->A1_PESSOA // VERIFICAR NOME DO CAMPO !!!

	
	IF     _cTipCli == "F"  // pessoa fisica 
		_cRet     := "30"
	ElseIF _cTipCli == "J"  // pessoa juridica 
		_cRet     := "10"
	ENDIF
ELSE
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA+"001") // VERIFICAR NOME DO CAMPO !!!
	
	_cInstPad := SEE->EE_INSTPRI
	_cRet     := If(!Empty(SE1->E1_INSTR1),SE1->E1_INSTR1,_cInstPad)
ENDIF

RETURN(_cRet)