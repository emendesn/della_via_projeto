#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M40LIOK  ºAutor  ³ Jader              º Data ³  04/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validacao da linha do pedido de      º±±
±±º          ³ venda. Usado para nao deixar excluir a linha quando vier   º±±
±±º          ³ de uma OP                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410LiOk()

Local _lRet   := .T.
Local _aAlias := GetArea()
Local _nPos := AScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_NUMOP"})
Local _cNumOP := aCols[n,_nPos]
Local _nPos := AScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ITEMOP"})
Local _cItemOP := aCols[n,_nPos]
Local _nPos := AScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_IDENTB6"})
Local _cIdentB6 := aCols[n,_nPos]

If SM0->M0_CODIGO == "03"  // Somente para empresa Durapol 	
	IF ! Upper(Alltrim(Substr(cUsuario,7,15))) $ "MARCELO.FODOR/MONICA.SILVA"
		If (! Empty(_cNumOP) .And. ! Empty(_cItemOP)) .Or. ! Empty(_cIdentB6)	
			If aCols[n,Len(aHeader)+1]
				MsgStop("Este item nao pode ser excluido pois esta vinculado a uma ordem de producao ou ao poder de terceiros. Verifique.","Atencao")
				_lRet := .F.
			Endif
			IF UsrRetGrp()[1] == "000000" //Grupo de Administradores
				_lRet := .T.
			EndIF	
		EndIf	
	Endif   
Endif

RestArea(_aAlias)                          

Return(_lRet)
