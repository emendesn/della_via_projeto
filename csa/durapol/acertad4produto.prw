#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AcD4Prd      ºAutor  ³ Jairo Oliveira  º Data ³  08/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acerta o D4_Produto com base no D4_COD Acessando B1_COD    º±±
±±º          ³ e movendo o B1_Produto para D4_produto                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AcD4Prd() 

MsAguarde({ || AcD4Prd_1() } , "Aguarde","Alterando D4_Produto",.f.)

Return

Static Function AcD4Prd_1()
Local _cQry := " "
Local aArea		:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSD4	:= SD4->(GetArea())

IF Select("D4TMP") > 0
	dbSelectArea("D4TMP")
	dbCloseArea()
EndIF
_cQry := "SELECT SD4.R_E_C_N_O_ RECD4"
_cQry += " FROM " + RetSqlName("SD4") + " SD4 "
_cQry += " WHERE "
_cQry += " D4_FILIAL = '" + XFILIAL("SD4") + "' AND "
_cQry += " D4_PRODUTO = '               ' AND"
_cQry += " SD4.D_E_L_E_T_ = ' '"

_cQry := ChangeQuery(_cQry)
dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQry), 'D4TMP', .F., .T.)
dbGotop()

While !EOF()
	DbSelectArea("SD4")
	DbGoto(D4TMP->RECD4)
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(XFILIAL("SB1")+SD4->D4_COD)
	IF !EOF() .AND. !EMPTY(SB1->B1_PRODUTO)
		DbSelectArea("SD4")
		RecLock("SD4",.F.)
		SD4->D4_PRODUTO		:= SB1->B1_PRODUTO
		MsUnLock()
	End
	DbSelectArea("D4TMP")
	DbSkip()

End
IF Select("D4TMP") > 0
	dbSelectArea("D4TMP")
	dbCloseArea()
EndIF

RestArea(aAreaSB1)
RestArea(aAreaSD4)
RestArea(aArea)
Return