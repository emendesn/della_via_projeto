#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FVldCond ºAutor  ³ Alexandre Martim   º Data ³  31/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua verificacao do que o usuario digitou nos campos     º±±
±±º          ³ de Cond. de Pagamento C1_CONDPG, C3_COND, C7_COND, C8_COND º±±
±±º          ³ CB_COND, F1_COND, AIA_CONDPAG.                             º±±
±±º          ³ verificando se o que foi digitado esta em conforme com     º±±
±±º          ³ o filtro implementado na consulta SE4 do SXB               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Function FVldCond()

//Variaveis Locais da Funcao
Local _lRetorno	:= .T.
// Verifican em qual campo o usuario esta para efetuar corretamente a validacao necessaria
Local _cQualCpo	:= ReadVar()

If Upper(Alltrim(_cQualCpo)) == "M->C1_CONDPAG"

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + M->C1_CONDPAG)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	EndIf	

ElseIf Upper(Alltrim(_cQualCpo)) == "M->C3_COND"

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + M->C3_COND)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	EndIf	

ElseIf Upper(Alltrim(_cQualCpo)) == "M->C7_COND"

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + M->C7_COND)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	EndIf	

ElseIf Upper(Alltrim(_cQualCpo)) == "M->C8_COND"

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + M->C8_COND)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	EndIf	

ElseIf Upper(Alltrim(_cQualCpo)) == "M->CB_COND"

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + M->CB_COND)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	EndIf	

ElseIf Upper(Alltrim(_cQualCpo)) == "M->F1_COND"

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + M->F1_COND)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	EndIf	

ElseIf Upper(Alltrim(_cQualCpo)) == "M->AIA_CONDPG"

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + M->AIA_CONDPG)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	EndIf	

Else

	_lRetorno	:= .T.

EndIf

Return(_lRetorno)
