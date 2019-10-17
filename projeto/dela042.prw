#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELA042  ºAutor  ³Anderson Kurtinaitisº Data ³  09/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLocacao   ³ Fab.Tradicional  ³Contato ³ andkurt@microsiga.com.br       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua verificacao do que o usuario digitou nos campos     º±±
±±º          ³ de Cond. de Pagamento LQ_CONDPG, C5_CONDPAG e UA_CONDPG    º±±
±±º          ³ verificando se o que foi digitado esta em conforme com     º±±
±±º          ³ o filtro implementado na consulta SE4 do SXB, ja que as    º±±
±±º          ³ condicoes apresentadas sao filtradas de acordo com o       º±±
±±º          ³ conteudo do campo XX_TIPOVND, onde XX pode ser LQ,C5 ou UA º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Chamada atravez do X3_VLDUSER do Campo LQ_CONDPG,C5_CONDPAGº±±
±±º          ³ e UA_CONDPG.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Project Function DELA042()

//Variaveis Locais da Funcao
Local _lRetorno	:= .T.
// Verifican em qual campo o usuario esta para efetuar corretamente a validacao necessaria
Local _cQualCpo	:= ReadVar()

If Upper(Alltrim(_cQualCpo)) == "M->LQ_CONDPG"

	If Empty(M->LQ_TIPOVND)
	
		MsgAlert(OemtoAnsi("O Campo TIPO DE VENDA esta vazio, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	
	Else

		DbSelectArea("SE4")
		DbSetOrder(1)
		If DbSeek(xFilial("SE4") + M->LQ_CONDPG)

			// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
			IF !(Alltrim(M->LQ_TIPOVND) $ Alltrim(SE4->E4_TIPOVND))

				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO se enquadra no Tipo de Venda informado, verifique !"), "Aviso") 
				_lRetorno	:= .F.
				
			EndIf
		
		Else // Nao achou condicao digitada

			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		
		EndIf	
	
	EndIf

ElseIf Upper(Alltrim(_cQualCpo)) == "M->C5_CONDPAG"

	If Empty(M->C5_TPVEND)
	
		MsgAlert(OemtoAnsi("O Campo TIPO DE VENDA esta vazio, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	
	Else

		DbSelectArea("SE4")
		DbSetOrder(1)
		If DbSeek(xFilial("SE4") + M->C5_CONDPAG)

			// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
			IF !(Alltrim(M->C5_TPVEND) $ Alltrim(SE4->E4_TIPOVND))

				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO se enquadra no Tipo de Venda informado, verifique !"), "Aviso") 
				_lRetorno	:= .F.
				
			EndIf
		
		Else // Nao achou condicao digitada

			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		
		EndIf	
	
	EndIf


ElseIf Upper(Alltrim(_cQualCpo)) == "M->UA_CONDPG"

	If Empty(M->UA_TIPOVND)
	
		MsgAlert(OemtoAnsi("O Campo TIPO DE VENDA esta vazio, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	
	Else

		DbSelectArea("SE4")
		DbSetOrder(1)
		If DbSeek(xFilial("SE4") + M->UA_CONDPG)

			// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
			IF !(Alltrim(M->UA_TIPOVND) $ Alltrim(SE4->E4_TIPOVND))

				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO se enquadra no Tipo de Venda informado, verifique !"), "Aviso") 
				_lRetorno	:= .F.
				
			EndIf
		
		Else // Nao achou condicao digitada

			MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		
		EndIf	
	
	EndIf

Else

	_lRetorno	:= .T.

EndIf

Return(_lRetorno)
