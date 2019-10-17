#include "rwmake.ch"

User Function SD3250I

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

Local _aArea   := GetArea()
Local _aAreaSD4:= SD4->(GetArea())
Local _aAreaSD7:= SD7->(GetArea())
Local _aAreaSB2:= SB2->(GetArea())
LOCAL _cOP := SPACE(6)
Local _aAreaSC2 := GetArea()
Local _cLocCQ := GetMV("MV_CQ")

If SM0->M0_CODIGO == "03" .And. SD3->D3_LOCAL == _cLocCQ
	SD7->(dbSetOrder(3))
	If SD7->(dbSeek(xFilial('SD7')+SD3->D3_COD+SD3->D3_NUMSEQ, .F.)) .And. SD7->D7_ORIGLAN == 'PR'
		cSeekSD7 := xFilial('SD7') + SD7->D7_NUMERO + SD7->D7_PRODUTO
		SD7->(dbSetOrder(1))
		SD7->(dbSeek(cSeekSD7, .F.))
		Do While !SD7->(Eof()) .And. cSeekSD7 == SD7->D7_FILIAL+SD7->D7_NUMERO+SD7->D7_PRODUTO
			If SD7->D7_TIPO == 0 .And. Empty(SD7->D7_ESTORNO)
				Reclock("SD7",.F.)
					SD7->D7_X_OP := SD3->D3_OP
				MsUnlock()
			EndIf
			SD7->(dbSkip())
		EndDo
	EndIf

   _cOp := SD3->D3_OP

   DbSelectArea("SC2")
   DbSetOrder(1)
   IF DbSeek(xFilial("SC2")+_cOP)
	   IF SC2->C2_X_STATU != "9"
    	  RecLock("SC2")
	    	  SC2->C2_X_STATU := "6"
    	  MsUnLock()
		EndIF 
   ENDIF

RestArea(_aAreaSC2)
	
	
EndIf
RestArea(_aAreaSD4)
RestArea(_aAreaSD7)
RestArea(_aAreaSB2)
RestArea(_aArea)
Return