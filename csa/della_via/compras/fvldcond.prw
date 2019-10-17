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

User Function FVldCond()

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
	    If !Empty(M->C1_CONDPAG)
			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
    		_lRetorno	:= .F.
        Endif
	EndIf	

ElseIf Upper(Alltrim(_cQualCpo)) == "CCONDICAO" .and. funname() $ "MATA120/MATA121/MATA125/MATA103/MATA150" 

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + cCondicao)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
	    If !Empty(cCondicao)
			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
    		_lRetorno	:= .F.
        Endif
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
	    If !Empty(M->AIA_CONDPG)
			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
    		_lRetorno	:= .F.
        Endif
	EndIf	

ElseIf Upper(Alltrim(_cQualCpo)) == "M->A2_COND"

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + M->A2_COND)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
	    If !Empty(M->A2_COND)
			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
    		_lRetorno	:= .F.
        Endif
	EndIf	

Else

	_lRetorno	:= .T.

EndIf

Return(_lRetorno)
