#include "rwmake.ch"
User Function MT175Atu

Local _aArea  := GetArea()
Local _aAreaSB2 := SB2->(GetArea())
Local _aAreaSD3 := SD3->(GetArea())
Local _aAreaSD4 := SD4->(GetArea())
Local _cOP    := SD7->D7_X_OP
Local _cDoc   := SD7->D7_NUMERO
Local _cCod   := SD7->D7_PRODUTO
Local _cLocal := SD7->D7_LOCAL

dbSelectArea("SD7")
dbSetorder(1)
dbSeek(xFilial("SD7")+_cDoc+_cCod+_cLocal)

While !Eof() .and. xFilial("SD7")+_cDoc+_cCod+_cLocal == SD7->D7_FILIAL+SD7->D7_NUMERO+SD7->D7_PRODUTO+SD7->D7_LOCAL			
	_cSequen  := SD7->D7_NUMSEQ
	_cTipo    := SD7->D7_TIPO
	dbSkip()
EndDo	
SD7->(dbSetorder(3))
SD7->(dbSeek(xFilial("SD7")+_cCod+_cSequen+_cDoc))
Reclock("SD7",.F.)
	SD7->D7_X_OP := _cOP
Msunlock()

RestArea(_aArea)
RestArea(_aAreaSD3)
RestArea(_aAreaSD4)
RestArea(_aAreaSB2)
Return
