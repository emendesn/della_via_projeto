#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SD3250I   ºAutor  ³Reinaldo Caldas     º Data ³  20/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava a op no arquivo de liberacao CQ                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION SD3250E()

LOCAL _aArea   := GetArea()
LOCAL _aAreaSC2:= SC2->(GetArea())
LOCAL _aAreaSD7:= SD7->(GetArea())

If SM0->M0_CODIGO == "03" .And. SD3->D3_LOCAL == UPPER(AllTrim(GetMV("MV_CQ"))) .And. SD3->D3_CF = 'ER0'
	SD7->(dbSetOrder(3))
	If SD7->(dbSeek(xFilial('SD7')+SD3->D3_COD+SD3->D3_NUMSEQ, .F.)) .And. SD7->D7_ORIGLAN == 'PR'
	   dbSelectArea("SD7")
	   RecLock("SD7",.F.)
			SD7->D7_X_OP := SD3->D3_OP
		MsUnlock()
	EndIf

   SC2->(dbSetOrder(1))
   If SC2->(dbSeek(xFilial("SC2")+SD3->D3_OP,.f.))
      RecLock("SC2",.F.)
         SC2->C2_X_STATU := "1"
      MsUnLock()
   EndIf
EndIf

RestArea(_aAreaSC2)
RestArea(_aAreaSD7)
RestArea(_aArea)

RETURN