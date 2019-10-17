#Include 'rwmake.ch'

User Function BUTC004()
	Local _aButtons		:= {}

	aAdd(_aButtons, {"LINE"    ,{|| U_DVLOJC07(SA1->A1_COD,SA1->A1_LOJA) },"Orçamentos"})
	aAdd(_aButtons, {"GRAF2D"  ,{|| U_DVLOJC05(SA1->A1_COD,SA1->A1_LOJA) },"Faturados"})
	aAdd(_aButtons, {"SIMULACA",{|| U_DVLOJC08(SA1->A1_COD,SA1->A1_LOJA) },"Titulos recebidos"})
	aAdd(_aButtons, {"BUDGETY" ,{|| U_DVLOJC06(SA1->A1_COD,SA1->A1_LOJA) },"Titulos em aberto"})
	aAdd(_aButtons, {"FORM"    ,{|| U_BUTC004A()                         },"Histórico de Cobranças"})
	aAdd(_aButtons, {"AUTOM"   ,{|| U_FC010CON()                         },"Cons. Especifica"})

Return _aButtons   

User Function BUTC004A()
	Private oDlg
	Pergunte("FIC010", .T.)
	TMKC020()
Return nil