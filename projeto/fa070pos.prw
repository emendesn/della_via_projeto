#include "rwmake.ch"

User function FA070POS()
Local _aArea := GetArea()

dBaixa 		:= dDatabase
cPortado 	:= space(3)
cBanco 		:= space(3)
cAgencia	:= space(5)
cConta		:= space(10)

// Eder - busca banco para baixa
If FunName()=="LOJA701" .and. ALLTRIM(SE1->E1_TIPO)=="CH" .AND. SE1->E1_SALDO>0 .AND. (SE1->E1_VENCTO-SL1->L1_EMISNF<=7)
	
	// BUSCA BANCO(S) NO SLJ
	dbSelectArea("SA6")
	dbSetORder(1)
	If dbSeek(xFilial("SA6")+SLF->LF_COD)
		cPortado 	:= SA6->A6_COD
		cBanco 		:= SA6->A6_COD
		cAgencia	:= SA6->A6_AGENCIA
		cConta		:= SA6->A6_NUMCON
	Endif
	
Endif

RestArea(_aArea)

Return

