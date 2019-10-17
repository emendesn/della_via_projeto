#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DESTV01   ºAutor  ³Microsiga           º Data ³  12/14/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DESTV01

Local _aArea := GetArea()
Local lRet   := .T.
Local cOP    := M->D3_OP
Local cProd  := M->D3_X_PROD

SD3->( dbSetOrder (12) )
IF SD3->( dbSeek(xFilial("SD3") +cOP+ cProd ) )
	While !Eof() .and.  xFilial("SD3")  + cOP + cProd == xFilial("SD3")  + SD3->D3_OP + SD3->D3_X_PROD .and. lRet
		IF SD3->D3_ESTORNO <> 'S'
			lRet := .F.
			Aviso("Atencao","Este produto já foi apontado nesta Ordem de produção !!!",{"OK"})
		EndIF
		SD3->(dbSkip() )
	EndDo	
EndIF  
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek("  "+M->D3_X_PROD)
If Found() 
	If SB1->B1_GRUPO = "BAND"
		If AllTrim(SB1->B1_XDESENH) <> Alltrim(SC2->C2_X_DESEN)
			Aviso("Des OP:" + AllTrim(SC2->C2_X_DESEN) + "Dif Lanç:" + AllTrim(SB1->B1_XDESENH) , "BANDA",{"OK"})
			lret := .f.
		EndIf
	Endif
Else
	Aviso("Produto Não Cadastrado","Material",{"OK"})
	lret := .f.
Endif

RestArea(_aArea)
Return(lRet)
